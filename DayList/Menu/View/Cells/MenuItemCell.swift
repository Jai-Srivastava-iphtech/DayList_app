//
//  MenuItemCell.swift
//  DayList
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        iconImageView.tintColor = .darkGray
        iconImageView.contentMode = .scaleAspectFit
        
        // Use a consistent dark color for ALL items (including Settings)
        titleLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Align icon
        iconImageView.frame.origin.x = 16
        // Round badge
        countLabel.layer.cornerRadius = countLabel.bounds.height / 2
    }
    
    func configure(with menuItem: MenuItem, isSelected: Bool) {
        titleLabel.text = menuItem.title
        
        if isSelected {
            backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        } else {
            backgroundColor = .white
        }
        
        if let customIcon = menuItem.customIcon {
            iconImageView.image = customIcon
        } else if #available(iOS 13.0, *) {
            iconImageView.image = UIImage(systemName: menuItem.systemIconName)
        }
        
        if let count = menuItem.count {
            countLabel.text = "\(count)"
            countLabel.isHidden = false
            countLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            countLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            countLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            countLabel.textAlignment = .center
            countLabel.clipsToBounds = true
            countLabel.layer.masksToBounds = true
        } else {
            countLabel.isHidden = true
        }
    }
}
