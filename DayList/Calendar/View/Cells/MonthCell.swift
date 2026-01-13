import UIKit

class MonthCell: UICollectionViewCell {
    
    static let identifier = "MonthCell"
    
    // UI Elements
    private let selectionLayer = UIView()
    private let dayLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 1. Selection Background (Rounded Square)
        selectionLayer.translatesAutoresizingMaskIntoConstraints = false
        selectionLayer.layer.cornerRadius = 8
        selectionLayer.backgroundColor = .clear
        contentView.addSubview(selectionLayer)
        
        // 2. Day Label
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentView.addSubview(dayLabel)

        NSLayoutConstraint.activate([
            // Center Label
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Selection Layer Size (Approx 36x36)
            selectionLayer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionLayer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionLayer.widthAnchor.constraint(equalToConstant: 36),
            selectionLayer.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func configure(day: String, isCurrentMonth: Bool, isSelected: Bool) {
        dayLabel.text = day
        
        if isSelected {
            // Selected: Gray Box, Bold Black Text
            selectionLayer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            dayLabel.textColor = .black
            dayLabel.font = .systemFont(ofSize: 16, weight: .bold)
        } else {
            // Normal: No Background
            selectionLayer.backgroundColor = .clear
            
            // Text Color Logic
            if isCurrentMonth {
                dayLabel.textColor = .black
            } else {
                // Previous/Next Month dates show as Light Gray
                dayLabel.textColor = UIColor.lightGray.withAlphaComponent(0.6)
            }
            dayLabel.font = .systemFont(ofSize: 16, weight: .regular)
        }
    }
}
