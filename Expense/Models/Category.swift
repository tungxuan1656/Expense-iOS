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
    case anvat = "Ăn vặt"
    case antiem = "Ăn tiệm"
    case caphetrada = "Cà phê, trà đá"
    case sinhhoatphi = "Sinh hoạt phí"
    case dien = "Điện"
    case nuoc = "Nước"
    case internet = "Internet"
    case truyenhinh = "Truyền hình"
    case gas = "Gas"
    case dienthoai = "Điện thoại"
    case dilai = "Đi lại"
    case xangdau = "Xăng dầu"
    case vetauxe = "Vé tàu xe"
    case taxi = "Taxi"
    case giaitri = "Giải trí"
    case xemphim = "Xem Phim"
    case dulich = "Du lịch"
    case amnhac = "Âm nhạc"
    case game = "Game"
    case suckhoelamdep = "Sức khỏe làm đẹp"
    case thethao = "Thể thao"
    case quanao = "Quần áo"
    case mypham = "Mỹ phẩm"
    case chuabenh = "Chữa bệnh"
    case thuoc = "Thuốc"
    case nhacua = "Nhà cửa"
    case thuenha = "Thuê nhà"
    case samdo = "Sắm đồ"
    case thucung = "Thú cưng"
    case suachua = "Sửa chữa"
    case giupviec = "Giúp việc"
    case concai = "Con cái"
    case phattrien = "Phát triển bản thân"
    case hocphi = "Học phí"
    case sach = "Sách"
    case xagiao = "Xã giao"
    case chovay = "Cho vay"
    case trano = "Trả nợ"
    case tuthien = "Từ thiện"
    case trocapgiadinh = "Trợ cấp gia đình"
    
    case dautu = "Đầu tư"
    case vaytien = "Vay tiền"
    case nhantien = "Nhận tiền"
    case luongthuong = "Lương thưởng"
    case kinhdoanh = "Kinh doanh"
    case thuhoino = "Thu hồi nợ"
    case mungtang = "Mừng tặng"
    
    case khac = "Khác"
    
    var icon: String {
        switch self {
        case .anuong:
            return "ico_anuong"
        case .dicho:
            return "ico_sieuthi"
        case .anvat:
            return "ico_anvat"
        case .antiem:
            return "ico_antiem"
        case .caphetrada:
            return "ico_caphe"
        case .sinhhoatphi:
            return "ico_sinhhoatphi"
        case .dien:
            return "ico_dien"
        case .nuoc:
            return "ico_nuoc"
        case .internet:
            return "ico_internet"
        case .truyenhinh:
            return "ico_tivi"
        case .gas:
            return "ico_gas"
        case .dienthoai:
            return "ico_dienthoai"
        case .dilai:
            return "ico_dichuyen"
        case .xangdau:
            return "ico_xangdau"
        case .vetauxe:
            return "ico_vexe"
        case .taxi:
            return "ico_taxi"
        case .giaitri:
            return "ico_giaitri"
        case .xemphim:
            return "ico_phim"
        case .dulich:
            return "ico_dulich"
        case .amnhac:
            return "ico_music"
        case .game:
            return "ico_game"
        case .suckhoelamdep:
            return "ico_suckhoe"
        case .thethao:
            return "ico_thethao"
        case .quanao:
            return "ico_quanao"
        case .mypham:
            return "ico_mypham"
        case .chuabenh:
            return "ico_benhvien"
        case .thuoc:
            return "ico_thuoc"
        case .nhacua:
            return "ico_nhacua"
        case .thuenha:
            return "ico_thuenha"
        case .samdo:
            return "ico_sieuthi"
        case .thucung:
            return "ico_pet"
        case .suachua:
            return "ico_suachua"
        case .giupviec:
            return "ico_giupviec"
        case .concai:
            return "ico_concai"
        case .phattrien:
            return "ico_phattrien"
        case .hocphi:
            return "ico_hocphi"
        case .sach:
            return "ico_sachvo"
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
        case .kinhdoanh:
            return "ico_dautu"
        case .thuhoino:
            return "ico_nhantien"
        case .mungtang:
            return "ico_xagiao"
        }
    }
}
