//
//  DarkTheme.swift
//  StateMonitoringDemo
//
//  Created by Valeriy Efimov on 3/17/19.
//  Copyright © 2019 tomych. All rights reserved.
//

import UIKit

class DarkTheme: Theme {
    var backgroundColor: UIColor = .black
    var collectionViewTheme: CollectionViewTheme = CollectionViewThemeDark()
    var labelTheme: LabelTheme = LabelThemeDark()
    var imageViewTheme: ImageViewTheme = ImageViewThemeDark()
    var buttonTheme: ButtonTheme = ButtonThemeDark()
    var blurTheme: BlurTheme = BlurThemeDark()
    var navigationBarTheme: NavigationBarTheme = NavigationBarThemeDark()
    var backgroundTasksAvailable: Bool = true
    var recommendedBrightnessLevel: CGFloat = 0.8
    
    class CollectionViewThemeDark: CollectionViewTheme {
        var backgroundColor: UIColor = .black
    }
    
    class LabelThemeDark: LabelTheme {
        var backgroundColor: UIColor = .clear
        var fontColor: UIColor = .white
    }
    
    class ImageViewThemeDark: ImageViewTheme {
        var backgroundColor: UIColor = .clear
    }
    
    class ButtonThemeDark: ButtonTheme {
        var backgroundColor: UIColor = .clear
        var tintColor: UIColor = .white
    }
    
    class BlurThemeDark: BlurTheme {
        var backgroundColor: UIColor = .clear
        var vibrancy: Bool = true
        var effectStyle: UIBlurEffect.Style = .dark
        var blurAvailable: Bool = true
    }
    
    class NavigationBarThemeDark: NavigationBarTheme {
        var backgroundColor: UIColor = .black
        var titleColor: UIColor = .white
    }
}

