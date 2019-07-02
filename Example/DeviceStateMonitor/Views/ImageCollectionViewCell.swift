//
//  ImageCollectionViewCell.swift
//  DeviceStateMonitor
//
//  Copyright © 2019 dashdevs. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentImageView: UIImageView!
}

extension ImageCollectionViewCell: Themable {
    func apply(theme: Theme) {
        backgroundColor = theme.backgroundColor
        contentImageView.apply(theme: theme)
    }
}

