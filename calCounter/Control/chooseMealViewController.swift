//  chooseMealViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//

import Foundation
import UIKit

class chooseMealViewController: UIViewController {
    
    @IBOutlet weak var BreakfastButtonImg: UIButton!
    @IBOutlet weak var LunchButtonImg: UIButton!
    @IBOutlet weak var DinnerButtonImg: UIButton!
    @IBOutlet weak var SnacksButtonImg: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        BreakfastButtonImg.setImage(UIImage(named: "Breakfast"), for: .normal)
        LunchButtonImg.setImage(UIImage(named: "Lunch"), for: .normal)
        DinnerButtonImg.setImage(UIImage(named: "Dinner"), for: .normal)
        SnacksButtonImg.setImage(UIImage(named: "Snacks"), for: .normal)
    }
    //amend this to the correct views
//    @IBAction func mealButtonTapped(_ sender: UIButton) {
//        var destinationViewControllerIdentifier = ""
//
//        switch sender {
//        case BreakfastButtonImg:
//            destinationViewControllerIdentifier = "BreakfastViewController"
//        case LunchButtonImg:
//            destinationViewControllerIdentifier = "LunchViewController"
//        case DinnerButtonImg:
//            destinationViewControllerIdentifier = "DinnerViewController"
//        case SnacksButtonImg:
//            destinationViewControllerIdentifier = "SnacksViewController"
//        default:
//            print("Unknown button")
//            return
//        }
//
//        let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: destinationViewControllerIdentifier)
//        if let destinationViewController = destinationViewController {
//            self.present(destinationViewController, animated: true, completion: nil)
//        }
//    }
    
//    @IBAction func homeButtonTapped(_ sender: UIButton) {
//        let destinationView = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        present(destinationView, animated: true, completion: nil)
//    }



}
