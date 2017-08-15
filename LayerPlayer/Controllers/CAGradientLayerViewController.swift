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

class CAGradientLayerViewController: UIViewController {
  
  @IBOutlet weak var viewForGradientLayer: UIView!
  @IBOutlet weak var startPointSlider: UISlider!
  @IBOutlet weak var startPointSliderValueLabel: UILabel!
  @IBOutlet weak var endPointSlider: UISlider!
  @IBOutlet weak var endPointSliderValueLabel: UILabel!
  @IBOutlet var colorSwitches: [UISwitch]!
  @IBOutlet var locationSliders: [UISlider]!
  @IBOutlet var locationSliderValueLabels: [UILabel]!
  
  let gradientLayer = CAGradientLayer()
  var colors = [AnyObject]()
  let locations: [Float] = [0, 1/6.0, 1/3.0, 0.5, 2/3.0, 5/6.0, 1.0]
  
  // MARK: - Quick reference
  
  func sortOutletCollections() {
    colorSwitches.sortUIViewsInPlaceByTag()
    locationSliders.sortUIViewsInPlaceByTag()
    locationSliderValueLabels.sortUIViewsInPlaceByTag()
  }
  
  func setUpColors() {
    colors = [cgColorForRed(209.0, green: 0.0, blue: 0.0),
      cgColorForRed(255.0, green: 102.0, blue: 34.0),
      cgColorForRed(255.0, green: 218.0, blue: 33.0),
      cgColorForRed(51.0, green: 221.0, blue: 0.0),
      cgColorForRed(17.0, green: 51.0, blue: 204.0),
      cgColorForRed(34.0, green: 0.0, blue: 102.0),
      cgColorForRed(51.0, green: 0.0, blue: 68.0)]
  }
  
  func setUpGradientLayer() {
    gradientLayer.frame = viewForGradientLayer.bounds
    gradientLayer.colors = colors
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayer.locations = locations as [NSNumber]?
  }
  
  func setUpLocationSliders() {
    let sliders = locationSliders
    
    for (index, slider) in (sliders?.enumerated())! {
      slider.value = locations[index]
    }
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sortOutletCollections()
    setUpColors()
    setUpGradientLayer()
    viewForGradientLayer.layer.addSublayer(gradientLayer)
    setUpLocationSliders()
    updateLocationSliderValueLabels()
  }
  
  // MARK: - @IBActions
  
  @IBAction func startPointSliderChanged(_ sender: UISlider) {
    gradientLayer.startPoint = CGPoint(x: CGFloat(sender.value), y: 0.0)
    updateStartAndEndPointValueLabels()
  }
  
  @IBAction func endPointSliderChanged(_ sender: UISlider) {
    gradientLayer.endPoint = CGPoint(x: CGFloat(sender.value), y: 1.0)
    updateStartAndEndPointValueLabels()
  }
  
  @IBAction func colorSwitchChanged(_ sender: UISwitch) {
    var gradientLayerColors = [AnyObject]()
    var locations = [NSNumber]()
    
    for (index, colorSwitch) in colorSwitches.enumerated() {
      let slider = locationSliders[index]
      
      if colorSwitch.isOn {
        gradientLayerColors.append(colors[index])
        locations.append(NSNumber(value: slider.value as Float))
        slider.isEnabled = true
      } else {
        slider.isEnabled = false
      }
    }
    
    if gradientLayerColors.count == 1 {
      gradientLayerColors.append(gradientLayerColors[0])
    }
    
    gradientLayer.colors = gradientLayerColors
    gradientLayer.locations = locations.count > 1 ? locations : nil
    updateLocationSliderValueLabels()
  }
  
  @IBAction func locationSliderChanged(_ sender: UISlider) {
    var gradientLayerLocations = [NSNumber]()
    
    for (index, slider) in locationSliders.enumerated() {
      let colorSwitch = colorSwitches[index]
      
      if colorSwitch.isOn {
        gradientLayerLocations.append(NSNumber(value: slider.value as Float))
      }
    }
    
    gradientLayer.locations = gradientLayerLocations
    updateLocationSliderValueLabels()
  }
  
  // MARK: - Triggered actions
  
  func updateStartAndEndPointValueLabels() {
    startPointSliderValueLabel.text = String(format: "(%.1f, 0.0)", startPointSlider.value)
    endPointSliderValueLabel.text = String(format: "(%.1f, 1.0)", endPointSlider.value)
  }
  
  func updateLocationSliderValueLabels() {
    for (index, label) in locationSliderValueLabels.enumerated() {
      let colorSwitch = colorSwitches[index]
      
      if colorSwitch.isOn {
        let slider = locationSliders[index]
        label.text = String(format: "%.2f", slider.value)
        label.isEnabled = true
      } else {
        label.isEnabled = false
      }
    }
  }
  
  // MARK: - Helpers
  
  func cgColorForRed(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> AnyObject {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).cgColor as AnyObject
  }
  
}
