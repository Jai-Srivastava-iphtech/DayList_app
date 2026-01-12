//
//  MenuViewController.swift
//  DayList
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!

    enum MenuRow {
        case header(String)
        case menuItem(MenuItem)
        case listItem(color: UIColor, title: String, count: Int)
        case addButton(String)
        case newListCreation
        case tags([String])
    }

    private var menuData: [MenuRow] = []
    private var selectedIndexPath: IndexPath?
    private var isAddListExpanded = false

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
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        tableView.register(NewListCreationCell.self,
                           forCellReuseIdentifier: "NewListCreationCell")
    }

    private func setupData() {
        menuData = [
            .header("TASKS"),
            .menuItem(menuItems[0]),
            .menuItem(menuItems[1]),
            .menuItem(menuItems[2]),
            .menuItem(menuItems[3]),
            .header("LISTS"),
            .listItem(color: .systemPink, title: "Personal", count: 3),
            .listItem(color: .systemTeal, title: "Work", count: 6),
            .listItem(color: .systemYellow, title: "List 1", count: 3),
            .addButton("Add New List"),
            .header("TAGS"),
            .tags(["Tag 1", "Tag 2"])
        ]
    }

    // MARK: - Table DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuData.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch menuData[indexPath.row] {

        case .header(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.configure(title: title)
            // Make header text bold and same size as menu items
            cell.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
            return cell

        case .newListCreation:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewListCreationCell", for: indexPath) as! NewListCreationCell
            cell.configure()
            return cell

        case .tags(let tags):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagCell
            cell.configure(tags: tags)
            return cell
        }
    }

    // MARK: - Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch menuData[indexPath.row] {

        case .menuItem(let item):
            selectedIndexPath = indexPath
            navigateToDestination(item.destination)
            tableView.reloadData()

        case .listItem:
            selectedIndexPath = indexPath
            tableView.reloadData()

        case .addButton:
            toggleNewListBox(at: indexPath)

        default:
            break
        }
    }

    // MARK: - Expand / Collapse
    private func toggleNewListBox(at indexPath: IndexPath) {
        tableView.beginUpdates()

        if isAddListExpanded {
            if indexPath.row + 1 < menuData.count,
               case .newListCreation = menuData[indexPath.row + 1] {
                menuData.remove(at: indexPath.row + 1)
                tableView.deleteRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .fade)
            }
        } else {
            menuData.insert(.newListCreation, at: indexPath.row + 1)
            tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .fade)
        }

        isAddListExpanded.toggle()
        tableView.endUpdates()
    }

    // MARK: - Navigation
    private func navigateToDestination(_ destination: MenuDestination) {
        switch destination {
        case .today: print(" Navigate to Today")
        case .upcoming: print(" Navigate to Upcoming")
        case .calendar: print(" Navigate to Calendar")
        case .stickyWall: print(" Navigate to Sticky Wall")
        }
    }

    // MARK: - Row Height
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch menuData[indexPath.row] {
        case .header:
            return 32
        case .tags:
            return 56
        case .newListCreation:
            return 100
        default:
            return 40
        }
    }
}
