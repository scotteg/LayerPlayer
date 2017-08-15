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

let sideLength: CGFloat = 640.0
let fileName = "windingRoad"

class TilingViewForImage: UIView {
  
  let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
  
  override class var layerClass : AnyClass {
    return TiledLayer.self
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    guard let layer = self.layer as? TiledLayer else { return nil }
    layer.contentsScale = UIScreen.main.scale
    layer.tileSize = CGSize(width: sideLength, height: sideLength)
  }
  
  override func draw(_ rect: CGRect) {
    let firstColumn = Int(rect.minX / sideLength)
    let lastColumn = Int(rect.maxX / sideLength)
    let firstRow = Int(rect.minY / sideLength)
    let lastRow = Int(rect.maxY / sideLength)
    
    for row in firstRow...lastRow {
      for column in firstColumn...lastColumn {
        if let tile = imageForTileAtColumn(column, row: row) {
          let x = sideLength * CGFloat(column)
          let y = sideLength * CGFloat(row)
          let point = CGPoint(x: x, y: y)
          let size = CGSize(width: sideLength, height: sideLength)
          var tileRect = CGRect(origin: point, size: size)
          tileRect = bounds.intersection(tileRect)
          tile.draw(in: tileRect)
        }
      }
    }
  }
  
  func imageForTileAtColumn(_ column: Int, row: Int) -> UIImage? {
    let filePath = "\(cachesPath)/\(fileName)_\(column)_\(row)"
    return UIImage(contentsOfFile: filePath)
  }

}
