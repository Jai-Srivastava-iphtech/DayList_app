//
//  SeparatorCell.swift
//  DayList
//

import UIKit

class SeparatorCell: UITableViewCell {
    
    private let lineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.9, alpha: 1) // Faint gray color
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            // Height of the line
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            // Center the line vertically
            lineView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Left and Right padding (Inset)
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
