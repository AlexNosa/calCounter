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
}
