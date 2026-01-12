import UIKit

class TaskTableViewCell: UITableViewCell {

    // MARK: - Outlets (made optional for safety)
    @IBOutlet weak var titleContainerView: UIView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var checkboxButton: UIButton?
    @IBOutlet weak var arrowButton: UIButton?

    // MARK: - Callbacks
    var onCellTap: (() -> Void)?

    // MARK: - Metadata
    private var metadataStackView: UIStackView?
    private var separatorView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Debug print to see if outlets are connected
        print("awakeFromNib called")
        print("titleLabel: \(titleLabel != nil)")
        print("checkboxButton: \(checkboxButton != nil)")
        print("arrowButton: \(arrowButton != nil)")

        //  Disable buttons eating touches (safely)
        checkboxButton?.isUserInteractionEnabled = false
        arrowButton?.isUserInteractionEnabled = false

        // Add tap recognizer to whole cell
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tap)
    }

    @objc private func cellTapped() {
        print(" CELL TAP DETECTED")
        onCellTap?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeMetadata()
        onCellTap = nil
    }

    func configure(with task: Task) {
        
        print(" Configuring cell with task: \(task.title)")

        titleLabel?.text = task.title

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

            let icon = UIImageView(image: UIImage(named: "biugyffb"))
            icon.contentMode = .scaleAspectFit
            icon.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                icon.widthAnchor.constraint(equalToConstant: 20),
                icon.heightAnchor.constraint(equalToConstant: 20)
            ])

            let label = UILabel()
            label.text = date
            label.font = .systemFont(ofSize: 12)
            label.textColor = .systemGray

            let dateStack = UIStackView(arrangedSubviews: [icon, label])
            dateStack.spacing = 4
            dateStack.alignment = .center

            stack.addArrangedSubview(dateStack)
        }

        // SUBTASK
        if let countText = task.subtaskCountText {
            hasMetadata = true

            let badge = UILabel()
            badge.text = countText
            badge.font = .systemFont(ofSize: 11, weight: .medium)
            badge.backgroundColor = .systemGray5
            badge.textColor = .darkGray
            badge.textAlignment = .center
            badge.layer.cornerRadius = 6
            badge.clipsToBounds = true
            badge.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                badge.heightAnchor.constraint(equalToConstant: 18),
                badge.widthAnchor.constraint(greaterThanOrEqualToConstant: 22)
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
        if let list = task.listName,
           let color = task.tagColor {
            hasMetadata = true

            let box = UIView()
            box.backgroundColor = color
            box.layer.cornerRadius = 4
            box.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                box.widthAnchor.constraint(equalToConstant: 12),
                box.heightAnchor.constraint(equalToConstant: 12)
            ])

            let label = UILabel()
            label.text = list
            label.font = .systemFont(ofSize: 12)
            label.textColor = .systemGray

            let listStack = UIStackView(arrangedSubviews: [box, label])
            listStack.spacing = 6

            stack.addArrangedSubview(listStack)
        }

        if hasMetadata {
            contentView.addSubview(stack)
            
            // Safe constraint setup with fallbacks
            let leadingAnchor = titleLabel?.leadingAnchor ?? contentView.leadingAnchor
            let trailingAnchor = arrowButton?.leadingAnchor ?? contentView.trailingAnchor
            let topAnchor = titleContainerView?.bottomAnchor ?? titleLabel?.bottomAnchor ?? contentView.topAnchor

            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: leadingAnchor),
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

    private func removeMetadata() {
        metadataStackView?.removeFromSuperview()
        metadataStackView = nil

        separatorView?.removeFromSuperview()
        separatorView = nil
    }
}
