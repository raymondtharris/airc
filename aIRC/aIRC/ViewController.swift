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

let AddingServerNotification:String = "AddingServerNotification"

class ServerListViewController: UITableViewController {
    var servers:[Server] = [Server]()//[Server(aName: "Server 1", anAddress: NSURL(string: "http://chat.freenode.net")!, aPort: 6667), Server(aName: "Server 2", anAddress: NSURL(string: "http://chat.freenode.net")!, aPort: 6667), Server(aName: "Server 3", anAddress: NSURL(string: "http://chat.freenode.net")!, aPort: 6667), Server(aName: "Server 4", anAddress: NSURL(string: "http://chat.freenode.net")!, aPort: 6667)]
    var deleteIndexPath:NSIndexPath? = nil
    var index = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addingNewServer:", name: AddingServerNotification, object: nil)

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("serverCell", forIndexPath: indexPath) as! ServerCellView
        cell.serverNameLabel.text = servers[indexPath.row].name
        return cell
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteIndexPath = indexPath
            let serverToDelete = servers[indexPath.row]
            deleteAServer(serverToDelete)
        }
    }
    func deleteAServer(aServer:Server){
        let alert = UIAlertController(title: "Delete Server", message: "Are you sure you want to remove \(aServer.name)?", preferredStyle: .ActionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: executeServerDelete)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelServerDelete)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func executeServerDelete(alertAction: UIAlertAction!) {
        if let indexPath = deleteIndexPath {
            let view  = self.view as! UITableView
            view.beginUpdates()
            _ = servers.removeAtIndex(indexPath.row)
            view.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            deleteIndexPath = nil
            view.endUpdates()
        }
        
    }
    func cancelServerDelete(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }
    @IBAction func addServer(sender: AnyObject) {
        let newServer = Server(aName: "Server \(servers.count + 1)", anAddress: NSURL(string: "http://chat.freenode.net")!, aPort: 6667)
        servers.append(newServer)
        let view = self.view as! UITableView
        view.reloadData()
    }

    func addingNewServer(notification: NSNotification){
        let dataDictionary = notification.userInfo!
        let newServer = dataDictionary["server"] as! Server
        servers.append(newServer)
        let tableView = self.view as! UITableView
        tableView.reloadData()
    }
}

class ServerCellView: UITableViewCell {
    @IBOutlet weak var serverNameLabel: UILabel!
    
}

class ServerConfigViewController: UIViewController {
    var newServer = Server()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func addNewServer(sender: AnyObject) {
        newServer.name = "Server "
        newServer.address = NSURL(string: "http://chat.freenode.net")!
        let serverDictionary = ["server" : newServer]
        NSNotificationCenter.defaultCenter().postNotificationName(AddingServerNotification, object: self, userInfo: serverDictionary)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
