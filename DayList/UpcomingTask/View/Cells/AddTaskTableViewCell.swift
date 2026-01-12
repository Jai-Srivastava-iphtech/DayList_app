//
//  AddTaskTableViewCell.swift
//  DayList
//

import UIKit

class AddTaskTableViewCell: UITableViewCell, UITextFieldDelegate {

    var onAddTask: ((String) -> Void)?

    // 1. Container: White Background + Gray Border
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white // White background
        v.layer.cornerRadius = 8
        v.layer.borderWidth = 1 // Add border
        v.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor // Light Gray Border
        return v
    }()
    
    // 2. Plus Icon
    private let plusIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            iv.image = UIImage(systemName: "plus")
        }
        iv.tintColor = .gray // Gray icon
        return iv
    }()
    
    // 3. Text Field
    private let taskTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Add New Task"
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        tf.returnKeyType = .done
        return tf
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
        backgroundColor = .clear
        
        taskTextField.delegate = self
        
        contentView.addSubview(containerView)
        containerView.addSubview(plusIcon)
        containerView.addSubview(taskTextField)
        
        NSLayoutConstraint.activate([
            // Container Box
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Icon Position
            plusIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            plusIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            plusIcon.widthAnchor.constraint(equalToConstant: 18),
            plusIcon.heightAnchor.constraint(equalToConstant: 18),
            
            // Text Field Position
            taskTextField.leadingAnchor.constraint(equalTo: plusIcon.trailingAnchor, constant: 12),
            taskTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            taskTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            taskTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            onAddTask?(text)
            textField.text = ""
        }
        return true
    }
}
