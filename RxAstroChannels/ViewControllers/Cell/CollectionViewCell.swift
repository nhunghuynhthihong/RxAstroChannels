//
//  CollectionViewCell.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/24/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import UIKit
class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    var channel: Channel = Channel() {
        didSet {
            bottomRightButton.setImage(#imageLiteral(resourceName: "FavoritesSelectedIcon").scaledToSize(CGSize(width: 30, height: 30)), for: .normal)
            bottomRightButton.imageView?.contentMode = .scaleAspectFit
            bottomRightButton.isHidden = false
            bottomRightButton.tintColor = channel.isFavorite ? UIColor.green : UIColor.lightGray
            titleLabel.text = channel.title
        }
    }
}
