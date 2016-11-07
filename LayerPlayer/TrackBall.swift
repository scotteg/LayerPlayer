//
//  TrackBall.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/20/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

postfix operator **
postfix func ** (value: CGFloat) -> CGFloat {
  return value * value
}

class TrackBall {
  
  let tolerance = 0.001
  
  var baseTransform = CATransform3DIdentity
  let trackBallRadius: CGFloat
  let trackBallCenter: CGPoint
  var trackBallStartPoint = (x: CGFloat(0.0), y: CGFloat(0.0), z: CGFloat(0.0))
  
  init(location: CGPoint, inRect bounds: CGRect) {
    if bounds.width > bounds.height {
      trackBallRadius = bounds.height * 0.5
    } else {
      trackBallRadius = bounds.width * 0.5
    }
    
    trackBallCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    setStartPointFromLocation(location)
  }
  
  func setStartPointFromLocation(_ location: CGPoint) {
    trackBallStartPoint.x = location.x - trackBallCenter.x
    trackBallStartPoint.y = location.y - trackBallCenter.y
    let distance = trackBallStartPoint.x** + trackBallStartPoint.y**
    trackBallStartPoint.z = distance > trackBallRadius** ? CGFloat(0.0) : sqrt(trackBallRadius** - distance)
  }
  
  func finalizeTrackBallForLocation(_ location: CGPoint) {
    baseTransform = rotationTransformForLocation(location)
  }
  
  func rotationTransformForLocation(_ location: CGPoint) -> CATransform3D {
    var trackBallCurrentPoint = (x: location.x - trackBallCenter.x, y: location.y - trackBallCenter.y, z: CGFloat(0.0))
    let withinTolerance = fabs(Double(trackBallCurrentPoint.x - trackBallStartPoint.x)) < tolerance && fabs(Double(trackBallCurrentPoint.y - trackBallStartPoint.y)) < tolerance
    
    if withinTolerance {
      return CATransform3DIdentity
    }
    
    let distance = trackBallCurrentPoint.x** + trackBallCurrentPoint.y**
    
    if distance > trackBallRadius** {
      trackBallCurrentPoint.z = 0.0
    } else {
      trackBallCurrentPoint.z = sqrt(trackBallRadius** - distance)
    }
    
    let startPoint = trackBallStartPoint
    let currentPoint = trackBallCurrentPoint
    let x = startPoint.y * currentPoint.z - startPoint.z * currentPoint.y
    let y = -startPoint.x * currentPoint.z + trackBallStartPoint.z * currentPoint.x
    let z = startPoint.x * currentPoint.y - startPoint.y * currentPoint.x
    var rotationVector = (x: x, y: y, z: z)
    
    let startLength = sqrt(Double(startPoint.x** + startPoint.y** + startPoint.z**))
    let currentLength = sqrt(Double(currentPoint.x** + currentPoint.y** + currentPoint.z**))
    let startDotCurrent = Double(startPoint.x * currentPoint.x + startPoint.y + currentPoint.y + startPoint.z + currentPoint.z)
    let rotationLength = sqrt(Double(rotationVector.x** + rotationVector.y** + rotationVector.z**))
    let angle = CGFloat(atan2(rotationLength / (startLength * currentLength), startDotCurrent / (startLength * currentLength)))
    
    let normalizer = CGFloat(rotationLength)
    rotationVector.x /= normalizer
    rotationVector.y /= normalizer
    rotationVector.z /= normalizer
    
    let rotationTransform = CATransform3DMakeRotation(angle, rotationVector.x, rotationVector.y, rotationVector.z)
    return CATransform3DConcat(baseTransform, rotationTransform)
  }
  
}
