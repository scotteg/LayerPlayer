//
//  Array+SortUIViewsInPlaceByTag.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 10/21/15.
//  Copyright © 2015 Scott Gardner. All rights reserved.
//

import UIKit

extension Array where Element: UIView {
  
  /**
   Sorts an array of UIViews or subclasses by tag. For example, this is useful when working with `IBOutletCollection`s, whose order of elements can be changed when manipulating the view objects in Interface Builder. Just tag your views in Interface Builder and then call this method on your `IBOutletCollection`s in `viewDidLoad()`.
   - author: Scott Gardner
   - seealso:
   * [Source on GitHub](http://bit.ly/SortUIViewsInPlaceByTag)
   */
  mutating func sortUIViewsInPlaceByTag() {
    sort { (left: Element, right: Element) in
      left.tag < right.tag
    }
  }
  
}
