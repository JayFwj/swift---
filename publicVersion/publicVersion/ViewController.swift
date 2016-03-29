//
//  ViewController.swift
//  publicVersion
//
//  Created by apple on 16/3/28.
//  Copyright © 2016年 Harrison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var lbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        
        let view = HistogramViewController()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.frame = CGRectMake(0, 20, SwiftUtil.ScreenWidth(),( SwiftUtil.ScreenHeight() / 2 - 40))
        
        view.setHistogramData(self.getData())
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSelectedForProgressView:", name: NOTIFICATION_FOR_CURRENT_SELECTED_ITEM, object: nil)
        
        
        
        self.view.addSubview(view)
        
        lbl = UILabel(frame: CGRectMake(0, CGRectGetMaxY(view.frame),SwiftUtil.ScreenWidth(), 30))
        
        lbl.backgroundColor = UIColor.purpleColor()
        
        lbl.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(lbl)
        
        
        let height = SwiftUtil.ScreenHeight() - CGRectGetMaxY(lbl.frame)
        
        let frame = CGRectMake(0, CGRectGetMaxY(lbl.frame) + 5, SwiftUtil.ScreenWidth(), height)
        
        let lineGraphView = LineGraphViewController()
        
        lineGraphView.frame = frame
        
        lineGraphView.backgroundColor = UIColor.whiteColor()
        
        lineGraphView.setLineGraphData(self.getDataForLineGraph())
        
        self.view.addSubview(lineGraphView)
        
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func currentSelectedForProgressView(notification:NSNotification)
    {
        print("--== \(notification.object)")
        
        lbl.text = "\(notification.object as! String)"
    }
    
    
    func getDataForLineGraph() ->LineGraphData
    {
        let data = LineGraphData()
        
        data.dateStr = "2016-03"
        
        data.titleStr = "收支报表"
        
        data.unitStr = "单位：元"
        
        data.dataList = [GraphDataList]()
        
        
        var max:Int = 0
        
        var lineColors = [UIColor.greenColor(), UIColor.blueColor()]
        
        //  var tempRandomColors = [UIColor.greenColor(), UIColor.blueColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.blackColor()]
        
        for(var j = 0; j < lineColors.count; j++)
        {
            let graphaDataList = GraphDataList()
            
            graphaDataList.graphDataList = [GraphDataItem]()
            
            for(var i = 0; i < 31; i++)
            {
                let item = GraphDataItem()
                
                //随机生成的出货票数
                let total = arc4random_uniform(30) + 1
                
                item.data = "\(total)"
                
                
                item.date = "\(i + 1)"
                
                //let ri = arc4random_uniform(UInt32(tempRandomColors.count))
                
                item.lineColor = lineColors[j]// tempRandomColors[Int(ri)] //  UIColor.darkGrayColor()
                
                item.dotColor =  lineColors[j] //UIColor.orangeColor()
                
                graphaDataList.graphDataList.append(item)
                
                if(Int(total) > max)
                {
                    max = Int(total);
                }
            }
            
            graphaDataList.max = max;
            
            data.dataList.append(graphaDataList)
            
        }
        
        
        
        
        
        
        return data;
        
    }
    
    
    
    
    
    
    
    func getData() -> HistogramData
    {
        let data = HistogramData()
        
        data.dateStr = "2016-03"
        
        data.lblStr = "出货"
        
        data.signedLblStr = "已签收数量"
        
        data.totalLblStr = "出货票数"
        
        data.histogramItemList = [HistogramItemData]()
        
        
        var max:Int = 0
        
        for(var i = 0; i < 31; i++)
        {
            let item = HistogramItemData()
            
            //随机生成的出货票数
            let total = arc4random_uniform(30) + 1
            
            
            
            item.totalStr = "\(total)"
            
            let signed = arc4random_uniform(total)
            
            item.signedStr = "\(signed)"
            
            item.dayStr = "\(i + 1)"
            
            data.histogramItemList.append(item)
            
            if(Int(total) > max)
            {
                max = Int(total);
            }
        }
        
        data.max = max;
        
        return data;
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

