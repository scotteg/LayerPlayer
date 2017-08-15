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

class CATiledLayerViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var tiledImageLayerButton: UIBarButtonItem!
  @IBOutlet weak var zoomLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var viewForTiledLayer: TilingView!
  @IBOutlet weak var fadeDurationSlider: UISlider!
  @IBOutlet weak var fadeDurationSliderValueLabel: UILabel!
  @IBOutlet weak var tileSizeSlider: UISlider!
  @IBOutlet weak var tileSizeSliderValueLabel: UILabel!
  @IBOutlet weak var levelsOfDetailSlider: UISlider!
  @IBOutlet weak var levelsOfDetailSliderValueLabel: UILabel!
  @IBOutlet weak var detailBiasSlider: UISlider!
  @IBOutlet weak var detailBiasSliderValueLabel: UILabel!
  @IBOutlet weak var zoomScaleSlider: UISlider!
  @IBOutlet weak var zoomScaleSliderValueLabel: UILabel!
  
  var tiledLayer: TiledLayer {
    return viewForTiledLayer.layer as! TiledLayer
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTileImageLayerButton()
    scrollView.contentSize = scrollView.frame.size
    updateFadeDurationSliderValueLabel()
    updateTileSizeSliderValueLabel()
    updateLevelsOfDetailSliderValueLabel()
    updateDetailBiasSliderValueLabel()
    updateZoomScaleSliderValueLabel()
  }
  
  deinit {
    TiledLayer.setFadeDuration(CFTimeInterval(0.25))
  }
  
  // MARK: - IBActions
    
  @IBAction func fadeDurationSliderChanged(_ sender: UISlider) {
    TiledLayer.setFadeDuration(CFTimeInterval(sender.value))
    updateFadeDurationSliderValueLabel()
    tiledLayer.contents = nil
    tiledLayer.setNeedsDisplay(tiledLayer.bounds)
  }
  
  @IBAction func tileSizeSliderChanged(_ sender: UISlider) {
    let value = Int(sender.value)
    tiledLayer.tileSize = CGSize(width: value, height: value)
    updateTileSizeSliderValueLabel()
  }
  
  @IBAction func levelsOfDetailSliderChanged(_ sender: UISlider) {
    tiledLayer.levelsOfDetail = Int(sender.value)
    updateLevelsOfDetailSliderValueLabel()
  }
  
  @IBAction func levelsOfDetailSliderTouchedUp(_ sender: AnyObject) {
    showZoomLabel()
  }
  
  func showZoomLabel() {
    zoomLabel.alpha = 1.0
    zoomLabel.isHidden = false
    let label = zoomLabel
    
    UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
      label?.alpha = 0
      }, completion: { _ in
        label?.isHidden = true
    })
  }
  
  @IBAction func detailBiasSliderChanged(_ sender: UISlider) {
    tiledLayer.levelsOfDetailBias = Int(sender.value)
    updateDetailBiasSliderValueLabel()
  }
  
  @IBAction func detailBiasSliderTouchedUp(_ sender: AnyObject) {
    showZoomLabel()
  }
  
  @IBAction func zoomScaleSliderChanged(_ sender: UISlider) {
    scrollView.zoomScale = CGFloat(sender.value)
    updateZoomScaleSliderValueLabel()
  }
  
  // MARK: - Helpers
  
  func setUpTileImageLayerButton() {
    tiledImageLayerButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "LayerPlayer", size: 23.0)!], for: UIControlState())
  }
  
  func updateFadeDurationSliderValueLabel() {
    fadeDurationSliderValueLabel.text = String(format: "%.2f", adjustableFadeDuration)
  }
  
  func updateTileSizeSliderValueLabel() {
    tileSizeSliderValueLabel.text = "\(Int(tiledLayer.tileSize.width))"
  }
  
  func updateLevelsOfDetailSliderValueLabel() {
    levelsOfDetailSliderValueLabel.text = "\(tiledLayer.levelsOfDetail)"
  }
  
  func updateDetailBiasSliderValueLabel() {
    detailBiasSliderValueLabel.text = "\(tiledLayer.levelsOfDetailBias)"
  }
  
  func updateZoomScaleSliderValueLabel() {
    zoomScaleSliderValueLabel.text = "\(Int(scrollView.zoomScale))"
  }
  
  // MARK: UIScrollViewDelegate
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return viewForTiledLayer
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    zoomScaleSlider.setValue(Float(scrollView.zoomScale), animated: true)
    updateZoomScaleSliderValueLabel()
  }
  
}
