//
//  ProfileDataSource.swift
//  StateMonitoringDemo
//
//  Created by Valeriy Efimov on 3/17/19.
//  Copyright © 2019 tomych. All rights reserved.
//

import UIKit

class ProfileDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Vars
    
    lazy var images: [UIImage] = {
        var images: [UIImage] = []
        for i in 1...15 {
            let name = "im\(i)"
            images.append(UIImage(named: name)!)
        }
        return images
    }()
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.describingSelf,
                                                      for: indexPath) as? ImageCollectionViewCell
        cell?.contentImageView.image = images[indexPath.row]
        cell?.apply(theme: ThemeStorage.shared.current)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: ProvileHeaderCollectionView.describingSelf,
                                                                     for: indexPath) as? ProvileHeaderCollectionView
        header?.apply(theme: ThemeStorage.shared.current)
        return header ?? ProvileHeaderCollectionView()
    }
}

extension UIView {
    static var describingSelf: String {
        return String(describing: self)
    }
}
