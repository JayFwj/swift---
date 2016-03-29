//
//  Histogram.swift
//  publicVersion
//
//  Created by apple on 16/3/28.
//  Copyright © 2016年 Harrison. All rights reserved.
//

import UIKit

//对于当前选中项的广播通知
let NOTIFICATION_FOR_CURRENT_SELECTED_ITEM  = "NOTIFICATION_FOR_CURRENT_SELECTED_ITEM"


class HistogramViewController:UIView {
    
    var histogramData:HistogramData!
    
    //-----------------------
    //定义高度
    //-----------------------
    
    //标题栏高度
    let titleRowHeight:CGFloat = 35
 
    //标题栏字体
     let titleFont = UIFont.systemFontOfSize(12)
    
    //标题栏字体颜色
     let titleColor = UIColor.darkGrayColor()
    
    //签收数量栏字体颜色
     let signedColor = UIColor.orangeColor()
    
    //总的数量颜色
     let totalColor = UIColor.lightGrayColor()

     var viewWidth:CGFloat!
    
    
    func setHistogramData(histogramData:HistogramData)
    {
        self.histogramData = histogramData
        
        let view = HistogramContainerView()
        
        view.showsHorizontalScrollIndicator = false
        
        view.frame = CGRectMake(0, titleRowHeight, SwiftUtil.ScreenWidth(), (CGRectGetHeight(self.frame) - titleRowHeight))
        
        view.setHistogramData(histogramData)
        
        self.addSubview(view)
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.   */
    override func drawRect(rect: CGRect) {
        // Drawing code 
        
        viewWidth = rect.size.width
        
        //-------------------------------------------------------------
        
        self.drawTitlePart()
    }
    
    
    //画标题栏
    func drawTitlePart()
    {
        let context = UIGraphicsGetCurrentContext()
        
        //距离右面的间距
        let paddingRight:CGFloat = 8
        
        var x:CGFloat = 15
        
        let y:CGFloat = 0
        
        var size = self.drawText(histogramData.dateStr, font: self.titleFont, txtColor: self.titleColor, x: x, y: y)
        
        x += size.width + 10
        
        size = self.drawText(histogramData.lblStr, font: self.titleFont, txtColor: self.titleColor, x: x, y: y)
        
        x += size.width
        
        
        //右面说明标签的字符串
        let rightStr = "(\(self.histogramData.signedLblStr)/\(self.histogramData.totalLblStr))"
        
        size = SwiftUtil.measureTxt(rightStr, font: self.titleFont)
        
        x = (viewWidth - (size.width + paddingRight))
        
        size = self.drawText("(\(histogramData.signedLblStr)", font: self.titleFont, txtColor: self.signedColor, x: x, y: 0)
        
        x += size.width
        
        self.drawText("/\(histogramData.totalLblStr))", font: self.titleFont, txtColor: self.totalColor, x: x, y: 0)
        
        
        self.drawALine(context!, y: 0)
        
        self.drawALine(context!, y: self.titleRowHeight)
        
        
    }
    

    func drawALine(context:CGContext, y:CGFloat)
    {
        let layer = CALayer()
        
        layer.frame = CGRectMake(0, y, viewWidth, 1)
        
        layer.backgroundColor = UIColor.darkGrayColor().CGColor
        
        self.layer.addSublayer(layer)
    }
    
    
    func drawText(txt:NSString, font:UIFont, txtColor:UIColor, x:CGFloat, y:CGFloat) ->CGSize
    {
        let size = SwiftUtil.measureTxt(txt, font: font)
        
        let frame = CGRectMake(x, (titleRowHeight - size.height)/2, size.width, size.height)
        
        let attributes = SwiftUtil.getAttribute(font, textColor: txtColor)
        
        txt.drawInRect(frame, withAttributes: attributes)
        
        return size;
    }
    
}



class HistogramContainerView:UIScrollView {
    
    
    
    func setHistogramData(histogramData:HistogramData)
    {
        let view = HistogramView()
        
        view.backgroundColor = UIColor.whiteColor()
        
        //每一项的宽度
        let dateItemWidth =  self.frame.size.width / 7.5
        
        let w = (CGFloat( histogramData.histogramItemList.count) * dateItemWidth)
        
        let h = self.frame.size.height
        
        view.frame = CGRectMake(0, 0,w, h)
        
        view.histogramData = histogramData
        
        
        
        self.addSubview(view)
        
        self.contentSize = CGSizeMake(w, h)
        
    
    }
    
    
}


class HistogramView: UIView {
    
    
    var histogramData:HistogramData!
    
    //-----------------------
    //定义高度
    //-----------------------
    
