//
//  TaskDetailViewController.swift
//  DayList
//

import UIKit

class TaskDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    var taskEntity: TaskEntity?
    var isNewTask = false
    
    private var selectedList: String?
    private var selectedDate: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadTaskData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Add borders to buttons
        addBorderToButton(listButton)
        addBorderToButton(dateButton)
        addBorderToButton(cancelButton)
        addBorderToButton(saveButton)
        
        // Center button text
        listButton.contentHorizontalAlignment = .center
        dateButton.contentHorizontalAlignment = .center
        
        // Set button initial states
        listButton.setTitle("Select List", for: .normal)
        dateButton.setTitle("Select Date", for: .normal)
        
        // Configure placeholders
        titleTextField.placeholder = "Task title"
        descriptionTextField.placeholder = "Description"
    }
    
    private func addBorderToButton(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 8
    }
    
    private func loadTaskData() {
        guard let task = taskEntity else {
            // New task mode - everything is empty
            isNewTask = true
            titleTextField.text = ""
            descriptionTextField.text = ""
            return
        }
        
        // Edit mode - load existing data
        isNewTask = false
        titleTextField.text = task.title
        descriptionTextField.text = task.taskDescription
        
        // Load list
        if let list = task.listName {
            selectedList = list
            updateListButton(with: list)
        } else {
            listButton.setTitle("Select List", for: .normal)
            listButton.backgroundColor = .clear
        }
        
        // Load date
        if let date = task.dateText {
            selectedDate = date
            dateButton.setTitle(date, for: .normal)
        } else {
            dateButton.setTitle("Select Date", for: .normal)
        }
    }
    
    // MARK: - Button Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func listButtonTapped(_ sender: UIButton) {
        showListPicker()
    }
    
    @IBAction func dateButtonTapped(_ sender: UIButton) {
        showDatePicker()
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert("Please enter a task title")
            return
        }
        
        let description = descriptionTextField.text
        
        // Get tag color based on selected list
        let tagColor = getColorForList(selectedList)
        
        if isNewTask {
            // Create new task
            let newTask = CoreDataManager.shared.createTask(
                title: title,
                dateText: selectedDate,
                subtaskCount: 0,
                listName: selectedList,
                tagColorHex: tagColor
            )
            
            // Update with description
            if let desc = description, !desc.isEmpty {
                newTask.taskDescription = desc
                CoreDataManager.shared.saveContext()
            }
            
            print("New task created: \(title)")
            
        } else {
            // Update existing task
            guard let task = taskEntity else { return }
            
            task.title = title
            task.taskDescription = description
            task.dateText = selectedDate
            task.listName = selectedList
            task.tagColorHex = tagColor
            
            CoreDataManager.shared.saveContext()
            
            print("Task updated: \(title)")
        }
        
        // Go back
        dismiss(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        if isNewTask {
            dismiss(animated: true)
        } else {
            loadTaskData()
        }
    }
    
    // MARK: - List Color Helper
    private func getColorForList(_ listName: String?) -> String? {
        guard let list = listName else { return nil }
        
        switch list {
        case "Personal":
            return UIColor.systemRed.hexString
        case "Work":
            return UIColor.systemBlue.hexString
        case "List 1":
            return UIColor.systemYellow.hexString
        case "Shopping":
            return UIColor.systemGreen.hexString
        case "Important":
            return UIColor.systemOrange.hexString
        default:
            return UIColor.systemGray.hexString
        }
    }
    
    private func updateListButton(with listName: String) {
        listButton.setTitle(listName, for: .normal)
        
        // Set button background color based on list
        switch listName {
        case "Personal":
            listButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
        case "Work":
            listButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        case "List 1":
            listButton.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
        case "Shopping":
            listButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        case "Important":
            listButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
        default:
            listButton.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        }
    }
    
    // MARK: - Pickers
    private func showListPicker() {
        let alert = UIAlertController(title: "Select List", message: nil, preferredStyle: .actionSheet)
        
        let lists = [
            ("Personal", UIColor.systemRed),
            ("Work", UIColor.systemBlue),
            ("List 1", UIColor.systemYellow),
            ("Shopping", UIColor.systemGreen),
            ("Important", UIColor.systemOrange)
        ]
        
        for (listName, color) in lists {
            let action = UIAlertAction(title: listName, style: .default) { [weak self] _ in
                self?.selectedList = listName
                self?.updateListButton(with: listName)
            }
            
            // Add colored icon to action
            if let image = createColoredCircle(color: color) {
                action.setValue(image, forKey: "image")
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Remove List", style: .destructive) { [weak self] _ in
            self?.selectedList = nil
            self?.listButton.setTitle("Select List", for: .normal)
            self?.listButton.backgroundColor = .clear
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func createColoredCircle(color: UIColor) -> UIImage? {
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    private func showDatePicker() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        // Create date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Get start of TODAY (midnight) to prevent selecting past dates
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Set minimum date to START OF TODAY
        datePicker.minimumDate = today
        
        // Set maximum date to 50 years from TODAY
        let maxDate = calendar.date(byAdding: .year, value: 50, to: today)
        datePicker.maximumDate = maxDate
        
        // Set default selected date
        if let previousDate = selectedDate,
           let date = convertStringToDate(previousDate),
           date >= today {
            // Only use previous date if it's today or in the future
            datePicker.date = date
        } else {
            // Default to today if no valid previous date
            datePicker.date = today
        }
        
        // Add picker to alert
        alertController.view.addSubview(datePicker)
        
        // Setup constraints - Position picker at TOP
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 20),
            datePicker.widthAnchor.constraint(equalToConstant: 270),
            datePicker.heightAnchor.constraint(equalToConstant: 216)
        ])
        
        // Done action
        let doneAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yy"
            let dateString = formatter.string(from: datePicker.date)
            self?.selectedDate = dateString
            self?.dateButton.setTitle(dateString, for: .normal)
        }
        
        // Remove action
        let removeAction = UIAlertAction(title: "Remove Date", style: .destructive) { [weak self] _ in
            self?.selectedDate = nil
            self?.dateButton.setTitle("Select Date", for: .normal)
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(doneAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

    // Helper method to convert date string back to Date
    private func convertStringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        return formatter.date(from: dateString)
    }

    
    @objc private func removeDateTapped() {
        selectedDate = nil
        dateButton.setTitle("Select Date", for: .normal)
        dismiss(animated: true)
    }
    
    // MARK: - Helper
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
