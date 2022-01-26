//
//  AppData.swift
//  Expense
//
//  Created by Tùng Xuân on 14/10/2021.
//

import Foundation

class AppData {
    static var outCategories: [Category] = []
    static var inCategories: [Category] = []
    static var sources = [String]()
    
    static func getExpenditures(start: Date = Date.fromOrdinalDay(Date().ordinalDay() - 30), end: Date = Date()) -> [Expenditure] {
        
        let s = start.ordinalDay()
        let e = end.ordinalDay()
        // Log.m(s, e)
        return DB.shared.select(start: s, end: e)
    }
    
    
    // MARK: - Defaults
    private static let defaultInCategories: [Category] = [
        .dautu, .vaytien, .nhantien, .kinhdoanh, .thuhoino, .mungtang, .khac
    ]
    
    private static let defaultOutCategories: [Category] = [
        .anuong, .dicho, .antiem, .anvat, .caphetrada,
        .sinhhoatphi, .dien, .nuoc, .internet, .truyenhinh, .gas, .dienthoai,
        .dilai, .xangdau, .vetauxe, .taxi,
        .giaitri, .xemphim, .dulich, .amnhac, .game,
        .suckhoelamdep, .thethao, .quanao, .mypham, .chuabenh, .thuoc,
        .nhacua, .thuenha, .samdo, .thucung, .suachua, .giupviec,
        .concai,
        .phattrien, .hocphi, .sach,
        .xagiao,
        .chovay,
        .vaytien,
        .trano,
        .dautu,
        .tuthien,
        .trocapgiadinh,
        .khac
    ]
    
    // MARK: - Cache
    static func saveSources() {
        if let data = try? JSONEncoder().encode(AppData.sources),
           let json = String(data: data, encoding: .utf8) {
            UserDefaults.standard.setValue(json, for: .sources)
        }
    }
    
    static func loadSources() {
        guard let s = UserDefaults.standard.getValue(for: .sources) as? String,
              let data = s.data(using: .utf8),
              let sources = try? JSONDecoder().decode([String].self, from: data)
        else { return }
        
        AppData.sources = sources
    }
    
    static func loadInCategories() {
        if let sic = UserDefaults.standard.getValue(for: .inCategories) as? String,
           let data = sic.data(using: .utf8),
           let sInCategories = try? JSONDecoder().decode([String].self, from: data) {
            AppData.inCategories = sInCategories.map { Category(rawValue: $0) ?? .khac }
        }
        
        if AppData.inCategories.isEmpty {
            AppData.inCategories = AppData.defaultInCategories
        }
    }
    
    static func saveInCategories() {
        let arr = AppData.inCategories.map { $0.rawValue }
        if let data = try? JSONEncoder().encode(arr),
           let json = String(data: data, encoding: .utf8) {
            UserDefaults.standard.setValue(json, for: .inCategories)
        }
    }
    
    static func loadOutCategories() {
        if let soc = UserDefaults.standard.getValue(for: .outCategories) as? String,
           let data = soc.data(using: .utf8),
           let sOutCategories = try? JSONDecoder().decode([String].self, from: data) {
            AppData.outCategories = sOutCategories.map { Category(rawValue: $0) ?? .khac }
        }
        
        if AppData.outCategories.isEmpty {
            AppData.outCategories = AppData.defaultOutCategories
        }
    }
    
    static func saveOutCategories() {
        let arr = AppData.outCategories.map { $0.rawValue }
        if let data = try? JSONEncoder().encode(arr),
           let json = String(data: data, encoding: .utf8) {
            UserDefaults.standard.setValue(json, for: .outCategories)
        }
    }
}
