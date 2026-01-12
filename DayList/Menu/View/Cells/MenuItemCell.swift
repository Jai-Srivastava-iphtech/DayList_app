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
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Force icon to exact position
        iconImageView.frame.origin.x = 16
        
        // Create perfect pill-shaped badge
        countLabel.layer.cornerRadius = countLabel.bounds.height / 2
    }
    
    func configure(with menuItem: MenuItem, isSelected: Bool) {
        titleLabel.text = menuItem.title
        
        // Set background color for selected state
        if isSelected {
            backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        } else {
            backgroundColor = .white
        }
        
        // Set icon - Try custom image first, fallback to system icon
        if let customIcon = menuItem.customIcon {
            iconImageView.image = customIcon
        } else if #available(iOS 13.0, *) {
            iconImageView.image = UIImage(systemName: menuItem.systemIconName)
        } else {
            iconImageView.image = UIImage(named: menuItem.systemIconName)
        }
        
        if let count = menuItem.count {
            // Style the counter badge
            countLabel.text = "\(count)"
            countLabel.isHidden = false
            
            // Pill-shaped gray badge
            countLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            countLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            countLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            countLabel.textAlignment = .center
            countLabel.clipsToBounds = true
            
            // Add padding to make it pill-shaped
            countLabel.layer.masksToBounds = true
        } else {
            countLabel.isHidden = true
        }
    }
    
}

