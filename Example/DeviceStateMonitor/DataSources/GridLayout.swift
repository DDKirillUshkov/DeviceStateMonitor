//
//  GridLayout.swift
//  StateMonitoringDemo
//
//  Created by Valeriy Efimov on 3/17/19.
//  Copyright © 2019 tomych. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    var numberOfColumns: CGFloat = 3.0
    var numberOfRows: CGFloat = 4.0
    lazy var numberOfVerticalSpace: CGFloat = { return numberOfColumns - 1 }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        commonInit()
    }
    
    func commonInit() {
        self.minimumInteritemSpacing = 2.0
        self.minimumLineSpacing = 2.0
        
        let totalWidth: CGFloat = collectionView?.frame.width ?? 0
        let itemDimension: CGFloat = (totalWidth - (self.minimumInteritemSpacing * numberOfVerticalSpace)) / numberOfColumns
        self.itemSize = CGSize(width: itemDimension, height: itemDimension)
    }
}

