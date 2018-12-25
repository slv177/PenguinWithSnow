/*
* Copyright (c) 2014-present Razeware LLC
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
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore

class ViewController: UIViewController {
  
    @IBOutlet var penguin: UIImageView!
    @IBOutlet var slideButton: UIButton!
    @IBOutlet weak var planeImage: UIImageView!
    
    
    
    
  
  var isLookingRight: Bool = true {
    didSet {
      let xScale: CGFloat = isLookingRight ? 1 : -1
      penguin.transform = CGAffineTransform(scaleX: xScale, y: 1)
      slideButton.transform = penguin.transform
    }
  }

  var penguinY: CGFloat = 0.0
  
  var walkSize: CGSize = CGSize.zero
  var slideSize: CGSize = CGSize.zero
  
  let animationDuration = 1.0
  
  var walkFrames = [
    UIImage(named: "walk01.png")!,
    UIImage(named: "walk02.png")!,
    UIImage(named: "walk03.png")!,
    UIImage(named: "walk04.png")!
  ]
  
  var slideFrames = [
    UIImage(named: "slide01.png")!,
    UIImage(named: "slide02.png")!,
    UIImage(named: "slide01.png")!
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    planeDepart()

    //grab the sizes of the different sequences
    walkSize = walkFrames[0].size
    print(walkSize)
    slideSize = slideFrames[0].size
    
    //setup the animation
    penguinY = penguin.frame.origin.y

    loadWalkAnimation()
    
    let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width, height: 50.0)
    let emitter = CAEmitterLayer()
    emitter.frame = rect
    view.layer.addSublayer(emitter)
    
    emitter.emitterShape = kCAEmitterLayerRectangle
    
    emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
    emitter.emitterSize = rect.size
    
    let emitterCell = CAEmitterCell()
    emitterCell.contents = UIImage(named: "flake.png")?.cgImage
    emitterCell.birthRate = 20
    emitterCell.lifetime = 3.5
    emitter.emitterCells = [emitterCell]
    emitterCell.yAcceleration = 70.0
    emitterCell.xAcceleration = 10.0
    emitterCell.velocity = 20.0
    emitterCell.emissionLongitude = .pi * -0.5
    emitterCell.velocityRange = 200.0
    emitterCell.emissionRange = .pi * 0.5
    emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    emitterCell.redRange   = 0.1
    emitterCell.greenRange = 0.1
    emitterCell.blueRange  = 0.1
    emitterCell.scale = 0.8
    emitterCell.scaleRange = 0.8
    emitterCell.scaleSpeed = -0.15
    emitterCell.birthRate = 150
    emitterCell.alphaRange = 0.75
    emitterCell.alphaSpeed = -0.15
    emitterCell.emissionLongitude = -.pi
    emitterCell.lifetimeRange = 1.0
    
    //cell #2
    let cell2 = CAEmitterCell()
    cell2.contents = UIImage(named: "flake2.png")?.cgImage
    cell2.birthRate = 50
    cell2.lifetime = 2.5
    cell2.lifetimeRange = 1.0
    cell2.yAcceleration = 50
    cell2.xAcceleration = 50
    cell2.velocity = 80
    cell2.emissionLongitude = .pi
    cell2.velocityRange = 20
    cell2.emissionRange = .pi * 0.25
    cell2.scale = 0.8
    cell2.scaleRange = 0.2
    cell2.scaleSpeed = -0.1
    cell2.alphaRange = 0.35
    cell2.alphaSpeed = -0.15
    cell2.spin = .pi
    cell2.spinRange = .pi
    
    //cell #3
    let cell3 = CAEmitterCell()
    cell3.contents = UIImage(named: "flake3.png")?.cgImage
    cell3.birthRate = 20
    cell3.lifetime = 7.5
    cell3.lifetimeRange = 1.0
    cell3.yAcceleration = 20
    cell3.xAcceleration = 10
    cell3.velocity = 40
    cell3.emissionLongitude = .pi
    cell3.velocityRange = 50
    cell3.emissionRange = .pi * 0.25
    cell3.scale = 0.8
    cell3.scaleRange = 0.2
    cell3.scaleSpeed = -0.05
    cell3.alphaRange = 0.5
    cell3.alphaSpeed = -0.05
    
    emitter.emitterCells = [emitterCell, cell2, cell3]
  }
  
  func loadWalkAnimation() {
    penguin.animationImages = walkFrames
    penguin.animationDuration = animationDuration / 3
    penguin.animationRepeatCount = 3
  }
  
  func loadSlideAnimation() {
    penguin.animationImages = slideFrames
    penguin.animationDuration = animationDuration
    penguin.animationRepeatCount = 1
  }
  
  @IBAction func actionLeft(_ sender: AnyObject) {
    isLookingRight = false
    penguin.startAnimating()

    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
      self.penguin.center.x -= self.walkSize.width
    }, completion: nil)
  }
  
  @IBAction func actionRight(_ sender: AnyObject) {
    isLookingRight = true
    penguin.startAnimating()

    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
      self.penguin.center.x += self.walkSize.width
    }, completion: nil)
  }
  
  @IBAction func actionSlide(_ sender: AnyObject) {
    loadSlideAnimation()
    penguin.frame = CGRect(
      x: penguin.frame.origin.x,
      y: penguinY + (walkSize.height - slideSize.height),
      width: slideSize.width,
      height: slideSize.height)
    penguin.startAnimating()
    UIView.animate(withDuration: animationDuration - 0.02, delay: 0.0, options: .curveEaseOut, animations: {
      self.penguin.center.x += self.isLookingRight ? self.slideSize.width : -self.slideSize.width
    }, completion: { _ in
      self.penguin.frame = CGRect(
        x: self.penguin.frame.origin.x,
        y: self.penguinY,
        width: self.walkSize.width,
        height: self.walkSize.height)
      self.loadWalkAnimation()
    })
  }
    
  func planeDepart() {
    let originalCenter = planeImage.center

    UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, animations: {
      //add keyframes
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
        self.planeImage.center.x += 180.0
        self.planeImage.center.y -= 10.0
      })

      UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
        self.planeImage.transform = CGAffineTransform(rotationAngle: -.pi / 8)
      }

      UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
        self.planeImage.center.x += 300.0
        self.planeImage.center.y -= 50.0
        self.planeImage.alpha = 0.0
      }

      UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01) {
        self.planeImage.transform = .identity
        self.planeImage.center = CGPoint(x: 0.0, y: originalCenter.y)
      }

      UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45) {
        self.planeImage.alpha = 1.0
        self.planeImage.center = originalCenter
      }
    }, completion: nil)
  }

    
}

