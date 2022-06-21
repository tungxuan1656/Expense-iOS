//
//  BigSpendingGroup.swift
//  Expense
//
//  Created by Tùng Xuân on 20/06/2022.
//

import Foundation

class BigSpendingGroup {
    var id: Int = 0
    var name: String = ""
    var note: String = ""
    var value: Double = 0
    var arrSpending = [BigSpending]()
    
    init() {}
}


class BigSpending {
    var id: Int = 0
    var groupId: Int = 0
    var value: Double = 0
    var day: Date = Date()
    var note = ""
    
    init() {}
}
