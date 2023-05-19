//  mealHistoryViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//

import Foundation
import UIKit

class MealHistory {
    static let shared = MealHistory()
    private init() {}

    var meals: [Meal] = []

    func addMeal(_ meal: Meal) {
        meals.append(meal)
    }
}

struct Meal {
    var foodName: String
    var mealType: String
    var calories: Double
}

class mealHistoryViewController: UIViewController {
    
    var foodName: String?
    var mealType: String?
    var calories: Double?
    
    @IBOutlet weak var tableView: UITableView!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let meals = MealHistory.shared.meals
        for meal in meals {
            print(meal)
        }
    }
}

extension mealHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MealHistory.shared.meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)

        let meal = MealHistory.shared.meals[indexPath.row]
        cell.textLabel?.text = meal.foodName
        cell.detailTextLabel?.text = "Meal: \(meal.foodName), Meal Type: \(mealType ?? ""), Calories: \(meal.calories)"

        return cell
    }
    
    // You can also implement other delegate methods based on your needs.
}
