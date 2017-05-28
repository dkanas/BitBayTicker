//
//  AppDelegate.swift
//  asd
//
//  Created by user on 28.05.2017.
//  Copyright © 2017 user. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var timer = Timer()
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.title = "$0.0"
        statusItem.menu = statusMenu
        getLastestPrice()
        self.timer = Timer.scheduledTimer(
            timeInterval: 5.0,
            target: self,
            selector: #selector(self.getLastestPrice),
            userInfo: nil,
            repeats: true
        )
    }
    
    func getLastestPrice() {
        let session = URLSession.shared
        let url = URL(string: "https://bitbay.net/API/Public/ETHPLN/ticker.json")!
        let task = session.dataTask(with: url) { (data, _, _) -> Void in
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let last = json["last"] as? Double {
                        self.statusItem.title = String(format: "%0.2f zł", arguments: [last])
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        task.resume()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

