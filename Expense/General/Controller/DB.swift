//
//  DB.swift
//  Expense
//
//  Created by Tùng Xuân on 06/11/2021.
//

import Foundation
import SQLite

class DB {
    private var path: String = ""
    private var db: Connection? = nil
    
    var tbExpenditure = TableExpenditure()
    var tbBigSpendingGroup = TableBigSpendingGroups()
    var tbBigSpending = TableBigSpending()
    
    init() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            self.path = dir.appendingPathComponent("Expense.db").path
            if !FileManager.default.fileExists(atPath: self.path) {
                if let url = Bundle.main.url(forResource: "init", withExtension: "db") {
                    do {
                        let data = try Data(contentsOf: url)
                        FileManager.default.createFile(atPath: self.path, contents: data, attributes: nil)
                    } catch {
                        Log.i(error)
                    }
                }
            }
        }
    }
    
    static let shared = DB()
    
    func open() {
        do {
            if FileManager.default.fileExists(atPath: self.path) {
                let db = try Connection(self.path)
                self.db = db
                
                self.tbExpenditure = TableExpenditure(db: db)
                self.tbBigSpendingGroup = TableBigSpendingGroups(db: db)
                self.tbBigSpending = TableBigSpending(db: db)
                
                Log.v("Open DB done!")
            }
            else {
                Log.v("Not found db!")
            }
        }
        catch {
            Log.v(error)
        }
    }
    
    class TableExpenditure {
        init(db: Connection? = nil) {
            self.db = db
        }
        
        private var db: Connection? = nil
        
        private let tbExpenditures = Table("Expenditures")
        private let colId = Expression<Int>("Id")
        private let colCategory = Expression<String>("Category")
        private let colValue = Expression<Double>("Value")
        private let colNote = Expression<String?>("Note")
        private let colSource = Expression<String?>("Source")
        private let colDay = Expression<Int?>("Day")
        private let colDayCreateAt = Expression<Int?>("DayCreateAt")
        
        func insert(expenditure: Expenditure) -> Int {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return 0
            }
            
            do {
                let cate = expenditure.category.rawValue
                let note = expenditure.note
                let source = expenditure.source
                let day = expenditure.day.ordinalDay()
                let now = Date().ordinalDay()
                let value = expenditure.value
                let insert = self.tbExpenditures.insert(colCategory <- cate,
                                                        colValue <- value,
                                                        colNote <- note,
                                                        colSource <- source,
                                                        colDay <- day,
                                                        colDayCreateAt <- now)
                
                let rowId = try db.run(insert)
                Log.m("Insert done", rowId, cate, value, note, source, day)
                return Int(rowId)
            }
            catch {
                print(error)
                Global.showError(error.localizedDescription)
            }
            
            return 0
        }
        
        func delete(id: Int) {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return
            }
            
            do {
                let row = self.tbExpenditures.filter(self.colId == id)
                if try db.run(row.delete()) > 0 {
                    Log.m("Delete row done", id)
                }
                else {
                    Log.m("Delete row failed", id)
                }
            }
            catch {
                Global.showError(error.localizedDescription)
            }
        }
        
        func select(start: Int, end: Int) -> [Expenditure] {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return []
            }
            var arrOut: [Expenditure] = []
            
            
            let select = self.tbExpenditures.filter(self.colDay <= end && self.colDay >= start).order(self.colDay.desc, self.colId.desc)
            do {
                let rows = try db.prepare(select)
                for row in rows {
                    if let day = try row.get(self.colDay),
                       let cate = try Category.init(rawValue: row.get(self.colCategory)) {
                        
                        let value = try row.get(self.colValue)
                        let id = try row.get(self.colId)
                        let note = try row.get(self.colNote)
                        let source = try row.get(self.colSource)
                        
                        let date = Date.fromOrdinalDay(day)
                        arrOut.append(.init(id: id, day: date, category: cate, value: value, note: note ?? "", source: source ?? ""))
                    }
                }
            }
            catch {
                Global.showError(error.localizedDescription)
            }
            return arrOut
        }
    }
    
    class TableBigSpendingGroups {
        init(db: Connection? = nil) {
            self.db = db
        }
        
        private var db: Connection? = nil
        
        private let tbBigSpendingGroups = Table("BigSpendingGroups")
        private let colId = Expression<Int>("Id")
        private let colName = Expression<String?>("Name")
        private let colNote = Expression<String?>("Note")
        private let colDayCreateAt = Expression<Int?>("DayCreateAt")
        
        func insert(group: BigSpendingGroup) -> Int {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return 0
            }
            
            do {
                let note = group.note
                let now = Date().ordinalDay()
                let name = group.name
                let insert = self.tbBigSpendingGroups.insert(colNote <- note,
                                                             colName <- name,
                                                             colDayCreateAt <- now)
                
                let rowId = try db.run(insert)
                Log.m("Insert done", rowId, name, note, now)
                return Int(rowId)
            }
            catch {
                print(error)
                Global.showError(error.localizedDescription)
            }
            
            return 0
        }
        
        func delete(id: Int) {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return
            }
            
            do {
                let row = self.tbBigSpendingGroups.filter(self.colId == id)
                if try db.run(row.delete()) > 0 {
                    Log.m("Delete row done", id)
                }
                else {
                    Log.m("Delete row failed", id)
                }
            }
            catch {
                Global.showError(error.localizedDescription)
            }
        }
        
        func select() -> [BigSpendingGroup] {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return []
            }
            var arrOut: [BigSpendingGroup] = []
            
            
            let select = self.tbBigSpendingGroups
            do {
                let rows = try db.prepare(select)
                for row in rows {
                    if let _ = try row.get(self.colDayCreateAt) {
                        
                        let id = try row.get(self.colId)
                        let note = try row.get(self.colNote)
                        let name = try row.get(self.colName)
                        //                        let date = Date.fromOrdinalDay(day)
                        
                        let group = BigSpendingGroup()
                        group.id = id
                        group.name = name ?? ""
                        group.note = note ?? ""
                        
                        arrOut.append(group)
                    }
                }
            }
            catch {
                Global.showError(error.localizedDescription)
            }
            return arrOut
        }
        
        func update(id: Int, name: String, note: String) -> Bool {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return false
            }
            
            let query = self.tbBigSpendingGroups.filter(self.colId == id).update(self.colName <- name, self.colNote <- note)
            do {
                let output = try db.run(query)
                if output > 0 {
                    return true
                }
            }
            catch {
                Global.showError(error.localizedDescription)
            }
            
            return false
        }
    }
    
    class TableBigSpending {
        init(db: Connection? = nil) {
            self.db = db
        }
        
        private var db: Connection? = nil
        
        private let tbBigSpending = Table("BigSpending")
        private let colId = Expression<Int>("Id")
        private let colGroupId = Expression<Int>("GroupId")
        private let colValue = Expression<Double?>("Value")
        private let colDay = Expression<Int?>("Day")
        private let colNote = Expression<String?>("Note")
        private let colDayCreateAt = Expression<Int?>("DayCreateAt")
        
        func insert(spending: BigSpending) -> Int {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return 0
            }
            
            do {
                let groupId = spending.groupId
                let value = spending.value
                let day = spending.day.ordinalDay()
                let now = Date().ordinalDay()
                let note = spending.note
                
                let insert = self.tbBigSpending.insert(colGroupId <- groupId,
                                                       colValue <- value,
                                                       colNote <- note,
                                                       colDay <- day,
                                                       colDayCreateAt <- now)
                
                let rowId = try db.run(insert)
                Log.m("Insert done", rowId, groupId, value, note, day, now)
                return Int(rowId)
            }
            catch {
                print(error)
                Global.showError(error.localizedDescription)
            }
            
            return 0
        }
        
        func delete(id: Int) {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return
            }
            
            do {
                let row = self.tbBigSpending.filter(self.colId == id)
                if try db.run(row.delete()) > 0 {
                    Log.m("Delete row done", id)
                }
                else {
                    Log.m("Delete row failed", id)
                }
            }
            catch {
                Global.showError(error.localizedDescription)
            }
        }
        
        func select(groupId: Int) -> [BigSpending] {
            guard let db = db else {
                Global.showError("Không thể mở database!")
                return []
            }
            var arrOut: [BigSpending] = []
            
            
            let select = self.tbBigSpending.filter(self.colGroupId == groupId)
            do {
                let rows = try db.prepare(select)
                for row in rows {
                    if let day = try row.get(self.colDay) {
                        let id = try row.get(self.colId)
                        let groupId = try row.get(self.colGroupId)
                        let value = try row.get(self.colValue)
                        let note = try row.get(self.colNote)
                        
                        let spending = BigSpending()
                        spending.groupId = groupId
                        spending.id = id
                        spending.day = Date.fromOrdinalDay(day)
                        spending.value = value ?? 0
                        spending.note = note ?? ""
                        
                        arrOut.append(spending)
                    }
                }
            }
            catch {
                Global.showError(error.localizedDescription)
            }
            return arrOut
        }
    }
}

