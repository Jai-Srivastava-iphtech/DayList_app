//
//  MenuViewController.swift
//  DayList
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!

    // MARK: - Menu Structure
    enum MenuRow {
        case header(String)
        case menuItem(MenuItem)
        case listItem(color: UIColor, title: String, count: Int)
        case addButton(String)
        case newListCreation
        case tags([String])
        case settings
        case signOut
        case spacer
    }

    private var menuData: [MenuRow] = []
    private var selectedIndexPath: IndexPath?
    private var isAddListExpanded = false

    // Standard Menu Items
    private let menuItems: [MenuItem] = [
        MenuItem(title: "Upcoming", customIconName: "icon_upcoming", systemIcon: "chevron.right.2", count: 12, destination: .upcoming),
        MenuItem(title: "Today", customIconName: "icon_today", systemIcon: "list.bullet", count: 5, destination: .today),
        MenuItem(title: "Calendar", customIconName: "icon_calendar", systemIcon: "calendar", count: nil, destination: .calendar),
        MenuItem(title: "Sticky Wall", customIconName: "icon_sticky_wall", systemIcon: "note.text", count: nil, destination: .stickyWall)
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupData()
    }

    // MARK: - Setup
    private func setupSearchBar() {
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        searchContainerView.layer.cornerRadius = 8
        searchContainerView.backgroundColor = .white
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Style: Single lines, faint gray, with standard left padding
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 54, bottom: 0, right: 0)
        
        tableView.backgroundColor = .white
        // Bottom padding so Sign Out isn't cut off
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)

        // Register Programmatic Cells
        tableView.register(NewListCreationCell.self, forCellReuseIdentifier: "NewListCreationCell")
        tableView.register(SignOutCell.self, forCellReuseIdentifier: "SignOutCell")
    }

    private func setupData() {
        menuData = [
            // Section 1: Tasks
            .header("TASKS"),
            .menuItem(menuItems[0]),
            .menuItem(menuItems[1]),
            .menuItem(menuItems[2]),
            .menuItem(menuItems[3]),
            
            .spacer, // Gap
            
            // Section 2: Lists
            .header("LISTS"),
            .listItem(color: .systemPink, title: "Personal", count: 3),
            .listItem(color: .systemTeal, title: "Work", count: 6),
            .listItem(color: .systemYellow, title: "List 1", count: 3),
            
            .spacer, // Gap
            
            .addButton("Add New List"),
            
            // Section 3: Tags
            .header("TAGS"),
            .tags(["Tag 1", "Tag 2"]),
            
            .spacer, // Gap
            
            // Section 4: Settings & Exit
            .settings,
            .spacer,
            .signOut
        ]
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Helper to hide separator for specific rows
        let hideSeparator = { (cell: UITableViewCell) in
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }

        switch menuData[indexPath.row] {

        case .header(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.configure(title: title)
            // Make headers bold
            cell.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            hideSeparator(cell)
            return cell

        case .menuItem(let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
            cell.configure(with: item, isSelected: indexPath == selectedIndexPath)
            return cell

        case .listItem(let color, let title, let count):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
            cell.configure(color: color, title: title, count: count)
            return cell

        case .addButton(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddButtonCell", for: indexPath) as! AddButtonCell
            cell.configure(title: title)
            hideSeparator(cell)
            return cell

        case .newListCreation:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewListCreationCell", for: indexPath) as! NewListCreationCell
            cell.configure()
            hideSeparator(cell)
            return cell

        case .tags(let tags):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagCell
            cell.configure(tags: tags)
            // Separator is allowed here to divide Tags from Settings
            return cell
            
        case .settings:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
            // Create a temporary MenuItem for the Settings row
            let settingsItem = MenuItem(title: "Settings", systemIcon: "slider.horizontal.3", destination: .settings)
            cell.configure(with: settingsItem, isSelected: false)
            hideSeparator(cell)
            return cell
            
        case .signOut:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignOutCell", for: indexPath) as! SignOutCell
            cell.onSignOutTapped = { [weak self] in
                print("Sign Out Tapped")
                // Add logout logic here (e.g. self?.dismiss...)
            }
            hideSeparator(cell)
            return cell
            
        case .spacer:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            hideSeparator(cell)
            return cell
        }
    }

    // MARK: - TableView Selection (Navigation Logic)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch menuData[indexPath.row] {

        case .menuItem(let item):
                    selectedIndexPath = indexPath
                    // tableView.reloadData() // Optional, mostly visual

                    // --- REDIRECTION LOGIC ---
                    if item.title == "Upcoming" {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let upcomingVC = storyboard.instantiateViewController(withIdentifier: "UpcomingViewController") as? UpcomingViewController {
                            upcomingVC.modalPresentationStyle = .fullScreen
                            self.present(upcomingVC, animated: true, completion: nil)
                        }
                    }

        case .listItem(let color, let title, let count):
            selectedIndexPath = indexPath
            tableView.reloadData()
            
            // --- REDIRECTION LOGIC FOR "WORK" ---
            if title == "Work" {
                // 1. Get Main Storyboard
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                // 2. Find WorkViewController by ID
                // Make sure Storyboard ID is set to "WorkViewController" in Interface Builder!
                if let workVC = storyboard.instantiateViewController(withIdentifier: "WorkViewController") as? WorkViewController {
                    
                    workVC.modalPresentationStyle = .fullScreen
                    self.present(workVC, animated: true, completion: nil)
                }
            } else {
                print("Tapped List: \(title)")
            }
            // ------------------------------------

        case .addButton:
            toggleNewListBox(at: indexPath)
            
        case .settings:
            print("Settings Tapped")

        default:
            break
        }
    }

    // MARK: - Add New List Animation
    private func toggleNewListBox(at indexPath: IndexPath) {
        tableView.beginUpdates()

        if isAddListExpanded {
            // Collapse
            if indexPath.row + 1 < menuData.count,
               case .newListCreation = menuData[indexPath.row + 1] {
                menuData.remove(at: indexPath.row + 1)
                tableView.deleteRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .fade)
            }
        } else {
            // Expand
            menuData.insert(.newListCreation, at: indexPath.row + 1)
            tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .fade)
        }

        isAddListExpanded.toggle()
        tableView.endUpdates()
        
        // Scroll to bottom if expanded so hidden items (Settings/SignOut) are visible
        if isAddListExpanded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let lastRow = self.menuData.count - 1
                if lastRow > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }

    // MARK: - Navigation Helper
    private func navigateToDestination(_ destination: MenuDestination) {
        // Handle other menu navigation here
    }

    // MARK: - Row Heights
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch menuData[indexPath.row] {
        case .header: return 32
        case .tags: return 56
        case .newListCreation: return 140 // Large height for input box + colors
        case .settings: return 50
        case .signOut: return 80          // Taller for button + padding
        case .spacer: return 20           // Gap size
        default: return 44                // Standard row height
        }
    }
}
