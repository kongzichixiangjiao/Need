//
//  GAImageView.swift
//  Need
//
//  Created by houjianan on 2020/3/25.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import GAExtension

public class GAImageView: UIView {

    @IBInspectable var imgW: CGFloat = 0
    @IBInspectable var imgH: CGFloat = 0
    
    @IBInspectable var iconName: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var iconColor: UIColor?
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        let w: CGFloat = (imgW == 0 ? self.size.width : imgW)
        let h: CGFloat = (imgH == 0 ? self.size.width : imgH)
        let x: CGFloat = self.bounds.width / 2 - w / 2
        let y: CGFloat = self.bounds.width / 2 - h / 2
        
        if iconName.isEmpty {
            return
        }
        
        guard let iconColor = iconColor else {
            return
        }
        
        var img = UIImage(named: iconName)
        
        img = img?.iconButton_imageWithTintColor(tintColor: iconColor, blendMode: CGBlendMode.destinationIn)!
        
        guard let imgCG = img?.cgImage else {
            return
        }
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: h)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setFillColor(UIColor.black.cgColor)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.draw(imgCG, in: CGRect(x: x, y: y, width: w, height: h))
    }
    
    func _imageWithTintColor(img: UIImage, tintColor: UIColor, blendMode: CGBlendMode = .destinationIn) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(img.size, false, 0.0)
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        UIRectFill(bounds)
        img.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        if blendMode != .destinationIn {
            img.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        }
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return tintedImage
    }

}
