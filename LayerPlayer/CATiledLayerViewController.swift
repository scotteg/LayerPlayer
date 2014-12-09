//
//  CATiledLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/17/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CATiledLayerViewController: UIViewController, UIScrollViewDelegate {
  
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
    return viewForTiledLayer.layer as TiledLayer
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    
  @IBAction func fadeDurationSliderChanged(sender: UISlider) {
    TiledLayer.setFadeDuration(CFTimeInterval(sender.value))
    updateFadeDurationSliderValueLabel()
    tiledLayer.contents = nil
    tiledLayer.setNeedsDisplayInRect(tiledLayer.bounds)
  }
  
  @IBAction func tileSizeSliderChanged(sender: UISlider) {
    let value = Int(sender.value)
    tiledLayer.tileSize = CGSize(width: value, height: value)
    updateTileSizeSliderValueLabel()
  }
  
  @IBAction func levelsOfDetailSliderChanged(sender: UISlider) {
    tiledLayer.levelsOfDetail = UInt(sender.value)
    updateLevelsOfDetailSliderValueLabel()
  }
  
  @IBAction func levelsOfDetailSliderTouchedUp(sender: AnyObject) {
    showZoomLabel()
  }
  
  func showZoomLabel() {
    zoomLabel.alpha = 1.0
    zoomLabel.hidden = false
    let label = zoomLabel
    
    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
      label.alpha = 0
      }, completion: { _ in
        label.hidden = true
    })
  }
  
  @IBAction func detailBiasSliderChanged(sender: UISlider) {
    tiledLayer.levelsOfDetailBias = UInt(sender.value)
    updateDetailBiasSliderValueLabel()
  }
  
  @IBAction func detailBiasSliderTouchedUp(sender: AnyObject) {
    showZoomLabel()
  }
  
  @IBAction func zoomScaleSliderChanged(sender: UISlider) {
    scrollView.zoomScale = CGFloat(sender.value)
    updateZoomScaleSliderValueLabel()
  }
  
  // MARK: - Helpers
  
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
  
  func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
    return viewForTiledLayer
  }
  
  func scrollViewDidZoom(scrollView: UIScrollView!) {
    zoomScaleSlider.setValue(Float(scrollView.zoomScale), animated: true)
    updateZoomScaleSliderValueLabel()
  }
  
}
