//
//  CAGradientLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/14/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

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
    gradientLayer.locations = locations
  }
  
  func setUpLocationSliders() {
    let sliders = locationSliders
    
    for (index, slider) in enumerate(sliders) {
      slider.value = locations[index]
    }
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpColors()
    setUpGradientLayer()
    viewForGradientLayer.layer.addSublayer(gradientLayer)
    setUpLocationSliders()
    updateLocationSliderValueLabels()
  }
  
  // MARK: - @IBActions
  
  @IBAction func startPointSliderChanged(sender: UISlider) {
    gradientLayer.startPoint = CGPoint(x: CGFloat(sender.value), y: 0.0)
    updateStartAndEndPointValueLabels()
  }
  
  @IBAction func endPointSliderChanged(sender: UISlider) {
    gradientLayer.endPoint = CGPoint(x: CGFloat(sender.value), y: 1.0)
    updateStartAndEndPointValueLabels()
  }
  
  @IBAction func colorSwitchChanged(sender: UISwitch) {
    var gradientLayerColors = [AnyObject]()
    var locations = [NSNumber]()
    
    for (index, colorSwitch) in enumerate(colorSwitches) {
      let slider = locationSliders[index]
      
      if colorSwitch.on {
        gradientLayerColors.append(colors[index])
        locations.append(NSNumber(float: slider.value))
        slider.hidden = false
      } else {
        slider.hidden = true
      }
    }
    
    if gradientLayerColors.count == 1 {
      gradientLayerColors.append(gradientLayerColors[0])
    }
    
    gradientLayer.colors = gradientLayerColors
    gradientLayer.locations = locations.count > 1 ? locations : nil
    updateLocationSliderValueLabels()
  }
  
  @IBAction func locationSliderChanged(sender: UISlider) {
    var gradientLayerLocations = [NSNumber]()
    
    for (index, slider) in enumerate(locationSliders) {
      let colorSwitch = colorSwitches[index]
      
      if colorSwitch.on {
        gradientLayerLocations.append(NSNumber(float: slider.value))
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
    for (index, label) in enumerate(locationSliderValueLabels) {
      let colorSwitch = colorSwitches[index]
      
      if colorSwitch.on {
        let slider = locationSliders[index]
        label.text = String(format: "%.2f", slider.value)
        label.hidden = false
      } else {
        label.hidden = true
      }
    }
  }
  
  // MARK: - Helpers
  
  func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat) -> AnyObject {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).CGColor as AnyObject
  }
  
}
