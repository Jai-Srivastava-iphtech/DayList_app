//
// AddButtonCell.swift
// DayList
//

import UIKit

class AddButtonCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        selectionStyle = .none
        iconImageView.tintColor = .systemGray
        titleLabel.textColor = .systemGray
        titleLabel.font = UIFont.systemFont(ofSize: 16)
    }

    func configure(title: String) {
        titleLabel.text = title

        if #available(iOS 13.0, *) {
            iconImageView.image = UIImage(systemName: "plus")
        }

        // Always show icon and title
        iconImageView.isHidden = false
        titleLabel.isHidden = false
    }
}
