//  mealHistoryViewController.swift
//  calCounter
//
//  Created by Alex Nosatti on 30/4/2023.
//
 import Foundation
 import UIKit

 struct meal{
     var foodName:String
     var calorieCount:Int
 }

 class mealHistoryViewController : UIViewController {
     @IBOutlet weak var mealHistoryTableView: UITableView!
     var mealHistory = [meal]()
     
     // Function to add a new meal to the mealHistory array. After adding to meal, it relaods the tableView
    func addMealToHistory(_ meal: meal) {
        mealHistory.insert(meal, at: 0)
        mealHistoryTableView.reloadData()
    }
 }

extension mealHistoryViewController: UITableViewDataSource {
    
    //return the number of rows equivalent to the mealHistory array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealHistory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let food = mealHistory[mealHistory.count - indexPath.row - 1] // Reverse the order
        cell.textLabel?.text = food.foodName
        cell.detailTextLabel?.text = String(food.calorieCount)
        return cell
    }
}
