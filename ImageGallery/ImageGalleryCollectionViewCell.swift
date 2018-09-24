//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by Raj Gupta on 24/9/18.
//  Copyright © 2018 SoulfulMachine. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    var backgroundImage: UIImage? { didSet { setNeedsDisplay() }}
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
    
}
