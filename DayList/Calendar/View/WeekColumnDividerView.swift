import UIKit

final class WeekColumnDividerView: UICollectionReusableView {

    // 👇 THIS IS WHAT WAS MISSING
    static let kind = "WeekColumnDividerView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        let columnWidth = rect.width / 7.0
        context.setStrokeColor(UIColor.systemGray5.cgColor)
        context.setLineWidth(1)

        for i in 1..<7 {
            let x = CGFloat(i) * columnWidth
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: rect.height))
        }

        context.strokePath()
    }
}
