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

class CAScrollLayerViewController: UIViewController {
  
  @IBOutlet weak var scrollingView: ScrollingView!
  @IBOutlet weak var horizontalScrollingSwitch: UISwitch!
  @IBOutlet weak var verticalScrollingSwitch: UISwitch!
  
  var scrollingViewLayer: CAScrollLayer {
    return scrollingView.layer as! CAScrollLayer
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollingViewLayer.scrollMode = kCAScrollBoth
  }
  
  // MARK: - IBActions
  
  @IBAction func panRecognized(_ sender: UIPanGestureRecognizer) {
    var newPoint = scrollingView.bounds.origin
    newPoint.x -= sender.translation(in: scrollingView).x
    newPoint.y -= sender.translation(in: scrollingView).y
    sender.setTranslation(CGPoint.zero, in: scrollingView)
    scrollingViewLayer.scroll(to: newPoint)
    
    if sender.state == .ended {
      UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
        [unowned self] in
        self.scrollingViewLayer.scroll(to: CGPoint.zero)
        }, completion: nil)
    }
  }
  
  @IBAction func scrollingSwitchChanged(_ sender: UISwitch) {
    switch (horizontalScrollingSwitch.isOn, verticalScrollingSwitch.isOn) {
    case (true, true):
      scrollingViewLayer.scrollMode = kCAScrollBoth
    case (true, false):
      scrollingViewLayer.scrollMode = kCAScrollHorizontally
    case (false, true):
      scrollingViewLayer.scrollMode = kCAScrollVertically
    default:
      scrollingViewLayer.scrollMode = kCAScrollNone
    }
  }
  
}
