//
//  NewListCreationCell.swift
//  DayList
//

import UIKit

class NewListCreationCell: UITableViewCell, UITextFieldDelegate {

    // MARK: - Outer container
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        return v
    }()

    // MARK: - Input box
    private let inputBox: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0.97, alpha: 1)
        v.layer.cornerRadius = 8
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        return v
    }()

    private let colorIndicator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 6
        v.backgroundColor = .systemBlue
        return v
    }()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "List Name"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .darkGray
        return tf
    }()

    // MARK: - Color picker
    private let colorStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 14
        sv.alignment = .center
        return sv
    }()

    private let colors: [UIColor] = [
        .systemRed,
        .systemPurple,
        UIColor(red: 0.5, green: 0.4, blue: 0.9, alpha: 1),
        .systemBlue,
        UIColor(red: 0.4, green: 0.8, blue: 0.95, alpha: 1),
        .systemGreen,
        .systemYellow,
        .systemOrange
    ]

    private var selectedColor: UIColor = .systemBlue

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        textField.delegate = self

        contentView.addSubview(containerView)
        containerView.addSubview(inputBox)
        containerView.addSubview(colorStackView)

        inputBox.addSubview(colorIndicator)
        inputBox.addSubview(textField)

        NSLayoutConstraint.activate([

            // Container
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            // Input box
            inputBox.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            inputBox.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            inputBox.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            inputBox.heightAnchor.constraint(equalToConstant: 44),

            // Color indicator
            colorIndicator.leadingAnchor.constraint(equalTo: inputBox.leadingAnchor, constant: 12),
            colorIndicator.centerYAnchor.constraint(equalTo: inputBox.centerYAnchor),
            colorIndicator.widthAnchor.constraint(equalToConstant: 20),
            colorIndicator.heightAnchor.constraint(equalToConstant: 20),

            // Text field
            textField.leadingAnchor.constraint(equalTo: colorIndicator.trailingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: inputBox.trailingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: inputBox.centerYAnchor),

            // Color row
            colorStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            colorStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            colorStackView.topAnchor.constraint(equalTo: inputBox.bottomAnchor, constant: 14),
            colorStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14),
            colorStackView.heightAnchor.constraint(equalToConstant: 20)
        ])

        setupColors()
    }

    // MARK: - Colors
    private func setupColors() {
        colorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for color in colors {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = color
            v.layer.cornerRadius = 6
            v.widthAnchor.constraint(equalToConstant: 20).isActive = true
            v.heightAnchor.constraint(equalToConstant: 20).isActive = true

            let tap = UITapGestureRecognizer(target: self, action: #selector(colorTapped(_:)))
            v.addGestureRecognizer(tap)
            v.isUserInteractionEnabled = true

            colorStackView.addArrangedSubview(v)
        }
    }

    @objc private func colorTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        selectedColor = view.backgroundColor ?? .systemBlue
        colorIndicator.backgroundColor = selectedColor
    }

    // MARK: - Public
    func configure() {
        textField.text = ""
        colorIndicator.backgroundColor = selectedColor
        textField.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
