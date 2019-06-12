//
//  ImageCollectionViewCell.swift
//  StateMonitoringDemo
//
//  Created by Valeriy Efimov on 3/17/19.
//  Copyright © 2019 tomych. All rights reserved.
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

