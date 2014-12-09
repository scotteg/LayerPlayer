//
//  TiledLayer.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/17/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

var adjustableFadeDuration: CFTimeInterval = 0.25

class TiledLayer: CATiledLayer {
  
  override class func fadeDuration() -> CFTimeInterval {
    return adjustableFadeDuration
  }
  
  class func setFadeDuration(duration: CFTimeInterval) {
    adjustableFadeDuration = duration
  }
  
}
