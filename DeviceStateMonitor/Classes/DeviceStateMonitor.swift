//
//  DeviceStateMonitor.swift
//  DeviceStateMonitor
//
//  Copyright © 2019 dashdevs. All rights reserved.
//

import Foundation

/// Set of possible observable services
@objc public enum DeviceService: Int {
    case thermal
    case battery
    case power
}

/// The protocol that must be implemented by the result models
@objc public protocol ServiceState {
    @objc var service: DeviceService { get }
}

/// Class containing description of thermal state device
@available(iOS 11.0, *)
public class ThermalState: ServiceState {
    public var thermalState: ProcessInfo.ThermalState
    public var service: DeviceService { return .thermal }
    
    init(thermalState: ProcessInfo.ThermalState) {
        self.thermalState = thermalState
    }
}

/// Class containing description of battery state device
@available(iOS 3.0, *)
public class BatteryState: ServiceState {
    public var batteryState: UIDevice.BatteryState
    public var service: DeviceService { return .battery }
    
    init(batteryState: UIDevice.BatteryState) {
        self.batteryState = batteryState
    }
}

/// Class containing description of power state device
@available(iOS 9.0, *)
public class PowerState: ServiceState {
    public var isLowPowerModeEnabled: Bool
    public var service: DeviceService { return .power }
    
    init(isLowPowerModeEnabled: Bool) {
        self.isLowPowerModeEnabled = isLowPowerModeEnabled
    }
}

/// The subscriber's protocol that you need to implement in order to receive the update of the device states
@objc public protocol DeviceStateSubscriber: AnyObject {
    
    /// Method which will be called after some service updated
    ///
    /// - Parameter serviceState: Service state object which contains description of changed service
    func didUpdate(serviceState: ServiceState)
}

/// A class that monitors the status of device services.
public final class DeviceStateMonitor {
    
    /// Shared instance of DeviceStateMonitor
    public static let sharedInstance = DeviceStateMonitor()
    
    private let notificationCenter = NotificationCenter.default
    private let device = UIDevice.current
    private var subscribers: [DeviceService: NSHashTable<DeviceStateSubscriber>]
    
    private init() {
        subscribers = [.thermal: NSHashTable<DeviceStateSubscriber>.weakObjects(),
                       .battery: NSHashTable<DeviceStateSubscriber>.weakObjects(),
                       .power: NSHashTable<DeviceStateSubscriber>.weakObjects()]
        addObservers()
    }
    
    deinit {
        device.isBatteryMonitoringEnabled = false
    }
    
    /// Method for subscribing to service
    ///
    /// - Parameters:
    ///   - subscriber: Subscriber which will receive service updates
    ///   - service: Identifier observable service
    public func subscribe(subscriber: DeviceStateSubscriber, to service: DeviceService) {
        subscribers[service]?.add(subscriber)
    }
    
    /// Method for unsubscribing from service
    ///
    /// - Parameters:
    ///   - subscriber: Subscriber which will receive service updates
    ///   - service: Identifier observable service
    public func unsubscribe(subscriber: DeviceStateSubscriber, from service: DeviceService) {
        subscribers[service]?.remove(subscriber)
    }
    
    private func addObservers() {
        device.isBatteryMonitoringEnabled = true
        notificationCenter.addObserver(self, selector: .thermalDidChange, name: .thermalDidChange, object: nil)
        notificationCenter.addObserver(self, selector: .batteryDidChange, name: .batteryDidChange, object: nil)
        notificationCenter.addObserver(self, selector: .powerDidChange, name: .powerDidChange, object: nil)
    }
}

// MARK: - Subscribes
private extension DeviceStateMonitor {
    @objc func termalStateDidChange(_ notification: NSNotification) {
        if let thermalState = (notification.object as? ProcessInfo)?.thermalState {
            let thermalState = ThermalState(thermalState: thermalState)
            subscribers[.thermal]?.allObjects.forEach({ $0.didUpdate(serviceState: thermalState) })
        }
    }
    
    @objc func batteryStateDidChange(_ notification: NSNotification) {
        if let batteryState = (notification.object as? UIDevice)?.batteryState {
            let batteryState = BatteryState(batteryState: batteryState)
            subscribers[.battery]?.allObjects.forEach({ $0.didUpdate(serviceState: batteryState) })
        }
    }
    
    @objc func powerModeDidChange(_ notification: NSNotification) {
        if let isLowPowerModeEnabled = (notification.object as? ProcessInfo)?.isLowPowerModeEnabled {
            let state = PowerState(isLowPowerModeEnabled: isLowPowerModeEnabled)
            subscribers[.power]?.allObjects.forEach({ $0.didUpdate(serviceState: state) })
        }
    }
}

// MARK: - Selector
fileprivate extension Selector {
    static let thermalDidChange = #selector(DeviceStateMonitor.termalStateDidChange(_:))
    static let batteryDidChange = #selector(DeviceStateMonitor.batteryStateDidChange(_:))
    static let powerDidChange = #selector(DeviceStateMonitor.powerModeDidChange(_:))
}

// MARK: - NSNotification.Name
fileprivate extension NSNotification.Name {
    static let thermalDidChange = ProcessInfo.thermalStateDidChangeNotification
    static let batteryDidChange = UIDevice.batteryStateDidChangeNotification
    static let powerDidChange = NSNotification.Name.NSProcessInfoPowerStateDidChange
}
