//  chooseMealViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//

import Foundation
import UIKit

class chooseMealViewController: UIViewController {
    
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var snackButton: UIButton!
    
    var selectedMealType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure button title properties
        let buttonArray = [breakfastButton, lunchButton, dinnerButton, snackButton]
        
        // Set up button tags
        breakfastButton.tag = 1
        lunchButton.tag = 2
        dinnerButton.tag = 3
        snackButton.tag = 4
        
        // Set up button actions
        breakfastButton.addTarget(self, action: #selector(mealButtonClicked(_:)), for: .touchUpInside)
        lunchButton.addTarget(self, action: #selector(mealButtonClicked(_:)), for: .touchUpInside)
        dinnerButton.addTarget(self, action: #selector(mealButtonClicked(_:)), for: .touchUpInside)
        snackButton.addTarget(self, action: #selector(mealButtonClicked(_:)), for: .touchUpInside)
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
    // send data to the addCaloriesViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddCaloriesVC" {
            let destinationVC = segue.destination as! addCaloriesViewController
            destinationVC.mealType = selectedMealType
        }
    }
    // if breakfast button pressed....
    @IBAction func addBreakfast(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addCaloriesViewController") as! addCaloriesViewController
        vc.mealType = "Breakfast"
        navigationController?.pushViewController(vc, animated: true)
    }
    // if lunch button pressed....
    @IBAction func addLunch(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addCaloriesViewController") as! addCaloriesViewController
        vc.mealType = "Lunch"
        navigationController?.pushViewController(vc, animated: true)
    }
    // if dinner button pressed....
    @IBAction func addDinner(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addCaloriesViewController") as! addCaloriesViewController
        vc.mealType = "Dinner"
        navigationController?.pushViewController(vc, animated: true)
    }
    // if snack button pressed....
    @IBAction func addSnack(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addCaloriesViewController") as! addCaloriesViewController
        vc.mealType = "Snacks"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
