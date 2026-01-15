import UIKit

class TodayViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var TaskView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Data
    var tasks: [TaskEntity] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("Core Data DB Location: \(url)")
        }

        setupUI()
        setupTableView()
        setupAddTaskTextField()


        addSampleTasksIfNeeded()
        loadTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        badgeLabel.layer.cornerRadius = 5
        badgeLabel.layer.masksToBounds = true
        badgeLabel.layer.borderWidth = 1
        badgeLabel.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor

        TaskView.layer.cornerRadius = 7
        TaskView.layer.masksToBounds = true
        TaskView.layer.borderWidth = 1
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let text = addTaskTextField.text, !text.isEmpty {
            createQuickTask(title: text)
        } else {
            openCreateTask()
        }
    }
    

    private func navigateToSignIn() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = signInVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
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
        tableView.delegate = self
    }
    
    private func setupAddTaskTextField() {
        addTaskTextField.delegate = self
        addTaskTextField.returnKeyType = .done
        addTaskTextField.placeholder = "Add New Task"
    }
    
}

// MARK: - UITableViewDataSource
extension TodayViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        
        let taskEntity = tasks[indexPath.row]
        let task = Task(from: taskEntity)
        
        print("📱 Cell \(indexPath.row): Displaying '\(task.title ?? "NIL")'")
        
        cell.configure(with: task)

        cell.onCellTap = { [weak self] in
            guard let self = self else { return }
            print("Cell tapped:", task.title ?? "")
            self.openTaskDetail(taskEntity: taskEntity)
        }
        
        cell.onCheckboxTap = { [weak self] isCompleted in
            taskEntity.isCompleted = isCompleted
            CoreDataManager.shared.saveContext()
            print("Task '\(task.title ?? "")' completed: \(isCompleted)")
        }

        return cell
    }

}

// MARK: - UITableViewDelegate
extension TodayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            print("Deleting task: \(taskToDelete.title ?? "Untitled")")
            
            CoreDataManager.shared.deleteTask(taskToDelete)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            badgeLabel.text = "\(tasks.count)"
        }
    }
}

// MARK: - UITextFieldDelegate
extension TodayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addTaskTextField {
            if let text = textField.text, !text.isEmpty {
                createQuickTask(title: text)
            }
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Navigation
extension TodayViewController {

    private func openTaskDetail(taskEntity: TaskEntity) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        vc.taskEntity = taskEntity
        vc.isNewTask = false
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func openCreateTask() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        vc.taskEntity = nil
        vc.isNewTask = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func createQuickTask(title: String) {
        CoreDataManager.shared.createTask(
            title: title,
            dateText: nil,
            subtaskCount: 0,
            listName: nil,
            tagColorHex: nil
        )
        
        addTaskTextField.text = ""
        loadTasks()
        print("Quick task created: \(title)")
    }
}

// MARK: - Data
extension TodayViewController {

    func loadTasks() {
        tasks = CoreDataManager.shared.fetchAllTasks()
        
        // Debug: Print all task titles
        print("--- TASKS LOADED ---")
        for (index, taskEntity) in tasks.enumerated() {
            let task = Task(from: taskEntity)
            print("\(index + 1). Entity Title: '\(taskEntity.title ?? "NIL")' → Task Title: '\(task.title ?? "NIL")'")
        }
        print("--------------------")
        
        badgeLabel.text = "\(tasks.count)"
        tableView.reloadData()
        print("Loaded \(tasks.count) tasks from Core Data")
    }

    
    private func addSampleTasksIfNeeded() {
        if CoreDataManager.shared.fetchAllTasks().isEmpty {
            print("Adding sample tasks for current user...")
            
            CoreDataManager.shared.createTask(
                title: "Research content ideas",
                listName: nil,
                tagColorHex: nil
            )
            
            CoreDataManager.shared.createTask(
                title: "Create a database of guest a...",
                listName: nil,
                tagColorHex: nil
            )
            
            CoreDataManager.shared.createTask(
                title: "Renew driver's license",
                dateText: "22-03-22",
                subtaskCount: 1,
                listName: "Personal",
                tagColorHex: UIColor.red.hexString
            )
            
            CoreDataManager.shared.createTask(
                title: "Consult accountant",
                subtaskCount: 2,
                listName: "List 1",
                tagColorHex: UIColor.systemYellow.hexString
            )
            
            CoreDataManager.shared.createTask(
                title: "Business",
                listName: nil,
                tagColorHex: nil
            )
            
            print("Sample tasks added for current user")
        } else {
            print("Current user already has tasks, skipping sample data")
        }
    }
}
