//  addCaloriesViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//

import Foundation
import UIKit


// Declare a class that conforms to the ObservableObject protocol
class FoodData: ObservableObject {
    @Published var foodItems: [FoodItem] = []
}
struct TotalFoodItem: Codable {
    let totalCalories: Double
    let totalFatTotalG: Double
    let totalProteinG: Double
    let totalSugarG: Double
    var finalFoodName: String?
}

struct FoodItem: Codable {
    let name: String
    let calories: Double
    let fatTotalG: Double
    let proteinG: Double
    let sugarG: Double
}
struct ApiResponse: Codable {
    let items: [FoodItem]
}

class addCaloriesViewController: UIViewController {
    
    var mealType: String?
    //this is the segue from choosing meal so set the top label to this value
    
    // Instantiate the FoodData class
    private var foodData = FoodData()
    
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var mealTypeLabel: UILabel!
    @IBOutlet weak var searchFood: UIButton!
    @IBOutlet weak var servings: UITextField!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    
    @IBOutlet weak var addCaloriesButton: UIButton!
    
    var totalCalories =  0.0
    var totalFatTotalG = 0.0
    var totalProteinG  = 0.0
    var totalSugarG = 0.0
    var lastResetDate: Date?
    
    
    var foodItems: [FoodItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealTypeLabel.text = mealType
        foodNameLabel.text = ""
        self.caloriesLabel.text = ""
        self.proteinLabel.text = ""
        self.fatLabel.text = ""
        self.sugarLabel.text = ""
    }
    
    @IBAction func findFoodButtonTapped(_ sender: Any) {
        print("I have been searched.")
        guard let foodName = foodNameTextField.text else { return }
        foodNameLabel.text = "\(foodName)"
        fetchFood(query:foodName)
        // Set text area to an empty string
        foodNameTextField.text = ""
    }
    
    func calculateTotals() -> TotalFoodItem {
        
        for foodItem in foodItems {
            totalCalories += foodItem.calories
            totalFatTotalG += foodItem.fatTotalG
            totalProteinG += foodItem.proteinG
            totalSugarG += foodItem.sugarG
        }
        
        return TotalFoodItem(
            totalCalories: Double(String(format: "%.1f", totalCalories)) ?? totalCalories,
            totalFatTotalG: Double(String(format: "%.1f", totalFatTotalG)) ?? totalFatTotalG,
            totalProteinG: Double(String(format: "%.1f", totalProteinG)) ?? totalProteinG,
            totalSugarG: Double(String(format: "%.1f", totalSugarG)) ?? totalSugarG,
            finalFoodName: self.foodNameLabel.text
        )
    }
    
    
    
    // Api call to find the food and calories using struct
    func fetchFood(query: String) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: "https://api.calorieninjas.com/v1/nutrition?query=" + query)!
        var request = URLRequest(url: url)
        request.setValue("eHLXvaQ8P8N40UMSrZh85A==78XyI3BrPnl7SE6n", forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error with the request: \(error)")
                return
            }
            guard let data = data else {
                print("No data returned from the request.")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("JSON successfully parsed.")
                    if let items = json["items"] as? [[String: Any]] {
                        print("\"items\" array successfully extracted from JSON.")
                        var newFoodItems = [FoodItem]()
                        for item in items {
                            let foodItem = FoodItem(
                                name: item["name"] as? String ?? "",
                                calories: item["calories"] as? Double ?? 0.0,
                                fatTotalG: item["fat_total_g"] as? Double ?? 0.0,
                                proteinG: item["protein_g"] as? Double ?? 0.0,
                                sugarG: item["sugar_g"] as? Double ?? 0.0
                            )
                            newFoodItems.append(foodItem)
                        }
                        
                        DispatchQueue.main.async {
                            self.foodItems = newFoodItems
                            
                            let total = self.calculateTotals()
                            self.caloriesLabel.text = "\(total.totalCalories)"
                            self.proteinLabel.text = "\(total.totalProteinG)"
                            self.fatLabel.text = "\(total.totalFatTotalG)"
                            self.sugarLabel.text = "\(total.totalSugarG)"
                        }
                    } else {
                        print("Unable to extract \"items\" array from JSON.")
                    }
                } else {
                    print("Unable to parse JSON.")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    
    @IBAction func addCaloriesButtonTapped(_ sender: UIButton) {
        guard let servingsText = servings.text, let servingsValue = Double(servingsText) else { return }
        let foodName = foodNameLabel.text ?? ""
        let caloriesString = String(totalCalories)
        let calories = (Double(caloriesString) ?? 0.0) * servingsValue
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardVC = storyboard.instantiateViewController(withIdentifier: "dashBoardViewController") as! dashBoardViewController
        dashboardVC.addFoodEntry(foodName: foodName, calories: Int(calories))
        
        // Push the DashboardViewController onto the navigation stack
        navigationController?.pushViewController(dashboardVC, animated: true)
        
        // Hide the back button
        dashboardVC.navigationItem.setHidesBackButton(true, animated: true)
    }
}









