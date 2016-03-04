//
//  Async.swift
//
//  Created by Tobias DM on 15/07/14.
//
//	OS X 10.10+ and iOS 8.0+
//	Only use with ARC
//
//	The MIT License (MIT)
//	Copyright (c) 2014 Tobias Due Munk
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//	the Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation


/*        
    https://github.com/duemunk/Async
            how to use it?

            Async sugar looks like this:

Async.background {
    println("This is run on the background queue")
}.main {
    println("This is run on the main queue, after the previous block")
}
            
            Instead of the familiar syntax for GCD:

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
    println("This is run on the background queue")

dispatch_async(dispatch_get_main_queue(), {
    println("This is run on the main queue, after the previous block")
})

})


*/
// MARK: - HACK: For Swift 1.1
extension qos_class_t {
    
    public var id:Int {
        return Int(rawValue)
    }
}


// MARK: - DSL for GCD queues

private class GCD {
	
	/* dispatch_get_queue()
     
    QOS_CLASS_USER_INTERACTIVE： user interactive等级表示任务需要被立即执行以提供好的用户体验。使用它来更新UI，响应事件以及需要低延时的小工作量任务。这个等级的工作总量应该保持较小规模。
    QOS_CLASS_USER_INITIATED：user initiated等级表示任务由UI发起并且可以异步执行。它应该用在用户需要即时的结果同时又要求可以继续交互的任务。
    QOS_CLASS_UTILITY：utility等级表示需要长时间运行的任务，常常伴随有用户可见的进度指示器。使用它来做计算，I/O，网络，持续的数据填充等任务。这个等级被设计成节能的。
    QOS_CLASS_BACKGROUND：background等级表示那些用户不会察觉的任务。使用它来执行预加载，维护或是其它不需用户交互和对时间不敏感的任务。

    */
	class func mainQueue() -> dispatch_queue_t {
		return dispatch_get_main_queue()
		// Don't ever use dispatch_get_global_queue(qos_class_main().id, 0) re https://gist.github.com/duemunk/34babc7ca8150ff81844
	}
	class func userInteractiveQueue() -> dispatch_queue_t {
		return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE.id, 0)
	}
	class func userInitiatedQueue() -> dispatch_queue_t {
		 return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED.id, 0)
	}
	class func utilityQueue() -> dispatch_queue_t {
		return dispatch_get_global_queue(QOS_CLASS_UTILITY.id, 0)
	}
	class func backgroundQueue() -> dispatch_queue_t {
		return dispatch_get_global_queue(QOS_CLASS_BACKGROUND.id, 0)
	}
}


// MARK: - Async – Struct

public struct Async {
    
    private let block: dispatch_block_t
    
    private init(_ block: dispatch_block_t) {
        self.block = block
    }
}


// MARK: - Async – Static methods

extension Async {

	
	/* dispatch_async() */

	private static func async(block: dispatch_block_t, inQueue queue: dispatch_queue_t) -> Async {
		// Create a new block (Qos Class) from block to allow adding a notification to it later (see matching regular Async methods)
		// Create block with the "inherit" type
		let _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
		// Add block to queue
		dispatch_async(queue, _block)
		// Wrap block in a struct since dispatch_block_t can't be extended
		return Async(_block)
	}
	public static func main(block: dispatch_block_t) -> Async {
		return Async.async(block, inQueue: GCD.mainQueue())
	}
	public static func userInteractive(block: dispatch_block_t) -> Async {
		return Async.async(block, inQueue: GCD.userInteractiveQueue())
	}
	public static func userInitiated(block: dispatch_block_t) -> Async {
		return Async.async(block, inQueue: GCD.userInitiatedQueue())
	}
	public static func utility(block: dispatch_block_t) -> Async {
		return Async.async(block, inQueue: GCD.utilityQueue())
	}
	public static func background(block: dispatch_block_t) -> Async {
		return Async.async(block, inQueue: GCD.backgroundQueue())
	}
	public static func customQueue(queue: dispatch_queue_t, block: dispatch_block_t) -> Async {
		return Async.async(block, inQueue: queue)
	}


	/* dispatch_after() */

	private static func after(seconds: Double, block: dispatch_block_t, inQueue queue: dispatch_queue_t) -> Async {
		let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
		let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
		return at(time, block: block, inQueue: queue)
	}
	private static func at(time: dispatch_time_t, block: dispatch_block_t, inQueue queue: dispatch_queue_t) -> Async {
		// See Async.async() for comments
		let _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
		dispatch_after(time, queue, _block)
		return Async(_block)
	}
	public static func main(after after: Double, block: dispatch_block_t) -> Async {
		return Async.after(after, block: block, inQueue: GCD.mainQueue())
	}
	public static func userInteractive(after after: Double, block: dispatch_block_t) -> Async {
		return Async.after(after, block: block, inQueue: GCD.userInteractiveQueue())
	}
	public static func userInitiated(after after: Double, block: dispatch_block_t) -> Async {
		return Async.after(after, block: block, inQueue: GCD.userInitiatedQueue())
	}
	public static func utility(after after: Double, block: dispatch_block_t) -> Async {
		return Async.after(after, block: block, inQueue: GCD.utilityQueue())
	}
	public static func background(after after: Double, block: dispatch_block_t) -> Async {
		return Async.after(after, block: block, inQueue: GCD.backgroundQueue())
	}
	public static func customQueue(after after: Double, queue: dispatch_queue_t, block: dispatch_block_t) -> Async {
		return Async.after(after, block: block, inQueue: queue)
	}
}