    //标题栏高度
    let titleRowHeight:CGFloat = 0
    
    //日期栏高度
    let dateRowHeight:CGFloat = 45
    
    //进度项宽度
    var dateItemWidth:CGFloat = 0
    
    //进度项比例高度
    var progressScaleHeight:CGFloat = 0
    
    
    //进度项距离上面的间距
    var paddingForProgress:CGFloat = 10
    
    //进度区域的高度
    var progressAreaHeight:CGFloat!
    
    //标题栏字体
    let titleFont = UIFont.systemFontOfSize(12)
    
    //日期栏字体
    let dateFont = UIFont.systemFontOfSize(14)
    
    //签收数量栏字体
    let signedFont = UIFont.systemFontOfSize(12)
    
    //标题栏字体颜色
    let titleColor = UIColor.darkGrayColor()
    
    //日期栏字体颜色
    let dateColor = UIColor.darkGrayColor()
    
    //签收数量栏字体颜色
    let signedColor = UIColor.orangeColor()
    
    //总的数量颜色
    let totalColor = UIColor.lightGrayColor()
    
    //线的颜色
    let lineColor = UIColor.darkGrayColor()
    
    //视图宽度
    var viewWidth:CGFloat!
    
    var viewHeight:CGFloat!
    
    //frameList
    var frameList = [CGRect]()
    
    //选中的视图
    var selectedHintView:UIView!
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.   */
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        viewHeight = rect.size.height
        
        viewWidth = rect.size.width
        
        //每一项的宽度
        dateItemWidth =  SwiftUtil.ScreenWidth() / 7.5
        
        //进度区域的高度
        progressAreaHeight = (viewHeight - (titleRowHeight + dateRowHeight + paddingForProgress))
        
        //进度区域的比例高度 //得到数据中的最大项 除以高度
        
        progressScaleHeight = (progressAreaHeight / CGFloat(self.histogramData.max))
        
        
        //-------------------------------------------------------------
        
        let context = UIGraphicsGetCurrentContext()
        
        
        self.drawDatePart(context!)
        
        
        selectedHintView = UIView()
        
        selectedHintView.backgroundColor = self.signedColor.colorWithAlphaComponent(0.5)
        
