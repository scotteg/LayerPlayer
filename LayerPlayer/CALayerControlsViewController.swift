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
    case ContentsGravity, ContentsGravityPicker, DisplayContents, GeometryFlipped, Hidden, Opacity, CornerRadius, BorderWidth, BorderColor, BackgroundColor, ShadowOpacity, ShadowOffset, ShadowRadius, ShadowColor, MagnificationFilter
  }
  enum Switch: Int {
    case DisplayContents, GeometryFlipped, Hidden
  }
  enum Slider: Int {
    case Opacity, CornerRadius, BorderWidth, ShadowOpacity, ShadowRadius
  }
  enum ColorSlider: Int {
    case Red, Green, Blue
  }
  enum MagnificationFilter: Int {
    case Linear, Nearest, Trilinear
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
  
  @IBAction func switchChanged(sender: UISwitch) {
    let switchesArray = switches as NSArray
    let theSwitch = Switch(rawValue: switchesArray.indexOfObject(sender))!
    
    switch theSwitch {
    case .DisplayContents:
      layerViewController.layer.contents = sender.on ? layerViewController.star : nil
    case .GeometryFlipped:
      layerViewController.layer.geometryFlipped = sender.on
    case .Hidden:
      layerViewController.layer.hidden = sender.on
    }
  }
  
  @IBAction func sliderChanged(sender: UISlider) {
    let slidersArray = sliders as NSArray
    let slider = Slider(rawValue: slidersArray.indexOfObject(sender))!
    
    switch slider {
    case .Opacity:
      layerViewController.layer.opacity = sender.value
    case .CornerRadius:
      layerViewController.layer.cornerRadius = CGFloat(sender.value)
    case .BorderWidth:
      layerViewController.layer.borderWidth = CGFloat(sender.value)
    case .ShadowOpacity:
      layerViewController.layer.shadowOpacity = sender.value
    case .ShadowRadius:
      layerViewController.layer.shadowRadius = CGFloat(sender.value)
    }
    
    updateSliderValueLabel(slider)
  }
  
  @IBAction func borderColorSliderChanged(sender: UISlider) {
    let colorAndLabel = colorAndLabelForSliders(borderColorSliders)
    layerViewController.layer.borderColor = colorAndLabel.color
    borderColorSlidersValueLabel.text = colorAndLabel.label
  }

  @IBAction func backgroundColorSliderChanged(sender: UISlider) {
    let colorAndLabel = colorAndLabelForSliders(backgroundColorSliders)
    layerViewController.layer.backgroundColor = colorAndLabel.color
    backgroundColorSlidersValueLabel.text = colorAndLabel.label
  }
  
  @IBAction func shadowOffsetSliderChanged(sender: UISlider) {
    let width = CGFloat(shadowOffsetSliders[0].value)
    let height = CGFloat(shadowOffsetSliders[1].value)
    layerViewController.layer.shadowOffset = CGSize(width: width, height: height)
    shadowOffsetSlidersValueLabel.text = "Width: \(Int(width)), Height: \(Int(height))"
  }
  
  @IBAction func shadowColorSliderChanged(sender: UISlider) {
    let colorAndLabel = colorAndLabelForSliders(shadowColorSliders)
    layerViewController.layer.shadowColor = colorAndLabel.color
    shadowColorSlidersValueLabel.text = colorAndLabel.label
  }
  
  @IBAction func magnificationFilterSegmentedControlChanged(sender: UISegmentedControl) {
    let filter = MagnificationFilter(rawValue: sender.selectedSegmentIndex)!
    var filterValue = ""
    
    switch filter {
    case .Linear:
      filterValue = kCAFilterLinear
    case .Nearest:
      filterValue = kCAFilterNearest
    case .Trilinear:
      filterValue = kCAFilterTrilinear
    }
    
    layerViewController.layer.magnificationFilter = filterValue
  }
  
  // MARK: - Triggered actions
  
  func showContentsGravityPicker() {
    contentsGravityPickerVisible = true
    relayoutTableViewCells()
    let index = contentsGravityValues.indexOfObject(layerViewController.layer.contentsGravity)
    contentsGravityPicker.selectRow(index, inComponent: 0, animated: false)
    contentsGravityPicker.hidden = false
    contentsGravityPicker.alpha = 0.0
    
    UIView.animateWithDuration(0.25, animations: {
      [unowned self] in
      self.contentsGravityPicker.alpha = 1.0
    })
  }
  
  func hideContentsGravityPicker() {
    if contentsGravityPickerVisible {
      tableView.userInteractionEnabled = false
      contentsGravityPickerVisible = false
      relayoutTableViewCells()
      
      UIView.animateWithDuration(0.25, animations: {
        [unowned self] in
        self.contentsGravityPicker.alpha = 0.0
        }, completion: {
          [unowned self] _ in
          self.contentsGravityPicker.hidden = true
          self.tableView.userInteractionEnabled = true
      })
    }
  }
  
  // MARK: - Helpers
  
  func updateContentsGravityPickerValueLabel() {
    contentsGravityPickerValueLabel.text = layerViewController.layer.contentsGravity as NSString
  }
  
  func updateSliderValueLabels() {
    for slider in Slider.Opacity.rawValue...Slider.ShadowRadius.rawValue {
      updateSliderValueLabel(Slider(rawValue: slider)!)
    }
  }
  
  func updateSliderValueLabel(sliderEnum: Slider) {
    let index = sliderEnum.rawValue
    let label = sliderValueLabels[index]
    let slider = sliders[index]
    
    switch sliderEnum {
    case .Opacity, .ShadowOpacity:
      label.text = String(format: "%.1f", slider.value)
    case .CornerRadius, .BorderWidth, .ShadowRadius:
      label.text = "\(Int(slider.value))"
    }
  }
  
  func colorAndLabelForSliders(sliders: [UISlider]) -> (color: CGColorRef, label: String) {
    let red = CGFloat(sliders[0].value)
    let green = CGFloat(sliders[1].value)
    let blue = CGFloat(sliders[2].value)
    let color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).CGColor
    let label = "RGB: \(Int(red)), \(Int(green)), \(Int(blue))"
    return (color: color, label: label)
  }
  
  func relayoutTableViewCells() {
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let row = Row(rawValue: indexPath.row)!
    
    if row == .ContentsGravityPicker {
      return contentsGravityPickerVisible ? 162.0 : 0.0
    } else {
      return 44.0
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let row = Row(rawValue: indexPath.row)!
    
    switch row {
    case .ContentsGravity where !contentsGravityPickerVisible:
      showContentsGravityPicker()
    default:
      hideContentsGravityPicker()
    }
  }
  
  // MARK: - UIPickerViewDataSource
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return contentsGravityValues.count
  }
  
  // MARK: - UIPickerViewDelegate
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    return contentsGravityValues[row] as String
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    layerViewController.layer.contentsGravity = contentsGravityValues[row] as String
    updateContentsGravityPickerValueLabel()
  }

}
