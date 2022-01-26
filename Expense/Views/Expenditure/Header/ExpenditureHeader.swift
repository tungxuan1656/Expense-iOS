//
//  ExpenditureHeader.swift
//  Expense
//
//  Created by Tùng Xuân on 15/10/2021.
//

import UIKit

class ExpenditureHeader: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelDayOfWeek: UILabel!
    @IBOutlet weak var labelProfit: UILabel!
    @IBOutlet weak var labelLoss: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let _ = loadNib()
        self.addSubview(self.viewContent)
        self.viewContent.frame = self.bounds
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let _ = loadNib()
        self.addSubview(self.viewContent)
        self.viewContent.frame = self.bounds
        self.commonInit()
    }
    
    func commonInit() {
        
    }
    
    func setupUI(summary: ExSummary) {
        self.labelDay.text = Calendar.current.component(.day, from: summary.time).description
        self.labelProfit.isHidden = summary.profit <= 0
        self.labelProfit.text = Currency.vnd.get(summary.profit)
        self.labelLoss.isHidden = summary.loss >= 0
        self.labelLoss.text = Currency.vnd.get(summary.loss)
        
        let wd = Calendar.current.component(.weekday, from: summary.time)
        self.labelDayOfWeek.text = wd == 1 ? "Chủ nhật" : "Thứ " + wd.description
        self.labelMonth.text = "tháng " + summary.time.toString(format: .custom("MM/yyyy"))
    }
}


