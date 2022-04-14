//
//  Category.swift
//  Expense
//
//  Created by Tùng Xuân on 15/10/2021.
//

import Foundation

enum Category: String, Codable, CaseIterable {
    case anuong = "Ăn uống"
    case dicho = "Đi chợ"
    case sinhhoatphi = "Sinh hoạt phí" // điện thoại, cắt tóc, thuê giúp việc,...
    
    case diennuoc = "Điện, nước"
    case gas = "Gas"
    case mangtruyenhinh = "Mạng, truyền hình"
    
    case xangdau = "Xăng dầu"
    case vetauxe = "Vé xe, tàu, taxi"
    
    case dichoidian = "Đi chơi, đi ăn"
    case xemphim = "Xem Phim"
    case dulich = "Du lịch"
    
    case sothich = "Sở thích" // game, truyện, netflix,...
    case thethao = "Thể thao"
    case lamdep = "Làm đẹp"
    
    case suckhoe = "Sức khỏe"
    
    case thuenha = "Thuê nhà"
    case samdo = "Sắm đồ"
    case thucung = "Thú cưng"
    case suachua = "Sửa chữa" // sửa xe, nhà cửa, đồ đạc, điện thoại,...
    
    case concai = "Con cái"
    case phattrien = "Phát triển bản thân"
    
    case xagiao = "Xã giao"
    case chovay = "Cho vay"
    case trano = "Trả nợ"
    case tuthien = "Từ thiện"
    case trocapgiadinh = "Trợ cấp gia đình"
    
    // cả khoản chi và khoản thu
    case dautu = "Đầu tư"
    case khac = "Khác"
    
    // khoản thu
    case vaytien = "Vay tiền"
    case nhantien = "Nhận tiền"
    case luongthuong = "Lương thưởng"
    case thuhoino = "Thu hồi nợ"
    
    var icon: String {
        switch self {
        case .anuong:
            return "ico_anuong"
        case .dicho:
            return "ico_sieuthi"
        case .sinhhoatphi:
            return "ico_sinhhoatphi"
        case .diennuoc:
            return "ico_dien"
        case .mangtruyenhinh:
            return "ico_internet"
        case .gas:
            return "ico_gas"
        case .xangdau:
            return "ico_xangdau"
        case .vetauxe:
            return "ico_vexe"
        case .dichoidian:
            return "ico_giaitri"
        case .xemphim:
            return "ico_phim"
        case .dulich:
            return "ico_dulich"
        case .sothich:
            return "ico_game"
        case .thethao:
            return "ico_thethao"
        case .suckhoe:
            return "ico_benhvien"
        case .thuenha:
            return "ico_thuenha"
        case .samdo:
            return "ico_sieuthi"
        case .thucung:
            return "ico_pet"
        case .suachua:
            return "ico_suachua"
        case .concai:
            return "ico_concai"
        case .phattrien:
            return "ico_phattrien"
        case .xagiao:
            return "ico_xagiao"
        case .chovay:
            return "ico_chovaytrano"
        case .trano:
            return "ico_chovaytrano"
        case .vaytien:
            return "ico_nhantien"
        case .dautu:
            return "ico_dautu"
        case .tuthien:
            return "ico_tuthien"
        case .trocapgiadinh:
            return "ico_giadinh"
        case .khac:
            return "ico_khac"
        case .nhantien:
            return "ico_nhantien"
        case .luongthuong:
            return "ico_hocphi"
        case .thuhoino:
            return "ico_nhantien"
        case .lamdep:
            return "ico_mypham"
        }
    }
}
