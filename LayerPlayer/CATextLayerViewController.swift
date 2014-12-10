//
//  CATextLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/12/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CATextLayerViewController: UIViewController {
  
  @IBOutlet weak var viewForTextLayer: UIView!
  @IBOutlet weak var fontSizeSliderValueLabel: UILabel!
  @IBOutlet weak var fontSizeSlider: UISlider!
  @IBOutlet weak var wrapTextSwitch: UISwitch!
  @IBOutlet weak var alignmentModeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var truncationModeSegmentedControl: UISegmentedControl!
  
  enum Font: Int {
    case Helvetica, NoteworthyLight
  }
  
  enum AlignmentMode: Int {
    case Left, Center, Justified, Right
  }
  enum TruncationMode: Int {
    case Start, Middle, End
  }
  
  var noteworthyLightFont: AnyObject?
  var helveticaFont: AnyObject?
  let baseFontSize: CGFloat = 24.0
  let textLayer = CATextLayer()
  var fontSize: CGFloat = 24.0
  var previouslySelectedTruncationMode = TruncationMode.End
  
  // MARK: - Quick reference
  
  func setUpTextLayer() {
    textLayer.frame = viewForTextLayer.bounds
    var string = ""
    
    for _ in 1...20 {
      string += "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor arcu quis velit congue dictum. "
    }
    
    textLayer.string = string
    textLayer.font = helveticaFont
    textLayer.foregroundColor = UIColor.darkGrayColor().CGColor
    textLayer.wrapped = true
    textLayer.alignmentMode = kCAAlignmentLeft
    textLayer.truncationMode = kCATruncationEnd
    textLayer.contentsScale = UIScreen.mainScreen().scale
  }
  
  func createFonts() {
    var fontName: CFStringRef = "Noteworthy-Light"
    noteworthyLightFont = CTFontCreateWithName(fontName, baseFontSize, nil)
    fontName = "Helvetica"
    helveticaFont = CTFontCreateWithName(fontName, baseFontSize, nil)
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createFonts()
    setUpTextLayer()
    viewForTextLayer.layer.addSublayer(textLayer)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    textLayer.frame = viewForTextLayer.bounds
    textLayer.fontSize = fontSize
  }
  
  // MARK: - IBActions
  
  @IBAction func fontSegmentedControlChanged(sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case Font.Helvetica.rawValue:
      textLayer.font = helveticaFont
    case Font.NoteworthyLight.rawValue:
      textLayer.font = noteworthyLightFont
    default:
      break
    }
  }
  
  @IBAction func fontSizeSliderChanged(sender: UISlider) {
    fontSizeSliderValueLabel.text = "\(Int(sender.value * 100.0))%"
    fontSize = baseFontSize * CGFloat(sender.value)
  }
  
  @IBAction func wrapTextSwitchChanged(sender: UISwitch) {
    alignmentModeSegmentedControl.selectedSegmentIndex = AlignmentMode.Left.rawValue
    textLayer.alignmentMode = kCAAlignmentLeft
    
    if sender.on {
      if let truncationMode = TruncationMode(rawValue: truncationModeSegmentedControl.selectedSegmentIndex) {
        previouslySelectedTruncationMode = truncationMode
      }
      
      truncationModeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
      textLayer.wrapped = true
    } else {
      textLayer.wrapped = false
      truncationModeSegmentedControl.selectedSegmentIndex = previouslySelectedTruncationMode.rawValue
    }
  }
  
  @IBAction func alignmentModeSegmentedControlChanged(sender: UISegmentedControl) {
    wrapTextSwitch.on = true
    textLayer.wrapped = true
    truncationModeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    textLayer.truncationMode = kCATruncationNone
    
    switch sender.selectedSegmentIndex {
    case AlignmentMode.Left.rawValue:
      textLayer.alignmentMode = kCAAlignmentLeft
    case AlignmentMode.Center.rawValue:
      textLayer.alignmentMode = kCAAlignmentCenter
    case AlignmentMode.Justified.rawValue:
      textLayer.alignmentMode = kCAAlignmentJustified
    case AlignmentMode.Right.rawValue:
      textLayer.alignmentMode = kCAAlignmentRight
    default:
      textLayer.alignmentMode = kCAAlignmentLeft
    }
  }
  
  @IBAction func truncationModeSegmentedControlChanged(sender: UISegmentedControl) {
    wrapTextSwitch.on = false
    textLayer.wrapped = false
    alignmentModeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    textLayer.alignmentMode = kCAAlignmentLeft
    
    switch sender.selectedSegmentIndex {
    case TruncationMode.Start.rawValue:
      textLayer.truncationMode = kCATruncationStart
    case TruncationMode.Middle.rawValue:
      textLayer.truncationMode = kCATruncationMiddle
    case TruncationMode.End.rawValue:
      textLayer.truncationMode = kCATruncationEnd
    default:
      textLayer.truncationMode = kCATruncationNone
    }
  }
  
}
