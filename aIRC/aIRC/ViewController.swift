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
let AddingUserNotification:String =  "AddingUserNotification"

class ServerListViewController: UITableViewController {
    var servers:[Server] = [Server]()//[Server(aName: "Server 1", anAddress: NSURL(string: "http://chat.freenode.net")!, aPort: 6667), Server(aName: "Server 2", anAddress: NSURL(string: "http://chat.freenode.net")!, aPort: 6667), Server(aName: "Server 3", anAddress: NSURL(string: "http://chat.freenode.net")!, aPort: 6667), Server(aName: "Server 4", anAddress: NSURL(string: "http://chat.freenode.net")!, aPort: 6667)]
    var deleteIndexPath:NSIndexPath? = nil
    var index = 5
    var userData = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addingNewServer:", name: AddingServerNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addingNewUser:", name: AddingUserNotification, object: nil)
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("userData")
        loadUser()
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
    func loadUser(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("userData") != nil {
            //Get User data and set is for the userData variable.
            userData = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("userData") as! NSData) as! User
            //print(userData)
        } else{
            //segue to userConfig controller to create a new user.
            //print("new user.")
            self.performSegueWithIdentifier("presentUserConfig", sender: self)
        }
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
    
    func addingNewUser(notification: NSNotification){
        let userDictionary = notification.userInfo!
        print(userDictionary["user"])
        userData = userDictionary["user"] as! User
        let data = NSKeyedArchiver.archivedDataWithRootObject(userData)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "userData")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showChannelList" {
            let listView = self.view as! UITableView
            let indexPath: NSIndexPath = listView.indexPathForSelectedRow!
            let viewController = segue.destinationViewController as! ChannelListViewController
            let selectedServer = servers[indexPath.row]
            viewController.title = selectedServer.name
            viewController.channels = [Channel]()
            
        }
    }
}

class ServerCellView: UITableViewCell {
    @IBOutlet weak var serverNameLabel: UILabel!
    
}

class ServerConfigViewController: UIViewController {
    var newServer = Server()
    
    @IBOutlet weak var newServerAddressTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func addNewServer(sender: AnyObject) {
        newServer.name = "Server "
        newServer.address = NSURL(string: newServerAddressTextField.text!)!
        let serverDictionary = ["server" : newServer]
        NSNotificationCenter.defaultCenter().postNotificationName(AddingServerNotification, object: self, userInfo: serverDictionary)
        self.navigationController?.popViewControllerAnimated(true)
    }
}

class UserConfigViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNicknameTextField: UITextField!
    @IBOutlet weak var finishedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func saveNewUser(sender: AnyObject) {
        
        let newName = userNameTextField.text!
        let newNickname = userNicknameTextField.text!
        let userDataDictionary = ["user": User(aName: newName, aNickname: newNickname)]
        NSNotificationCenter.defaultCenter().postNotificationName(AddingUserNotification, object: self, userInfo: userDataDictionary)
        print(userDataDictionary)
        
    }
}

let AddingChannelNotification:String = "AddingChannelNotification"

class ChannelListViewController: UITableViewController {
    var channels = [Channel]()
    var server = Server()
    var deleteIndexPath:NSIndexPath? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.title = server.name
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addingNewChannel:", name: AddingChannelNotification, object: nil)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("channelCell", forIndexPath: indexPath) as! ChannelCellView
        cell.channelNameLabel.text = channels[indexPath.row].name
        return cell
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteIndexPath = indexPath
            let channelToDelete = channels[indexPath.row]
            deleteAServer(channelToDelete)
        }
    }
    func deleteAServer(aChannel:Channel){
        let alert = UIAlertController(title: "Delete Channel", message: "Are you sure you want to remove \(aChannel.name)?", preferredStyle: .ActionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: executeChannelDelete)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelChannelDelete)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func executeChannelDelete(alertAction: UIAlertAction!) {
        if let indexPath = deleteIndexPath {
            let view  = self.view as! UITableView
            view.beginUpdates()
            _ = channels.removeAtIndex(indexPath.row)
            view.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            deleteIndexPath = nil
            view.endUpdates()
        }
        
    }
    func cancelChannelDelete(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }
    
    func addingNewChannel(notificaiton:NSNotification){
        let channelDictionary = notificaiton.userInfo!
        let newChannel = channelDictionary["channel"] as! Channel
        channels.append(newChannel)
        let tableView = self.view as! UITableView
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChannelChatSegue" {
            let viewController = segue.destinationViewController as! ChannelChatViewController
            let listView = self.view as! UITableView
            let indexPath: NSIndexPath = listView.indexPathForSelectedRow!
            let selectedChannel = channels[indexPath.row]
            viewController.currentChannel = selectedChannel
            viewController.navigationController?.title = selectedChannel.name
        }
    }
    
}
class ChannelCellView: UITableViewCell {
    @IBOutlet weak var channelNameLabel: UILabel!
    
}

class ChannelConfigViewController: UIViewController {
    @IBOutlet weak var channelNameTextField: UITextField!
    @IBOutlet weak var addChannelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func addChannel(sender: AnyObject) {
        let newChannel = Channel(aName: channelNameTextField.text!)
        print(newChannel.name)
        let channelDictionary = ["channel": newChannel]
        NSNotificationCenter.defaultCenter().postNotificationName(AddingChannelNotification, object: self, userInfo: channelDictionary)
    }
}


class ChannelChatViewController: UIViewController {
    var currentChannel = Channel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
