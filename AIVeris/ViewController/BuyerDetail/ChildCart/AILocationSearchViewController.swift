//
//  AILocationSearchViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Alamofire
import HanziPinyin

struct AIAddressParse: JSONJoy {
    var name: String?
    var address: String?
    
    var location_lng:Float?
    var location_lat:Float?
    
    init(){}
    
    init(_ decoder: JSONDecoder) {
        
    }
}

class AILocationSearchViewController: UIViewController , UITextFieldDelegate {
    
    private var dataSource: [AIAddressParse]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var searchFeild: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFeild.placeholder = "Tap here to search your location"
        searchFeild.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0)
        doneButton.titleLabel?.font = AITools.myriadLightWithSize(15)
        
        // Set Background Using Mask.
        let myLayer = CALayer()
        let myImage = UIImage(named: "Background_ChildService_Buy")?.CGImage
        myLayer.frame = view.bounds
        myLayer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0)
        myLayer.contents = myImage
        view.layer.insertSublayer(myLayer, atIndex: 0)
        
        Async.main(after: 0.1) { 
            self.searchFeild.addBottomWholeSSBorderLine(AIApplication.AIColor.MainSystemLineColor)
        }
        
    }
    
    deinit{
        debugPrint(self.classForCoder)
        self.searchFeild.delegate = nil
        self.tableView.delegate = nil
        self.tableView.dataSource = nil        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.searchFeild.canBecomeFirstResponder() {
            self.searchFeild.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendPathRequest("\(textField.text ?? "")")
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        dataSource?.removeAll()
        self.tableView.reloadData()
        return true
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        searchFeild.resignFirstResponder()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func sendPathRequest(address: String) {
        self.view.showLoading()
        /**
         path
         GET http://api.map.baidu.com/place/v2/search
         */
        
        // Add URL parameters
        let urlParams = [
            "q":"\(address)",
            "region":"北京",
            "output":"json",
            "ak":"BDa76a8f5523a567c7b829fba6aaa0fd",
            ]
        
        var array = Array<AIAddressParse>()
        
        // Fetch Request
        Alamofire.request(.GET, "http://api.map.baidu.com/place/v2/search", parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    if let dicResponse = response.data {
                        let json = JSONDecoder(dicResponse)
                        if let results = json["results"].array {
                            for resu in results {
                                var address = AIAddressParse()
                                address.address = resu["address"].string ?? ""
                                address.name = resu["name"].string ?? ""
                                array.append(address)
                            }
                            
                            
                        }//
                        // reload
                        self.dataSource = array
                        self.view.hideLoading()
                    }
                    
                }
                else {
                    self.view.hideLoading()
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }

    
}


extension AILocationSearchViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let deCell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if let textTitle = deCell?.contentView.viewWithTag(1) as? UILabel, let textDescription = deCell?.contentView.viewWithTag(2) as? UILabel {
            
            textTitle.font = AITools.myriadSemiCondensedWithSize(15)
            textDescription.font = AITools.myriadSemiCondensedWithSize(15)
            textDescription.textColor = UIColor(hexString: "#9A99ED")
            if let model = dataSource?[indexPath.row] {
                
//                let outputFormat = PinyinOutputFormat(toneType: .None, vCharType: .VCharacter, caseType: .Lowercase)
                textTitle.text = model.name?.toPinyin(withFormat: PinyinOutputFormat.defaultFormat, separator: " ")
                textDescription.text = model.address?.toPinyin(withFormat: PinyinOutputFormat.defaultFormat, separator: " ")
            }            
        }
        deCell?.addBottomWholeSSBorderLine(AIApplication.AIColor.MainSystemLineColor)
        return deCell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}






