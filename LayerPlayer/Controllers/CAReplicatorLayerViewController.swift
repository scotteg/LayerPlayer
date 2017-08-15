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

class CAReplicatorLayerViewController: UIViewController {
  
  // FIXME: Unsatisfiable constraints in compact width, any height (e.g., iPhone in landscape)
  
  @IBOutlet weak var viewForReplicatorLayer: UIView!
  @IBOutlet weak var layerSizeSlider: UISlider!
  @IBOutlet weak var layerSizeSliderValueLabel: UILabel!
  @IBOutlet weak var instanceCountSlider: UISlider!
  @IBOutlet weak var instanceCountSliderValueLabel: UILabel!
  @IBOutlet weak var instanceDelaySlider: UISlider!
  @IBOutlet weak var instanceDelaySliderValueLabel: UILabel!
  @IBOutlet weak var offsetRedSwitch: UISwitch!
  @IBOutlet weak var offsetGreenSwitch: UISwitch!
  @IBOutlet weak var offsetBlueSwitch: UISwitch!
  @IBOutlet weak var offsetAlphaSwitch: UISwitch!
  
  let lengthMultiplier: CGFloat = 3.0
  let whiteColor = UIColor.white.cgColor
  let replicatorLayer = CAReplicatorLayer()
  let instanceLayer = CALayer()
  let fadeAnimation = CABasicAnimation(keyPath: "opacity")
  
  // MARK: - Quick reference
  
  func setUpReplicatorLayer() {
    replicatorLayer.frame = viewForReplicatorLayer.bounds
    let count = instanceCountSlider.value
    replicatorLayer.instanceCount = Int(count)
    replicatorLayer.preservesDepth = false
    replicatorLayer.instanceColor = whiteColor
    replicatorLayer.instanceRedOffset = offsetValueForSwitch(offsetRedSwitch)
    replicatorLayer.instanceGreenOffset = offsetValueForSwitch(offsetGreenSwitch)
    replicatorLayer.instanceBlueOffset = offsetValueForSwitch(offsetBlueSwitch)
    replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)
    let angle = Float(Double.pi * 2.0) / count
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
  }
  
  func setUpInstanceLayer() {
    let layerWidth = CGFloat(layerSizeSlider.value)
    let midX = viewForReplicatorLayer.bounds.midX - layerWidth / 2.0
    instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * lengthMultiplier)
    instanceLayer.backgroundColor = whiteColor
  }
  
  func setUpLayerFadeAnimation() {
    fadeAnimation.fromValue = 1.0
    fadeAnimation.toValue = 0.0
    fadeAnimation.repeatCount = Float(Int.max)
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpReplicatorLayer()
    viewForReplicatorLayer.layer.addSublayer(replicatorLayer)
    setUpInstanceLayer()
    replicatorLayer.addSublayer(instanceLayer)
    setUpLayerFadeAnimation()
    instanceDelaySliderChanged(instanceDelaySlider)
    updateLayerSizeSliderValueLabel()
    updateInstanceCountSliderValueLabel()
    updateInstanceDelaySliderValueLabel()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setUpReplicatorLayer()
    setUpInstanceLayer()
  }
  
  // MARK: - IBActions
  
  @IBAction func layerSizeSliderChanged(_ sender: UISlider) {
    let value = CGFloat(sender.value)
    instanceLayer.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: value, height: value * lengthMultiplier))
    updateLayerSizeSliderValueLabel()
  }
  
  @IBAction func instanceCountSliderChanged(_ sender: UISlider) {
    replicatorLayer.instanceCount = Int(sender.value)
    replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)
    updateInstanceCountSliderValueLabel()
  }
  
  @IBAction func instanceDelaySliderChanged(_ sender: UISlider) {
    if sender.value > 0.0 {
      replicatorLayer.instanceDelay = CFTimeInterval(sender.value / Float(replicatorLayer.instanceCount))
      setLayerFadeAnimation()
    } else {
      replicatorLayer.instanceDelay = 0.0
      instanceLayer.opacity = 1.0
      instanceLayer.removeAllAnimations()
    }
    
    updateInstanceDelaySliderValueLabel()
  }
  
  @IBAction func offsetSwitchChanged(_ sender: UISwitch) {
    switch sender {
    case offsetRedSwitch:
      replicatorLayer.instanceRedOffset = offsetValueForSwitch(sender)
    case offsetGreenSwitch:
      replicatorLayer.instanceGreenOffset = offsetValueForSwitch(sender)
    case offsetBlueSwitch:
      replicatorLayer.instanceBlueOffset = offsetValueForSwitch(sender)
    case offsetAlphaSwitch:
      replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(sender)
    default:
      break
    }
  }
  
  // MARK: - Triggered actions
  
  func setLayerFadeAnimation() {
    instanceLayer.opacity = 0.0
    fadeAnimation.duration = CFTimeInterval(instanceDelaySlider.value)
    instanceLayer.add(fadeAnimation, forKey: "FadeAnimation")
  }
  
  // MARK: - Helpers
  
  func offsetValueForSwitch(_ offsetSwitch: UISwitch) -> Float {
    if offsetSwitch == offsetAlphaSwitch {
      let count = Float(replicatorLayer.instanceCount)
      return offsetSwitch.isOn ? -1.0 / count : 0.0
    } else {
      return offsetSwitch.isOn ? 0.0 : -0.05
    }
  }
  
  func updateLayerSizeSliderValueLabel() {
    let value = layerSizeSlider.value
    layerSizeSliderValueLabel.text = String(format: "%.0f x %.0f", value, value * Float(lengthMultiplier))
  }
  
  func updateInstanceCountSliderValueLabel() {
    instanceCountSliderValueLabel.text = String(format: "%.0f", instanceCountSlider.value)
  }
  
  func updateInstanceDelaySliderValueLabel() {
    instanceDelaySliderValueLabel.text = String(format: "%.0f", instanceDelaySlider.value)
  }
  
}
