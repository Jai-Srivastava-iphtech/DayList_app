import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        selectionStyle = .none
        
        colorView.layer.cornerRadius = 4
        
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Create perfect pill-shaped badge
        countLabel.layer.cornerRadius = countLabel.bounds.height / 2
    }
    
    func configure(color: UIColor, title: String, count: Int) {
        colorView.backgroundColor = color
        titleLabel.text = title
        
        // Style the counter badge
        countLabel.text = "\(count)"
        countLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        countLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        countLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        countLabel.textAlignment = .center
        countLabel.clipsToBounds = true
        countLabel.layer.masksToBounds = true
    }
}
