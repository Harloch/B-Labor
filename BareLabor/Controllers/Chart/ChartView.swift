//
//  ChartView.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class ChartView: UIView {

    var graphPoints : [CGPoint] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        print(rect.height)
        // draw the line graph
        
        let context = UIGraphicsGetCurrentContext();
        context?.setLineCap(CGLineCap.round)
        
        context?.setStrokeColor(UIColor.white.cgColor);
        context?.setFillColor(UIColor.white.cgColor)
        context?.beginPath();
        
        //Grid
        let grid : CGMutablePath = CGMutablePath()
        for i in 1..<Int(rect.height / 29 + 1){
            CGPathMoveToPoint(grid, nil, 0, CGFloat(29 * i))
            CGPathAddLineToPoint(grid, nil, rect.width, CGFloat(29 * i));
        }
        
        for i in 1..<Int(rect.width / 29 + 1 ){
            CGPathMoveToPoint(grid, nil, CGFloat(29 * i), 0 )
            CGPathAddLineToPoint(grid, nil, CGFloat(29 * i), rect.height);
        }
        
        context?.addPath(grid);
        context?.setLineWidth(1);
        context?.setStrokeColor(UIColor.lightGray.cgColor);
        context?.strokePath()
        
        // Сhart
        let сhart : CGMutablePath = CGMutablePath()
        CGPathMoveToPoint(сhart, nil, -1, rect.height - 3 )
        CGPathAddLineToPoint(сhart, nil, rect.width/4 , rect.height - 3 );
        CGPathAddCurveToPoint(сhart, nil, rect.width/3 + 40, rect.height - 3, rect.width/2 - 20, 80, rect.width/2, 60 )
        CGPathAddCurveToPoint(сhart, nil, rect.width/2 + 20, 60, rect.width/2 + 40, rect.height - 10, rect.width/3*2+40, rect.height - 3 )
        CGPathAddLineToPoint(сhart, nil, rect.width + 1 , rect.height - 3 );
        CGPathAddLineToPoint(сhart, nil, rect.width + 1 , rect.height + 1  );
        CGPathAddLineToPoint(сhart, nil, -1 , rect.height + 1  );
        сhart.closeSubpath();
        
        // Foreground Mountain stroking
        context?.addPath(сhart);
        context?.setLineWidth(2);
        context?.setStrokeColor(UIColor.white.cgColor);
        context?.strokePath();
    }
}
