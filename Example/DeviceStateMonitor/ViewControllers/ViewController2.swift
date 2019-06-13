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
        monitor.subscribe(subscriber: self, to: .thermal)
        monitor.subscribe(subscriber: self, to: .battery)
        monitor.subscribe(subscriber: self, to: .power)
    }
}

extension ViewController2: DeviceStateSubscriber {
    func didUpdate(serviceState: ServiceState) {
        switch serviceState {
        case let serviceState as ThermalState:
            print(serviceState.thermalState)
        case let serviceState as BatteryState:
            print(serviceState.batteryState)
        case let serviceState as PowerState:
            print(serviceState.isLowMode)
        default: break
        }
    }
}
