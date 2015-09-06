//
//  AISwiftLogger.swift
//  AI2020OS
//
//  Created by tinkl on 31/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*!
*  @author tinkl, 15-03-31 10:03:03
*
*  Logger for Console
*  ======================= how to use it? =======================
    logVerbose("This is verbose message")
    logDebug("I can use format: %d + %d = %d", args: 1, 1, 2)
    logInfo("This is info message")
    logWarning("This is a warning")
    logError("Cratical error")
*/
// Public Class
var logLevel = defaultDebugLevel
var AILogShowDateTime: Bool = true
var AILogShowLogLevel: Bool = true
var AILogShowFileName: Bool = true
var AILogShowLineNumber: Bool = true
var AILogShowFunctionName: Bool = true

enum AILogLevel: Int {
    case All        = 0
    case Verbose    = 10
    case Debug      = 20
    case Info       = 30
    case Warning    = 40
    case Error      = 50
    case Off        = 60
    static func logLevelString(logLevel: AILogLevel) -> String {
        switch logLevel {
        case .Verbose: return "Verbose"
        case .Info: return "Info"
        case .Debug: return "Debug"
        case .Warning: return "Warning"
        case .Error: return "Error"
        default: assertionFailure("Invalid level to get string")
        }
        return ""
    }
}

// Be sure to set the "DEBUG" symbol.
// Set it in the "Swift Compiler - Custom Flags" section, "Other Swift Flags" line. You add the DEBUG symbol with the -D DEBUG entry.
#if DEBUG
    let defaultDebugLevel = AILogLevel.All
#else
    let defaultDebugLevel = AILogLevel.All  // Current settings Other Swift Flags->DEBUG =>BUILD ERROR
#endif

var _AILogDateFormatter: NSDateFormatter?
var AILogDateFormatter: NSDateFormatter = {
    if _AILogDateFormatter == nil {
        _AILogDateFormatter = NSDateFormatter()
        _AILogDateFormatter!.locale = NSLocale(localeIdentifier: "en_US_POSIX") //24H
        _AILogDateFormatter!.dateFormat = "y-MM-dd HH:mm:ss.SSS"
    }
    return _AILogDateFormatter!
    }()

// Default
#if DEBUG
    var AILogFunc: (format: String) -> Void = println
    var AILogUsingNSLog: Bool = false
    #else
var AILogFunc: (format: String, args: CVarArgType...) -> Void = NSLog
var AILogUsingNSLog: Bool = true
#endif

func logVerbose(logText: String = "",
    file: String = __FILE__,
    line: UWord = __LINE__,
    function: String = __FUNCTION__,
    args: CVarArgType...)
{
    if AILogLevel.Verbose.rawValue >= logLevel.rawValue {
        log(.Verbose, file: file, function: function, line: line, format: logText, args: getVaList(args))
    }
}

func logInfo(logText: String = "",
    file: String = __FILE__,
    line: UWord = __LINE__,
    function: String = __FUNCTION__,
    args: CVarArgType...)
{
    if AILogLevel.Info.rawValue >= logLevel.rawValue {
        log(.Info, file: file, function: function, line: line, format: logText, args: getVaList(args))
    }
}

func logDebug(logText: String = "",
    file: String = __FILE__,
    line: UWord = __LINE__,
    function: String = __FUNCTION__,
    args: CVarArgType...)
{
    if AILogLevel.Debug.rawValue >= logLevel.rawValue {
        log(.Debug, file: file, function: function, line: line, format: logText, args: getVaList(args))
    }
}

func logWarning(logText: String = "",
    file: String = __FILE__,
    line: UWord = __LINE__,
    function: String = __FUNCTION__,
    args: CVarArgType...)
{
    if AILogLevel.Warning.rawValue >= logLevel.rawValue {
        log(.Warning, file: file, function: function, line: line, format: logText, args: getVaList(args))
    }
}

func logError(logText: String = "",
    file: String = __FILE__,
    line: UWord = __LINE__,
    function: String = __FUNCTION__,
    args: CVarArgType...)
{
    if AILogLevel.Error.rawValue >= logLevel.rawValue {
        log(.Error, file: file, function: function, line: line, format: logText, args: getVaList(args))
    }
}

func logWithLevel(level: AILogLevel,
    _
    logText: String = "",
    file: String = __FILE__,
    line: UWord = __LINE__,
    function: String = __FUNCTION__,
    args: CVarArgType...)
{
    if level.rawValue >= logLevel.rawValue {
        log(level, file: file, function: function, line: line, format: logText, args: getVaList(args))
    }
}

private func log(level: AILogLevel, file: String = __FILE__, var function: String = __FUNCTION__, line: UWord = __LINE__, format: String, args: CVaListPointer) {
    let time: String = AILogShowDateTime ? (AILogUsingNSLog ? "" : "\(AILogDateFormatter.stringFromDate(NSDate())) ") : ""
    let level: String = AILogShowLogLevel ? "[\(AILogLevel.logLevelString(level))] " : ""
    var fileLine: String = ""
    if AILogShowFileName {
        fileLine += "[" + file.lastPathComponent
        if AILogShowLineNumber {
            fileLine += ":\(line)"
        }
        fileLine += "] "
    }
    if !AILogShowFunctionName { function = "" }
    let message = NSString(format: format, arguments: args) as String
    let logText = "\(time)\(level)\(fileLine)\(function): \(message)"
    
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        AILogFunc(format: logText)
    })
}
