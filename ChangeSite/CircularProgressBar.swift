//
//  CircularProgressBar.swift
//  ChangeSite3
//
//  Created by Emily Mittleman on 1/3/20.
//  Copyright © 2020 Emily Mittleman. All rights reserved.
//

import Foundation
import UIKit

class CircularProgressBar: UIView {
    
    var reminder = ( try? PropertyListDecoder().decode(PumpSite.self, from: UserDefaults.standard.object(forKey: "reminder") as! Data) )!
    
    //MARK: awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        label.text = "0"
    }
    
    
    //MARK: Public
    
    public var lineWidth:CGFloat = 50 {
        didSet{
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }
    
    public var labelSize: CGFloat = 20 {
        didSet {
            label.font = UIFont(name: labelFont, size: labelSize)
            //label.sizeToFit()
            label.adjustsFontSizeToFitWidth = true
            configLabel()
        }
    }
    
    public var labelFont: String = "DINAlternate-Bold" {
        didSet {
            label.font = UIFont(name: labelFont, size: labelSize)
            //label.sizeToFit()
            label.adjustsFontSizeToFitWidth = true
            configLabel()
        }
    }
    
    public var safePercent: Int = 100 {
        didSet{
            setForegroundLayerColorForSafePercent()
        }
    }
    
    public var wholeCircleAnimationDuration: Double = 2
    
    public var lineBackgroundColor: UIColor = .gray
    public var lineColor: UIColor = UIColor.teal
    public var lineFinishColor: UIColor = .red
    
    
    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        
        let animationDuration = wholeCircleAnimationDuration * progress
        
        foregroundLayer.strokeEnd = CGFloat(progress)
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = animationDuration
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
            
        }
        
        var currentTime:Double = 0
        //print(progress)
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            if currentTime >= animationDuration {
                timer.invalidate()
            } else {
                currentTime += 0.01
                //let percent = currentTime/self.wholeCircleAnimationDuration * 100
                //print(percent)
                //self.label.text = "\(Int(percent))"
                if((currentTime/self.wholeCircleAnimationDuration * 100) >= Double(self.safePercent)) {
                    self.setForegroundLayerColorForSafePercent()
                }
                //self.configLabel()
            }
        }
        timer.fire()
        
    }
    
    public var days: String = "0"
    public var hours: String = "0"
    public var minutes: String = "0"
    
    public func setLabelText(days: String, hours: String, minutes: String) {
        self.days = days
        self.hours = hours
        self.minutes = minutes
        
        label = makeLabel(days: days, hours: hours, minutes: minutes)
        label.adjustsFontSizeToFitWidth = true
        
        //layoutDone = false
        self.setupView()
        
        configLabel()
    }
    
    
    
    
    //MARK: Private -----------------------------------------------------------------
    private var label = UILabel()
    private var labelDays = UILabel()
    private var labelHours = UILabel()
    private var labelMinutes = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth)/2 }
        }
    }
    
    private var pathCenter: CGPoint{
        get{ return self.convert(self.center, from:self.superview) }
    }
    
    private func makeBar(){
        self.layer.sublayers = nil
        drawBackgroundLayer()
        drawForegroundLayer()
    }
    
    private func drawBackgroundLayer(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.strokeColor = lineBackgroundColor.cgColor
        self.backgroundLayer.lineWidth = lineWidth - (lineWidth * 20/100)
        self.backgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayer)
        
    }
    
    private func drawForegroundLayer(){
        
        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = lineColor.cgColor
        foregroundLayer.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayer)
        
    }
    
    private func makeLabel(days: String, hours: String, minutes: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        var labelString: String = days
        if(days == "1") { labelString += " Day\n" + hours }
        else { labelString += " Days\n" + hours }
        if(hours == "1") { labelString += " Hour\n" + minutes }
        else { labelString += " Hours\n" + minutes }
        if(minutes == "1") { labelString += " Minute" }
        else { labelString += " Minutes" }
        // add OVERDUE
        if(reminder.overdue) {
            labelString += "\n" + "OVERDUE"
        }
        
        label.text = labelString
        label.font = UIFont(name: labelFont, size: 35)
        label.adjustsFontSizeToFitWidth = true
        label.center = pathCenter
        label.textAlignment = .center
        
        let maximumLabelSize = CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let expectSize = sizeThatFits(maximumLabelSize)
        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: expectSize.width, height: expectSize.height)
        
        let myString: String = label.text!
        
        var proportion: CGFloat = 0.4968559451219512
        if(reminder.overdue) {
            proportion = 0.6
        }
        let newHeight: CGFloat = proportion * radius * 2
        
        var size: CGSize = myString.size(withAttributes: [.font: UIFont(name: "DINAlternate-Bold", size: 35)!])
        var fontSize: CGFloat = 35
        while(size.height > newHeight) {
            fontSize -= 0.5
            size = myString.size(withAttributes: [.font: UIFont(name: "DINAlternate-Bold", size: fontSize)!])
        }
        label.font = UIFont(name: labelFont, size: fontSize)
        
        return label
    }
    
    private func configLabel() {
        label.center = pathCenter
    }
    
    private func setForegroundLayerColorForSafePercent(){
        self.foregroundLayer.strokeColor = lineFinishColor.cgColor
    }
    
    private func setupView() {
        makeBar()
        self.addSubview(label)
    }
    
    
    
    //Layout Sublayers

    public var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
        }
    }
    
}
