//
//  CAEmitterLayerControlsViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/22/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CAEmitterLayerControlsViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  @IBOutlet weak var renderModePickerValueLabel: UILabel!
  @IBOutlet weak var renderModePicker: UIPickerView!
  @IBOutlet var sliderValueLabels: [UILabel]!
  @IBOutlet weak var enabledSwitch: UISwitch!
  @IBOutlet var sliders: [UISlider]!
  
  enum Section: Int {
    case EmitterLayer, EmitterCell
  }
  enum Slider: Int {
    case Color, RedRange, GreenRange, BlueRange, AlphaRange, RedSpeed, GreenSpeed, BlueSpeed, AlphaSpeed, Scale, ScaleRange, Spin, SpinRange, EmissionLatitude, EmissionLongitude, EmissionRange, Lifetime, LifetimeRange, BirthRate, Velocity, VelocityRange, XAcceleration, YAcceleration
  }
  
  weak var emitterLayerViewController: CAEmitterLayerViewController!
  var emitterLayer: CAEmitterLayer {
    return emitterLayerViewController.emitterLayer
  }
  var emitterCell: CAEmitterCell {
    return emitterLayerViewController.emitterCell
  }
  var emitterLayerRenderModes = [kCAEmitterLayerUnordered, kCAEmitterLayerOldestFirst, kCAEmitterLayerOldestLast, kCAEmitterLayerBackToFront, kCAEmitterLayerAdditive] as NSArray
  var renderModePickerVisible = false
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateRenderModePickerValueLabel()
    updateSliderValueLabels()
  }
  
  // MARK: - IBActions
  
  @IBAction func enabledSwitchChanged(sender: UISwitch) {
    emitterLayerViewController.emitterCell.enabled = sender.on
    emitterLayerViewController.resetEmitterCells()
  }
  
  @IBAction func sliderChanged(sender: UISlider) {
    let slidersArray = sliders as NSArray
    let slider = Slider(rawValue: slidersArray.indexOfObject(sender))!
    var keyPath = "emitterCell."
    
    switch slider {
    case .Color: keyPath += "color"
    case .RedRange: keyPath += "redRange"
    case .GreenRange: keyPath += "greenRange"
    case .BlueRange: keyPath += "blueRange"
    case .AlphaRange: keyPath += "alphaRange"
    case .RedSpeed: keyPath += "redSpeed"
    case .GreenSpeed: keyPath += "greenSpeed"
    case .BlueSpeed: keyPath += "blueSpeed"
    case .AlphaSpeed: keyPath += "alphaSpeed"
    case .Scale: keyPath  += "scale"
    case .ScaleRange: keyPath += "scaleRange"
    case .Spin: keyPath += "spin"
    case .SpinRange: keyPath += "spinRange"
    case .EmissionLatitude: keyPath += "emissionLatitude"
    case .EmissionLongitude: keyPath += "emissionLongitude"
    case .EmissionRange: keyPath += "emissionRange"
    case .Lifetime: keyPath += "lifetime"
    case .LifetimeRange: keyPath += "lifetimeRange"
    case .BirthRate: keyPath += "birthRate"
    case .Velocity: keyPath += "velocity"
    case .VelocityRange: keyPath += "velocityRange"
    case .XAcceleration: keyPath += "xAcceleration"
    case .YAcceleration: keyPath += "yAcceleration"
    }
    
    if keyPath == "emitterCell.color" {
      let color = UIColor(hue: 0.0, saturation: 0.0, brightness: CGFloat(sender.value), alpha: 1.0)
      emitterLayerViewController.emitterCell.color = color.CGColor
      emitterLayerViewController.resetEmitterCells()
    } else {
      emitterLayerViewController.setValue(NSNumber(float: sender.value), forKeyPath: keyPath)
      emitterLayerViewController.resetEmitterCells()
    }
    
    updateSliderValueLabel(slider)
  }
  
  // MARK: - Triggered actions
  
  func showEmitterLayerRenderModePicker() {
    renderModePickerVisible = true
    relayoutTableViewCells()
    let index = emitterLayerRenderModes.indexOfObject(emitterLayer.renderMode)
    renderModePicker.selectRow(index, inComponent: 0, animated: false)
    renderModePicker.hidden = false
    renderModePicker.alpha = 0.0
    
    UIView.animateWithDuration(0.25, animations: {
      [unowned self] in
      self.renderModePicker.alpha = 1.0
    })
  }
  
  func hideEmitterLayerRenderModePicker() {
    if renderModePickerVisible {
      UIApplication.sharedApplication().beginIgnoringInteractionEvents()
      renderModePickerVisible = false
      relayoutTableViewCells()
      
      UIView.animateWithDuration(0.25, animations: {
        [unowned self] in
        self.renderModePicker.alpha = 0.0
      }, completion: {
        [unowned self] _ in
        self.renderModePicker.hidden = true
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
      })
    }
  }
  
  // MARK: - Helpers
  
  func updateRenderModePickerValueLabel() {
    renderModePickerValueLabel.text = emitterLayer.renderMode
  }
  
  func updateSliderValueLabels() {
    for slider in Slider.Color.rawValue...Slider.YAcceleration.rawValue {
      updateSliderValueLabel(Slider(rawValue: slider)!)
    }
  }
  
  func updateSliderValueLabel(sliderEnum: Slider) {
    let index = sliderEnum.rawValue
    let label = sliderValueLabels[index]
    let slider = sliders[index]
    
    switch sliderEnum {
    case .RedRange, .GreenRange, .BlueRange, .AlphaRange, .RedSpeed, .GreenSpeed, .BlueSpeed, .AlphaSpeed, .Scale, .ScaleRange, .Lifetime, .LifetimeRange:
      label.text = String(format: "%.1f", slider.value)
    case .Color:
      label.text = String(format: "%.0f", slider.value * 100.0)
    case .Spin, .SpinRange, .EmissionLatitude, .EmissionLongitude, .EmissionRange:
      let formatter = NSNumberFormatter()
      formatter.minimumFractionDigits = 0
      label.text = "\(Int(radiansToDegrees(Double(slider.value))))"
    case .BirthRate, .Velocity, .VelocityRange, .XAcceleration, .YAcceleration:
      label.text = String(format: "%.0f", slider.value)
    }
  }
  
  func relayoutTableViewCells() {
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let section = Section(rawValue: indexPath.section)!
    
    if section == .EmitterLayer && indexPath.row == 1 {
      return renderModePickerVisible ? 162.0 : 0.0
    } else {
      return 44.0
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let section = Section(rawValue: indexPath.section)!
    
    switch section {
    case .EmitterLayer where !renderModePickerVisible:
      showEmitterLayerRenderModePicker()
    default:
      hideEmitterLayerRenderModePicker()
    }
  }
  
  // MARK: - UIPickerViewDataSource
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return emitterLayerRenderModes.count
  }
  
  // MARK: - UIPickerViewDelegate
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    return emitterLayerRenderModes[row] as String
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    emitterLayerViewController.emitterLayer.renderMode = emitterLayerRenderModes[row] as String
    updateRenderModePickerValueLabel()
  }
  
}
