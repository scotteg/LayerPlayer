//
//  CATiledImageLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/19/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CATiledImageLayerViewController: UIViewController {
  
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var tilingView: TilingViewForImage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    doneButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "LayerPlayer", size: 23.0)!], for: UIControlState())
    scrollView.contentSize = CGSize(width: 5120, height: 3200)
  }
  
  @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
}
