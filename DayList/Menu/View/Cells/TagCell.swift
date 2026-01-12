//
// TagCell.swift
// DayList
//

import UIKit

class TagCell: UITableViewCell,
               UICollectionViewDelegate,
               UICollectionViewDataSource,
               UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    private var tags: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        selectionStyle = .none

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
    }

    func configure(tags: [String]) {
        self.tags = tags
        collectionView.reloadData()
    }

    // MARK: CollectionView data source

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return tags.count + 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TagItemCell",
            for: indexPath
        ) as! TagItemCell

        if indexPath.item < tags.count {
            // Different colors for different tags
            let color: UIColor
            if indexPath.item == 0 {
                color = UIColor(red: 0.7, green: 0.9, blue: 1.0, alpha: 1.0)  // Light blue for Tag 1
            } else {
                color = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)  // Light pink for Tag 2
            }
            cell.configure(text: tags[indexPath.item], isAddButton: false, color: color)
        } else {
            cell.configure(text: "+ Add Tag", isAddButton: true, color: UIColor(white: 0.92, alpha: 1.0))
        }
        return cell
    }

    // MARK: Flow layout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 35)
    }
}
