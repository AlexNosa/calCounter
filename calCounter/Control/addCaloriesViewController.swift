//  addCaloriesViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//

import Foundation
import UIKit

class addCaloriesViewController: UIViewController {
    
    var mealType: String?
    //this is the segue from choosing meal so set the top label to this value
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var caloriesLabel: UILabel!

    struct Food: Codable {
        let items: [Item]
        
        struct Item: Codable {
            let name: String
            let calories: Double
        }
    }
    
    
    @IBOutlet weak var mealTypeLabel: UILabel!
    //add a text field for food name
    //add a button to find food: Here is where you have a method to run the api and set the data to the textfield of information
    //add a label to have the number of calories for the food
    //add a button to add the calories to the array
    // add a text field to set the value of all the food items in api call
    
    //add a text field for food name
    //add a button to find food
    //add a label to have the number of calories for the food
    //add a button to add the calories to the array

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealTypeLabel.text = mealType
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func findFoodButtonTapped(_ sender: Any) {
        guard let foodName = foodNameTextField.text else { return }
        fetchFood(for: foodName) { [weak self] data in
            DispatchQueue.main.async {
                self?.caloriesLabel.text = data
                //set the text here || separate for food info label and calories label
            }
        }
    }
    //Api call to find the food and calories using struct
    func fetchFood(for food: String, completion: @escaping (String?) -> Void) {
        guard let query = food.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: "https://api.calorieninjas.com/v1/nutrition?query=" + query)!
        var request = URLRequest(url: url)
            request.setValue("eHLXvaQ8P8N40UMSrZh85A==78XyI3BrPnl7SE6n", forHTTPHeaderField: "X-Api-Key")
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
                do {
                    let decoder = JSONDecoder()
                    let foodData = try decoder.decode(Food.self, from: data)
                    if let calories = foodData.items.first?.calories {
                        completion(String(calories)) // Convert the Double to a String
                        //set the calories to the textfield value
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
            task.resume()
    }

}
