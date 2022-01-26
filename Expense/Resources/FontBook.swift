//
//  FontBook.swift
//  iMatch
//
//  Created by Tùng Xuân on 31/08/2021.
//  Copyright © 2021 Tung Xuan. All rights reserved.
//

import Foundation
import UIKit

public protocol isFont {
    var family: String { get }
    var style: String { get }
}

extension isFont {
    public func size(_ size: CGFloat) -> UIFont {
        let fontName = "\(family)-\(style)"
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

public struct FontBook {
    public enum AvenirNext: String, isFont {
        public var family: String {
            return "AvenirNext"
        }
        
        public var style: String {
            return self.rawValue
        }
        
        case Bold
        case DemiBold
        case Heavy
        case Medium
        case Regular
        
    }
}
