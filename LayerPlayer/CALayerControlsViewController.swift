//
//  CALayerControlsViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/23/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CALayerControlsViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  @IBOutlet weak var contentsGravityPickerValueLabel: UILabel!
  @IBOutlet weak var contentsGravityPicker: UIPickerView!
  @IBOutlet var switches: [UISwitch]!
  @IBOutlet var sliderValueLabels: [UILabel]!
  @IBOutlet var sliders: [UISlider]!
  @IBOutlet weak var borderColorSlidersValueLabel: UILabel!
  @IBOutlet var borderColorSliders: [UISlider]!
  @IBOutlet weak var backgroundColorSlidersValueLabel: UILabel!
  @IBOutlet var backgroundColorSliders: [UISlider]!
  @IBOutlet weak var shadowOffsetSlidersValueLabel: UILabel!
  @IBOutlet var shadowOffsetSliders: [UISlider]!
  @IBOutlet weak var shadowColorSlidersValueLabel: UILabel!
  @IBOutlet var shadowColorSliders: [UISlider]!
  @IBOutlet weak var magnificationFilterSegmentedControl: UISegmentedControl!
  
  enum Row: Int {
    case contentsGravity, contentsGravityPicker, displayContents, geometryFlipped, hidden, opacity, cornerRadius, borderWidth, borderColor, backgroundColor, shadowOpacity, shadowOffset, shadowRadius, shadowColor, magnificationFilter
  }
  enum Switch: Int {
    case displayContents, geometryFlipped, hidden
  }
  enum Slider: Int {
    case opacity, cornerRadius, borderWidth, shadowOpacity, shadowRadius
  }
  enum ColorSlider: Int {
    case red, green, blue
  }
  enum MagnificationFilter: Int {
    case linear, nearest, trilinear
  }
  
  weak var layerViewController: CALayerViewController!
  var contentsGravityValues = [kCAGravityCenter, kCAGravityTop, kCAGravityBottom, kCAGravityLeft, kCAGravityRight, kCAGravityTopLeft, kCAGravityTopRight, kCAGravityBottomLeft, kCAGravityBottomRight, kCAGravityResize, kCAGravityResizeAspect, kCAGravityResizeAspectFill] as NSArray
  var contentsGravityPickerVisible = false
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateSliderValueLabels()
  }
  
  // MARK: - IBActions
  
  @IBAction func switchChanged(_ sender: UISwitch) {
    let switchesArray = switches as NSArray
    let theSwitch = Switch(rawValue: switchesArray.index(of: sender))!
    
    switch theSwitch {
    case .displayContents:
      layerViewController.layer.contents = sender.isOn ? layerViewController.star : nil
    case .geometryFlipped:
      layerViewController.layer.isGeometryFlipped = sender.isOn
    case .hidden:
      layerViewController.layer.isHidden = sender.isOn
    }
  }
  
  @IBAction func sliderChanged(_ sender: UISlider) {
    let slidersArray = sliders as NSArray
    let slider = Slider(rawValue: slidersArray.index(of: sender))!
    
    switch slider {
    case .opacity:
      layerViewController.layer.opacity = sender.value
    case .cornerRadius:
      layerViewController.layer.cornerRadius = CGFloat(sender.value)
    case .borderWidth:
      layerViewController.layer.borderWidth = CGFloat(sender.value)
    case .shadowOpacity:
      layerViewController.layer.shadowOpacity = sender.value
    case .shadowRadius:
      layerViewController.layer.shadowRadius = CGFloat(sender.value)
    }
    
    updateSliderValueLabel(slider)
  }
  
  @IBAction func borderColorSliderChanged(_ sender: UISlider) {
    let colorAndLabel = colorAndLabelForSliders(borderColorSliders)
    layerViewController.layer.borderColor = colorAndLabel.color
    borderColorSlidersValueLabel.text = colorAndLabel.label
  }

  @IBAction func backgroundColorSliderChanged(_ sender: UISlider) {
    let colorAndLabel = colorAndLabelForSliders(backgroundColorSliders)
    layerViewController.layer.backgroundColor = colorAndLabel.color
    backgroundColorSlidersValueLabel.text = colorAndLabel.label
  }
  
  @IBAction func shadowOffsetSliderChanged(_ sender: UISlider) {
    let width = CGFloat(shadowOffsetSliders[0].value)
    let height = CGFloat(shadowOffsetSliders[1].value)
    layerViewController.layer.shadowOffset = CGSize(width: width, height: height)
    shadowOffsetSlidersValueLabel.text = "Width: \(Int(width)), Height: \(Int(height))"
  }
  
  @IBAction func shadowColorSliderChanged(_ sender: UISlider) {
    let colorAndLabel = colorAndLabelForSliders(shadowColorSliders)
    layerViewController.layer.shadowColor = colorAndLabel.color
    shadowColorSlidersValueLabel.text = colorAndLabel.label
  }
  
  @IBAction func magnificationFilterSegmentedControlChanged(_ sender: UISegmentedControl) {
    let filter = MagnificationFilter(rawValue: sender.selectedSegmentIndex)!
    var filterValue = ""
    
    switch filter {
    case .linear:
      filterValue = kCAFilterLinear
    case .nearest:
      filterValue = kCAFilterNearest
    case .trilinear:
      filterValue = kCAFilterTrilinear
    }
    
    layerViewController.layer.magnificationFilter = filterValue
  }
  
  // MARK: - Triggered actions
  
  func showContentsGravityPicker() {
    contentsGravityPickerVisible = true
    relayoutTableViewCells()
    let index = contentsGravityValues.index(of: layerViewController.layer.contentsGravity)
    contentsGravityPicker.selectRow(index, inComponent: 0, animated: false)
    contentsGravityPicker.isHidden = false
    contentsGravityPicker.alpha = 0.0
    
    UIView.animate(withDuration: 0.25, animations: {
      [unowned self] in
      self.contentsGravityPicker.alpha = 1.0
    })
  }
  
  func hideContentsGravityPicker() {
    if contentsGravityPickerVisible {
      tableView.isUserInteractionEnabled = false
      contentsGravityPickerVisible = false
      relayoutTableViewCells()
      
      UIView.animate(withDuration: 0.25, animations: {
        [unowned self] in
        self.contentsGravityPicker.alpha = 0.0
        }, completion: {
          [unowned self] _ in
          self.contentsGravityPicker.isHidden = true
          self.tableView.isUserInteractionEnabled = true
      })
    }
  }
  
  // MARK: - Helpers
  
  func updateContentsGravityPickerValueLabel() {
    contentsGravityPickerValueLabel.text = layerViewController.layer.contentsGravity
  }
  
  func updateSliderValueLabels() {
    for slider in Slider.opacity.rawValue...Slider.shadowRadius.rawValue {
      updateSliderValueLabel(Slider(rawValue: slider)!)
    }
  }
  
  func updateSliderValueLabel(_ sliderEnum: Slider) {
    let index = sliderEnum.rawValue
    let label = sliderValueLabels[index]
    let slider = sliders[index]
    
    switch sliderEnum {
    case .opacity, .shadowOpacity:
      label.text = String(format: "%.1f", slider.value)
    case .cornerRadius, .borderWidth, .shadowRadius:
      label.text = "\(Int(slider.value))"
    }
  }
  
  func colorAndLabelForSliders(_ sliders: [UISlider]) -> (color: CGColor, label: String) {
    let red = CGFloat(sliders[0].value)
    let green = CGFloat(sliders[1].value)
    let blue = CGFloat(sliders[2].value)
    let color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).cgColor
    let label = "RGB: \(Int(red)), \(Int(green)), \(Int(blue))"
    return (color: color, label: label)
  }
  
  func relayoutTableViewCells() {
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let row = Row(rawValue: indexPath.row)!
    
    if row == .contentsGravityPicker {
      return contentsGravityPickerVisible ? 162.0 : 0.0
    } else {
      return 44.0
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = Row(rawValue: indexPath.row)!
    
    switch row {
    case .contentsGravity where !contentsGravityPickerVisible:
      showContentsGravityPicker()
    default:
      hideContentsGravityPicker()
    }
  }
  
  // MARK: - UIPickerViewDataSource
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return contentsGravityValues.count
  }
  
  // MARK: - UIPickerViewDelegate
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return contentsGravityValues[row] as? String
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    layerViewController.layer.contentsGravity = contentsGravityValues[row] as! String
    updateContentsGravityPickerValueLabel()
  }

}
