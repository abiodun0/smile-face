//
//  FaceView.swift
//  happiness
//
//  Created by Abiodun Shuaib on 18/04/2016.
//  Copyright © 2016 Abiodun Shuaib. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class {
    func smiliness(sender: FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView {
    weak var dataSource: FaceViewDataSource?
    @IBInspectable
    var lineWidth:CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var color: UIColor = UIColor.blueColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var smileness:Double = 0.5 {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var scale: CGFloat = 0.9{
        didSet{
            setNeedsDisplay()
        }
    }
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)    }
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio:CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio:CGFloat = 3
        static let FaceRadiusToEyeSeperationRatio:CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio:CGFloat = 1
        static let FaceRadiusToMouthHeightRatio:CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio:CGFloat = 3
    }
    private enum Eye {
        case Left, Right
    }
    private func beizerPathForEye(whichEye: Eye) -> UIBezierPath{
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeperation = faceRadius / Scaling.FaceRadiusToEyeSeperationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeOffset
        switch whichEye{
        case .Left:
            eyeCenter.x -= eyeHorizontalSeperation / 2
        case .Right:
            eyeCenter.x += eyeHorizontalSeperation / 2
            
        }
        let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: CGFloat(eyeRadius), startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        eyePath.lineWidth = lineWidth
        return eyePath
    }
    private func beizerPathForMouth(fractionOfMaxSmile: Double)-> UIBezierPath {
        let mouthWidth = faceRadius / CGFloat(Scaling.FaceRadiusToMouthWidthRatio)
        let mouthHeight = faceRadius / CGFloat(Scaling.FaceRadiusToMouthHeightRatio)
        let mouthVerticalOffset = faceRadius / CGFloat(Scaling.FaceRadiusToMouthOffsetRatio)
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
  
        return path
    }
    func scale(gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed{
            print(gesture.scale)
            scale *= gesture.scale
            print(scale)
            gesture.scale = 1
        }
    }

    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: CGFloat(faceRadius), startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        beizerPathForEye(.Left).stroke()
        beizerPathForEye(.Right).stroke()
        
        let smilenes = dataSource?.smiliness(self) ?? smileness
        let smile = beizerPathForMouth(smilenes)
        smile.lineWidth = lineWidth
        smile.stroke()
    }

}
