//
//  SubInfoContainerController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 27..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class SubInfoContainerController: UIViewController {
    let board = UIStoryboard(name: "Main", bundle: nil)
    var vc: UIViewController!
    var vc2: UIViewController!
    var vc3: UIViewController!
    var currentPositions = [CGFloat]()
    var nextPositions = [CGFloat]()
    var yPosition: CGFloat!
    var prevSender: UIView!
    var prevVelocity: CGFloat!

    @objc func pan(sender: CustomPanGestureRecognizer) {
        var xTranslation = sender.translation(in: sender.view!.superview!).x
        let state = sender.state
        let velocity = sender.velocity(in: self.view).x
        let width = sender.view!.frame.size.width
        var duration = 0.23
        
        if state == .began {
            duration = 0.23
            vc.view.frame = vc.view.layer.presentation()!.frame
            vc2.view.frame = vc2.view.layer.presentation()!.frame
            vc3.view.frame = vc3.view.layer.presentation()!.frame
            
            vc.view.layer.removeAllAnimations()
            vc2.view.layer.removeAllAnimations()
            vc3.view.layer.removeAllAnimations()
            
            vc.view.layoutIfNeeded()
            vc2.view.layoutIfNeeded()
            vc3.view.layoutIfNeeded()
        } else if state == .changed {
            if (velocity > 0 && vc.view.center.x > width/2) || (velocity < 0 && vc3.view.center.x < width/2) {
                xTranslation *= 0.3
            }

            vc.view.center = CGPoint(x: vc.view.center.x + xTranslation, y: yPosition)
            vc2.view.center = CGPoint(x: vc2.view.center.x + xTranslation, y: yPosition)
            vc3.view.center = CGPoint(x: vc3.view.center.x + xTranslation, y: yPosition)
            sender.setTranslation(.zero, in: sender.view!.superview!)
        } else if state == .ended {
            var xDelta = velocity > 0 ? width : -width
            
            let isSideView = (sender.view! == vc.view && sender.view!.center.x >= width/2) || (sender.view! == vc3.view && sender.view!.center.x <= width/2)

            if ((abs(velocity) > 200) || (sender.view!.center.x >= width) || (sender.view!.center.x <= 0)) && !isSideView {
                if currentPositions[0] + xDelta > width/2 || currentPositions[2] + xDelta < width/2 {
                    xDelta = 0
                }
                if (prevSender == sender.view!) && (velocity*prevVelocity > 0)  {
                    duration *= 2
                }
                nextPositions[0] = currentPositions[0] + xDelta
                nextPositions[1] = currentPositions[1] + xDelta
                nextPositions[2] = currentPositions[2] + xDelta
                UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction],
                                animations: {
                                    self.vc.view.center = CGPoint(x: self.nextPositions[0], y: self.yPosition)
                                    self.vc2.view.center = CGPoint(x: self.nextPositions[1], y: self.yPosition)
                                    self.vc3.view.center = CGPoint(x: self.nextPositions[2], y: self.yPosition)
                                },
                                completion: { (Bool) in
                                    self.currentPositions = self.nextPositions
                                }
                )
            } else {
                UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction],
                                    animations: {
                                        self.vc.view.center = CGPoint(x: self.currentPositions[0], y: self.yPosition)
                                        self.vc2.view.center = CGPoint(x: self.currentPositions[1], y: self.yPosition)
                                        self.vc3.view.center = CGPoint(x: self.currentPositions[2], y: self.yPosition)
                                    },
                                    completion: nil
                )
            }
            prevSender = sender.view!
            prevVelocity = velocity
        }
    }

    func getRecognizer() -> CustomPanGestureRecognizer {
        let recognizer = CustomPanGestureRecognizer (target: self, action: #selector(pan))
        recognizer.cancelsTouchesInView = true
        return recognizer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        vc = board.instantiateViewController(withIdentifier: "test")
        vc2 = board.instantiateViewController(withIdentifier: "test2")
        vc3 = board.instantiateViewController(withIdentifier: "test3")
        
        self.addChildViewController(vc)
        self.addChildViewController(vc2)
        self.addChildViewController(vc3)

        vc.didMove(toParentViewController: self)
        vc2.didMove(toParentViewController: self)
        vc3.didMove(toParentViewController: self)

        let baseFrame = vc2.view.frame.size
        vc.view.frame = CGRect(x: -baseFrame.width, y: 0, width: baseFrame.width, height: baseFrame.height)
        vc3.view.frame = CGRect(x: baseFrame.width, y: 0, width: baseFrame.width, height: baseFrame.height)
        yPosition = vc.view.center.y
        
//        vc.view.addGestureRecognizer(getTapHandler())
//        vc2.view.addGestureRecognizer(getTapHandler())
//        vc3.view.addGestureRecognizer(getTapHandler())

        vc.view.addGestureRecognizer(getRecognizer())
        vc2.view.addGestureRecognizer(getRecognizer())
        vc3.view.addGestureRecognizer(getRecognizer())
        
        currentPositions.append(vc.view.center.x)
        currentPositions.append(vc2.view.center.x)
        currentPositions.append(vc3.view.center.x)
        nextPositions = [0, 0, 0]

        self.view.addSubview(vc.view)
        self.view.addSubview(vc2.view)
        self.view.addSubview(vc3.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class CustomPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizerState.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizerState.began
    }
}
