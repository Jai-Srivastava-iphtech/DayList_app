import UIKit

class WeekEventCell: UICollectionViewCell {
    
    static let identifier = "WeekEventCell"
    
    private let eventStack = UIStackView()
    private let separatorLine = UIView()
    
    // Toggle the right-side line (hide for the last column)
    var showSeparator: Bool = true {
        didSet { separatorLine.isHidden = !showSeparator }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 1. Stack View for Events
        eventStack.axis = .vertical
        eventStack.spacing = 10 // Space between events
        eventStack.alignment = .fill
        eventStack.distribution = .fillEqually
        eventStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventStack)
        
        // 2. Vertical Divider Line
        separatorLine.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            // Stack: Leave padding on sides
            eventStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            eventStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            eventStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            // Allow stack to determine its own height, but don't overflow bottom
            eventStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            // Separator: Stick to right edge
            separatorLine.widthAnchor.constraint(equalToConstant: 1),
            separatorLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(events: [WeekEvent]) {
        // Clear old events before reusing cell
        eventStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for event in events {
            // Create the colored box
            let eventBox = UIView()
            eventBox.backgroundColor = event.color
            eventBox.layer.cornerRadius = 10
            eventBox.translatesAutoresizingMaskIntoConstraints = false
            
            // Fixed height for events to match the "block" look
            eventBox.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            // Label inside box
            let label = UILabel()
            label.text = event.title
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.textColor = UIColor.black.withAlphaComponent(0.7)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            eventBox.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: eventBox.topAnchor, constant: 8),
                label.leadingAnchor.constraint(equalTo: eventBox.leadingAnchor, constant: 8)
            ])
            
            eventStack.addArrangedSubview(eventBox)
        }
        
        // Add an empty spacer at the bottom to push everything up
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        eventStack.addArrangedSubview(spacer)
    }
}
