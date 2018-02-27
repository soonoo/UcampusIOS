//
//  SubInfoContainerController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 27..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class SubInfoContainerController: UIViewController {
    let board = UIStoryboard(name: "Main", bundle: nil)
    var vc: UIViewController!
    var vc2: UIViewController!
    var vc3: UIViewController!
    var currentPosition: CGFloat!
    var positions = [CGFloat]()

    var viewControllers = [UIViewController]()

    var gestureRecognizer: UIPanGestureRecognizer!

    @objc func pan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!.superview!)
        let state = sender.state
        if state == .began {
            currentPosition = sender.view!.center.x
        }
        
        if state == .began || state == .changed {
            let yPosition = sender.view!.center.y
            let viewWidth = sender.view!.frame.size.width

            let xDelta = (vc.view.frame.origin.x >= 0 || vc3.view.frame.origin.x <= 0) ? translation.x * 0.4 : translation.x
            
            self.vc.view.center = CGPoint(x: self.vc.view.center.x + xDelta, y: yPosition)
            self.vc2.view.center = CGPoint(x: self.vc.view.center.x + viewWidth, y: yPosition)
            self.vc3.view.center = CGPoint(x: self.vc.view.center.x + viewWidth*2, y: yPosition)
            sender.setTranslation(.zero, in: self.view)
        }
        
        if sender.state == .ended {
            print(vc.view.frame.origin.x)
            print(translation.x)
            
            let velocity = sender.velocity(in: self.view).x
            let divider = velocity > 0 ? sender.view!.frame.width - sender.view!.frame.origin.x : sender.view!.frame.origin.x
            let duration = abs(velocity) / divider
            
            if vc.view.frame.origin.x >= 0 || vc3.view.frame.origin.x <= 0 {
                UIView.animate(withDuration: 0.33, animations: {
                    let yPosition = sender.view!.center.y
                    self.vc.view.center = CGPoint(x: self.positions[0], y: yPosition)
                    self.vc2.view.center = CGPoint(x: self.positions[1], y: yPosition)
                    self.vc3.view.center = CGPoint(x: self.positions[2], y: yPosition)
                }, completion: { Bool in
                    self.positions[0] = self.vc.view.center.x
                    self.positions[1] = self.vc2.view.center.x
                    self.positions[2] = self.vc3.view.center.x
                })
                return
            }

            if abs(velocity) > 300 {
                UIView.animate(withDuration: 0.33, animations: {
                    let yPosition = sender.view!.center.y
                    let viewWidth = velocity > 0 ? sender.view!.frame.size.width : -sender.view!.frame.size.width
                    self.vc.view.center = CGPoint(x: self.positions[0] + viewWidth, y: yPosition)
                    self.vc2.view.center = CGPoint(x: self.positions[1] + viewWidth,    y: yPosition)
                    self.vc3.view.center = CGPoint(x: self.positions[2] + viewWidth,  y: yPosition)
                }, completion: { Bool in
                    self.positions[0] = self.vc.view.center.x
                    self.positions[1] = self.vc2.view.center.x
                    self.positions[2] = self.vc3.view.center.x
                })
            } else {
                UIView.animate(withDuration: 0.33, animations: {
                    let yPosition = sender.view!.center.y
                    self.vc.view.center = CGPoint(x: self.positions[0], y: yPosition)
                    self.vc2.view.center = CGPoint(x: self.positions[1], y: yPosition)
                    self.vc3.view.center = CGPoint(x: self.positions[2], y: yPosition)
                }, completion: { Bool in
                    self.positions[0] = self.vc.view.center.x
                    self.positions[1] = self.vc2.view.center.x
                    self.positions[2] = self.vc3.view.center.x
                })
            }
        }
    }

    func getRecognizer() -> UIPanGestureRecognizer {
        return UIPanGestureRecognizer (target: self, action: #selector(pan))
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

        vc.view.addGestureRecognizer(getRecognizer())
        vc2.view.addGestureRecognizer(getRecognizer())
        vc3.view.addGestureRecognizer(getRecognizer())
        
        positions.append(vc.view.center.x)
        positions.append(vc2.view.center.x)
        positions.append(vc3.view.center.x)

        self.view.addSubview(vc.view)
        self.view.addSubview(vc2.view)
        self.view.addSubview(vc3.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
