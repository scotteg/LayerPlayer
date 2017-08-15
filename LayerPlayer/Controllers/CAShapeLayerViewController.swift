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

class CAShapeLayerViewController: UIViewController {
  
  // FIXME: Unsatisfiable constraints in compact width, compact height (e.g., iPhone 5 in landscape)
  
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
    case nonZero, evenOdd
  }
  enum LineCap: Int {
    case butt, round, square, cap
  }
  enum LineJoin: Int {
    case miter, round, bevel
  }
  
  let shapeLayer = CAShapeLayer()
  var color = swiftOrangeColor
  let openPath = UIBezierPath()
  let closedPath = UIBezierPath()
  
  // MARK: - Quick reference
  
  func setUpOpenPath() {
    openPath.move(to: CGPoint(x: 30, y: 196))
    openPath.addCurve(to: CGPoint(x: 112.0, y: 12.5), controlPoint1: CGPoint(x: 110.56, y: 13.79), controlPoint2: CGPoint(x: 112.07, y: 13.01))
    openPath.addCurve(to: CGPoint(x: 194, y: 196), controlPoint1: CGPoint(x: 111.9, y: 11.81), controlPoint2: CGPoint(x: 194, y: 196))
    openPath.addLine(to: CGPoint(x: 30.0, y: 85.68))
    openPath.addLine(to: CGPoint(x: 194.0, y: 48.91))
    openPath.addLine(to: CGPoint(x: 30, y: 196))
  }
  
  func setUpClosedPath() {
    closedPath.cgPath = openPath.cgPath.mutableCopy()!
    closedPath.close()
  }
  
  func setUpShapeLayer() {
    shapeLayer.path = openPath.cgPath
    shapeLayer.fillColor = nil
    shapeLayer.fillRule = kCAFillRuleNonZero
    shapeLayer.lineCap = kCALineCapButt
    shapeLayer.lineDashPattern = nil
    shapeLayer.lineDashPhase = 0.0
    shapeLayer.lineJoin = kCALineJoinMiter
    shapeLayer.lineWidth = CGFloat(lineWidthSlider.value)
    shapeLayer.miterLimit = 4.0
    shapeLayer.strokeColor = color.cgColor
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
  
  @IBAction func closePathSwitchChanged(_ sender: UISwitch) {
    var selectedSegmentIndex: Int!
    
    if sender.isOn {
      selectedSegmentIndex = UISegmentedControlNoSegment
      shapeLayer.path = closedPath.cgPath
    } else {
      switch shapeLayer.lineCap {
      case kCALineCapButt:
        selectedSegmentIndex = LineCap.butt.rawValue
      case kCALineCapRound:
        selectedSegmentIndex = LineCap.round.rawValue
      default:
        selectedSegmentIndex = LineCap.square.rawValue
      }
      
      shapeLayer.path = openPath.cgPath
    }
    
    lineCapSegmentedControl.selectedSegmentIndex = selectedSegmentIndex
  }
  
  @IBAction func hueSliderChanged(_ sender: UISlider) {
    let hue = CGFloat(sender.value / 359.0)
    let color = UIColor(hue: hue, saturation: 0.81, brightness: 0.97, alpha: 1.0)
    shapeLayer.fillColor = fillSwitch.isOn ? color.cgColor : nil
    shapeLayer.strokeColor = color.cgColor
    self.color = color
  }
  
  @IBAction func fillSwitchChanged(_ sender: UISwitch) {
    var selectedSegmentIndex: Int
    
    if sender.isOn {
      shapeLayer.fillColor = color.cgColor
      
      if shapeLayer.fillRule == kCAFillRuleNonZero {
        selectedSegmentIndex = FillRule.nonZero.rawValue
      } else {
        selectedSegmentIndex = FillRule.evenOdd.rawValue
      }
    } else {
      selectedSegmentIndex = UISegmentedControlNoSegment
      shapeLayer.fillColor = nil
    }
    
    fillRuleSegmentedControl.selectedSegmentIndex = selectedSegmentIndex
  }
  
  @IBAction func fillRuleSegmentedControlChanged(_ sender: UISegmentedControl) {
    fillSwitch.isOn = true
    shapeLayer.fillColor = color.cgColor
    var fillRule = kCAFillRuleNonZero
    
    if sender.selectedSegmentIndex != FillRule.nonZero.rawValue {
      fillRule = kCAFillRuleEvenOdd
    }
    
    shapeLayer.fillRule = fillRule
  }
  
  @IBAction func lineWidthSliderChanged(_ sender: UISlider) {
    shapeLayer.lineWidth = CGFloat(sender.value)
  }
  
  @IBAction func lineDashSwitchChanged(_ sender: UISwitch) {
    if sender.isOn {
      shapeLayer.lineDashPattern = [50, 50]
      shapeLayer.lineDashPhase = 25.0
    } else {
      shapeLayer.lineDashPattern = nil
      shapeLayer.lineDashPhase = 0
    }
  }
  
  @IBAction func lineCapSegmentedControlChanged(_ sender: UISegmentedControl) {
    closePathSwitch.isOn = false
    shapeLayer.path = openPath.cgPath
    var lineCap = kCALineCapButt
    
    switch sender.selectedSegmentIndex {
    case LineCap.round.rawValue:
      lineCap = kCALineCapRound
    case LineCap.square.rawValue:
      lineCap = kCALineCapSquare
    default:
      break
    }
    
    shapeLayer.lineCap = lineCap
  }
  
  @IBAction func lineJoinSegmentedControlChanged(_ sender: UISegmentedControl) {
    var lineJoin = kCALineJoinMiter
    
    switch sender.selectedSegmentIndex {
    case LineJoin.round.rawValue:
      lineJoin = kCALineJoinRound
    case LineJoin.bevel.rawValue:
      lineJoin = kCALineJoinBevel
    default:
      break
    }
    
    shapeLayer.lineJoin = lineJoin
  }
  
}
