import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var contentContainerView: UIView!
    
    // --- 1. DAY VIEW ---
    @IBOutlet weak var dayContainerView: UIView!
    @IBOutlet weak var dayCalendarView: FSCalendar!     // NEW: Connect this in Storyboard
    @IBOutlet weak var dayTimelineTableView: UITableView! // NEW: Connect this in Storyboard

    // --- 2. WEEK VIEW ---
    @IBOutlet weak var weekContainerView: UIView!
    @IBOutlet weak var weekCalendarView: FSCalendar!
    @IBOutlet weak var weekEventsCollectionView: UICollectionView!
    
    // --- 3. MONTH VIEW ---
    @IBOutlet weak var calendarView: FSCalendar!

    // MARK: - Properties
    private let calendar = Calendar.current
    private var selectedDate: Date = Date()
    
    // Week Data
    private var weekEvents: [[WeekEvent]] = []
    
    // Day Data (Dummy Hours 9AM - 5PM)
    private let dayHours = ["09:00\nAM", "10:00\nAM", "11:00\nAM", "12:00\nPM", "01:00\nPM", "02:00\nPM", "03:00\nPM"]
    private var dayEvents: [Int: (String, UIColor)] = [:] // Map Hour Index -> Event

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyling()
        
        // Setup All Views
        setupMonthCalendar()
        setupWeekCalendar()
        setupDayView() // <--- NEW Setup
        
        // Setup Grids
        setupWeekEventsGrid()
        generateWeekEvents()
        generateDayEvents() // <--- Generate Dummy Day Data

        // Initial State
        updateVisibleView()
    }
    
    private func setupStyling() {
        if #available(iOS 13.0, *) {
            modeSegmentedControl.selectedSegmentTintColor = .white
            modeSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        }
    }

    // MARK: - Actions
    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        updateVisibleView()
    }

    private func updateVisibleView() {
        dayContainerView.isHidden = true
        weekContainerView.isHidden = true
        calendarView.isHidden = true
        
        switch modeSegmentedControl.selectedSegmentIndex {
        case 0: // DAY
            dayContainerView.isHidden = false
            dayCalendarView.select(selectedDate)
            dayCalendarView.setCurrentPage(selectedDate, animated: false)
            dayTimelineTableView.reloadData()
            
        case 1: // WEEK
            weekContainerView.isHidden = false
            weekCalendarView.select(selectedDate)
            weekCalendarView.setCurrentPage(selectedDate, animated: false)
            weekEventsCollectionView.reloadData()
            DispatchQueue.main.async { self.weekEventsCollectionView.collectionViewLayout.invalidateLayout() }
            
        case 2: // MONTH
            calendarView.isHidden = false
            calendarView.select(selectedDate)
            calendarView.setCurrentPage(selectedDate, animated: false)
            
        default: break
        }
    }
}

// MARK: - FSCalendar Configuration (All 3 Calendars)
extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    // --- 1. DAY VIEW SETUP ---
        private func setupDayView() {
            // A. Header (FSCalendar)
            dayCalendarView.dataSource = self
            dayCalendarView.delegate = self
            dayCalendarView.scope = .week // Single week strip
            
            // --- FORCE HIDE BLUE HEADER ---
            dayCalendarView.calendarHeaderView.isHidden = true // Hide the view entirely
            dayCalendarView.headerHeight = 0
            dayCalendarView.appearance.headerTitleColor = .clear
            dayCalendarView.appearance.headerMinimumDissolvedAlpha = 0.0
            
            // --- EXACT STYLING FROM WEEK VIEW ---
            dayCalendarView.weekdayHeight = 30
            dayCalendarView.firstWeekday = 2 // Monday
            dayCalendarView.backgroundColor = .white
            dayCalendarView.placeholderType = .none
            
            // Fonts (Copied from Week View)
            dayCalendarView.appearance.weekdayTextColor = .darkGray
            dayCalendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 11, weight: .bold)
            
            dayCalendarView.appearance.titleDefaultColor = .black
            dayCalendarView.appearance.titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
            
            // Selection Styling
            dayCalendarView.appearance.selectionColor = UIColor(white: 0.9, alpha: 1.0)
            dayCalendarView.appearance.titleSelectionColor = .black
            dayCalendarView.appearance.borderRadius = 0.4
            dayCalendarView.appearance.todayColor = .clear
            dayCalendarView.appearance.titleTodayColor = .black
            
            // B. Timeline (TableView)
            dayTimelineTableView.dataSource = self
            dayTimelineTableView.delegate = self
            dayTimelineTableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineCell.identifier)
            dayTimelineTableView.separatorStyle = .none
            dayTimelineTableView.rowHeight = 100
            dayTimelineTableView.backgroundColor = .white
            
            // Force Update
            dayCalendarView.reloadData()
            dayCalendarView.layoutIfNeeded()
        }
    // --- 2. MONTH VIEW SETUP ---
    private func setupMonthCalendar() {
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scrollDirection = .vertical
        calendarView.pagingEnabled = false
        
        // Blue Header Fix
        calendarView.headerHeight = 0
        calendarView.appearance.headerTitleColor = .clear
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        calendarView.weekdayHeight = 40
        calendarView.firstWeekday = 2
        calendarView.backgroundColor = .white
        
        calendarView.appearance.weekdayTextColor = .darkGray
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        calendarView.appearance.titleDefaultColor = .black
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 16)
        calendarView.appearance.titlePlaceholderColor = UIColor.lightGray.withAlphaComponent(0.6)
        calendarView.placeholderType = .fillHeadTail
        
        calendarView.appearance.selectionColor = UIColor(white: 0.9, alpha: 1.0)
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.borderRadius = 0.4
        calendarView.appearance.todayColor = .clear
        calendarView.appearance.titleTodayColor = .black
    }
    
    // --- 3. WEEK VIEW SETUP ---
    private func setupWeekCalendar() {
        weekCalendarView.dataSource = self
        weekCalendarView.delegate = self
        weekCalendarView.scope = .week
        
        weekCalendarView.headerHeight = 0
        weekCalendarView.weekdayHeight = 30
        weekCalendarView.firstWeekday = 2
        weekCalendarView.backgroundColor = .white
        weekCalendarView.placeholderType = .none
        
        weekCalendarView.appearance.weekdayTextColor = .darkGray
        weekCalendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 11, weight: .bold)
        weekCalendarView.appearance.titleDefaultColor = .black
        weekCalendarView.appearance.titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        weekCalendarView.appearance.selectionColor = UIColor(white: 0.9, alpha: 1.0)
        weekCalendarView.appearance.titleSelectionColor = .black
        weekCalendarView.appearance.borderRadius = 0.4
        weekCalendarView.appearance.todayColor = .clear
        weekCalendarView.appearance.titleTodayColor = .black
    }
    
    // --- GLOBAL SYNC LOGIC ---
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        print("Selected: \(date)")
        
        // Sync all calendars
        if calendar != calendarView { calendarView.select(date); calendarView.setCurrentPage(date, animated: false) }
        if calendar != weekCalendarView { weekCalendarView.select(date); weekCalendarView.setCurrentPage(date, animated: false) }
        if calendar != dayCalendarView { dayCalendarView.select(date); dayCalendarView.setCurrentPage(date, animated: false) }
        
        // Reload Data
        generateWeekEvents()
        generateDayEvents() // Refresh day timeline for new date
        weekEventsCollectionView.reloadData()
        dayTimelineTableView.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        if calendar == weekCalendarView || calendar == dayCalendarView {
            // Optional: Logic when swiping weeks
        }
    }
}

