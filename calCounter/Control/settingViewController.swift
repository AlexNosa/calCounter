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
        
        // Hide the back button in the navigation bar
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveData" {
            let defaults = UserDefaults.standard
            defaults.set(nameTxtField.text, forKey: "name")
            defaults.set(genderSelectButton.selectedSegmentIndex, forKey: "gender")
            defaults.set(ageTxtField.text, forKey: "age")
            defaults.set(weightTextField.text, forKey: "weight")
            defaults.set(heightTxtField.text, forKey: "height")
            defaults.synchronize()
            
            guard let VC = segue.destination as? dashBoardViewController else {
                displayError(message: "Failed to retrieve destination view controller.")
                return
            }
              
            guard let weightText = weightTextField.text, let heightText = heightTxtField.text,
                let ageText = ageTxtField.text, let weight = Double(weightText),
                let height = Double(heightText), let age = Int(ageText) else {
                displayError(message: "Invalid input. Please enter valid data.")
                return
            }
              
            VC.weight = weight
            VC.height = height
            VC.age = age
            VC.gender = genderSelectButton.selectedSegmentIndex
              
            VC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
      
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
      
    func displayError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
