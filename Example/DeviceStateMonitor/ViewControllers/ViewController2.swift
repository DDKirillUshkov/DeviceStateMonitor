//
//  ViewController2.swift
//  DeviceStateMonitor_Example
//
//  Created by Artur Kvaratshelia on 6/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import DeviceStateMonitor

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let monitor = DeviceStateMonitorNew.sharedInstance
        monitor.add2(subscriber: self) { (result: ThermalResult) in
            print(result.value)
        }
        
        monitor.add2(subscriber: self, completion: { (result: BatteryResult) in
            print(result.value)
        })
        
        monitor.add2(subscriber: self, completion: { (result: PowerResult) in
            print(result.value)
        })
    }
}
