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
    
    @IBOutlet weak var nutrientTableView: UITableView!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var mealTypeLabel: UILabel!
    @IBOutlet weak var searchFood: UIButton!
    
    
    struct Food: Codable {
        let name: String
        let calories: Double
        let servingSizeG: Double
        let fatTotalG: Double
        let fatSaturatedG: Double
        let proteinG: Double
        let sodiumMg: Int
        let potassiumMg: Int
        let cholesterolMg: Int
        let carbohydratesTotalG: Double
        let fiberG: Double
        let sugarG: Double
    }
    
    var foodItems: [Food] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealTypeLabel.text = mealType
        nutrientTableView.dataSource = self
        foodNameLabel.text = ""
    }
    
    @IBAction func findFoodButtonTapped(_ sender: Any) {
        guard let foodName = foodNameTextField.text else { return }
        foodNameLabel.text = "\(foodName) Nutritional Information"
        fetchFood(for: foodName) { [weak self] data in
            DispatchQueue.main.async {
                if let data = data {
                    self?.foodItems.append(data)
                    self?.nutrientTableView.reloadData()
                } else {
                    // Handle error case
                }
            }
        }
    }
    
    // Api call to find the food and calories using struct
    func fetchFood(for food: String, completion: @escaping (Food?) -> Void) {
        guard let query = food.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: "https://api.calorieninjas.com/v1/nutrition?query=" + query)!
        var request = URLRequest(url: url)
        request.setValue("eHLXvaQ8P8N40UMSrZh85A==78XyI3BrPnl7SE6n", forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error with the request: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data returned from the request.")
                completion(nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("JSON successfully parsed.")
                    if let items = json["items"] as? [[String: Any]] {
                        print("\"items\" array successfully extracted from JSON.")
                        var foodItems = [Food]()
                        for item in items {
                            let foodItem = Food(
                                name: item["name"] as? String ?? "",
                                calories: item["calories"] as? Double ?? 0.0,
                                servingSizeG: item["serving_size_g"] as? Double ?? 0.0,
                                fatTotalG: item["fat_total_g"] as? Double ?? 0.0,
                                fatSaturatedG: item["fat_saturated_g"] as? Double ?? 0.0,
                                proteinG: item["protein_g"] as? Double ?? 0.0,
                                sodiumMg: item["sodium_mg"] as? Int ?? 0,
                                potassiumMg: item["potassium_mg"] as? Int ?? 0,
                                cholesterolMg: item["cholesterol_mg"] as? Int ?? 0,
                                carbohydratesTotalG: item["carbohydrates_total_g"] as? Double ?? 0.0,
                                fiberG: item["fiber_g"] as? Double ?? 0.0,
                                sugarG: item["sugar_g"] as? Double ?? 0.0
                            )
                            foodItems.append(foodItem)
                        }
                        // Printing details of each food item.
                        for foodItem in foodItems {
                            print("Food Name: \(foodItem.name)")
                            print("Calories: \(foodItem.calories)")
                        }
                    } else {
                        print("Unable to extract \"items\" array from JSON.")
                    }
                } else {
                    print("Unable to parse JSON.")
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}

extension addCaloriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        let food = foodItems[indexPath.row]
        cell.textLabel?.text = food.name
        cell.detailTextLabel?.text = "Calories: \(food.calories), Proteins: \(food.proteinG), Fat: \(food.fatTotalG), Sugars: \(food.sugarG)"
        return cell
    }
}
