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
    case emitterLayer, emitterCell
  }
  enum Slider: Int {
    case color, redRange, greenRange, blueRange, alphaRange, redSpeed, greenSpeed, blueSpeed, alphaSpeed, scale, scaleRange, spin, spinRange, emissionLatitude, emissionLongitude, emissionRange, lifetime, lifetimeRange, birthRate, velocity, velocityRange, xAcceleration, yAcceleration
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
  
  @IBAction func enabledSwitchChanged(_ sender: UISwitch) {
    emitterLayerViewController.emitterCell.isEnabled = sender.isOn
    emitterLayerViewController.resetEmitterCells()
  }
  
  @IBAction func sliderChanged(_ sender: UISlider) {
    let slidersArray = sliders as NSArray
    let slider = Slider(rawValue: slidersArray.index(of: sender))!
    var keyPath = "emitterCell."
    
    switch slider {
    case .color: keyPath += "color"
    case .redRange: keyPath += "redRange"
    case .greenRange: keyPath += "greenRange"
    case .blueRange: keyPath += "blueRange"
    case .alphaRange: keyPath += "alphaRange"
    case .redSpeed: keyPath += "redSpeed"
    case .greenSpeed: keyPath += "greenSpeed"
    case .blueSpeed: keyPath += "blueSpeed"
    case .alphaSpeed: keyPath += "alphaSpeed"
    case .scale: keyPath  += "scale"
    case .scaleRange: keyPath += "scaleRange"
    case .spin: keyPath += "spin"
    case .spinRange: keyPath += "spinRange"
    case .emissionLatitude: keyPath += "emissionLatitude"
    case .emissionLongitude: keyPath += "emissionLongitude"
    case .emissionRange: keyPath += "emissionRange"
    case .lifetime: keyPath += "lifetime"
    case .lifetimeRange: keyPath += "lifetimeRange"
    case .birthRate: keyPath += "birthRate"
    case .velocity: keyPath += "velocity"
    case .velocityRange: keyPath += "velocityRange"
    case .xAcceleration: keyPath += "xAcceleration"
    case .yAcceleration: keyPath += "yAcceleration"
    }
    
    if keyPath == "emitterCell.color" {
      let color = UIColor(hue: 0.0, saturation: 0.0, brightness: CGFloat(sender.value), alpha: 1.0)
      emitterLayerViewController.emitterCell.color = color.cgColor
      emitterLayerViewController.resetEmitterCells()
    } else {
      emitterLayerViewController.setValue(NSNumber(value: sender.value as Float), forKeyPath: keyPath)
      emitterLayerViewController.resetEmitterCells()
    }
    
    updateSliderValueLabel(slider)
  }
  
  // MARK: - Triggered actions
  
  func showEmitterLayerRenderModePicker() {
    renderModePickerVisible = true
    relayoutTableViewCells()
    let index = emitterLayerRenderModes.index(of: emitterLayer.renderMode)
    renderModePicker.selectRow(index, inComponent: 0, animated: false)
    renderModePicker.isHidden = false
    renderModePicker.alpha = 0.0
    
    UIView.animate(withDuration: 0.25, animations: {
      [unowned self] in
      self.renderModePicker.alpha = 1.0
    })
  }
  
  func hideEmitterLayerRenderModePicker() {
    if renderModePickerVisible {
      UIApplication.shared.beginIgnoringInteractionEvents()
      renderModePickerVisible = false
      relayoutTableViewCells()
      
      UIView.animate(withDuration: 0.25, animations: {
        [unowned self] in
        self.renderModePicker.alpha = 0.0
      }, completion: {
        [unowned self] _ in
        self.renderModePicker.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
      })
    }
  }
  
  // MARK: - Helpers
  
  func updateRenderModePickerValueLabel() {
    renderModePickerValueLabel.text = emitterLayer.renderMode
  }
  
  func updateSliderValueLabels() {
    for slider in Slider.color.rawValue...Slider.yAcceleration.rawValue {
      updateSliderValueLabel(Slider(rawValue: slider)!)
    }
  }
  
  func updateSliderValueLabel(_ sliderEnum: Slider) {
    let index = sliderEnum.rawValue
    let label = sliderValueLabels[index]
    let slider = sliders[index]
    
    switch sliderEnum {
    case .redRange, .greenRange, .blueRange, .alphaRange, .redSpeed, .greenSpeed, .blueSpeed, .alphaSpeed, .scale, .scaleRange, .lifetime, .lifetimeRange:
      label.text = String(format: "%.1f", slider.value)
    case .color:
      label.text = String(format: "%.0f", slider.value * 100.0)
    case .spin, .spinRange, .emissionLatitude, .emissionLongitude, .emissionRange:
      let formatter = NumberFormatter()
      formatter.minimumFractionDigits = 0
      label.text = "\(Int(radiansToDegrees(Double(slider.value))))"
    case .birthRate, .velocity, .velocityRange, .xAcceleration, .yAcceleration:
      label.text = String(format: "%.0f", slider.value)
    }
  }
  
  func relayoutTableViewCells() {
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = Section(rawValue: indexPath.section)!
    
    if section == .emitterLayer && indexPath.row == 1 {
      return renderModePickerVisible ? 162.0 : 0.0
    } else {
      return 44.0
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = Section(rawValue: indexPath.section)!
    
    switch section {
    case .emitterLayer where !renderModePickerVisible:
      showEmitterLayerRenderModePicker()
    default:
      hideEmitterLayerRenderModePicker()
    }
  }
  
  // MARK: - UIPickerViewDataSource
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return emitterLayerRenderModes.count
  }
  
  // MARK: - UIPickerViewDelegate
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return emitterLayerRenderModes[row] as? String
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    emitterLayerViewController.emitterLayer.renderMode = emitterLayerRenderModes[row] as! String
    updateRenderModePickerValueLabel()
  }
  
}
