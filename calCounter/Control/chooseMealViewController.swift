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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addBreakfast(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addCaloriesViewController") as! addCaloriesViewController
        vc.mealType = "Breakfast"
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func addLunch(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addCaloriesViewController") as! addCaloriesViewController
        vc.mealType = "Lunch"
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func addDinner(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addCaloriesViewController") as! addCaloriesViewController
        vc.mealType = "Dinner"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addSnack(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addCaloriesViewController") as! addCaloriesViewController
        vc.mealType = "Snacks"
        navigationController?.pushViewController(vc, animated: true)
    }
}
