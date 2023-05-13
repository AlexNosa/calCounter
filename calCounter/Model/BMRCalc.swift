//
//  calorieCalculator.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//
//    Info on BMR formula is from https://www.garnethealth.org/news/basal-metabolic-rate-calculator#:~:text=Calculate%20Basal%20Metabolic%20Rate&text=Your%20basal%20metabolism%20rate%20is,4.330%20x%20age%20in%20years)

import Foundation
import UIKit

class BMRCalc{
    var weightInKilograms: Double = 0.0
    var heightInCM: Double = 0.0
    var ageInYears: Int = 0
    var gender:Int = 0
    
    func calculateBMR() -> Int {
        var bmr = 0.0
        var weightCalc = 0.0
        var heightCalc = 0.0
        var ageCalc = 0.0
        
        if gender == 1 { // gender is female
            weightCalc = 9.247 * weightInKilograms
            heightCalc = 3.098 * heightInCM
            ageCalc = 4.330 * Double(ageInYears)
            
            bmr = 447.593 + weightCalc + heightCalc - ageCalc
            
        }else{ // gender is male
            weightCalc = 13.397 * weightInKilograms
            heightCalc = 4.799 * heightInCM
            ageCalc = 5.677 * Double(ageInYears)
            
            bmr = 88.362 + weightCalc + heightCalc - ageCalc
        }
        return Int(bmr)
    }
}
