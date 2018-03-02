//
//  SubInfoContainerController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 27..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class SubInfoContainerController: UIViewController, UIGestureRecognizerDelegate {
    let board = UIStoryboard(name: "Main", bundle: nil)
    var vc: NoticeViewController!
    var vc2: NoticeViewController!
    var vc3: NoticeViewController!
    var controllers = [UIView]()
    var currentPositions = [CGFloat]()
    var nextPositions = [CGFloat]()
    var yPosition: CGFloat!
    var prevSender: UIView!
    var prevVelocity: CGFloat!
    var isSuspended = false
    var g1, g2, g3: CustomPanGestureRecognizer!
    var rcs = [UIGestureRecognizer]()
    var rcs2 = [UIGestureRecognizer]()
    var rcs3 = [UIGestureRecognizer]()
    var isScrolling = false
    var isViewChanging = false
    
    @objc func pan(sender: CustomPanGestureRecognizer) {
        var translation = sender.translation(in: sender.view!.superview!)
        let state = sender.state
        let velocity = sender.velocity(in: self.view)
        let width = sender.view!.frame.size.width
        var duration = 0.18
        isSuspended = false

        if isScrolling {
            return
        }

        print(velocity)
        if state == .began {
            print("began")
            duration = 0.18
            isSuspended = true
            setVisibile()
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
            print("changed")

            if abs(velocity.x) < abs(velocity.y) && !isViewChanging {
                view.gestureRecognizers!.removeAll()
                isScrolling = true
                return
            } else {
                isScrolling = false
                isViewChanging = true
                vc2.noticeTableView.gestureRecognizers = []
                vc.noticeTableView.gestureRecognizers = []
                vc3.noticeTableView.gestureRecognizers = []
            }

            if (velocity.x > 0 && vc.view.center.x > width/2) || (velocity.x < 0 && vc3.view.center.x < width/2) {
                translation.x *= 0.3
            }

            vc.view.center = CGPoint(x: vc.view.center.x + translation.x, y: yPosition)
            vc2.view.center = CGPoint(x: vc2.view.center.x + translation.x, y: yPosition)
            vc3.view.center = CGPoint(x: vc3.view.center.x + translation.x, y: yPosition)
            sender.setTranslation(.zero, in: sender.view!.superview!)
        } else if state == .ended {
            print("ended")
            var xDelta = velocity.x > 0 ? width : -width
            
            let isSideView = (sender.view! == vc.view && sender.view!.center.x >= width/2) || (sender.view! == vc3.view && sender.view!.center.x <= width/2)

            if ((abs(velocity.x) > 300) || (sender.view!.center.x >= width) || (sender.view!.center.x <= 0)) && !isSideView {
                if currentPositions[0] + xDelta > width/2 || currentPositions[2] + xDelta < width/2 {
                    xDelta = 0
                }
                if (prevSender == sender.view!) && (velocity.x*prevVelocity > 0)  {
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
                                    self.isSuspended ? () : self.setVisibility()
                                    self.isViewChanging = false
                                    self.vc2.noticeTableView.gestureRecognizers = self.rcs
                                    self.vc.noticeTableView.gestureRecognizers = self.rcs2
                                    self.vc3.noticeTableView.gestureRecognizers = self.rcs3
                                }
                )
            } else {
                UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction],
                                animations: {
                                    self.vc.view.center = CGPoint(x: self.currentPositions[0], y: self.yPosition)
                                    self.vc2.view.center = CGPoint(x: self.currentPositions[1], y: self.yPosition)
                                    self.vc3.view.center = CGPoint(x: self.currentPositions[2], y: self.yPosition)
                                },
                                completion: { (Bool) in
                                    self.isSuspended ? () : self.setVisibility()
                                    self.isViewChanging = false
                                    self.vc2.noticeTableView.gestureRecognizers = self.rcs
                                    self.vc.noticeTableView.gestureRecognizers = self.rcs2
                                    self.vc3.noticeTableView.gestureRecognizers = self.rcs3
                                }
                )
            }
            prevSender = sender.view!
            prevVelocity = velocity.x
        }
    }

    func getRecognizer() -> CustomPanGestureRecognizer {
        let recognizer = CustomPanGestureRecognizer (target: self, action: #selector(pan))
        recognizer.cancelsTouchesInView = false
        recognizer.delegate = self
        return recognizer
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func setVisibility() {
        for view in controllers {
            view.isHidden = view.frame.origin.x == 0 ? false : true
        }
    }
    
    func setVisibile() {
        for view in controllers {
            view.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        vc2 = board.instantiateViewController(withIdentifier: "noticeTableController") as! NoticeViewController
        vc = board.instantiateViewController(withIdentifier: "noticeTableController") as! NoticeViewController
        vc3 = board.instantiateViewController(withIdentifier: "noticeTableController") as! NoticeViewController
        controllers = [vc.view, vc2.view, vc3.view]

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

        g1 = getRecognizer()
        view.addGestureRecognizer(g1)
        
        currentPositions.append(vc.view.center.x)
        currentPositions.append(vc2.view.center.x)
        currentPositions.append(vc3.view.center.x)
        nextPositions = [0, 0, 0]
        vc2.noticeTableView.isExclusiveTouch = true
        setVisibility()
        self.view.addSubview(vc.view)
        self.view.addSubview(vc2.view)
        self.view.addSubview(vc3.view)
        rcs = vc2.noticeTableView.gestureRecognizers!
        rcs2 = vc.noticeTableView.gestureRecognizers!
        rcs3 = vc3.noticeTableView.gestureRecognizers!
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
