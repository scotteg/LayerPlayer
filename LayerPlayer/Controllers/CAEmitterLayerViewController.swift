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

class CAEmitterLayerViewController: UIViewController {
  
  @IBOutlet weak var viewForEmitterLayer: UIView!
  
  @objc var emitterLayer = CAEmitterLayer()
  @objc var emitterCell = CAEmitterCell()
  
  // MARK: - Quick reference
  
  func setUpEmitterLayer() {
    emitterLayer.frame = viewForEmitterLayer.bounds
    emitterLayer.seed = UInt32(Date().timeIntervalSince1970)
    emitterLayer.emitterPosition = CGPoint(x: viewForEmitterLayer.bounds.midX * 1.5, y: viewForEmitterLayer.bounds.midY)
  }
  
  func setUpEmitterCell() {
    emitterCell.isEnabled = true
    emitterCell.contents = UIImage(named: "smallStar")?.cgImage
    emitterCell.contentsRect = CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: 1))
    emitterCell.color = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 1.0).cgColor
    emitterCell.redRange = 1.0
    emitterCell.greenRange = 1.0
    emitterCell.blueRange = 1.0
    emitterCell.alphaRange = 0.0
    emitterCell.redSpeed = 0.0
    emitterCell.greenSpeed = 0.0
    emitterCell.blueSpeed = 0.0
    emitterCell.alphaSpeed = -0.5
    emitterCell.scale = 1.0
    emitterCell.scaleRange = 0.0
    emitterCell.scaleSpeed = 0.1
    
    let zeroDegreesInRadians = degreesToRadians(0.0)
    emitterCell.spin = degreesToRadians(130.0)
    emitterCell.spinRange = zeroDegreesInRadians
    emitterCell.emissionLatitude = zeroDegreesInRadians
    emitterCell.emissionLongitude = zeroDegreesInRadians
    emitterCell.emissionRange = degreesToRadians(360.0)
    
    emitterCell.lifetime = 1.0
    emitterCell.lifetimeRange = 0.0
    emitterCell.birthRate = 250.0
    emitterCell.velocity = 50.0
    emitterCell.velocityRange = 500.0
    emitterCell.xAcceleration = -750.0
    emitterCell.yAcceleration = 0.0
  }
  
  // MARK: - View life cycle
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setUpEmitterCell()
    resetEmitterCells()
    setUpEmitterLayer()
    viewForEmitterLayer.layer.addSublayer(emitterLayer)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "DisplayEmitterControls":
        emitterLayer.renderMode = kCAEmitterLayerAdditive
        (segue.destination as? CAEmitterLayerControlsViewController)?.emitterLayerViewController = self
      default:
        break
      }
    }
  }
  
  // MARK: - Triggered actions
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let location = touches.first?.location(in: viewForEmitterLayer) {
      emitterLayer.emitterPosition = location
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let location = touches.first?.location(in: viewForEmitterLayer) {
      emitterLayer.emitterPosition = location
    }
  }
  
  // MARK: - Helpers
  
  func resetEmitterCells() {
    emitterLayer.emitterCells = nil
    emitterLayer.emitterCells = [emitterCell]
  }
  
}
