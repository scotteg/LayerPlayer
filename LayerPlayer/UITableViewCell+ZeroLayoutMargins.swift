//
//  UITableViewCell+ZeroLayoutMargins.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 10/23/15.
//  Copyright © 2015 Scott Gardner. All rights reserved.
//

import UIKit

extension UITableViewCell {
  
  override public var layoutMargins: UIEdgeInsets {
    get { return UIEdgeInsetsZero }
    set { }
  }
  
}
