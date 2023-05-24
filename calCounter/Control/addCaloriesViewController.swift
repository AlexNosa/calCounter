//  addCaloriesViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//

import Foundation
import UIKit

//The API from CalorieNinjas was used. See website https://calorieninjas.com/

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

class addCaloriesViewController: UIViewController , UITextFieldDelegate {
    
    var mealType: String?
    
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
    
    //the variables that the API will display based on user input
    var totalCalories =  0.0
    var totalFatTotalG = 0.0
    var totalProteinG  = 0.0
    var totalSugarG = 0.0
    var lastResetDate: Date?
    
    var foodItems: [FoodItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealTypeLabel.text = mealType
        foodNameLabel.text = "Nutritional Information"
        self.caloriesLabel.text = ""
        self.proteinLabel.text = ""
        self.fatLabel.text = ""
        self.sugarLabel.text = ""
        servings.delegate = self
    }
    
    @IBAction func findFoodButtonTapped(_ sender: Any) {
        print("I have been searched.") // to be displayed in the terminal
        guard let foodName = foodNameTextField.text else { return }
        foodNameLabel.text = "\(foodName)"
        fetchFood(query:foodName)
        // Set text area to an empty string
        foodNameTextField.text = ""
    }
    //To calculate the total values for calories, fat, protein, and sugar
    func calculateTotals() -> TotalFoodItem {
        //Iterate over each food item in the array and calculate the total values
        for foodItem in foodItems {
            totalCalories += foodItem.calories
            totalFatTotalG += foodItem.fatTotalG
            totalProteinG += foodItem.proteinG
            totalSugarG += foodItem.sugarG
        }
        //Create a TotalFoodItem object with the calculated totals and format the values to have one decimal place
        return TotalFoodItem(
            totalCalories: Double(String(format: "%.1f", totalCalories)) ?? totalCalories,
            totalFatTotalG: Double(String(format: "%.1f", totalFatTotalG)) ?? totalFatTotalG,
            totalProteinG: Double(String(format: "%.1f", totalProteinG)) ?? totalProteinG,
            totalSugarG: Double(String(format: "%.1f", totalSugarG)) ?? totalSugarG,
            finalFoodName: self.foodNameLabel.text)
    }
    
    // API call to find the food and calories using a struct
    func fetchFood(query: String) {
        // Encode the query string for URL usage
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        // Construct the URL with the encoded query string
        let url = URL(string: "https://api.calorieninjas.com/v1/nutrition?query=" + query)!
        
        // Create a URLRequest with the URL and set the X-Api-Key header
        var request = URLRequest(url: url)
        request.setValue("eHLXvaQ8P8N40UMSrZh85A==78XyI3BrPnl7SE6n", forHTTPHeaderField: "X-Api-Key")
        
        // Perform the API request using URLSession
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle request error
                print("Error with the request: \(error)")
                return
            }
            guard let data = data else {
                // Handle no data returned
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
                            // Extract the properties from each item and create a FoodItem
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
                            // Update the foodItems array on the main queue
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
        
        // Check if the servings text field is empty, if true then display an error alert
        guard let servingsText = servings.text, !servingsText.isEmpty else {
            displayErrorAlert(message: "Please input the number of servings")
            return
        }
        
        guard let servingsText = servings.text, let servingsValue = Double(servingsText) else { return }
        let foodName = foodNameLabel.text ?? ""
        let caloriesString = String(totalCalories)
        let calories = (Double(caloriesString) ?? 0.0) * servingsValue
        
        // Instantiate the DashboardViewController from the Main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardVC = storyboard.instantiateViewController(withIdentifier: "dashBoardViewController") as! dashBoardViewController
        dashboardVC.addFoodEntry(foodName: foodName, calories: Int(calories))
        
        // Add the food entry to the DashboardViewController
        navigationController?.pushViewController(dashboardVC, animated: true)
        
        // Hide the back button
        dashboardVC.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func displayErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Present the alert controller on the screen
        present(alert, animated: true, completion: nil)
    }
}









