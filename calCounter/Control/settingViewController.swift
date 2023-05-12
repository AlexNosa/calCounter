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
                    
        }
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        if segue.identifier == "saveData"{
            let VC = segue.destination as! ViewController
            VC.weight = Double(weightTextField.text!) ?? 0.0
            VC.height = Double(heightTxtField.text!) ?? 0.0
            VC.age = Int(ageTxtField.text!) ?? 0
            VC.gender = genderSelectButton.selectedSegmentIndex            }

    }
}
