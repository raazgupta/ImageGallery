//
//  ImageGalleryTableViewCell.swift
//  ImageGallery
//
//  Created by Raj Gupta on 4/10/18.
//  Copyright © 2018 SoulfulMachine. All rights reserved.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var galleryTitle: UITextField! {
        didSet {
            galleryTitle.delegate = self
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
        
    }

    @objc func tapAction() {
        galleryTitle.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isEnabled = false
        resignationHandler?()
    }
    
    var resignationHandler: (()->Void)?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
