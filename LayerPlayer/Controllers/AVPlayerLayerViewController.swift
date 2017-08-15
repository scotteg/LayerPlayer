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
import AVFoundation

class AVPlayerLayerViewController: UIViewController {
  
  @IBOutlet weak var viewForPlayerLayer: UIView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var rateSegmentedControl: UISegmentedControl!
  @IBOutlet weak var loopSwitch: UISwitch!
  @IBOutlet weak var volumeSlider: UISlider!
  
  enum Rate: Int {
    case slowForward, normal, fastForward
  }
    
  let playerLayer = AVPlayerLayer()
  var player: AVPlayer {
    return playerLayer.player!
  }
  var rateBeforePause: Float?
  var shouldLoop = true
  var isPlaying = false
  
  // MARK: - Quick reference
  
  func setUpPlayerLayer() {
    playerLayer.frame = viewForPlayerLayer.bounds
    let url = Bundle.main.url(forResource: "colorfulStreak", withExtension: "m4v")!
    let player = AVPlayer(url: url)
    player.actionAtItemEnd = .none
    playerLayer.player = player
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpPlayerLayer()
    viewForPlayerLayer.layer.addSublayer(playerLayer)
    NotificationCenter.default.addObserver(self, selector: #selector(AVPlayerLayerViewController.playerDidReachEndNotificationHandler(_:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - IBActions
  
  @IBAction func playButtonTapped(_ sender: UIButton) {
    play()
  }
  
  @IBAction func rateSegmentedControlChanged(_ sender: UISegmentedControl) {
    var rate: Float!
    
    switch sender.selectedSegmentIndex {
    case Rate.slowForward.rawValue:
      rate = 0.5
    case Rate.fastForward.rawValue:
      rate = 2.0
    default:
      rate = 1.0
    }
    
    player.rate = rate
    isPlaying = true
    rateBeforePause = rate
    updatePlayButtonTitle()
  }
  
  @IBAction func loopSwitchChanged(_ sender: UISwitch) {
    shouldLoop = sender.isOn
    
    if shouldLoop {
      player.actionAtItemEnd = .none
    } else {
      player.actionAtItemEnd = .pause
    }
  }
  
  @IBAction func volumeSliderChanged(_ sender: UISlider) {
    player.volume = sender.value
  }
  
  // MARK: - Triggered actions
  
  func play() {
    if playButton.titleLabel?.text == "Play" {
      if let resumeRate = rateBeforePause {
        player.rate = resumeRate
      } else {
        player.play()
      }
      
      isPlaying = true
    } else {
      rateBeforePause = player.rate
      player.pause()
      isPlaying = false
    }
    
    updatePlayButtonTitle()
    updateRateSegmentedControl()
  }
  
    @objc func playerDidReachEndNotificationHandler(_ notification: Notification) {
    guard let playerItem = notification.object as? AVPlayerItem else { return }
    playerItem.seek(to: kCMTimeZero, completionHandler: nil)
    
    if shouldLoop == false {
      player.pause()
      isPlaying = false
      updatePlayButtonTitle()
      updateRateSegmentedControl()
    }
  }
  
  // MARK: - Helpers
  
  func updatePlayButtonTitle() {
    if isPlaying {
      playButton.setTitle("Pause", for: UIControlState())
    } else {
      playButton.setTitle("Play", for: UIControlState())
    }
  }
  
  func updateRateSegmentedControl() {
    if isPlaying {
      switch player.rate {
      case 0.5:
        rateSegmentedControl.selectedSegmentIndex = Rate.slowForward.rawValue
      case 1.0:
        rateSegmentedControl.selectedSegmentIndex = Rate.normal.rawValue
      case 2.0:
        rateSegmentedControl.selectedSegmentIndex = Rate.fastForward.rawValue
      default:
        break
      }
    } else {
      rateSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    }
  }
  
}
