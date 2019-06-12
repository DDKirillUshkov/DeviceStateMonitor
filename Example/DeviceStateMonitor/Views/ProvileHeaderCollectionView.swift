//
//  ProvileHeaderCollectionView.swift
//  StateMonitoringDemo
//
//  Created by Valeriy Efimov on 3/17/19.
//  Copyright © 2019 tomych. All rights reserved.
//

import UIKit

class ProvileHeaderCollectionView: UICollectionReusableView {
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var underBlurView: UIImageView!
}

extension ProvileHeaderCollectionView: Themable {
    func apply(theme: Theme) {
        backgroundColor = theme.backgroundColor
        ratingLabel.apply(theme: theme)
        photosLabel.apply(theme: theme)
        followersLabel.apply(theme: theme)
        blurView.apply(theme: theme)
        underBlurView.isHidden = !theme.blurTheme.blurAvailable
        locationButton.apply(theme: theme)
    }
}
