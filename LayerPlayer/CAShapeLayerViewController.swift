//
//  CAShapeLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/17/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CAShapeLayerViewController: UIViewController {
  
  @IBOutlet weak var viewForShapeLayer: UIView!
  @IBOutlet weak var closePathSwitch: UISwitch!
  @IBOutlet weak var hueSlider: UISlider!
  @IBOutlet weak var fillSwitch: UISwitch!
  @IBOutlet weak var fillRuleSegmentedControl: UISegmentedControl!
  @IBOutlet weak var lineWidthSlider: UISlider!
  @IBOutlet weak var lineDashSwitch: UISwitch!
  @IBOutlet weak var lineCapSegmentedControl: UISegmentedControl!
  @IBOutlet weak var lineJoinSegmentedControl: UISegmentedControl!
  
  enum FillRule: Int {
    case NonZero, EvenOdd
  }
  enum LineCap: Int {
    case Butt, Round, Square, Cap
  }
  enum LineJoin: Int {
    case Miter, Round, Bevel
  }
  
  let shapeLayer = CAShapeLayer()
  var color = UIColor(hue: 129/359.0, saturation: 1.0, brightness: 0.4, alpha: 1.0)
  let openPath = UIBezierPath()
  let closedPath = UIBezierPath()
  
  // MARK: - Quick reference
  
  func setUpOpenPath() {
    openPath.moveToPoint(CGPoint(x: 30, y: 196))
    openPath.addCurveToPoint(CGPoint(x: 112.0, y: 12.5), controlPoint1: CGPoint(x: 110.56, y: 13.79), controlPoint2: CGPoint(x: 112.07, y: 13.01))
    openPath.addCurveToPoint(CGPoint(x: 194, y: 196), controlPoint1: CGPoint(x: 111.9, y: 11.81), controlPoint2: CGPoint(x: 194, y: 196))
    openPath.addLineToPoint(CGPoint(x: 30.0, y: 85.68))
    openPath.addLineToPoint(CGPoint(x: 194.0, y: 48.91))
    openPath.addLineToPoint(CGPoint(x: 30, y: 196))
  }
  
  func setUpClosedPath() {
    closedPath.CGPath = CGPathCreateMutableCopy(openPath.CGPath)
    closedPath.closePath()
  }
  
  func setUpShapeLayer() {
    shapeLayer.path = openPath.CGPath
    shapeLayer.fillColor = nil
    shapeLayer.fillRule = kCAFillRuleNonZero
    shapeLayer.lineCap = kCALineCapButt
    shapeLayer.lineDashPattern = nil
    shapeLayer.lineDashPhase = 0.0
    shapeLayer.lineJoin = kCALineJoinMiter
    shapeLayer.lineWidth = CGFloat(lineWidthSlider.value)
    shapeLayer.miterLimit = 4.0
    shapeLayer.strokeColor = color.CGColor
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpOpenPath()
    setUpClosedPath()
    setUpShapeLayer()
    viewForShapeLayer.layer.addSublayer(shapeLayer)
  }
  
  // MARK: - IBActions
  
  @IBAction func closePathSwitchChanged(sender: UISwitch) {
    var selectedSegmentIndex: Int!
    
    if sender.on {
      selectedSegmentIndex = UISegmentedControlNoSegment
      shapeLayer.path = closedPath.CGPath
    } else {
      switch shapeLayer.lineCap {
      case kCALineCapButt:
        selectedSegmentIndex = LineCap.Butt.rawValue
      case kCALineCapRound:
        selectedSegmentIndex = LineCap.Round.rawValue
      default:
        selectedSegmentIndex = LineCap.Square.rawValue
      }
      
      shapeLayer.path = openPath.CGPath
    }
    
    lineCapSegmentedControl.selectedSegmentIndex = selectedSegmentIndex
  }
  
  @IBAction func hueSliderChanged(sender: UISlider) {
    let hue = CGFloat(sender.value / 359.0)
    let color = UIColor(hue: hue, saturation: hue, brightness: 0.4, alpha: 1.0)
    shapeLayer.fillColor = fillSwitch.on ? color.CGColor : nil
    shapeLayer.strokeColor = color.CGColor
    self.color = color
  }
  
  @IBAction func fillSwitchChanged(sender: UISwitch) {
    var selectedSegmentIndex: Int
    
    if sender.on {
      shapeLayer.fillColor = color.CGColor
      
      if shapeLayer.fillRule == kCAFillRuleNonZero {
        selectedSegmentIndex = FillRule.NonZero.rawValue
      } else {
        selectedSegmentIndex = FillRule.EvenOdd.rawValue
      }
    } else {
      selectedSegmentIndex = UISegmentedControlNoSegment
      shapeLayer.fillColor = nil
    }
    
    fillRuleSegmentedControl.selectedSegmentIndex = selectedSegmentIndex
  }
  
  @IBAction func fillRuleSegmentedControlChanged(sender: UISegmentedControl) {
    fillSwitch.on = true
    shapeLayer.fillColor = color.CGColor
    var fillRule = kCAFillRuleNonZero
    
    if sender.selectedSegmentIndex != FillRule.NonZero.rawValue {
      fillRule = kCAFillRuleEvenOdd
    }
    
    shapeLayer.fillRule = fillRule
  }
  
  @IBAction func lineWidthSliderChanged(sender: UISlider) {
    shapeLayer.lineWidth = CGFloat(sender.value)
  }
  
  @IBAction func lineDashSwitchChanged(sender: UISwitch) {
    if sender.on {
      shapeLayer.lineDashPattern = [50, 50]
      shapeLayer.lineDashPhase = 25.0
    } else {
      shapeLayer.lineDashPattern = nil
      shapeLayer.lineDashPhase = 0
    }
  }
  
  @IBAction func lineCapSegmentedControlChanged(sender: UISegmentedControl) {
    closePathSwitch.on = false
    shapeLayer.path = openPath.CGPath
    var lineCap = kCALineCapButt
    
    switch sender.selectedSegmentIndex {
    case LineCap.Round.rawValue:
      lineCap = kCALineCapRound
    case LineCap.Square.rawValue:
      lineCap = kCALineCapSquare
    default:
      break
    }
    
    shapeLayer.lineCap = lineCap
  }
  
  @IBAction func lineJoinSegmentedControlChanged(sender: UISegmentedControl) {
    var lineJoin = kCALineJoinMiter
    
    switch sender.selectedSegmentIndex {
    case LineJoin.Round.rawValue:
      lineJoin = kCALineJoinRound
    case LineJoin.Bevel.rawValue:
      lineJoin = kCALineJoinBevel
    default:
      break
    }
    
    shapeLayer.lineJoin = lineJoin
  }
  
}
