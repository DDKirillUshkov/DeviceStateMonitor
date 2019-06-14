//
//  DeviceStateMonitorNew.swift
//  DeviceStateMonitor
//
//  Created by Artur Kvaratshelia on 6/12/19.
//

import Foundation

@objc public enum DeviceService: Int {
    case thermal
    case battery
    case power
}

@objc public protocol ServiceState {
    @objc var service: DeviceService { get }
}

public class ThermalState: ServiceState {
    public var thermalState: ProcessInfo.ThermalState
    public var service: DeviceService { return .thermal }
    
    init(thermalState: ProcessInfo.ThermalState) {
        self.thermalState = thermalState
    }
}

public class BatteryState: ServiceState {
    public var batteryState: UIDevice.BatteryState
    public var service: DeviceService { return .battery }
    
    init(batteryState: UIDevice.BatteryState) {
        self.batteryState = batteryState
    }
}

public class PowerState: ServiceState {
    public var isLowMode: Bool
    public var service: DeviceService { return .power }
    
    init(isLowMode: Bool) {
        self.isLowMode = isLowMode
    }
}

@objc public protocol DeviceStateSubscriber: AnyObject {
    func didUpdate(serviceState: ServiceState)
}

public final class DeviceStateMonitorNew {
    
    // MARK: - Public Properties
    
    public static let sharedInstance = DeviceStateMonitorNew()
    
    // MARK: - Private Properties
    
    private let notificationCenter = NotificationCenter.default
    private let device = UIDevice.current
    private var subscribers: [DeviceService: NSHashTable<DeviceStateSubscriber>]
    
    // MARK: - Lifecycle
    
    private init() {
        subscribers = [.thermal: NSHashTable<DeviceStateSubscriber>.weakObjects(),
                       .battery: NSHashTable<DeviceStateSubscriber>.weakObjects(),
                       .power: NSHashTable<DeviceStateSubscriber>.weakObjects()]
        addObservers()
    }
    
    deinit {
        device.isBatteryMonitoringEnabled = false
    }
    
    // MARK: - Interface
    
    public func subscribe(subscriber: DeviceStateSubscriber, to service: DeviceService) {
        subscribers[service]?.add(subscriber)
    }
    
    // MARK: - Private
    
    private func addObservers() {
        device.isBatteryMonitoringEnabled = true
        notificationCenter.addObserver(self, selector: .thermalDidChange, name: .thermalDidChange, object: nil)
        notificationCenter.addObserver(self, selector: .batteryDidChange, name: .batteryDidChange, object: nil)
        notificationCenter.addObserver(self, selector: .powerDidChange, name: .powerDidChange, object: nil)
    }
}

// MARK: - Subscribes
private extension DeviceStateMonitorNew {
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
        if let isLowMode = (notification.object as? ProcessInfo)?.isLowPowerModeEnabled {
            let state = PowerState(isLowMode: isLowMode)
            subscribers[.power]?.allObjects.forEach({ $0.didUpdate(serviceState: state) })
        }
    }
}

fileprivate extension Selector {
    static let thermalDidChange = #selector(DeviceStateMonitorNew.termalStateDidChange(_:))
    static let batteryDidChange = #selector(DeviceStateMonitorNew.batteryStateDidChange(_:))
    static let powerDidChange = #selector(DeviceStateMonitorNew.powerModeDidChange(_:))
}

fileprivate extension NSNotification.Name {
    static let thermalDidChange = ProcessInfo.thermalStateDidChangeNotification
    static let batteryDidChange = UIDevice.batteryStateDidChangeNotification
    static let powerDidChange = NSNotification.Name.NSProcessInfoPowerStateDidChange
}
