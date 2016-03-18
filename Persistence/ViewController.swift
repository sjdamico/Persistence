//
//  ViewController.swift
//  Persistence
//
//  Created by Steve D'Amico on 3/16/16.
//  Copyright © 2016 Steve D'Amico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var lineFields:[UITextField]!
    
    /*  When the main view is finished loading, it looks for a .plist file. If it exists, it is copied into the text fields. Next, the application is registered to be notified when the application becomes inactive (either by quiting or being pushed to the background). With notification, the values from the text field are written to a mutable array and saved to a .plist file.
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fileURL = self.dataFileURL()
        // Does data file already exist, if yes, instantiate an array with the contents of that file
        if (NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)) {
            // NSArray initializer creates an NSArray object of the contents at the NSURL
            if let array = NSArray(contentsOfURL: fileURL) as? [String] {
                for var i = 0; i < array.count; i++ {   // Copy to text fields
                    lineFields[i].text = array[i]
                }
            }
        }
        // Application needs to save its data before it is terminated, by app no longer in use, or incoming phone call
        let app = UIApplication.sharedApplication()
        // Using the NSNotificationCenter for notification of events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: app)
    }
    // Notification center calls this to construct an array of strings
    func applicationWillResignActive(notification:NSNotification) {
        let fileURL = self.dataFileURL()
        // NSArray implementation valueForKey does the iteration
        let array = (self.lineFields as NSArray).valueForKey("text") as! NSArray
        // writeToURL writes array to a .plist file
        array.writeToURL(fileURL, atomically: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dataFileURL() -> NSURL {   //Returns the URL of the data file to be created by finding the Documents directory and appending the file name to it.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls.first!.URLByAppendingPathComponent("data.plist")
    }

}

