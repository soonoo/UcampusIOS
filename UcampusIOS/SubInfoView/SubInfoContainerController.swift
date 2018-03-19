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
    @IBOutlet weak var topTabIndicatorView: UIStackView!
    let board = UIStoryboard(name: "Main", bundle: nil)

    var tabPosition: Int!
    var navBarShadowImage: UIImage!
    var offTabColor: UIColor!
    var lecture: Lecture!
    var controllers = [UIViewController & SubViewControllerWithTable]()
    var currentPositions = [CGFloat]()
    var nextPositions = [CGFloat]()
    var yPosition: CGFloat!
    var prevSender: UIView!
    var prevVelocity: CGFloat!
    var gestureRecognizer: CustomPanGestureRecognizer!
    var rcs = [[UIGestureRecognizer]]()
    var isScrolling = false
    var isViewChanging = false
    var timeAdded = false
    var isSuspended = false

    @objc func pan(sender: CustomPanGestureRecognizer) {
        var translation = sender.translation(in: sender.view!.superview!)
        let state = sender.state
        let velocity = sender.velocity(in: self.view)
        let width = sender.view!.frame.width
        var duration = 0.25
        if isScrolling {
            return
        }

        if state == .began {
            if isViewChanging {
                isSuspended = true
                for case let vc as UIViewController in controllers {
                    vc.view.frame = vc.view.layer.presentation()!.frame
                    vc.view.layer.removeAllAnimations()
                    vc.view.layoutIfNeeded()
                }
            }
        } else if state == .changed {
            if abs(velocity.x) < abs(velocity.y) && !isViewChanging {
                
                // prevent vertical gesture when table is empty
                for vc in controllers {
                    if vc.view.frame.origin.x == 0 && vc.mainTableView.numberOfRows(inSection: 0) == 0 {
                        return
                    }
                }

                view.gestureRecognizers!.removeAll()
                isScrolling = true
                isViewChanging = false
                return
            } else {
                setVisible()
                isScrolling = false
                isViewChanging = true

                for vc in controllers {
                    vc.mainTableView.isUserInteractionEnabled = false
                    vc.mainTableView.gestureRecognizers = []
                }
            }

            if (velocity.x > 0 && controllers[0].view.center.x >= width/2) || (velocity.x < 0 && controllers[controllers.count - 1].view.center.x <= width/2) {
                translation.x *= 0.2
            }

            for controller in controllers {
                controller.view.center = CGPoint(x: controller.view.center.x + translation.x, y: yPosition)
            }
            sender.setTranslation(.zero, in: sender.view!.superview!)
        } else if state == .ended {
            var xDelta = velocity.x > 0 ? width : -width

            if (abs(velocity.x) > 300 || abs(controllers[0].view.center.x - currentPositions[0]) > width/2) {
                if currentPositions[0] + xDelta > width/2 || currentPositions[currentPositions.count - 1] + xDelta < width/2 {
                    xDelta = 0
                }

                nextPositions = currentPositions.map{ $0 + xDelta }
                if abs(controllers[0].view.center.x - nextPositions[0]) > width {
                    duration *= 1.8
                }
                UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction],
                                animations: {
                                    for (index, vc) in self.controllers.enumerated() {
                                        vc.view.center = CGPoint(x: self.nextPositions[index], y: self.yPosition)
                                    }
                                },
                                completion: { (Bool) in
                                    if !self.isSuspended {
                                        self.setSubViewVisibility()
                                        self.setLabelVisibility()
                                    }
                                    self.currentPositions = self.nextPositions

                                    for (index, vc) in self.controllers.enumerated() {
                                        vc.mainTableView.gestureRecognizers = self.rcs[index]
                                        vc.mainTableView.isUserInteractionEnabled = true
                                    }
                                    
                                    for vc in self.controllers {
                                        if vc.view.frame.origin.x == 0 {
                                            self.isViewChanging = false
                                            return
                                        }
                                    }
                                    self.isSuspended = false
                                }
                )
            } else {
                UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction],
                                animations: {
                                    for (index, vc) in self.controllers.enumerated() {
                                        vc.view.center = CGPoint(x: self.currentPositions[index], y: self.yPosition)
                                    }
                                },
                                completion: { (Bool) in
                                    if !self.isSuspended {
                                        self.setSubViewVisibility()
                                        self.setLabelVisibility()
                                    }
                                    
                                    for (index, vc) in self.controllers.enumerated() {
                                        vc.mainTableView.gestureRecognizers = self.rcs[index]
                                        vc.mainTableView.isUserInteractionEnabled = true
                                    }

                                    for vc in self.controllers {
                                        if vc.view.frame.origin.x == 0 {
                                            self.isViewChanging = false
                                            return
                                        }
                                    }

                                    self.isSuspended = false
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

    func setSubViewVisibility() {
        for controller in controllers {
            controller.view.isHidden = controller.view.frame.origin.x == 0 ? false : true
        }
    }
    
    func setVisible() {
        for controller in controllers {
            controller.view.isHidden = false
        }
    }

    func setLabelVisibility() {
        for (index, label) in topTabIndicatorView.subviews.enumerated() {
            (label as! UILabel).textColor = controllers[index].view.frame.origin.x == 0 ? .black : offTabColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = lecture.title

        view.backgroundColor = .white
        nextPositions = [0, 0, 0]

        controllers.append(board.instantiateViewController(withIdentifier: "noticeTableController") as! NoticeViewController)
        controllers.append(board.instantiateViewController(withIdentifier: "lectureReferenceViewController") as! LectureReferenceViewController)

        gestureRecognizer = getRecognizer()
        view.addGestureRecognizer(gestureRecognizer)
        
        var i = -tabPosition
        for vc in controllers {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            view.addSubview(vc.view)
            vc.view.frame = CGRect(x: view.frame.width * CGFloat(i), y: topTabIndicatorView.frame.origin.y + topTabIndicatorView.frame.height, width: view.frame.width, height: view.frame.height - (topTabIndicatorView.frame.origin.y + topTabIndicatorView.frame.height))
            currentPositions.append(vc.view.center.x)
            rcs.append(vc.mainTableView.gestureRecognizers!)
            i += 1
        }
        yPosition = controllers[0].view.center.y

        setSubViewVisibility()
        
        // set tab text color
        offTabColor = (topTabIndicatorView.subviews[tabPosition] as! UILabel).textColor
        (topTabIndicatorView.subviews[tabPosition] as! UILabel).textColor = .black
        topTabIndicatorView.subviews.map {
            $0.backgroundColor = UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // remove navigation bar shadow
        navBarShadowImage = navigationController!.navigationBar.shadowImage
        navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.navigationBar.shadowImage = navBarShadowImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

class CustomPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizerState.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizerState.began
    }
}
