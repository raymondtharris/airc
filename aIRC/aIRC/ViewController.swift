//
//  ViewController.swift
//  aIRC
//
//  Created by Tim Harris on 9/13/15.
//  Copyright © 2015 Tim Harris. All rights reserved.
//

import UIKit



class ViewController: UIViewController, NSStreamDelegate {
    var inputStream : NSInputStream?
    var outputStream : NSOutputStream?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var readStream: Unmanaged<CFReadStreamRef>?
        var writeStream: Unmanaged<CFWriteStreamRef>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, "http://www.google.com" as CFStringRef, 80, &readStream, &writeStream)
        
        
        
        inputStream = readStream!.takeUnretainedValue()
        outputStream = writeStream!.takeUnretainedValue()
        
        inputStream!.delegate = self
        outputStream!.delegate = self
        
        inputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream!.open()
        outputStream!.open()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if aStream.isKindOfClass(NSInputStream){
            switch eventCode {
            case NSStreamEvent.None:
                print("there is none")
                break
            case NSStreamEvent.OpenCompleted:
                print("open")
                break
            case NSStreamEvent.HasBytesAvailable:
                print("write the bytes")
                var buffer = [UInt8](count: 8, repeatedValue: 0)
                let stream = aStream as! NSInputStream
                while stream.hasBytesAvailable{
                    let res = (aStream as! NSInputStream).read(&buffer, maxLength: buffer.count)
                    print("\(res.description)  \(buffer.count)")
                }
                break
            case NSStreamEvent.ErrorOccurred:
                print("there is an error")
                break
            case NSStreamEvent.HasSpaceAvailable:
                print("there is space")
                break
            case NSStreamEvent.EndEncountered:
                print("it has endned")
                break
            default:
                print("other")
                break
            }
        }
        if aStream.isKindOfClass(NSOutputStream){
            print("output")
            switch eventCode {
            case NSStreamEvent.None:
                print("there is none")
                break
            case NSStreamEvent.OpenCompleted:
                print("open")
                break
            case NSStreamEvent.HasBytesAvailable:
                print("write the bytes")
                var buffer = [UInt8](count: 8, repeatedValue: 0)
                let res = (aStream as! NSInputStream).read(&buffer, maxLength: buffer.count)
                print("\(res.description)  \(buffer.count)")
                break
            case NSStreamEvent.ErrorOccurred:
                print("there is an error")
                break
            case NSStreamEvent.HasSpaceAvailable:
                print("there is space")
                break
            case NSStreamEvent.EndEncountered:
                print("it has endned")
                break
            default:
                print("other")
                break
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

