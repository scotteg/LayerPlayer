//
//  CALayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/10/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CALayerViewController: UIViewController {
  
  @IBOutlet weak var viewForLayer: UIView!
  
  let layer = CALayer()
  let star = UIImage(named: "star")?.CGImage
  
  // MARK: - Quick reference
  
  func setUpLayer() {
    layer.frame = viewForLayer.bounds
    layer.contents = star
    layer.contentsGravity = kCAGravityCenter
    layer.geometryFlipped = false
    layer.cornerRadius = 100.0
    layer.borderWidth = 12.0
    layer.borderColor = UIColor.whiteColor().CGColor
    layer.backgroundColor = UIColor(red: 11/255.0, green: 86/255.0, blue: 14/255.0, alpha: 1.0).CGColor
    layer.shadowOpacity = 0.75
    layer.shadowOffset = CGSize(width: 0, height: 3)
    layer.shadowRadius = 3.0
    layer.magnificationFilter = kCAFilterLinear
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayer()
    viewForLayer.layer.addSublayer(layer)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "DisplayLayerControls":
        let controller = segue.destinationViewController as CALayerControlsViewController
        controller.layerViewController = self
      default:
        break
      }
    }
  }
    
}
