// chooseMealViewController.swift
// calCounter
//
// Created by Alex Nosatti on 30/4/2023.

import Foundation
import UIKit

class chooseMealViewController: UIViewController {
    
    @IBOutlet weak var BreakfastButtonImg: UIButton!
    @IBOutlet weak var LunchButtonImg: UIButton!
    @IBOutlet weak var DinnerButtonImg: UIButton!
    @IBOutlet weak var SnacksButtonImg: UIButton!
    
    var selectedMealType: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Configure button title properties
        let buttonArray = [BreakfastButtonImg, LunchButtonImg, DinnerButtonImg, SnacksButtonImg]
        for button in buttonArray {
            button?.setTitleColor(UIColor.white, for: .normal) // Change the text color
            button?.titleLabel?.shadowColor = UIColor.black // Add a text shadow
            button?.titleLabel?.shadowOffset = CGSize(width: -1, height: 1)
            button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // Increase the font size
        }
        
        // Set up button tags
        BreakfastButtonImg.tag = 1
        LunchButtonImg.tag = 2
        DinnerButtonImg.tag = 3
        SnacksButtonImg.tag = 4
        
        // Set up button actions
        BreakfastButtonImg.addTarget(self, action: #selector(mealButtonClicked(_:)), for: .touchUpInside)
        LunchButtonImg.addTarget(self, action: #selector(mealButtonClicked(_:)), for: .touchUpInside)
        DinnerButtonImg.addTarget(self, action: #selector(mealButtonClicked(_:)), for: .touchUpInside)
        SnacksButtonImg.addTarget(self, action: #selector(mealButtonClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func mealButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            selectedMealType = "Breakfast"
        case 2:
            selectedMealType = "Lunch"
        case 3:
            selectedMealType = "Dinner"
        case 4:
            selectedMealType = "Snacks"
        default:
            break
        }
        performSegue(withIdentifier: "segueToAddCaloriesVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddCaloriesVC" {
            let destinationVC = segue.destination as! addCaloriesViewController
            destinationVC.mealType = selectedMealType
        }
    }
}
