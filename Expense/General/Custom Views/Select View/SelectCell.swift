//
//  SelectCell.swift
//  Expense
//
//  Created by Tùng Xuân on 17/10/2021.
//

import UIKit

class SelectCell: UITableViewCell {
    
    @IBOutlet weak var viewHighlight: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTile: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        self.viewHighlight.backgroundColor = selected ? UIColor(named: "Pink") : .white
    }
    
    func setupUI(icon: UIImage?, title: String) {
        self.imageViewIcon.image = icon
        self.labelTile.text = title
        self.imageViewIcon.isHidden = icon == nil
    }
    
}
