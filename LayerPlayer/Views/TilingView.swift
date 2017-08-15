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

class TilingView: UIView {
  
  let sideLength = CGFloat(100.0)
  
  override class var layerClass : AnyClass {
    return TiledLayer.self
  }
  
  required init?(coder aDecoder: NSCoder) {
    srand48(Int(Date().timeIntervalSince1970))
    super.init(coder: aDecoder)
    guard let layer = self.layer as? TiledLayer else { return nil }
    layer.contentsScale = UIScreen.main.scale
    layer.tileSize = CGSize(width: sideLength, height: sideLength)
  }
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    let scale = UIScreen.main.scale
    
    var red = CGFloat(drand48())
    var green = CGFloat(drand48())
    var blue = CGFloat(drand48())
    context?.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
    context?.fill(rect)
    
    let x = bounds.origin.x
    let y = bounds.origin.y
    let offset = bounds.width / sideLength * (scale == 3 ? 2 : scale)
    context?.move(to: CGPoint(x: x + 9.0 * offset, y: y + 43.0 * offset))
    context?.addLine(to: CGPoint(x: x + 18.06 * offset, y: y + 22.6 * offset))
    context?.addLine(to: CGPoint(x: x + 25.0 * offset, y: y + 7.5 * offset))
    context?.addLine(to: CGPoint(x: x + 41.0 * offset, y: y + 43.0 * offset))
    context?.addLine(to: CGPoint(x: x + 9.0 * offset, y: y + 21.66 * offset))
    context?.addLine(to: CGPoint(x: x + 41.0 * offset, y: y + 14.54 * offset))
    context?.addLine(to: CGPoint(x: x + 9.0 * offset, y: y + 43.0 * offset))
    context?.closePath()
    
    red = CGFloat(drand48())
    green = CGFloat(drand48())
    blue = CGFloat(drand48())
    context?.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
    context?.setStrokeColor(UIColor.white.cgColor)
    context?.setLineWidth(4.0 / scale)
    context?.drawPath(using: .eoFillStroke)
  }
  
}
