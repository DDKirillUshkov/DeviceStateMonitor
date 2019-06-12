//
//  Themable.swift
//  StateMonitoringDemo
//
//  Created by Valeriy Efimov on 3/17/19.
//  Copyright © 2019 tomych. All rights reserved.
//

import UIKit

protocol Themable {
    func apply(theme: Theme)
}

enum ThemeStyle {
    case regular
    case dark
    case safe
}

protocol CollectionViewTheme {
    var backgroundColor: UIColor { get }
}

extension UICollectionView: Themable {
    func apply(theme: Theme) {
        self.backgroundColor = theme.collectionViewTheme.backgroundColor
        reloadData()
    }
}

protocol LabelTheme {
    var backgroundColor: UIColor { get }
    var fontColor: UIColor { get }
}

extension UILabel: Themable {
    func apply(theme: Theme) {
        self.backgroundColor = theme.labelTheme.backgroundColor
        self.textColor = theme.labelTheme.fontColor
    }
}

protocol ImageViewTheme {
    var backgroundColor: UIColor { get }
}

extension UIImageView: Themable {
    func apply(theme: Theme) {
        self.backgroundColor = theme.backgroundColor
    }
}

protocol ButtonTheme {
    var backgroundColor: UIColor { get }
    var tintColor: UIColor { get }
}

extension UIButton: Themable {
    func apply(theme: Theme) {
        self.backgroundColor = theme.buttonTheme.backgroundColor
        self.setTitleColor(theme.buttonTheme.tintColor, for: .normal)
    }
}

protocol BlurTheme {
    var backgroundColor: UIColor { get }
    var effectStyle: UIBlurEffect.Style { get }
    var vibrancy: Bool { get }
    var blurAvailable: Bool { get }
}

extension UIVisualEffectView: Themable {
    func apply(theme: Theme) {
        self.backgroundColor = theme.blurTheme.backgroundColor
        self.isHidden = !theme.blurTheme.blurAvailable
        if theme.blurTheme.blurAvailable {
            self.effect = UIBlurEffect(style: theme.blurTheme.effectStyle)
        }
    }
}

protocol NavigationBarTheme {
    var backgroundColor: UIColor { get }
    var titleColor: UIColor { get }
}

extension UINavigationBar: Themable {
    func apply(theme: Theme) {
        self.barTintColor = theme.navigationBarTheme.backgroundColor
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.navigationBarTheme.titleColor]
        largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.navigationBarTheme.titleColor]
    }
}

protocol Theme {
    var backgroundColor: UIColor { get }
    var collectionViewTheme: CollectionViewTheme { get }
    var labelTheme: LabelTheme { get }
    var imageViewTheme: ImageViewTheme { get }
    var buttonTheme: ButtonTheme { get }
    var blurTheme: BlurTheme { get }
    var navigationBarTheme: NavigationBarTheme { get }
    var backgroundTasksAvailable : Bool { get }
    var recommendedBrightnessLevel: CGFloat { get }
}

class ThemeStorage {
    static let shared = ThemeStorage()
    var currentStyle: ThemeStyle = .regular
}

extension ThemeStorage {
    var current: Theme {
        switch ThemeStorage.shared.currentStyle {
        case .dark:
            return DarkTheme()
        case .regular:
            return RegularTheme()
        case .safe:
            return SafeTheme()
        }
    }
}
