//
//  DeviceStateMonitorNew.swift
//  DeviceStateMonitor
//
//  Created by Artur Kvaratshelia on 6/12/19.
//

import Foundation
import AVFoundation

// TODO: Check forbiddance for implementation of Result in other library

public protocol Result {
    associatedtype Value
    var value: Value { get set }
}

public class ThermalResult: Result {
    public typealias Value = ProcessInfo.ThermalState
    public var value: Value
    
    init(value: Value) {
        self.value = value
    }
}

public class BatteryResult: Result {
    public typealias Value = UIDevice.BatteryState
    public var value: Value
    
    init(value: Value) {
        self.value = value
    }
}

public class PowerResult: Result {
    public typealias Value = Bool
    public var value: Value
    
    init(value: Value) {
        self.value = value
    }
}

public final class DeviceStateMonitorNew {
    
    public static let sharedInstance = DeviceStateMonitorNew()
    
    var thermalSubscribers = [SubscriberContainer<ThermalResult>]()
    var batterySubscribers = [SubscriberContainer<BatteryResult>]()
    var powerSubscribers = [SubscriberContainer<PowerResult>]()
    
    private init() {
        addObservers()
    }
    
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
    
    public func add2<T: Result>(subscriber: AnyObject, completion: @escaping ((T) -> Void)) {
        
        let container = SubscriberContainer(subscriber: subscriber, completion: completion)
        
        switch container {
        case let container as SubscriberContainer<ThermalResult>:
            thermalSubscribers.append(container)
        case let container as SubscriberContainer<BatteryResult>:
            batterySubscribers.append(container)
        case let container as SubscriberContainer<PowerResult>:
            powerSubscribers.append(container)
        default: break
        }
    }
}

// MARK: - Subscribes
private extension DeviceStateMonitorNew {
    @objc func termalStateDidChange(_ notification: NSNotification) {
        // or get from notification
        let thermalState = ProcessInfo.processInfo.thermalState
        let result = ThermalResult(value: thermalState)
        thermalSubscribers.forEach({ $0.completion?(result) })
    }
    
    @objc func batteryStateDidChange(_ notification: NSNotification) {
        // or get from notification
        let batteryState: UIDevice.BatteryState = UIDevice.current.batteryState
        let result = BatteryResult(value: batteryState)
        batterySubscribers.forEach({ $0.completion?(result) })
    }
    
    @objc func powerStateDidChange(_ notification: NSNotification) {
        // or get from notification
        let powerState: Bool = ProcessInfo.processInfo.isLowPowerModeEnabled
        let result = PowerResult(value: powerState)
        powerSubscribers.forEach({ $0.completion?(result) })
    }
    
    @objc func handleRouteChange(_ notification: NSNotification) {
        // or get from notification
        
        let userInfo = notification.userInfo
        guard let reasonRaw = userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber else { return }
        let reason = AVAudioSession.RouteChangeReason(rawValue: reasonRaw.uintValue)
    }
}

class SubscriberContainer<T: Result>: NSObject {
    
    private(set) weak var subscriber: AnyObject? {
        didSet {
            print("ALALA: \(subscriber)")
        }
    }
    
    private(set) var completion: ((T) -> Void)?
    
    init(subscriber: AnyObject?, completion: @escaping ((T) -> Void)) {
        self.subscriber = subscriber
        self.completion = completion
    }
}
