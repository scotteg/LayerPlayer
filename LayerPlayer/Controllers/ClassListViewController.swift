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

class ClassListViewController: UITableViewController {
  
  var classes: [(String, String)] {
    get {
      return [
        ("CALayer", "Manage and animate visual content"),
        ("CAScrollLayer", "Display portion of a scrollable layer"),
        ("CATextLayer", "Render plain text or attributed strings"),
        ("AVPlayerLayer", "Display an AV player "),
        ("CAGradientLayer", "Apply a color gradient over the background"),
        ("CAReplicatorLayer", "Duplicate a source layer"),
        ("CATiledLayer", "Asynchronously draw layer content in tiles"),
        ("CAShapeLayer", "Draw using scalable vector paths"),
        ("CAEAGLLayer", "Draw OpenGL content"),
        ("CATransformLayer", "Draw 3D structures"),
        ("CAEmitterLayer", "Render animated particles")
      ]
    }
  }
  
  var navController: UINavigationController!
  var detailViewController: UIViewController!
  var collapseDetailViewController = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    splitViewController?.delegate = self
  }
  
  // MARK: - UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return classes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell")!
    let row = indexPath.row
    cell.textLabel!.text = classes[row].0
    cell.detailTextLabel!.text = classes[row].1
    cell.imageView!.image = UIImage(named: classes[row].0)
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let identifier = classes[indexPath.row].0
    navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! UINavigationController
    detailViewController = navController.topViewController
    detailViewController?.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
    detailViewController?.navigationItem.leftItemsSupplementBackButton = true
    splitViewController?.showDetailViewController(navController, sender: nil)
    collapseDetailViewController = false
  }
  
}

extension ClassListViewController: UISplitViewControllerDelegate {
  
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    return collapseDetailViewController
  }
  
}

