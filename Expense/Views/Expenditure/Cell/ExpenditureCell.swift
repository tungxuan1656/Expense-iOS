//
//  ExpenditureCell.swift
//  Expense
//
//  Created by Tùng Xuân on 15/10/2021.
//

import UIKit

class ExpenditureCell: UITableViewCell {
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelSource: UILabel!
    @IBOutlet weak var viewHighlight: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.viewHighlight.isHidden = !selected
        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.viewHighlight.isHidden = !highlighted
    }
    
    func setupUI(expenditure: Expenditure) {
        let category = expenditure.category
        let value = expenditure.value
        self.labelCategory.text = category.rawValue
        self.imageViewIcon.image = UIImage(named: category.icon)
        
        self.labelValue.textColor = value < 0 ? UIColor(named: "Feature") : UIColor(named: "Moss")
        self.labelValue.text = Currency.vnd.get(value)
        
        self.labelNote.isHidden = expenditure.note == ""
        self.labelNote.text = expenditure.note
        
//        self.labelSource.isHidden = expenditure.source == ""
//        self.labelSource.text = expenditure.source
    }
    
    func setupGroup(group: BigSpendingGroup) {
        let name = group.name
        let note = group.note
        let value = group.value
        
        self.imageViewIcon.isHidden = true
        self.labelNote.text = note
        self.labelCategory.text = name
        
        self.labelValue.textColor = value < 0 ? UIColor(named: "Feature") : UIColor(named: "Moss")
        self.labelValue.text = Currency.vnd.get(value)
        
        self.separatorInset = .zero
    }
    
    func setupSpending(_ s: BigSpending) {
        let note = s.note
        let value = s.value
        let day = s.day
        
        self.imageViewIcon.isHidden = true
        self.labelNote.text = note
        self.labelCategory.text = day.toString(format: .custom("dd/MM/yyyy"))
        self.labelValue.textColor = value < 0 ? UIColor(named: "Feature") : UIColor(named: "Moss")
        self.labelValue.text = Currency.vnd.get(value)
        self.separatorInset = .zero
    }
}
