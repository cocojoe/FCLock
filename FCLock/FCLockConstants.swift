//
//  FCLockConstants.swift
//  FCLock
//
//  Created by Martin Walsh on 30/09/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

/**
 
 Using color schemes from http://colorhunt.co/
 Color order is top to bottom, just a suggestion.
 
 */

public struct FCLockSkin {
    var backgroundColor:UIColor // Color 3
    var boxColor:UIColor // Color 4
    var inputTextColor:UIColor // Color 2
    var buttonColor:UIColor // Color 3
    var buttonTextColor:UIColor // Color 2 or 4
}

public struct FCLockConstants {
    // http://colorhunt.co/c/35497
    static let ThemeDefault = FCLockSkin(backgroundColor: UIColor(red:0.92, green:0.33, blue:0.14, alpha:1.0),
                                       boxColor: UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0),
                                       inputTextColor: UIColor(red:0.23, green:0.28, blue:0.31, alpha:1.0),
                                       buttonColor: UIColor(red:0.92, green:0.33, blue:0.14, alpha:1.0),
                                       buttonTextColor: UIColor.white)
    
    // http://colorhunt.co/c/35642
    public static let ThemeLight = FCLockSkin(backgroundColor: UIColor(red:0.99, green:0.93, blue:0.85, alpha:1.0),
                                       boxColor: UIColor(red:1.00, green:0.32, blue:0.15, alpha:1.0),
                                       inputTextColor: UIColor(red:0.71, green:0.84, blue:0.87, alpha:1.0),
                                       buttonColor: UIColor(red:0.99, green:0.93, blue:0.85, alpha:1.0),
                                       buttonTextColor: UIColor(red:1.00, green:0.32, blue:0.15, alpha:1.0))
    
    static let MIN_PASSWORD = 4
}
