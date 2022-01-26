//
//  ExSummary.swift
//  Expense
//
//  Created by Tùng Xuân on 16/10/2021.
//

import Foundation
import UIKit

class ExSummary {
    var time: Date = Date()
    var type: TypeSummary = .day
    var profit: Double = 0
    var loss: Double = 0
    var expenditures: [Expenditure] = []
    
    init(timeline: Date? = nil, expenditures: [Expenditure], type: TypeSummary) {
        let arrExpenditures = expenditures
        guard arrExpenditures.count != 0 else { return }
        var arrFilters: [Expenditure] = []
        let timeline = timeline ?? arrExpenditures[0].day
        let index = timeline.ordinalDay()
        arrFilters = arrExpenditures.filter {
            $0.day.ordinalDay() == index
        }
        
        let cal = ExSummary.calculator(expenditures: arrFilters)
        self.time = arrFilters[0].day
        self.type = .day
        self.profit = cal.profit
        self.loss = cal.loss
        self.expenditures = arrFilters
    }
    
    static func calculator(expenditures: [Expenditure]) -> (profit: Double, loss: Double) {
        var profit: Double = 0
        var loss: Double = 0
        for e in expenditures {
            let v = e.value
            profit += v > 0 ? v : 0
            loss += v < 0 ? v : 0
        }
        return (profit: profit, loss: loss)
    }
    
    enum TypeSummary {
        case day
        case weak
        case month
        case year
    }
}
