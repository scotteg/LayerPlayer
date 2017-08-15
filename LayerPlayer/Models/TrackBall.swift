/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

func pow2(_ lhs: CGFloat) -> CGFloat {
    return pow(lhs, 2)
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
    let distance = pow2(trackBallStartPoint.x) + pow2(trackBallStartPoint.y)
    trackBallStartPoint.z = distance > pow2(trackBallRadius) ? CGFloat(0.0) : sqrt(pow2(trackBallRadius) - distance)
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
    
    let distance = pow2(trackBallCurrentPoint.x) + pow2(trackBallCurrentPoint.y)
    
    if distance > pow2(trackBallRadius) {
      trackBallCurrentPoint.z = 0.0
    } else {
      trackBallCurrentPoint.z = sqrt(pow2(trackBallRadius) - distance)
    }
    
    let startPoint = trackBallStartPoint
    let currentPoint = trackBallCurrentPoint
    let x = startPoint.y * currentPoint.z - startPoint.z * currentPoint.y
    let y = -startPoint.x * currentPoint.z + trackBallStartPoint.z * currentPoint.x
    let z = startPoint.x * currentPoint.y - startPoint.y * currentPoint.x
    var rotationVector = (x: x, y: y, z: z)
    
    let startLength = sqrt(Double(pow2(startPoint.x) + pow2(startPoint.y) + pow2(startPoint.z)))
    let currentLength = sqrt(Double(pow2(currentPoint.x) + pow2(currentPoint.y) + pow2(currentPoint.z)))
    let startDotCurrent = Double(startPoint.x * currentPoint.x + startPoint.y + currentPoint.y + startPoint.z + currentPoint.z)
    let rotationLength = sqrt(Double(pow2(rotationVector.x) + pow2(rotationVector.y) + pow2(rotationVector.z)))
    let angle = CGFloat(atan2(rotationLength / (startLength * currentLength), startDotCurrent / (startLength * currentLength)))
    
    let normalizer = CGFloat(rotationLength)
    rotationVector.x /= normalizer
    rotationVector.y /= normalizer
    rotationVector.z /= normalizer
    
    let rotationTransform = CATransform3DMakeRotation(angle, rotationVector.x, rotationVector.y, rotationVector.z)
    return CATransform3DConcat(baseTransform, rotationTransform)
  }
  
}
