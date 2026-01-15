//
//  TaskTableViewCell.swift
//  DayList
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleContainerView: UIView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var checkboxButton: UIButton?
    @IBOutlet weak var arrowButton: UIButton?

    // MARK: - Callbacks
    var onCellTap: (() -> Void)?
    var onCheckboxTap: ((Bool) -> Void)?  // NEW

    // MARK: - Metadata
    private var metadataStackView: UIStackView?
    private var separatorView: UIView?
    private var isCompleted: Bool = false  // NEW

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make checkbox interactive
        checkboxButton?.isUserInteractionEnabled = true  // CHANGED
        checkboxButton?.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)  // NEW
        
        arrowButton?.isUserInteractionEnabled = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tap)
    }

    @objc private func cellTapped() {
        onCellTap?()
    }
    
    // NEW: Handle checkbox tap
    @objc private func checkboxTapped() {
        isCompleted.toggle()
        updateCheckboxAppearance()
        onCheckboxTap?(isCompleted)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeMetadata()
        onCellTap = nil
        onCheckboxTap = nil  // NEW
        isCompleted = false  // NEW
    }

    func configure(with task: Task) {
        titleLabel?.text = task.title
        isCompleted = task.isCompleted  // NEW
        
        updateCheckboxAppearance()  // NEW

        titleContainerView?.setContentHuggingPriority(.required, for: .vertical)
        titleContainerView?.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        removeMetadata()
        contentView.layoutIfNeeded()

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        var hasMetadata = false

        // DATE
        if let date = task.dateText {
            hasMetadata = true
            
            var icon = UIImageView()
            if #available(iOS 13.0, *) {
                icon = UIImageView(image: UIImage(named: "cal"))
            }
            icon.tintColor = .systemGray
            icon.contentMode = .scaleAspectFill
            icon.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                icon.widthAnchor.constraint(equalToConstant: 18),
                icon.heightAnchor.constraint(equalToConstant: 18)
            ])

            let label = UILabel()
            label.text = date
            label.font = .systemFont(ofSize: 12)
            label.textColor = .systemGray

            let dateStack = UIStackView(arrangedSubviews: [icon, label])
            dateStack.spacing = 6
            dateStack.alignment = .center
            stack.addArrangedSubview(dateStack)
        }

        // SUBTASK
        if let countText = task.subtaskCountText {
            hasMetadata = true
            let badge = UILabel()
            badge.text = countText
            badge.font = .systemFont(ofSize: 11, weight: .medium)
            badge.backgroundColor = UIColor(white: 0.95, alpha: 1)
            badge.textColor = .darkGray
            badge.textAlignment = .center
            badge.layer.cornerRadius = 4
            badge.clipsToBounds = true
            badge.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                badge.heightAnchor.constraint(equalToConstant: 18),
                badge.widthAnchor.constraint(greaterThanOrEqualToConstant: 20)
            ])

            let text = UILabel()
            text.text = countText == "1" ? "Subtask" : "Subtasks"
            text.font = .systemFont(ofSize: 12)
            text.textColor = .systemGray

            let subtaskStack = UIStackView(arrangedSubviews: [badge, text])
            subtaskStack.spacing = 4
            stack.addArrangedSubview(subtaskStack)
        }

        // LIST TAG
        if let color = task.tagColor {
            hasMetadata = true
            let box = UIView()
            box.backgroundColor = color
            box.layer.cornerRadius = 4
            box.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                box.widthAnchor.constraint(equalToConstant: 12),
                box.heightAnchor.constraint(equalToConstant: 12)
            ])
            
            if let listName = task.listName {
                let label = UILabel()
                label.text = listName
                label.font = .systemFont(ofSize: 12)
                label.textColor = .systemGray
                
                let listStack = UIStackView(arrangedSubviews: [box, label])
                listStack.spacing = 6
                stack.addArrangedSubview(listStack)
            } else {
                stack.addArrangedSubview(box)
            }
        }

        if hasMetadata {
            contentView.addSubview(stack)
            
            // FIXED: Ensure metadata aligns with title (after checkbox), not cell edge
            let leadingAnchor: NSLayoutXAxisAnchor
            if let titleLeading = titleLabel?.leadingAnchor {
                leadingAnchor = titleLeading
            } else if let checkboxTrailing = checkboxButton?.trailingAnchor {
                leadingAnchor = checkboxTrailing
            } else {
                leadingAnchor = contentView.leadingAnchor
            }
            
            let trailingAnchor = arrowButton?.leadingAnchor ?? contentView.trailingAnchor
            let topAnchor = titleContainerView?.bottomAnchor ?? titleLabel?.bottomAnchor ?? contentView.topAnchor

            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0), // No extra padding needed
                stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8),
                stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
            metadataStackView = stack
        }


        // SEPARATOR
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.9, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        
        let separatorLeading = checkboxButton?.leadingAnchor ?? contentView.leadingAnchor

        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: separatorLeading),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        separatorView = separator
    }
    
    // NEW: Update checkbox appearance based on completion state
    private func updateCheckboxAppearance() {
        if isCompleted {
            // Checked state
            checkboxButton?.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            checkboxButton?.tintColor = .systemBlue
            
            // Strikethrough and gray text
            if let text = titleLabel?.text {
                titleLabel?.attributedText = NSAttributedString(
                    string: text,
                    attributes: [
                        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        .foregroundColor: UIColor.lightGray
                    ]
                )
            }
        } else {
            // Unchecked state
            checkboxButton?.setImage(UIImage(systemName: "square"), for: .normal)
            checkboxButton?.tintColor = .systemGray
            
            // Normal text
            if let text = titleLabel?.text {
                titleLabel?.attributedText = NSAttributedString(
                    string: text,
                    attributes: [.foregroundColor: UIColor.black]
                )
            }
        }
    }

    private func removeMetadata() {
        metadataStackView?.removeFromSuperview()
        metadataStackView = nil
        separatorView?.removeFromSuperview()
        separatorView = nil
    }
}
