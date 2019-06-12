//
//  ViewController.swift
//  StateMonitoringDemo
//
//  Created by Valeriy Efimov on 3/17/19.
//  Copyright © 2019 tomych. All rights reserved.
//

import UIKit
import SwiftMessages
import DeviceStateMonitor

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    var deviceStateMonitor: DeviceStateMonitor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceStateMonitor = DeviceStateMonitor(with: self)
        apply(theme: ThemeStorage.shared.current)
    }
    
    //just hack to demonstrate - need to figure out how to heat real device
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            ThemeStorage.shared.currentStyle = .safe
            apply(theme: ThemeStorage.shared.current)
            present(message: .overTermal)
        }
    }
}

extension ViewController: Themable {
    func apply(theme: Theme) {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.apply(theme: ThemeStorage.shared.current)
            self.collectionView.apply(theme: ThemeStorage.shared.current)
            self.navigationController?.navigationBar.layoutSubviews()
            UIScreen.main.brightness = CGFloat(theme.recommendedBrightnessLevel)
        }
    }
}

enum MessageType: String {
    case newAccessour = "Hey! New device plugged in"
    case darkTheme = "Hey! Swiched to dark theme"
    case regularTheme = "Hey! Swiched to regular theme"
    case charging = "We are charging - switched to regular theme"
    case overTermal = "Hey! We are burning - switched to safe theme"
}

extension ViewController: StateHandler {
    func didChangeAccessours(state: Accessours) {
        present(message: .newAccessour)
    }
    
    func didChangePowerMode(state: PowerMode) {
        if state == .lowPower {
            ThemeStorage.shared.currentStyle = .dark
            present(message: .darkTheme)
            apply(theme: ThemeStorage.shared.current)
            return
        }
        ThemeStorage.shared.currentStyle = .regular
        present(message: .regularTheme)
        apply(theme: ThemeStorage.shared.current)
        
    }
    
    func didChangePowerState(state: PowerState) {
        if state == .charging {
            ThemeStorage.shared.currentStyle = .regular
            apply(theme: ThemeStorage.shared.current)
            present(message: .charging)
        }
    }
    
    func didChangeTermalState(state: TermalState) {
        if state != .nominal {
            ThemeStorage.shared.currentStyle = .safe
            apply(theme: ThemeStorage.shared.current)
            present(message: .overTermal)
        }
    }    
}

extension ViewController {
    func present(message: MessageType) {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .statusLine)
            switch message {
            case .overTermal:
                view.configureTheme(.warning)
                view.configureContent(title: "Warning", body: message.rawValue, iconText: "🔥")
            case .darkTheme:
                view.configureTheme(.warning)
                view.configureContent(title: "Warning", body: message.rawValue, iconText: "😳")
            default:
                view.configureContent(title: "Hey", body: message.rawValue, iconText: "🤔")
                view.configureTheme(.info)
            }
            view.configureDropShadow()
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            SwiftMessages.show(view: view)
        }
    }
}
