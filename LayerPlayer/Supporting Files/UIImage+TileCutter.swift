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
 *
 *  Adapted from Nick Lockwood's Terminal app in his book, iOS Core Animation: Advanced Techniques
 *  http://www.informit.com/store/ios-core-animation-advanced-techniques-9780133440751
 */

import UIKit

extension UIImage {
  
  class func saveTileOfSize(_ size: CGSize, name: String) -> () {
    let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
    let filePath = "\(cachesPath)/\(name)_0_0.png"
    let fileManager = FileManager.default
    let fileExists = fileManager.fileExists(atPath: filePath)
        
    if fileExists == false {
      var tileSize = size
      let scale = Float(UIScreen.main.scale)
      
      if let image = UIImage(named: "\(name).jpg") {
        let imageRef = image.cgImage
        let totalColumns = Int(ceilf(Float(image.size.width / tileSize.width)) * scale)
        let totalRows = Int(ceilf(Float(image.size.height / tileSize.height)) * scale)
        let partialColumnWidth = Int(image.size.width.truncatingRemainder(dividingBy: tileSize.width))
        let partialRowHeight = Int(image.size.height.truncatingRemainder(dividingBy: tileSize.height))
        
        DispatchQueue.global(qos: .default).async {
          for y in 0..<totalRows {
            for x in 0..<totalColumns {
              if partialRowHeight > 0 && y + 1 == totalRows {
                tileSize.height = CGFloat(partialRowHeight)
              }
              
              if partialColumnWidth > 0 && x + 1 == totalColumns {
                tileSize.width = CGFloat(partialColumnWidth)
              }
              
              let xOffset = CGFloat(x) * tileSize.width
              let yOffset = CGFloat(y) * tileSize.height
              let point = CGPoint(x: xOffset, y: yOffset)
              
              if let tileImageRef = imageRef?.cropping(to: CGRect(origin: point, size: tileSize)), let imageData = UIImagePNGRepresentation(UIImage(cgImage: tileImageRef)) {
                let path = "\(cachesPath)/\(name)_\(x)_\(y).png"
                try? imageData.write(to: URL(fileURLWithPath: path), options: [])
              }
            }
          }
        }
      }
    }
  }
  
}
