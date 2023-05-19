//
//  ViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//

import Foundation
import UIKit

class dashBoardViewController: UIViewController {
    
    @IBOutlet weak var goalCaloriesTxt: UILabel!
    @IBOutlet weak var currentCaloriesTxt: UILabel!
    @IBOutlet weak var remainingCalPctTxt: UILabel!
    @IBOutlet weak var donutGraph: UIView!
    
    var bmrCalc = BMRCalc()
    var weight:Double = 0.0
    var height:Double = 0.0
    var age:Int = 0
    var gender:Int = 0
    var currentCalories:Double? = 0
    var goalCalories: Double = 0
    var percentageCompleted: Int = 0
    let donutLayer = CAShapeLayer()

    var servings: Double?
    var calories: Double?
    var protein: Double?
    var fat: Double?
    var sugar: Double?
    var foodName: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        calcGoalCalories()
        
        if let caloriesToAdd = calories {
              currentCalories = (currentCalories ?? 0) + caloriesToAdd
          }
        
        let percentageCompleted = calcRemainingPct()
        goalCaloriesTxt.text = String(goalCalories)
        currentCaloriesTxt.text = String(currentCalories ?? 0.0)
        remainingCalPctTxt.text = String(percentageCompleted) + "%"
        createGraph()
        

    }
    
    func calcGoalCalories(){
        bmrCalc.weightInKilograms = weight
        bmrCalc.heightInCM = height
        bmrCalc.ageInYears = age
        bmrCalc.gender = gender
        goalCalories = bmrCalc.calculateBMR()
    }
    
    func calcRemainingPct() -> Int {
        let remainingCalories = max(goalCalories - (currentCalories ?? 0.0), 0)
        percentageCompleted = 100 - Int((remainingCalories / goalCalories) * 100)
        return percentageCompleted
    }

    
    func createGraph(){
        let centerPoint = CGPoint(x: donutGraph.bounds.midX, y: donutGraph.bounds.midY)
        let radius = donutGraph.bounds.width / 2
        let lineWidth: CGFloat = 50
        let donutPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius - lineWidth/2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true)
        
        donutLayer.path = donutPath.cgPath
        donutLayer.strokeColor = UIColor(red: 195/255, green: 219/255, blue: 171/255, alpha: 1).cgColor
        donutLayer.fillColor = UIColor.clear.cgColor
        donutLayer.lineWidth = lineWidth
        donutLayer.lineCap = .round
        donutLayer.strokeEnd = 0.0 // initial value, no progress

        donutGraph.layer.addSublayer(donutLayer)
    }
    
    func updateDonut() {
        let progress = Double(percentageCompleted) / 100.0
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.fromValue = 0.0 // start from 0%
        animation.toValue = progress
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        donutLayer.add(animation, forKey: "progress")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDonut()
    }
}

