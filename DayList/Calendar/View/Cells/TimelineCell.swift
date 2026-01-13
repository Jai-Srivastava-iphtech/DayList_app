import UIKit

class TimelineCell: UITableViewCell {
    
    static let identifier = "TimelineCell"
    
    // UI Elements
    private let timeLabel = UILabel()
    private let eventContainer = UIView()
    private let eventTitleLabel = UILabel()
    private let bottomSeparator = UIView() // The horizontal line
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        // 1. Time Label (e.g. "09:00 AM")
        timeLabel.font = .systemFont(ofSize: 12, weight: .medium)
        timeLabel.textColor = .darkGray
        timeLabel.textAlignment = .center
        timeLabel.numberOfLines = 2
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
        
        // 2. Event Container (The colored box)
        eventContainer.layer.cornerRadius = 8
        eventContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventContainer)
        
        // 3. Event Title
        eventTitleLabel.font = .systemFont(ofSize: 14, weight: .bold) // Bold text like image
        eventTitleLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        eventTitleLabel.numberOfLines = 0 // Allow multiline text
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        eventContainer.addSubview(eventTitleLabel)
        
        // 4. Horizontal Separator Line (Between times)
        bottomSeparator.backgroundColor = UIColor(white: 0.9, alpha: 1.0) // Faint Gray
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            // --- Time Label Layout ---
            // Pinned to Top-Left
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            timeLabel.widthAnchor.constraint(equalToConstant: 50),
            
            // --- Event Card Layout ---
            // Right of Time Label
            eventContainer.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 16),
            eventContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            // Leave space at bottom for the line
            eventContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Title Padding inside Card
            eventTitleLabel.topAnchor.constraint(equalTo: eventContainer.topAnchor, constant: 12),
            eventTitleLabel.leadingAnchor.constraint(equalTo: eventContainer.leadingAnchor, constant: 12),
            eventTitleLabel.trailingAnchor.constraint(equalTo: eventContainer.trailingAnchor, constant: -12),
            eventTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: eventContainer.bottomAnchor, constant: -12),
            
            // --- Separator Line Layout ---
            // Sticks to the bottom of the cell
            bottomSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16), // Or 0 if you want full width
            bottomSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            bottomSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1) // Thin line
        ])
    }
    
    func configure(time: String, event: String?, color: UIColor?) {
        timeLabel.text = time
        
        if let eventText = event {
            // SHOW EVENT
            eventContainer.isHidden = false
            eventContainer.backgroundColor = color
            eventTitleLabel.text = eventText
            
            // If there is an event, you might want to hide the separator or keep it?
            // The image shows separators between TIME SLOTS.
            bottomSeparator.isHidden = false
        } else {
            // EMPTY SLOT
            eventContainer.isHidden = true
            eventContainer.backgroundColor = .clear
            eventTitleLabel.text = ""
            
            // Keep separator visible to show the "Grid"
            bottomSeparator.isHidden = false
        }
    }
}
