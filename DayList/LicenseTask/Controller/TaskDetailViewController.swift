import UIKit

class TaskDetailViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    //  Task property to receive data
    var task: Task?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
        styleButtons()
    }

    private func setupUI() {
        titleTextField.delegate = self
        descriptionTextField.delegate = self

        titleTextField.returnKeyType = .next
        descriptionTextField.returnKeyType = .done
    }
    
    private func styleButtons() {
        // Style list button
        listButton.layer.borderWidth = 1
        listButton.layer.borderColor = UIColor.systemGray3.cgColor
        listButton.layer.cornerRadius = 8.0
        listButton.contentHorizontalAlignment = .center
        listButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // Style due date button
        dueDateButton.layer.borderWidth = 1
        dueDateButton.layer.borderColor = UIColor.systemGray3.cgColor
        dueDateButton.layer.cornerRadius = 8.0
        dueDateButton.contentHorizontalAlignment = .center
        dueDateButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // Style Save Changes button
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.systemYellow.cgColor
        saveButton.layer.cornerRadius = 8.0
        
        // Style Delete button
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor.systemGray3.cgColor
        deleteButton.layer.cornerRadius = 8.0
    }

    private func populateData() {
        guard let task = task else { return }

        titleTextField.text = task.title
        descriptionTextField.text = ""   // later can be stored
        listButton.setTitle(task.listName ?? "None", for: .normal)
        dueDateButton.setTitle(task.dateText ?? "No date", for: .normal)
    }

    // MARK: - Keyboard flow
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            descriptionTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func saveTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func deleteTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
