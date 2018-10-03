//
//  ImageGallerySplitViewController.swift
//  ImageGallery
//
//  Created by Raj Gupta on 3/10/18.
//  Copyright © 2018 SoulfulMachine. All rights reserved.
//

import UIKit

class ImageGallerySplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if preferredDisplayMode != .primaryOverlay {
            preferredDisplayMode = .primaryOverlay
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
