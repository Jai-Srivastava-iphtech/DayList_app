import UIKit

class StickyNoteCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black

        bodyLabel.font = UIFont.systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = .darkGray

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(note: StickyWallViewController.Note) {
        titleLabel.text = note.title
        bodyLabel.text = note.body
        contentView.backgroundColor = note.color
    }
}
