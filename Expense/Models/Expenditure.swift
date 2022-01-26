//
//  Expenditure.swift
//  Expense
//
//  Created by Tùng Xuân on 14/10/2021.
//

import Foundation

class Expenditure {
    var id: Int = 0
    var day: Date = Date()
    var category: Category = .khac
    var note: String = ""
    var value: Double = 0
    var source: String = ""
    var ordinalDay: Int = Date().ordinalDay()
    
    init() {}
    
    init(id: Int, day: Date, category: Category, value: Double, note: String, source: String) {
        self.id = id
        self.day = day
        self.category = category
        self.value = value
        self.note = note
        self.source = source
        self.ordinalDay = self.day.ordinalDay()
    }
    
    var description: String {
        return "\(id) \(day) \(category) \(value) \(note) \(source)"
    }
    
    func setDay(_ day: Date) {
        self.day = day
        self.ordinalDay = day.ordinalDay()
    }
}

/*
class Expenditure: Codable {
    var id: Int?
    var time: Date? {
        get {
            return self.tempTime ?? Date(fromString: self.sTime ?? "", format: .isoDateTime)
        }
        set {
            self.sTime = newValue?.toString(format: .isoDateTime)
            self.tempTime = newValue
        }
    }
    var category: Category? {
        get {
            return self.tempCategory ?? Category(rawValue: self.sCategory ?? "")
        }
        set {
            self.sCategory = newValue?.rawValue
            self.tempCategory = newValue
        }
    }
    var note: String?
    var value: Double?
    var source: String?
    
    private var tempCategory: Category?
    private var tempTime: Date?
    private var sCategory: String?
    private var sTime: String?
    
    private enum CodingKeys: String, CodingKey {
        case sCategory = "category"
        case sTime = "time"
        case note = "note"
        case value = "value"
        case source = "source"
    }
    
    init(time: Date? = nil, category: Category? = nil, note: String? = nil, value: Double? = nil, source: String? = nil) {
        self.time = time
        self.category = category
        self.note = note
        self.value = value
        self.source = source
    }
    
    init(id: Int, time: Date, category: Category = .khac, value: Double, note: String? = nil, source: String? = nil) {
        self.time = time
        self.category = category
        self.note = note
        self.value = value
        self.source = source
        self.id = id
    }
    
    func getIndexDate(_ component: Calendar.Component) -> Int {
        guard let time = time else {
            return -1
        }

        let calender = Calendar.current
        let index = calender.ordinality(of: component, in: .era, for: time) ?? -1
        return index
    }
}
 */
