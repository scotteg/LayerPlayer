//
//  ScrollingView.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/11/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit
import QuartzCore

class ScrollingView: UIView {
  
  override class func layerClass() -> AnyClass {
    return CAScrollLayer.self
  }
  
}
