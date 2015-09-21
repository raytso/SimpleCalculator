//
//  GraphView.swift
//  Calculator
//
//  Created by Ray Tso on 9/18/15.
//  Copyright © 2015 Ray Tso. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func adjustScaleForGraphView(sender: GraphView) -> CGFloat?
    func adjustCenterForGraphView(sender: GraphView) -> CGPoint?
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource?
    
    
    override func drawRect(rect: CGRect) {
        
        let scale = dataSource?.adjustScaleForGraphView(self) ?? CGFloat(1)
        let viewCenter = dataSource?.adjustCenterForGraphView(self) ?? self.center
        let drawAxes = AxesDrawer(contentScaleFactor: contentScaleFactor)
        
        drawAxes.drawAxesInRect(bounds, origin: viewCenter, pointsPerUnit: scale)
        
    }
}
