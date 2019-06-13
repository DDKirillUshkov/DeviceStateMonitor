//
//  DeviceStateMonitorNew.swift
//  DeviceStateMonitor
//
//  Created by Artur Kvaratshelia on 6/12/19.
//

import Foundation
import AVFoundation

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
    
    // MARK: - Properties
    
    public static let sharedInstance = DeviceStateMonitorNew()
    
    private var subscribers: [DeviceService: NSHashTable<DeviceStateSubscriber>]
    
    // MARK: - Lifecycle
    
    private init() {
        subscribers = [.thermal: NSHashTable<DeviceStateSubscriber>.weakObjects(),
                       .battery: NSHashTable<DeviceStateSubscriber>.weakObjects(),
                       .power: NSHashTable<DeviceStateSubscriber>.weakObjects()]
        addObservers()
    }
    
    // MARK: - Interface
    
    public func subscribe(subscriber: DeviceStateSubscriber, to service: DeviceService) {
        subscribers[service]?.add(subscriber)
    }
    
    // MARK: - Private
    
    private func addObservers() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(termalStateDidChange(_:)),
                                               name: ProcessInfo.thermalStateDidChangeNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(batteryStateDidChange(_:)),
                                               name: UIDevice.batteryStateDidChangeNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(powerStateDidChange(_:)),
                                               name: NSNotification.Name.NSProcessInfoPowerStateDidChange,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange(_:)),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: nil)
    }
    
    
}

// MARK: - Subscribes
private extension DeviceStateMonitorNew {
    @objc func termalStateDidChange(_ notification: NSNotification) {
        // or get from notification
        let thermalState = ProcessInfo.processInfo.thermalState
        let state = ThermalState(thermalState: thermalState)
        subscribers[.thermal]?.allObjects.forEach({ $0.didUpdate(serviceState: state) })
    }
    
    @objc func batteryStateDidChange(_ notification: NSNotification) {
        // or get from notification
        let batteryState: UIDevice.BatteryState = UIDevice.current.batteryState
        let state = BatteryState(batteryState: batteryState)
        subscribers[.battery]?.allObjects.forEach({ $0.didUpdate(serviceState: state) })
    }
    
    @objc func powerStateDidChange(_ notification: NSNotification) {
        // or get from notification
        let powerState: Bool = ProcessInfo.processInfo.isLowPowerModeEnabled
        let state = PowerState(isLowMode: powerState)
        subscribers[.power]?.allObjects.forEach({ $0.didUpdate(serviceState: state) })
    }
    
    @objc func handleRouteChange(_ notification: NSNotification) {
        // or get from notification
        
        let userInfo = notification.userInfo
        guard let reasonRaw = userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber else { return }
        let reason = AVAudioSession.RouteChangeReason(rawValue: reasonRaw.uintValue)
    }
}
