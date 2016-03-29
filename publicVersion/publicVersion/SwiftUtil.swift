//
//  SwiftUtil.swift
//  CRMForSwift
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 Harrison. All rights reserved.
//

import UIKit

class SwiftUtil: NSObject {
    
    class func ScreenWidth() ->CGFloat
    {
        return UIScreen.mainScreen().bounds.width;
        
    }
    
    
    class func ScreenHeight() ->CGFloat
    {
        return UIScreen.mainScreen().bounds.height;
        
    }
    
    class func StateBarHeight() ->CGFloat
    {
        return UIApplication.sharedApplication().statusBarFrame.size.height;
        
    }
    
    
    class func getAppdelegate() ->AppDelegate
    {
        return UIApplication.sharedApplication().delegate as! AppDelegate;
        
    }
    
    class func getAttribute(font:UIFont, textColor:UIColor) ->[String:AnyObject]
    {
        let style = NSMutableParagraphStyle()
        
        style.alignment = NSTextAlignment.Center
        
        let attribute = [NSFontAttributeName:font, NSForegroundColorAttributeName:textColor,
            NSParagraphStyleAttributeName:style]
        
        return attribute
    }
    
    
    class func measureTxt(str:NSString, font:UIFont) ->CGSize
    {
        let attributes = [NSFontAttributeName:font];
        
        return str.sizeWithAttributes(attributes)
    }
    
    
    class func drawText(txt:NSString, font:UIFont, txtColor:UIColor, frame:CGRect)
    {
        let attributes = SwiftUtil.getAttribute(font, textColor: txtColor)
        
        txt.drawInRect(frame, withAttributes: attributes)
        
    }
    
    
    
}
