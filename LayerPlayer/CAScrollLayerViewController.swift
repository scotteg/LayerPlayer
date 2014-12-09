//
//  CAScrollLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/10/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CAScrollLayerViewController: UIViewController {
  
  @IBOutlet weak var scrollingView: ScrollingView!
  @IBOutlet weak var horizontalScrollingSwitch: UISwitch!
  @IBOutlet weak var verticalScrollingSwitch: UISwitch!
  
  var scrollingViewLayer: CAScrollLayer {
    return scrollingView.layer as CAScrollLayer
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollingViewLayer.scrollMode = kCAScrollBoth
  }
  
  // MARK: - IBActions
  
  @IBAction func panRecognized(sender: UIPanGestureRecognizer) {
    var newPoint = scrollingView.bounds.origin
    newPoint.x -= sender.translationInView(scrollingView).x
    newPoint.y -= sender.translationInView(scrollingView).y
    sender.setTranslation(CGPointZero, inView: scrollingView)
    scrollingViewLayer.scrollToPoint(newPoint)
    
    if sender.state == .Ended {
      UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
        [unowned self] in
        self.scrollingViewLayer.scrollToPoint(CGPointZero)
        }, completion: nil)
    }
  }
  
  @IBAction func scrollingSwitchChanged(sender: UISwitch) {
    switch (horizontalScrollingSwitch.on, verticalScrollingSwitch.on) {
    case (true, true):
      scrollingViewLayer.scrollMode = kCAScrollBoth
    case (true, false):
      scrollingViewLayer.scrollMode = kCAScrollHorizontally
    case (false, true):
      scrollingViewLayer.scrollMode = kCAScrollVertically
    default:
      scrollingViewLayer.scrollMode = kCAScrollNone
    }
  }
  
}
