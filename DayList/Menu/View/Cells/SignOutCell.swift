//
//  SignOutCell.swift
//  DayList
//

import UIKit

class SignOutCell: UITableViewCell {
    
    // The yellow button
    private let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Sign Out", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.backgroundColor = UIColor(red: 1.0, green: 0.85, blue: 0.3, alpha: 1.0) // Golden Yellow
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    // Callback for when button is tapped
    var onSignOutTapped: (() -> Void)?
    
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
        backgroundColor = .clear
        
        contentView.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Height
            button.heightAnchor.constraint(equalToConstant: 50),
            
            // Margins
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Bottom padding
        ])
    }
    
    @objc private func buttonTapped() {
        onSignOutTapped?()
    }
}
