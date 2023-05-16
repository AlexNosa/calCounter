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
        let items: [Item]
        
        struct Item: Codable {
            let name: String
            let calories: Double
            let proteins: Double
            let fat: Double
            let sugars: Double
        }
    }
    
    var foodItems: [Food.Item] = []
    
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
    func fetchFood(for food: String, completion: @escaping (Food.Item?) -> Void) {
        guard let query = food.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: "https://api.calorieninjas.com/v1/nutrition?query=" + query)!
        var request = URLRequest(url: url)
        request.setValue("eHLXvaQ8P8N40UMSrZh85A==78XyI3BrPnl7SE6n", forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                let foodData = try decoder.decode(Food.self, from: data)
                if let item = foodData.items.first {
                    completion(item)
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

extension addCaloriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        let food = foodItems[indexPath.row]
        cell.textLabel?.text = food.name
        cell.detailTextLabel?.text = "Calories: \(food.calories), Proteins: \(food.proteins), Fat: \(food.fat), Sugars: \(food.sugars)"
        return cell
    }
}