        self.addSubview(selectedHintView)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //两点触摸时，计算两点间的距离
        if touches.count > 0{
            //获取触摸点
            let first = (touches as NSSet).allObjects[0] as! UITouch
            
            //获取触摸点坐标
            let firstPoint = first.locationInView(self)
            
            for(var i = 0; i < self.frameList.count; i++)
            {
                if(CGRectContainsPoint(self.frameList[i], firstPoint))
                {
                    self.selectedHintView.frame = self.frameList[i];
                    
                    break;
                    
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
     
        //两点触摸时，计算两点间的距离
        if touches.count > 0{
            //获取触摸点
            let first = (touches as NSSet).allObjects[0] as! UITouch
            
            //获取触摸点坐标
            let firstPoint = first.locationInView(self)
            
            for(var i = 0; i < self.frameList.count; i++)
            {
                if(CGRectContainsPoint(self.frameList[i], firstPoint))
                {
                    
                    print("----\(i)")
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_FOR_CURRENT_SELECTED_ITEM, object: "\(i)")
                    
                    break;
                
                }
            }
        }
         self.selectedHintView.frame = CGRectZero
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        self.selectedHintView.frame = CGRectZero
    }
    
    
    
    //画日期栏
    
    func drawDatePart(context:CGContext)
    {
        let paddingTop:CGFloat = 3
        
        let tempDateHeight = SwiftUtil.measureTxt("12", font: self.dateFont).height
        
        let tempCountHeight = SwiftUtil.measureTxt("12", font: self.signedFont).height
        
        
        let y = (titleRowHeight + (dateRowHeight - (tempCountHeight + tempDateHeight + paddingTop)) / 2)
        
        
        
        for(var i = 0; i < self.histogramData.histogramItemList.count; i++)
        {
            let item = self.histogramData.histogramItemList[i]
            
            let x = (CGFloat(i) * self.dateItemWidth);
            
            //日期
            var frame = CGRectMake(x, y, self.dateItemWidth, tempDateHeight)
            
            self.drawTextForDateItem(item.dayStr, font: self.dateFont, txtColor: self.dateColor,frame: frame)
            
            //签收的数量，总的数量
            
            frame = CGRectMake((CGFloat(i) * self.dateItemWidth),  (y + tempDateHeight + paddingTop), self.dateItemWidth,tempCountHeight)
            
            self.drawTextForDateItem("\(item.signedStr)/\(item.totalStr)", font: self.signedFont, txtColor: self.totalColor,frame: frame)
            
            //画进度
            self.drawProgressPart(context, itemData: item, x: x)
            
            frameList.append(CGRectMake(x,0,self.dateItemWidth,viewHeight))
            
            //画线
            
            self.drawVerticalLine(x)
            
        }
        
        self.drawVerticalLine(1)
        
        self.drawVerticalLine(CGFloat(self.histogramData.histogramItemList.count) * self.dateItemWidth - 1)
        
        self.drawALine(context, y: (self.titleRowHeight + self.dateRowHeight))
        
        
        
    }
    
    
    //画进度栏
    
    func drawProgressPart(context:CGContext, itemData:HistogramItemData, x:CGFloat)
    {
        //画总票数
        
        var h = (CGFloat(itemData.totalStr.integerValue) * self.progressScaleHeight)
        
        var y = (viewHeight - h)
        
        var frame = CGRectMake(x, y, self.dateItemWidth, h)
        
        CGContextAddRect(context, frame)
        
        CGContextSetFillColorWithColor(context, self.totalColor.CGColor)
        
        CGContextFillPath(context)
        
        
        //画已签收的
        
        let context = UIGraphicsGetCurrentContext()
        
        
         h = (CGFloat(itemData.signedStr.integerValue) * self.progressScaleHeight)
        
        y = (viewHeight - h)
        
         frame = CGRectMake(x, y, self.dateItemWidth, h)
        
        CGContextAddRect(context, frame)
        
        CGContextSetFillColorWithColor(context, self.signedColor.CGColor)
        
        CGContextFillPath(context)
        
        
        
    }
    
    //画竖线
    
    func drawVerticalLine(x:CGFloat)
    {
        let lineWidth:CGFloat = 1
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextMoveToPoint(context, (x - lineWidth / 2), self.titleRowHeight)
        
        CGContextAddLineToPoint(context, (x - lineWidth / 2), self.viewHeight)
        
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        
        CGContextSetLineWidth(context, lineWidth)
        
        CGContextStrokePath(context)
    
    }
    
    
    
    func drawALine(context:CGContext, y:CGFloat)
    {
        let layer = CALayer()
        
        layer.frame = CGRectMake(0, y, viewWidth, 1)
        
        layer.backgroundColor = UIColor.darkGrayColor().CGColor
        
        self.layer.addSublayer(layer)
    }
    
    
    func drawText(txt:NSString, font:UIFont, txtColor:UIColor, x:CGFloat, y:CGFloat) ->CGSize
    {
        let size = SwiftUtil.measureTxt(txt, font: font)
        
        let frame = CGRectMake(x, (titleRowHeight - size.height)/2, size.width, size.height)
        
        let attributes = SwiftUtil.getAttribute(font, textColor: txtColor)
        
        txt.drawInRect(frame, withAttributes: attributes)
        
        return size;
    }

    
    
    func drawTextForDateItem(txt:NSString, font:UIFont, txtColor:UIColor, frame:CGRect)
    {
        //判断是否画已签收和总票数
        if(txt.rangeOfString("/").location != NSNotFound)
        {
            let temp = txt.componentsSeparatedByString("/")
            
            let sizeForSigned = SwiftUtil.measureTxt(temp[0], font: font)
            
            
            let sizeForTotal = SwiftUtil.measureTxt("/\(temp[1])", font: font)
            
            let x = frame.origin.x + (frame.size.width - (sizeForSigned.width + sizeForTotal.width)) / 2
            
            //------已签收-----
            
            var tframe = CGRectMake(x, frame.origin.y, sizeForSigned.width, frame.height)
            
            var attributes = SwiftUtil.getAttribute(font, textColor: self.signedColor)
            
            temp[0].drawInRect(tframe, withAttributes: attributes)
            
            //------总票数------
            
            tframe = CGRectMake((x + sizeForSigned.width), frame.origin.y, sizeForTotal.width, frame.height)
            
            attributes = SwiftUtil.getAttribute(font, textColor: self.totalColor)
            
            "/\(temp[1])".drawInRect(tframe, withAttributes: attributes)
        
        }else
        {
            let attributes = SwiftUtil.getAttribute(font, textColor: txtColor)
            
            txt.drawInRect(frame, withAttributes: attributes)
        
        }
        
        
    }
    
    
    
}



class HistogramData
{
    var histogramItemList = [HistogramItemData]()
    
    var dateStr:NSString!
    
    var lblStr:NSString!
    
    var signedLblStr:NSString!
    
    var totalLblStr:NSString!
    
    var max:Int!;
}


class HistogramItemData {
    
    var dayStr:NSString!
    
    var signedStr:NSString!
    
    var totalStr:NSString!
    
}
