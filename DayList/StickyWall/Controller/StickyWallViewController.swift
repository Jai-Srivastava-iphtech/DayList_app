import UIKit

class StickyWallViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    struct Note {
        let title: String
        let body: String
        let color: UIColor
        let isLarge: Bool
    }

    private let notes: [Note] = [
        Note(
            title: "Banner Ads",
            body: "Notes from the workshop:\n- Sizing matters\n- Choose distinctive imagery\n- The landing page must match the display ad",
            color: UIColor(red: 1.0, green: 0.83, blue: 0.64, alpha: 1),
            isLarge: true
        ),
        Note(
            title: "Content Strategy",
            body: "Would need time to get insights (goals, personals, budget, audits), but after, it would be good to focus on assembling my team (start with SEO specialist, then perhaps an email marketer?). Also need to brainstorm on tooling.",
            color: UIColor(red: 0.84, green: 0.93, blue: 0.94, alpha: 1),
            isLarge: false
        ),
        Note(
            title: "Social Media",
            body: "- Plan social content\n- Build content calendar\n- Plan promotion channels",
            color: UIColor(red: 1.0, green: 0.95, blue: 0.68, alpha: 1),
            isLarge: false
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            StickyNoteCell.self,
            forCellWithReuseIdentifier: "StickyNoteCell"
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - DataSource
extension StickyWallViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "StickyNoteCell",
            for: indexPath
        ) as! StickyNoteCell

        cell.configure(note: notes[indexPath.item])
        return cell
    }
}

// MARK: - Layout
extension StickyWallViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let note = notes[indexPath.item]
        let width = collectionView.bounds.width

        if note.isLarge {
            return CGSize(width: width, height: 220)
        } else {
            return CGSize(width: (width - 16) / 2, height: 200)
        }
    }
}
