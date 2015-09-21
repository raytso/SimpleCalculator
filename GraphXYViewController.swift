//
//  GraphXYViewController.swift
//  Calculator
//
//  Created by Ray Tso on 9/18/15.
//  Copyright © 2015 Ray Tso. All rights reserved.
//

import UIKit

class GraphXYViewController: UIViewController, GraphViewDataSource {
    
    var scale: CGFloat = 100 {
        didSet {
            updateGraphViewUI()
        }
    }
    
    var changedOrigin: CGPoint? {
        didSet {
            updateGraphViewUI()
        }
    }
    
    var resetOrigin: Bool = true
    
    var centerLocation: CGPoint?
    
    @IBAction func changeScale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    @IBAction func panAround(gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .Began:
            if resetOrigin {
                centerLocation = graphView.center
            } else {
                fallthrough
            }
        case .Changed:
            let translation = gesture.translationInView(graphView)
            changedOrigin = CGPoint(x: centerLocation!.x + translation.x, y: centerLocation!.y + translation.y)
        case .Ended:
            resetOrigin = false
            centerLocation = changedOrigin
        default:
            break
        }
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }
    
    private func updateGraphViewUI() {
        graphView.setNeedsDisplay()
    }
    
    func adjustCenterForGraphView(sender: GraphView) -> CGPoint? {
        return changedOrigin
    }
    
    func adjustScaleForGraphView(sender: GraphView) -> CGFloat? {
        return scale
    }
}
