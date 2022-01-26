//
//  Constant.swift
//  imatch
//
//  Created by Tùng Xuân on 07/10/2021.
//  Copyright © 2021 Tung Xuan. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    static let statusBarHeight: CGFloat = Global.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
    static let navBarHeight =  UINavigationBar().frame.size.height.positiveOrElse(44)
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenScale = UIScreen.main.scale
    static var bottomPadding: CGFloat = Global.window?.safeAreaInsets.bottom ?? 0
}

extension UserDefaults.Key {
    static let currentLanguage = UserDefaults.Key("currentLanguage")
    static let inCategories = UserDefaults.Key("inCategories")
    static let outCategories = UserDefaults.Key("outCategories")
    static let appData = UserDefaults.Key("appData")
    static let sources = UserDefaults.Key("sources")
}
