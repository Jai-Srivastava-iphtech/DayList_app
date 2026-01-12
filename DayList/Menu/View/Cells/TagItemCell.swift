//
// TagItemCell.swift
// DayList
//

import UIKit

class TagItemCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        clipsToBounds = true
        tagLabel.textAlignment = .center
        tagLabel.font = UIFont.systemFont(ofSize: 14)
        tagLabel.textColor = .darkGray
    }

    func configure(text: String, isAddButton: Bool, color: UIColor) {
        tagLabel.text = text
        backgroundColor = color
    }
}
