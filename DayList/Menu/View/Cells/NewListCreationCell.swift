//
//  NewListCreationCell.swift
//  DayList
//

import UIKit

class NewListCreationCell: UITableViewCell, UITextFieldDelegate {

    // MARK: - UI Components
    
    // 1. The White Card Container
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        return v
    }()

    // 2. The Gray Background Box (Acts as the wrapper)
    private let inputBackgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        // Light gray color
        v.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        v.layer.cornerRadius = 10 // Slightly rounder corners
        return v
    }()

    // 3. The Blue Square Indicator
    private let inputColorIndicator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 6
        v.backgroundColor = .systemBlue
        return v
    }()

    // 4. The Text Field (Transparent, sits inside the gray box)
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "List Name"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .darkGray
        tf.backgroundColor = .clear // Transparent background
        tf.borderStyle = .none      // No borders
        tf.returnKeyType = .done
        return tf
    }()

    // 5. The Color Row
    private let colorStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fillEqually
        sv.alignment = .center
        return sv
    }()

    // MARK: - Properties
    private let colors: [UIColor] = [
        .systemRed, .systemPurple, UIColor(red: 0.5, green: 0.4, blue: 0.9, alpha: 1),
        .systemBlue, UIColor(red: 0.4, green: 0.8, blue: 0.95, alpha: 1),
        .systemGreen, .systemYellow, .systemOrange
    ]

    private var selectedColor: UIColor = .systemBlue
    private var selectionRings: [UIView] = []

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder); setupUI() }

    // MARK: - Layout
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        nameTextField.delegate = self

        // 1. Add Main Container (White Card)
        contentView.addSubview(containerView)
        
        // 2. Add Wrapper & Color Stack to Container
        containerView.addSubview(inputBackgroundView)
        containerView.addSubview(colorStackView)

        // 3. Add Elements INSIDE the Gray Wrapper
        inputBackgroundView.addSubview(inputColorIndicator)
        inputBackgroundView.addSubview(nameTextField)

        NSLayoutConstraint.activate([
            // --- Container Constraints ---
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            // --- Gray Input Box Constraints ---
            inputBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            inputBackgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            inputBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            inputBackgroundView.heightAnchor.constraint(equalToConstant: 50), // Fixed Height: 50pts

            // --- Blue Indicator Constraints (Inside Gray Box) ---
            inputColorIndicator.widthAnchor.constraint(equalToConstant: 20),
            inputColorIndicator.heightAnchor.constraint(equalToConstant: 20),
            inputColorIndicator.centerYAnchor.constraint(equalTo: inputBackgroundView.centerYAnchor),
            inputColorIndicator.leadingAnchor.constraint(equalTo: inputBackgroundView.leadingAnchor, constant: 12),

            // --- Text Field Constraints (Inside Gray Box) ---
            nameTextField.leadingAnchor.constraint(equalTo: inputColorIndicator.trailingAnchor, constant: 12),
            nameTextField.trailingAnchor.constraint(equalTo: inputBackgroundView.trailingAnchor, constant: -12),
            nameTextField.topAnchor.constraint(equalTo: inputBackgroundView.topAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: inputBackgroundView.bottomAnchor),

            // --- Color Row Constraints ---
            colorStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            colorStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            colorStackView.topAnchor.constraint(equalTo: inputBackgroundView.bottomAnchor, constant: 15),
            colorStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            colorStackView.heightAnchor.constraint(equalToConstant: 30)
        ])

        setupColorRow()
    }

    private func setupColorRow() {
        colorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        selectionRings.removeAll()

        for (index, color) in colors.enumerated() {
            let wrapper = UIView()
            wrapper.translatesAutoresizingMaskIntoConstraints = false
            
            // Selection Ring
            let ring = UIView()
            ring.translatesAutoresizingMaskIntoConstraints = false
            ring.layer.cornerRadius = 8
            ring.layer.borderWidth = 2
            ring.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
            ring.backgroundColor = .clear
            ring.isHidden = true
            
            // Color Circle
            let colorView = UIView()
            colorView.translatesAutoresizingMaskIntoConstraints = false
            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 6
            
            wrapper.addSubview(ring)
            wrapper.addSubview(colorView)
            
            NSLayoutConstraint.activate([
                ring.widthAnchor.constraint(equalToConstant: 30),
                ring.heightAnchor.constraint(equalToConstant: 30),
                ring.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
                ring.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
                
                colorView.widthAnchor.constraint(equalToConstant: 20),
                colorView.heightAnchor.constraint(equalToConstant: 20),
                colorView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
                colorView.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor)
            ])
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(colorTapped(_:)))
            wrapper.addGestureRecognizer(tap)
            wrapper.isUserInteractionEnabled = true
            wrapper.tag = index
            
            selectionRings.append(ring)
            colorStackView.addArrangedSubview(wrapper)
        }
        updateSelectionState()
    }

    @objc private func colorTapped(_ gesture: UITapGestureRecognizer) {
        guard let wrapper = gesture.view else { return }
        selectedColor = colors[wrapper.tag]
        updateSelectionState()
    }
    
    private func updateSelectionState() {
        inputColorIndicator.backgroundColor = selectedColor
        for (index, ring) in selectionRings.enumerated() {
            ring.isHidden = (colors[index] != selectedColor)
        }
    }
    
    func configure() {
        nameTextField.text = ""
        selectedColor = .systemBlue
        updateSelectionState()
        nameTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
