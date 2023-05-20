//  settingViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//

import Foundation
import UIKit

class settingViewController: UIViewController {

    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var genderSelectButton: UISegmentedControl!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        nameTxtField.text = defaults.string(forKey: "name")
        genderSelectButton.selectedSegmentIndex = defaults.integer(forKey: "gender")
        ageTxtField.text = defaults.string(forKey: "age")
        weightTextField.text = defaults.string(forKey: "weight")
        heightTxtField.text = defaults.string(forKey: "height")
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        if segue.identifier == "saveData"{
            let VC = segue.destination as! dashBoardViewController
            VC.weight = Double(weightTextField.text!) ?? 0.0
            VC.height = Double(heightTxtField.text!) ?? 0.0
            VC.age = Int(ageTxtField.text!) ?? 0
            VC.gender = genderSelectButton.selectedSegmentIndex
            
            VC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = UserDefaults.standard
        defaults.set(nameTxtField.text, forKey: "name")
        defaults.set(genderSelectButton.selectedSegmentIndex, forKey: "gender")
        defaults.set(ageTxtField.text, forKey: "age")
        defaults.set(weightTextField.text, forKey: "weight")
        defaults.set(heightTxtField.text, forKey: "height")
        defaults.synchronize()
    }
    // Hide the back button
}
