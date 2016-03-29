

//
//  LineGraphView.swift
//  publicVersion
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 Harrison. All rights reserved.
//

import UIKit

class LineGraphViewController: UIView {
    
    var graphData:LineGraphData!
    
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
    
    
    
    func setLineGraphData(lineGraphData:LineGraphData)
    {
        self.graphData = lineGraphData
        
        let scrollView = UIScrollView(frame: CGRectMake(0, self.titleRowHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.titleRowHeight))
        
        
        //每一项的宽度
        let dateItemWidth =  self.frame.size.width / 7.5
        
        let count = lineGraphData.dataList[0].graphDataList.count
        
        let w = (CGFloat(count ) * dateItemWidth)
        
        let view = LineGraphView()
        
        view.lineGraphData = lineGraphData
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.frame = CGRectMake(0, 0, w, CGRectGetHeight(self.frame) - titleRowHeight)
        
        scrollView.addSubview(view)
        
        scrollView.contentSize = CGSizeMake(w, CGRectGetHeight(scrollView.frame))
        
        self.addSubview(scrollView)
        
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
        let paddingRight:CGFloat = 15
        
        var x:CGFloat = 15
        
        let y:CGFloat = 0
        
        var size = self.drawText(graphData.dateStr, font: self.titleFont, txtColor: self.titleColor, x: x, y: y)
        
        x += size.width + 10
        
        size = self.drawText(graphData.titleStr, font: self.titleFont, txtColor: self.titleColor, x: x, y: y)
        
        x += size.width
        
        
        //右面说明标签的字符串
        let rightStr = graphData.unitStr
        
        size = SwiftUtil.measureTxt(rightStr, font: self.titleFont)
        
        x = (viewWidth - (size.width + paddingRight))
        
        self.drawText(rightStr, font: self.titleFont, txtColor: self.totalColor, x: x, y: 0)
        
        
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


class LineGraphView: UIView
{
    //日期栏的高度
    let dateRowHeight:CGFloat = 35
    
    //折线图区域的高度
    var graphHeight:CGFloat!
    
    //折线图项宽
    var graphItemWidth:CGFloat!
    
    var graphLineWidth:CGFloat = 1.5
    
    var verticalLineWidth:CGFloat = 1
    
    var dotDiameter:CGFloat = 8
    
    var numberFont:UIFont = UIFont.systemFontOfSize(14)
    
    var dateFont:UIFont = UIFont.systemFontOfSize(14)
    
    var graphMarginTop:CGFloat = 20
    
    //线的颜色
    let lineColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.6)
    
    let dateColor = UIColor.darkGrayColor()
    
    var lineGraphData:LineGraphData!
    
    var itemScale:CGFloat!
    
    
    override func drawRect(rect: CGRect) {
        
        let height = rect.size.height
        
        
        self.graphHeight = (height - dateRowHeight)
        
        self.graphItemWidth = SwiftUtil.ScreenWidth() / 7.5
        
        //得到数据中的最大项
        
        var max = 0
        
        for(var i = 0; i < self.lineGraphData.dataList.count; i++)
        {
            let tmax = self.lineGraphData.dataList[i].max
            
            if(tmax > max)
            {
                max = tmax
            }
            
        }
        
        //每一项的比率 所占的百分比
        itemScale = (self.graphHeight - graphMarginTop) / CGFloat(max)
        
        for(var i = 0; i < self.lineGraphData.dataList.count; i++)
        {
            self.drawGraph(self.lineGraphData.dataList[i], textBelow: i % 2 == 0)
        }
        
    }
    
    
    func drawGraph(graphDataList:GraphDataList, textBelow:Bool)
    {
        //先画折线再画点
        
        //完整的折线路径
        let fullPath = UIBezierPath()
        
        
        var lastPoint:CGPoint!
        
        var theFirstPoint:CGPoint!
        
        var mainColor = graphDataList.graphDataList[0].lineColor
        
        for(var i = 1; i < graphDataList.graphDataList.count; i++)
        {
            let lastOne = i - 1
            
            var item = graphDataList.graphDataList[lastOne]
            
            var x = (CGFloat(lastOne) * self.graphItemWidth);
            
            self.drawVerticalLine(x)
            
            var dotX = (CGFloat(lastOne) * self.graphItemWidth) + (self.graphItemWidth) / 2
            
            var dotY = (self.graphHeight - CGFloat(item.data.floatValue) * itemScale)
            
            
            let path = UIBezierPath()
            
            //上一个点
            
            let firstPoint = CGPointMake(dotX, dotY)
            
            path.moveToPoint(firstPoint)
            
            //下一个点
            item = graphDataList.graphDataList[i]
            
            x = (CGFloat(i) * self.graphItemWidth);
            
            self.drawVerticalLine(x)
            
            dotX = (CGFloat(i) * self.graphItemWidth) + (self.graphItemWidth) / 2
            
            dotY = (self.graphHeight - CGFloat(item.data.floatValue) * itemScale )
            
            let secondPoint = CGPointMake(dotX, dotY)
            
            path.addLineToPoint(secondPoint)
            
            path.lineWidth = self.graphLineWidth
            
            item.lineColor.setStroke()
            
            path.stroke()
        }
        
        
        //画第一条线和最后一条线
        self.drawVerticalLine(1)
        
        self.drawVerticalLine(CGFloat(graphDataList.graphDataList.count) * self.graphItemWidth - 1)
        
        //数字距离点的间距
        let padding:CGFloat = 5
        
        //具体数字的高度
        let numSize = SwiftUtil.measureTxt("22", font: self.numberFont)
        
        
        let context = UIGraphicsGetCurrentContext()
        
        //先画折线再画点
        
        for(var i = 0; i < graphDataList.graphDataList.count; i++)
        {
            let item = graphDataList.graphDataList[i]
            
            let x = (CGFloat(i) * self.graphItemWidth)
            
            let dotX = x + (self.graphItemWidth - self.dotDiameter) / 2
            
            let dotY = (self.graphHeight - CGFloat(item.data.floatValue) * itemScale - self.dotDiameter / 2)
            
            CGContextAddEllipseInRect(context, CGRectMake(dotX, dotY, self.dotDiameter, self.dotDiameter))
            
            CGContextSetFillColorWithColor(context, item.dotColor.CGColor)
            
            CGContextFillPath(context)
            
            
            //画日期
            let size = SwiftUtil.measureTxt(item.date, font: self.dateFont)
            
            var y = graphHeight + (self.dateRowHeight - size.height) / 2
            
            let frame = CGRectMake(x, y, self.graphItemWidth, size.height)
            
            SwiftUtil.drawText(item.date, font: self.dateFont, txtColor: self.dateColor, frame: frame)
            
            
            //用于填充和渐变
            
            let lineX = (CGFloat(i) * self.graphItemWidth) + (self.graphItemWidth) / 2
            
            let lineY = (self.graphHeight - CGFloat(item.data.floatValue) * itemScale)
            
            //上一个点
            
            let firstPoint = CGPointMake(lineX, lineY)
            
            
            if(i == 0)
            {
                theFirstPoint = firstPoint
                
                fullPath.moveToPoint(firstPoint)
            }
            else
            {
                fullPath.addLineToPoint(firstPoint)
                
                lastPoint = firstPoint
            }
            
            //画数字
            
            if((graphDataList.showNumber) != nil)
            {
                if(textBelow)
                {
                    y = (dotY + self.dotDiameter + padding)
                    
                }else
                {
                    y = (dotY - (size.height + padding))
                    
                    
                    if(y < 0)
                    {
                        y = 0
                    }
                    
                }
                
                let frame = CGRectMake(x, y, self.graphItemWidth, numSize.height)
                
                SwiftUtil.drawText(item.date, font: self.numberFont, txtColor: item.lineColor, frame: frame)
            }
        }
        
        if((graphDataList.showGradient) != nil)
        {
            CGContextSaveGState(context)
            
            //将渐变色的路径设置完
            fullPath.addLineToPoint(CGPointMake(lastPoint.x, self.graphHeight))
            
            
            //将渐变色的路径设置完
            fullPath.addLineToPoint(CGPointMake(theFirstPoint.x, self.graphHeight))
            
            CGContextAddPath(context, fullPath.CGPath)
            
            fullPath.addClip()
            
            //创建渐变色
            
            let colorSpaces = CGColorSpaceCreateDeviceRGB()
            
            let gradient = CGGradientCreateWithColors(colorSpaces, [mainColor.colorWithAlphaComponent(0.7).CGColor, mainColor.colorWithAlphaComponent(0.2).CGColor], [0, 1.0])
            
            CGContextDrawLinearGradient(context, gradient, CGPoint.zero, CGPointMake(0, self.graphHeight), CGGradientDrawingOptions.DrawsBeforeStartLocation)
            
            
            CGContextRestoreGState(context)
        }
        
        
        
        //画日期上的分隔线
        
        self.drawALine(context!, y: self.graphHeight)
        
    }
    
    //画横线
    
    func drawALine(context:CGContext, y:CGFloat)
    {
        let layer = CALayer()
        
        layer.frame = CGRectMake(0, y, CGRectGetWidth(self.frame), 1)
        
        layer.backgroundColor = UIColor.darkGrayColor().CGColor
        
        self.layer.addSublayer(layer)
    }
    
    
    //画竖线
    
    func drawVerticalLine(x:CGFloat)
    {
        let lineWidth:CGFloat = 1
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextMoveToPoint(context, (x - lineWidth / 2), 0)
        
        CGContextAddLineToPoint(context, (x - lineWidth / 2), self.graphHeight)
        
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        
        CGContextSetLineWidth(context, lineWidth)
        
        CGContextStrokePath(context)
        
    }
    
}

class LineGraphData
{
    var dateStr:NSString!
    
    var titleStr:NSString!
    
    var unitStr:NSString!
    
    var dataList:[GraphDataList]!
    
}


class GraphDataList {
    
    var max:Int!
    
    var showGradient:Bool!
    
    var showNumber:Bool!
    
    var graphDataList:[GraphDataItem]!
    
}

class GraphDataItem {
    
    var data:NSString!
    
    var date:NSString!
    
    var lineColor:UIColor!
    
    var dotColor:UIColor!
    
}



