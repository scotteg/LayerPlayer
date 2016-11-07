//
//  CALayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/10/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CALayerViewController: UIViewController {
  
  // FIXME: Unsatisfiable constraints in compact width, compact height (e.g., iPhone 5 in landscape)
  
  @IBOutlet weak var viewForLayer: UIView!
  
  let layer = CALayer()
  let star = UIImage(named: "star")?.cgImage
  
  // MARK: - Quick reference
  
  func setUpLayer() {
    layer.frame = viewForLayer.bounds
    layer.contents = star
    layer.contentsGravity = kCAGravityCenter
    layer.isGeometryFlipped = false
    layer.cornerRadius = 100.0
    layer.borderWidth = 12.0
    layer.borderColor = UIColor.white.cgColor
    layer.backgroundColor = swiftOrangeColor.cgColor
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "DisplayLayerControls":
        (segue.destination as? CALayerControlsViewController)?.layerViewController = self
      default:
        break
      }
    }
  }
    
}