// MARK: - Day View Timeline (TableView)
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayHours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.identifier, for: indexPath) as! TimelineCell
        
        let time = dayHours[indexPath.row]
        let eventData = dayEvents[indexPath.row]
        
        cell.configure(time: time, event: eventData?.0, color: eventData?.1)
        
        return cell
    }
    
    private func generateDayEvents() {
        dayEvents.removeAll()
        // Dummy Data: Randomly add events to slots
        let titles = ["Team Meeting", "Code Review", "Lunch Break", "Client Call"]
        let colors = [
            UIColor(red: 0.81, green: 0.93, blue: 0.95, alpha: 1.0), // Light Blue
            UIColor(red: 0.99, green: 0.93, blue: 0.72, alpha: 1.0), // Light Yellow
            UIColor(red: 1.00, green: 0.85, blue: 0.84, alpha: 1.0)  // Light Red
        ]
        
        // Randomly fill 2-3 slots
        for _ in 0...2 {
            let randomRow = Int.random(in: 0..<dayHours.count)
            let randomTitle = titles.randomElement()!
            let randomColor = colors.randomElement()!
            dayEvents[randomRow] = (randomTitle, randomColor)
        }
    }
}

// MARK: - Week Events Grid (CollectionView)
extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupWeekEventsGrid() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        weekEventsCollectionView.collectionViewLayout = layout
        weekEventsCollectionView.dataSource = self
        weekEventsCollectionView.delegate = self
        weekEventsCollectionView.register(WeekEventCell.self, forCellWithReuseIdentifier: WeekEventCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekEventCell.identifier, for: indexPath) as! WeekEventCell
        if indexPath.item < weekEvents.count {
            cell.configure(events: weekEvents[indexPath.item])
        }
        cell.showSeparator = (indexPath.item != 6)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(collectionView.frame.width / 7.0)
        return CGSize(width: width, height: collectionView.frame.height)
    }
}

// MARK: - Data Generation (Week)
extension CalendarViewController {
    private func generateWeekEvents() {
        weekEvents = Array(repeating: [], count: 7)
        let colors = [
            UIColor(red: 0.81, green: 0.93, blue: 0.95, alpha: 1.0),
            UIColor(red: 0.99, green: 0.93, blue: 0.72, alpha: 1.0),
            UIColor(red: 1.00, green: 0.85, blue: 0.84, alpha: 1.0)
        ]
        let titles = ["Se..", "Sa..", "Co..", "Br..", "Bu..", "Re.."]
        for dayIndex in 0..<7 {
            let count = Int.random(in: 1...3)
            for i in 0..<count {
                if Int.random(in: 0...10) > 6 { continue }
                let event = WeekEvent(title: titles[i % titles.count], color: colors[(dayIndex + i) % colors.count])
                weekEvents[dayIndex].append(event)
            }
        }
    }
}