// MARK: - Async – Regualar methods matching static ones

extension Async {


	/* dispatch_async() */
	
	private func chain(block chainingBlock: dispatch_block_t, runInQueue queue: dispatch_queue_t) -> Async {
		// See Async.async() for comments
		let _chainingBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock)
		dispatch_block_notify(self.block, queue, _chainingBlock)
		return Async(_chainingBlock)
	}
	
	public func main(chainingBlock: dispatch_block_t) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.mainQueue())
	}
	public func userInteractive(chainingBlock: dispatch_block_t) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.userInteractiveQueue())
	}
	public func userInitiated(chainingBlock: dispatch_block_t) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.userInitiatedQueue())
	}
	public func utility(chainingBlock: dispatch_block_t) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.utilityQueue())
	}
	public func background(chainingBlock: dispatch_block_t) -> Async {
		return chain(block: chainingBlock, runInQueue: GCD.backgroundQueue())
	}
	public func customQueue(queue: dispatch_queue_t, chainingBlock: dispatch_block_t) -> Async {
		return chain(block: chainingBlock, runInQueue: queue)
	}

	
	/* dispatch_after() */

	private func after(seconds: Double, block chainingBlock: dispatch_block_t, runInQueue queue: dispatch_queue_t) -> Async {
		
		// Create a new block (Qos Class) from block to allow adding a notification to it later (see Async)
		// Create block with the "inherit" type
		let _chainingBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock)
		
		// Wrap block to be called when previous block is finished
		let chainingWrapperBlock: dispatch_block_t = {
			// Calculate time from now
			let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
			let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
			dispatch_after(time, queue, _chainingBlock)
		}
		// Create a new block (Qos Class) from block to allow adding a notification to it later (see Async)
		// Create block with the "inherit" type
		let _chainingWrapperBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingWrapperBlock)
		// Add block to queue *after* previous block is finished
		dispatch_block_notify(self.block, queue, _chainingWrapperBlock)
		// Wrap block in a struct since dispatch_block_t can't be extended
		return Async(_chainingBlock)
	}
	public func main(after after: Double, block: dispatch_block_t) -> Async {
		return self.after(after, block: block, runInQueue: GCD.mainQueue())
	}
	public func userInteractive(after after: Double, block: dispatch_block_t) -> Async {
		return self.after(after, block: block, runInQueue: GCD.userInteractiveQueue())
	}
	public func userInitiated(after after: Double, block: dispatch_block_t) -> Async {
		return self.after(after, block: block, runInQueue: GCD.userInitiatedQueue())
	}
	public func utility(after after: Double, block: dispatch_block_t) -> Async {
		return self.after(after, block: block, runInQueue: GCD.utilityQueue())
	}
	public func background(after after: Double, block: dispatch_block_t) -> Async {
		return self.after(after, block: block, runInQueue: GCD.backgroundQueue())
	}
	public func customQueue(after after: Double, queue: dispatch_queue_t, block: dispatch_block_t) -> Async {
		return self.after(after, block: block, runInQueue: queue)
	}


	/* cancel */

	public func cancel() {
		dispatch_block_cancel(block)
	}
	

	/* wait */

	/// If optional parameter forSeconds is not provided, use DISPATCH_TIME_FOREVER
	public func wait(seconds: Double = 0.0) {
		if seconds != 0.0 {
			let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
			let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
			dispatch_block_wait(block, time)
		} else {
			dispatch_block_wait(block, DISPATCH_TIME_FOREVER)
		}
	}
}


// MARK: - Apply

public struct Apply {
    
    // DSL for GCD dispatch_apply()
    //
    // Apply runs a block multiple times, before returning. 
    // If you want run the block asynchounusly from the current thread, 
    // wrap it in an Async block, 
    // e.g. Async.main { Apply.background(3) { ... } }
    
    public static func userInteractive(iterations: Int, block: (Int) -> ()) {
        dispatch_apply(iterations, GCD.userInteractiveQueue(), block)
    }
    public static func userInitiated(iterations: Int, block: (Int) -> ()) {
        dispatch_apply(iterations, GCD.userInitiatedQueue(), block)
    }
    public static func utility(iterations: Int, block: (Int) -> ()) {
        dispatch_apply(iterations, GCD.utilityQueue(), block)
    }
    public static func background(iterations: Int, block: (Int) -> ()) {
        dispatch_apply(iterations, GCD.backgroundQueue(), block)
    }
    public static func customQueue(iterations: Int, queue: dispatch_queue_t, block: (Int) -> ()) {
        dispatch_apply(iterations, queue, block)
    }
}



// MARK: - qos_class_t

extension qos_class_t {

    // Convenience description of qos_class_t
	// Calculated property
	var description: String {
		get {
			switch self.id {
				case qos_class_main().id: return "Main"
				case QOS_CLASS_USER_INTERACTIVE.id: return "User Interactive"
				case QOS_CLASS_USER_INITIATED.id: return "User Initiated"
				case QOS_CLASS_DEFAULT.id: return "Default"
				case QOS_CLASS_UTILITY.id: return "Utility"
				case QOS_CLASS_BACKGROUND.id: return "Background"
				case QOS_CLASS_UNSPECIFIED.id: return "Unspecified"
				default: return "Unknown"
			}
		}
	}
}
