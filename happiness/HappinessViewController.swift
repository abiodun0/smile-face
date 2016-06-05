//
//  HappinessViewController.swift
//  happiness
//
//  Created by Abiodun Shuaib on 18/04/2016.
//  Copyright © 2016 Abiodun Shuaib. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController,FaceViewDataSource {
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.scale(_:))))
        }
    }
    private struct Constants{
        static let HappinessGestureScale:CGFloat = 4
    }
    @IBAction func changeHappiness(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(faceView)
            let happinessChange = Int(translation.y / Constants.HappinessGestureScale)
            print(happinessChange)
            if happinessChange != 0 {
                happiness += happinessChange
                sender.setTranslation(CGPointZero, inView:faceView)

            }
        default: break
        }
    }
    var happiness: Int = 50  { // from 50 to 1000
        didSet{
            happiness = min(max(happiness, 0), 100)
            print("\(happiness)")
            updateUi()
        }
    }
    func updateUi() {
        faceView.setNeedsDisplay()
    }
    func smiliness(sender: FaceView) -> Double? {
        return Double(happiness-50)/50

    }
}
