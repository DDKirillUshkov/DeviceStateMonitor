//
//  SafeTheme.swift
//  StateMonitoringDemo
//
//  Created by Valeriy Efimov on 3/17/19.
//  Copyright © 2019 tomych. All rights reserved.
//

import UIKit

class SafeTheme: Theme {
    var backgroundColor: UIColor = .black
    var collectionViewTheme: CollectionViewTheme = CollectionViewThemeSafe()
    var labelTheme: LabelTheme = LabelThemeSafe()
    var imageViewTheme: ImageViewTheme = ImageViewThemeSafe()
    var buttonTheme: ButtonTheme = ButtonThemeSafe()
    var blurTheme: BlurTheme = BlurThemeSafe()
    var navigationBarTheme: NavigationBarTheme = NavigationBarThemeSafe()
    var backgroundTasksAvailable: Bool = false
    var recommendedBrightnessLevel: CGFloat = 0.2
    
    class CollectionViewThemeSafe: CollectionViewTheme {
        var backgroundColor: UIColor = .black
    }
    
    class LabelThemeSafe: LabelTheme {
        var backgroundColor: UIColor = .clear
        var fontColor: UIColor = .lightText
    }
    
    class ImageViewThemeSafe: ImageViewTheme {
        var backgroundColor: UIColor = .clear
    }
    
    class ButtonThemeSafe: ButtonTheme {
        var backgroundColor: UIColor = .clear
        var tintColor: UIColor = .lightText
    }
    
    class BlurThemeSafe: BlurTheme {
        var backgroundColor: UIColor = .black
        var vibrancy: Bool = false
        var effectStyle: UIBlurEffect.Style = .prominent
        var blurAvailable: Bool = false
    }
    
    class NavigationBarThemeSafe: NavigationBarTheme {
        var backgroundColor: UIColor = .black
        var titleColor: UIColor = .lightText
    }
}

