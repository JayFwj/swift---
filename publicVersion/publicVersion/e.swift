//
//  ViewController.swift
//  publicVersion
//
//  Created by apple on 16/3/28.
//  Copyright © 2016年 Harrison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        let height:CGFloat = 350
        
        let frame = CGRectMake(0, 60, SwiftUtil.ScreenWidth(), height)
        
        let lineGraphView = LineGraphViewController()
        
        lineGraphView.frame = frame
        
        lineGraphView.backgroundColor = UIColor.whiteColor()
        
        lineGraphView.setLineGraphData(self.getDataForLineGraph())
        
        self.view.addSubview(lineGraphView)
        
        
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
    
}

