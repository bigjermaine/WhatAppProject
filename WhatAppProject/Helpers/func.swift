//
//  func.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 25/08/2025.
//


import UIKit

extension UIFont {
    
    class func satoshi(weight: UIFont.Weight = .regular, size: CGFloat) -> UIFont {
        
        var dynamicSize = size
        
        // Scale font for larger devices
        
        
        // Use system font instead of custom Satoshi
        return UIFont.systemFont(ofSize: dynamicSize, weight: weight)
    }
}
