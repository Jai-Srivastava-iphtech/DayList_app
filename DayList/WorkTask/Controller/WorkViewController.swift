import UIKit

class WorkViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerContainerView: UIView!

    // MARK: - Data
    var tasks: [Task] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        badgeLabel.layer.cornerRadius = 6
        badgeLabel.layer.masksToBounds = true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UI Setup
extension WorkViewController {

    private func setupUI() {
        titleLabel.text = "Work"
        
        if #available(iOS 13.0, *) {
            backButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        } else {
            backButton.setTitle("Menu", for: .normal)
        }
        backButton.tintColor = .black
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        // REMOVED: setupAddTaskHeader()
        // We removed this line so it won't create the duplicate button
    }
}

// MARK: - DataSource & Delegate
extension WorkViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
}

// MARK: - Data
extension WorkViewController {
    func loadTasks() {
        tasks = [
            Task(title: "Research content ideas"),
            Task(title: "Create a database of guest authors"),
            Task(title: "Create job posting for SEO specialist"),
            Task(title: "Request design assets for landing page",
                 dateText: "22-03-22",
                 subtaskCountText: "2",
                 listName: "Work",
                 tagColor: .systemTeal),
            Task(title: "Prepare collaboration proposals"),
            Task(title: "Adopt a link tracker tool")
        ]
        
        badgeLabel.text = "\(tasks.count)"
        tableView.reloadData()
    }
}
