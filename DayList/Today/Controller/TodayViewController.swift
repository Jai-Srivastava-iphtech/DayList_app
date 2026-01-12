import UIKit

class TodayViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var TaskView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

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

        badgeLabel.layer.cornerRadius = 5
        badgeLabel.layer.masksToBounds = true

        TaskView.layer.cornerRadius = 7
        TaskView.layer.masksToBounds = true
    }
}

// MARK: - UI Setup
extension TodayViewController {

    private func setupUI() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    private func setupTableView() {
        tableView.dataSource = self
//        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension TodayViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TaskCell",
            for: indexPath
        ) as! TaskTableViewCell

        let task = tasks[indexPath.row]
        cell.configure(with: task)

        //  IMPORTANT: handle tap from cell
        cell.onCellTap = { [weak self] in
            guard let self = self else { return }

            print(" Cell tapped:", task.title)

            // Open detail screen ONLY for this task
            if task.title == "Renew driver's license" {
                self.openTaskDetail(task: task)
            }
        }

        return cell
    }
}

// MARK: - Navigation
extension TodayViewController {

    private func openTaskDetail(task: Task) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(
            withIdentifier: "TaskDetailViewController"
        ) as! TaskDetailViewController

        //  Pass the task data to detail screen
        vc.task = task

        //  Full screen presentation (covers whole screen)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - Data
extension TodayViewController {

    func loadTasks() {
        tasks = [
            Task(
                title: "Research content ideas",
                dateText: nil,
                subtaskCountText: nil,
                listName: nil,
                tagColor: nil
            ),
            Task(
                title: "Create a database of guest a...",
                dateText: nil,
                subtaskCountText: nil,
                listName: nil,
                tagColor: nil
            ),
            Task(
                title: "Renew driver's license",
                dateText: "22-03-22",
                subtaskCountText: "1",
                listName: "Personal",
                tagColor: .red
            ),
            Task(
                title: "Consult accountant",
                dateText: nil,
                subtaskCountText: "2",
                listName: "List 1",
                tagColor: .systemYellow
            ),
            Task(
                title: "Business",
                dateText: nil,
                subtaskCountText: nil,
                listName: nil,
                tagColor: nil
            )
        ]

        badgeLabel.text = "\(tasks.count)"
        tableView.reloadData()
    }
}
