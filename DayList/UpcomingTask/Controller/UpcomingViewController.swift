//
//  UpcomingViewController.swift
//  DayList
//

import UIKit

class TaskSection {
    var title: String
    var tasks: [Task]
    
    init(title: String, tasks: [Task]) {
        self.title = title
        self.tasks = tasks
    }
}

// 1. Add UIGestureRecognizerDelegate
class UpcomingViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var sections: [TaskSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
// Setup the smart gesture
        loadData()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        titleLabel.text = "Upcoming"
        badgeLabel.text = "12"
        badgeLabel.layer.cornerRadius = 6
        badgeLabel.layer.masksToBounds = true
        
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
        
        // Register Cell
        tableView.register(AddTaskTableViewCell.self, forCellReuseIdentifier: "AddTaskCell")
    }

    
    
    private func loadData() {
        let todayTasks = [
            Task(title: "Research content ideas"),
            Task(title: "Create a database of guest authors"),
            Task(title: "Renew driver's license"),
            Task(title: "Consult accountant"),
            Task(title: "Print business card")
        ]
        
        let tomorrowTasks = [
            Task(title: "Create job posting for SEO specialist"),
            Task(title: "Request design assets for landing page"),
            Task(title: "Prepare collaboration proposals")
        ]
        
        let thisWeekTasks = [
            Task(title: "Research content ideas"),
            Task(title: "Create a database of guest authors"),
            Task(title: "Renew driver's license"),
            Task(title: "Consult accountant"),
            Task(title: "Print business card")
        ]
        
        sections = [
            TaskSection(title: "Today", tasks: todayTasks),
            TaskSection(title: "Tomorrow", tasks: tomorrowTasks),
            TaskSection(title: "This Week", tasks: thisWeekTasks)
        ]
        
        tableView.reloadData()
    }
    
    private func addNewTask(title: String, inSection sectionIndex: Int) {
        let newTask = Task(title: title)
        sections[sectionIndex].tasks.append(newTask)
        
        let row = sections[sectionIndex].tasks.count
        let indexPath = IndexPath(row: row, section: sectionIndex)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        let total = sections.reduce(0) { $0 + $1.tasks.count }
        badgeLabel.text = "\(total)"
    }
}

// MARK: - TableView DataSource & Delegate
extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tasks.count + 1
    }
    
    // 5. Prevent TableView from highlighting the Input Row
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskCell", for: indexPath) as! AddTaskTableViewCell
            cell.onAddTask = { [weak self] newTitle in
                self?.addNewTask(title: newTitle, inSection: indexPath.section)
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = sections[indexPath.section].tasks[indexPath.row - 1]
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.text = sections[section].title
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
