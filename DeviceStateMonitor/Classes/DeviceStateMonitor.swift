////
////  DeviceStateMonitor.swift
////  StateMonitoringDemo
////
////  Created by Valeriy Efimov on 3/25/19.
////  Copyright © 2019 tomych. All rights reserved.
////
//
//import AVFoundation
//import UIKit
//
//public protocol StateHandler: class {
//    func didChangeAccessours(state: Accessours)
//    func didChangePowerMode(state: PowerMode)
//    func didChangePowerState(state: PowerState)
//    func didChangeTermalState(state: TermalState)
//}
//
//public final class DeviceStateMonitor {
//    open var delegate: StateHandler
//    
//    public init(with delegate: StateHandler) {
//        self.delegate = delegate
//        UIDevice.current.isBatteryMonitoringEnabled = true
//        try? AVAudioSession.sharedInstance().setActive(true, options: [])
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(batteryStateDidChange(_:)),
//                                               name: UIDevice.batteryStateDidChangeNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(termalStateDidChange(_:)),
//                                               name: ProcessInfo.thermalStateDidChangeNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(handleRouteChange(_:)),
//                                               name: AVAudioSession.routeChangeNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(powerModeDidChange(_:)),
//                                               name: NSNotification.Name.NSProcessInfoPowerStateDidChange,
//                                               object: nil)
//    }
//    
//    deinit {
//        UIDevice.current.isBatteryMonitoringEnabled = false
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
//// MARK: - State names
//public enum Accessours {
//    case headphones
//    case bluetoothA2DP
//    case airPlay
//    case bluetoothLE
//    case bluetoothHFP
//    case usbAudio
//    case carAudio
//}
//
//public enum PowerMode {
//    case ordinary
//    case lowPower
//}
//
//public enum PowerState {
//    case charging
//    case full
//    case unplugged
//}
//
//public enum TermalState {
//    case fair
//    case critical
//    case serious
//    case nominal
//}
//
//// MARK: - Thermal handling
//extension DeviceStateMonitor {
//    @objc func termalStateDidChange(_ notification: NSNotification) {
//        switch ProcessInfo.processInfo.thermalState {
//        case .fair:
//            delegate.didChangeTermalState(state: .fair)
//        case .critical:
//            delegate.didChangeTermalState(state: .critical)
//        case .serious:
//            delegate.didChangeTermalState(state: .serious)
//        case .nominal:
//            delegate.didChangeTermalState(state: .nominal)
//        }
//    }
//}
//
//// MARK: - Power & battery handling
//extension DeviceStateMonitor {
//    @objc func batteryStateDidChange(_ notification: NSNotification) {
//        switch UIDevice.current.batteryState {
//        case .charging:
//            delegate.didChangePowerState(state: .charging)
//        case .full:
//             delegate.didChangePowerState(state: .full)
//        case .unplugged:
//             delegate.didChangePowerState(state: .unplugged)
//        case .unknown:
//             delegate.didChangePowerState(state: .unplugged)
//        }
//    }
//    
//    @objc func powerModeDidChange(_ notification: NSNotification) {
//        let isLowPowerModeEnabled = ProcessInfo.processInfo.isLowPowerModeEnabled
//        delegate.didChangePowerMode(state: isLowPowerModeEnabled ? .lowPower : .ordinary)
//    }
//}
//
//// MARK: - Accessours handling
//extension DeviceStateMonitor {
//    @objc func handleRouteChange(_ notification: Notification) {
//        let userInfo = notification.userInfo
//        guard let reasonRaw = userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber else { return }
//        let reason = AVAudioSession.RouteChangeReason(rawValue: reasonRaw.uintValue)
//        
//        if reason == .newDeviceAvailable {
//            let device = AVAudioSession.sharedInstance().currentRoute.outputs.first?.portType
//            switch device {
//            case AVAudioSession.Port.headphones:
//                delegate.didChangeAccessours(state: .headphones)
//            case AVAudioSession.Port.bluetoothA2DP:
//                  delegate.didChangeAccessours(state: .bluetoothA2DP)
//            case AVAudioSession.Port.airPlay:
//                  delegate.didChangeAccessours(state: .airPlay)
//            case AVAudioSession.Port.bluetoothLE:
//                  delegate.didChangeAccessours(state: .bluetoothLE)
//            case AVAudioSession.Port.bluetoothHFP:
//                  delegate.didChangeAccessours(state: .bluetoothHFP)
//            case AVAudioSession.Port.usbAudio:
//                  delegate.didChangeAccessours(state: .usbAudio)
//            case AVAudioSession.Port.carAudio:
//                 delegate.didChangeAccessours(state: .carAudio)
//            default: print("Other device e.g. HDMI")
//            }
//        }
//    }
//}
