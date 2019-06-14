//
//  ViewController.swift
//  StateMonitoringDemo
//
//  Copyright (c) 2019 dashdevs.com. All rights reserved.
//

import UIKit
import SwiftMessages
import DeviceStateMonitor

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    // MARK: - Properties
    
    private let deviceStateMonitor = DeviceStateMonitor.sharedInstance
    private let theme = ThemeStorage.shared
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apply(theme: theme.current)
        deviceStateMonitor.subscribe(subscriber: self, to: .thermal)
        deviceStateMonitor.subscribe(subscriber: self, to: .battery)
        deviceStateMonitor.subscribe(subscriber: self, to: .power)
    }
}

// MARK: - DeviceStateSubscriber
extension ViewController: DeviceStateSubscriber {
    func didUpdate(serviceState: ServiceState) {
        switch serviceState {
        case let thermalState as ThermalState:
            theme.currentStyle = thermalState.style
            apply(theme: theme.current)
            show(message: Message(thermalState: thermalState))
        case let batteryState as BatteryState:
            theme.currentStyle = batteryState.style
            apply(theme: theme.current)
            show(message: Message(batteryState: batteryState))
        case let powerState as PowerState:
            theme.currentStyle = powerState.style
            apply(theme: theme.current)
            show(message: Message(powerState: powerState))
        default: break
        }
    }
}

// MARK: - PowerState
fileprivate extension PowerState {
    var style: ThemeStyle {
        switch isLowMode {
        case true: return .safe
        case false: return .regular
        }
    }
}

// MARK: - BatteryState
fileprivate extension BatteryState {
    var style: ThemeStyle {
        switch batteryState {
        case .charging: return .dark
        case .full: return .regular
        case .unplugged, .unknown: return .safe
        }
    }
}

// MARK: - ThermalState
fileprivate extension ThermalState {
    var style: ThemeStyle {
        switch thermalState {
        case .critical, .serious, .fair: return .safe
        case .nominal: return .regular
        }
    }
}

// MARK: - DataStructures
extension ViewController {
    enum Message: String {
        
        case lowPowerMode = "Hello guy! Low power mode enabled"
        case regularPowerMode = "Hello guy! Low power mode disabled"
        case batteryCharging = "Hello guy! I'm charging"
        case batteryFull = "Hello guy! I've full battery"
        case batteryUnplugged = "Hello guy! I was disconnected from the network"
        case batteryUnknown = "Hello guy! I don't know what happened"
        case thermalCritial = "Hey, help me! I'm burning!!!"
        case thermalSerious = "Hey, I feel hot"
        case thermalFair = "Hey, slow down"
        case thermalNominal = "Hello, I stand idle"
        
        init(powerState: PowerState) {
            switch powerState.isLowMode {
            case true: self = .lowPowerMode
            case false: self = .regularPowerMode
            }
        }
        
        init(batteryState: BatteryState) {
            switch batteryState.batteryState {
            case .charging: self = .batteryCharging
            case .full: self = .batteryFull
            case .unplugged: self = .batteryUnplugged
            case .unknown: self = .batteryUnknown
            }
        }
        
        init(thermalState: ThermalState) {
            switch thermalState.thermalState {
            case .critical: self = .thermalCritial
            case .serious: self = .thermalSerious
            case .fair: self = .thermalFair
            case .nominal: self = .thermalNominal
            }
        }
    }
}

// MARK: - Themable
extension ViewController: Themable {
    func apply(theme: Theme) {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.apply(theme: self.theme.current)
            self.collectionView.apply(theme: self.theme.current)
            self.navigationController?.navigationBar.layoutSubviews()
            UIScreen.main.brightness = CGFloat(theme.recommendedBrightnessLevel)
        }
    }
}

// MARK: - Messages
extension ViewController {
    func show(message: Message) {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .statusLine)
            
            switch message {
            case .lowPowerMode,
                 .batteryUnknown,
                 .thermalCritial,
                 .thermalSerious,
                 .thermalFair:
                view.configureTheme(.warning)
                view.configureContent(title: "Warning", body: message.rawValue, iconText: "🔥")
            case .regularPowerMode,
                 .batteryCharging,
                 .batteryUnplugged,
                 .batteryFull,
                 .thermalNominal:
                view.configureTheme(.info)
                view.configureContent(title: "Info", body: message.rawValue, iconText: "🤔")
            }
            
            view.configureDropShadow()
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            SwiftMessages.show(view: view)
        }
    }
}
