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
    return scrollingView.layer as! CAScrollLayer
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollingViewLayer.scrollMode = kCAScrollBoth
  }
  
  // MARK: - IBActions
  
  @IBAction func panRecognized(_ sender: UIPanGestureRecognizer) {
    var newPoint = scrollingView.bounds.origin
    newPoint.x -= sender.translation(in: scrollingView).x
    newPoint.y -= sender.translation(in: scrollingView).y
    sender.setTranslation(CGPoint.zero, in: scrollingView)
    scrollingViewLayer.scroll(to: newPoint)
    
    if sender.state == .ended {
      UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
        [unowned self] in
        self.scrollingViewLayer.scroll(to: CGPoint.zero)
        }, completion: nil)
    }
  }
  
  @IBAction func scrollingSwitchChanged(_ sender: UISwitch) {
    switch (horizontalScrollingSwitch.isOn, verticalScrollingSwitch.isOn) {
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
