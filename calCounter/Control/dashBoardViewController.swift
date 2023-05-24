//
//  ViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//

import Foundation
import UIKit

struct FoodEntry: Codable {
    let foodName: String
    let calories: Int
}

let KEY_FOOD_ENTRIES = "foodEntries"

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
    var newFoodName:String = ""
    var newMealType:String = ""
    var newCalories:Double? = 0
    var lastResetDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calcGoalCalories()
        calculateCurrentCalories()
        
        let percentageCompleted = calcRemainingPct()
        goalCaloriesTxt.text = String(Int(goalCalories))
        currentCaloriesTxt.text = String(Int(currentCalories ?? 0.0))
        remainingCalPctTxt.text = String(percentageCompleted) + "% completed"
        createGraph()
    }
    
    func calcGoalCalories(){
        
        let defaults = UserDefaults.standard
        
        // Retrieve the values from UserDefaults
        let name = defaults.string(forKey: "name")
        let gender = defaults.integer(forKey: "gender")
        let age = defaults.string(forKey: "age")
        let weight = defaults.string(forKey: "weight")
        let height = defaults.string(forKey: "height")
        
        bmrCalc.weightInKilograms = Double(weight ?? "0.0") ?? 0.0
        bmrCalc.heightInCM = Double(height ?? "0.0") ?? 0.0
        bmrCalc.ageInYears = Int(age ?? "0") ?? 0
        bmrCalc.gender = gender
        goalCalories = bmrCalc.calculateBMR()
    }
    
    //calc the remaining % of calories needed to reach its goal daily calorie count
    func calcRemainingPct() -> Int {
        let remainingCalories = max(goalCalories - (currentCalories ?? 0.0), 0)
        percentageCompleted = 100 - Int((remainingCalories / goalCalories) * 100)
        return percentageCompleted
    }
    //
    func addFoodEntry(foodName: String, calories: Int) {
        let defaults = UserDefaults.standard
        var currentEntries = readFoodEntries()
        currentEntries.append(FoodEntry(foodName: foodName, calories: calories))
            
        if let encodedData = try? JSONEncoder().encode(currentEntries) {
            defaults.set(encodedData, forKey: KEY_FOOD_ENTRIES)
        }
    }
    //read food entries from user deafult
    func readFoodEntries() -> [FoodEntry] {
        let defaults = UserDefaults.standard
            
        if let savedData = defaults.data(forKey: KEY_FOOD_ENTRIES),
           let foodEntries = try? JSONDecoder().decode([FoodEntry].self, from: savedData) {
            return foodEntries
        }
        return []
    }
    
    //calculate the current calories by suming up each entry saved in user defaults
    func calculateCurrentCalories() {
        resetCurrentCaloriesIfNeeded()
        let foodEntries = readFoodEntries()
        print(foodEntries);
        var totalCalories = 0
        
        for entry in foodEntries {
            totalCalories += entry.calories
        }
        
        currentCalories = Double(totalCalories)
        currentCaloriesTxt.text = String(currentCalories ?? 0.0)
    }
    // program logs the dailt current calories, therefore needs to reset current calories each day
    func resetCurrentCaloriesIfNeeded() {
        guard let lastResetDate = lastResetDate else { return }
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastResetDate, to: currentDate)
        
        if let daysSinceReset = components.day, daysSinceReset >= 1 {
            // Reset the current calorie count
            currentCalories = 0.0
            
            // Update the reset date to the current date
            self.lastResetDate = currentDate
        }
    }
    //used to create the donut graph. The donut graph is dependent on the percentageCompleted function
    func createGraph(){
        let centerPoint = CGPoint(x: donutGraph.bounds.midX, y: donutGraph.bounds.midY)
        let radius = donutGraph.bounds.width / 3
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
    //animation for the donut graph
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
    
    //used to pass each foodname and calories into Meal History controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mealHistorySegue"{
            let VC = segue.destination as! mealHistoryViewController
            let currentFoodEntries = readFoodEntries()
            for food in currentFoodEntries{
                VC.mealHistory.append(meal(foodName: food.foodName, calorieCount: food.calories ))
            }
            
        }
    }
    //each time thsi controller is viewed, need to calcGoal calories, and calc remainingCalPct
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Recalculate goal calories and update UI
                calcGoalCalories()
                goalCaloriesTxt.text = String(Int(goalCalories))
                let percentageCompleted = calcRemainingPct()
                remainingCalPctTxt.text = String(percentageCompleted) + "% completed"
                updateDonut()
    }
}
