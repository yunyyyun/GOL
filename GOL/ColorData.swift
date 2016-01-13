//
//  ColorData.swift
//  GOL
//
//  Created by mengyun on 16/1/13.
//  Copyright © 2016年 mengyun. All rights reserved.
//

import UIKit

class ColorData: NSObject {
    class func aliveColor()->UIColor{
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    }
    class func aliveColorComponents()->[CGFloat]{
        return [0,0,0,0.8]
    }
    class func dieColor()->UIColor{
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
    }
    class func dieColorComponents()->[CGFloat]{
        return [1.0,1.0,1.0,0.8]
    }
}

