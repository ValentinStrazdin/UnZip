//
//  UIScrollView+Image.swift
//  UnZip
//
//  Created by Valentin Strazdin on 12/10/18.
//  Copyright © 2018 Valentin Strazdin. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    func centerContents(for view: UIView) {
        let boundsSize = self.bounds.size
        var contentsFrame = view.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        }
        else {
            contentsFrame.origin.x = 0.0
        }
        
        if (contentsFrame.size.height < boundsSize.height) {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        view.frame = contentsFrame
    }
    
    func setupImage(_ image: UIImage, for imageView: UIImageView) {
        self.zoomScale = 1.0
        imageView.image = image
        let screenSize = UIScreen.main.bounds.size
        let scaleWidth = screenSize.width / image.size.width
        let scaleHeight = screenSize.height / image.size.height
        let minScale = CGFloat.minimum(1, CGFloat.minimum(scaleWidth, scaleHeight))
        self.minimumZoomScale = minScale
        self.maximumZoomScale = 1
        self.zoomScale = minScale
        
        self.centerContents(for: imageView)
    }
    
}
