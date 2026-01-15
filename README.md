# DayList – iOS To-Do Application

## Introduction

DayList is a clean and minimal **iOS To-Do application** built using **Swift**, **UIKit**, and **Storyboards**.
The project focuses on building a solid **authentication and task-management foundation**, featuring **Firebase Authentication**, **Core Data** for local persistence, a custom side menu, categorized task lists (Today, Upcoming, Work), a **Calendar** module, and smart user interactions.

This repository demonstrates a **real-world iOS app flow** including **Onboarding**, **Firebase Authentication**, **Core Data Integration**, **Custom Side Menu Navigation**, and **Advanced TableView handling**.

---

## Screens Included

- **Onboarding Screen**  
  Introductory screen displayed on first launch.

- **Sign In & Sign Up Screens**  
  Secure authentication using Firebase (Email & Password) with Core Data integration.

- **Menu Screen (Side Navigation)**  
  A central hub to navigate between Tasks (Today, Upcoming, Calendar), Lists (Personal, Work), Sticky Wall, and Tags. Includes a "Sign Out" feature.

- **Today Screen**  
  Displays the user's daily tasks in a clean list with user-specific task filtering.

- **Upcoming Screen**  
  A complex multi-section view ("Today", "Tomorrow", "This Week") where each section has its own interactive "Add New Task" input field.

- **Work Screen**  
  A dedicated project list with specific tasks, color-coded tags, and a task counter.

- **Calendar Screen**  
  A comprehensive scheduling interface featuring synchronized **Day**, **Week**, and **Month** views.

- **Task Detail Screen**  
  Displays detailed information about a selected task with full CRUD operations.

- **Sticky Wall Screen**  
  A visual note board that displays ideas and thoughts as color-coded sticky cards using a custom UICollectionView layout.

---

## Features

### Onboarding & Authentication
- **Entry Point:** Clean onboarding flow introducing the app.
- **Validation:** Real-time checks for email format, password strength, and matching confirmation fields.
- **Firebase Auth:** Secure account creation and login handling.
- **Core Data Integration:** Automatic user entity creation upon Firebase authentication.
- **User Persistence:** Links Firebase UID to local Core Data user entities.
- **Error Handling:** Clear inline error messages for invalid inputs.

### Core Data Implementation
- **Data Models:**
  - **UserEntity:** Stores user information (UID, email, name, creation date).
  - **TaskEntity:** Stores task details (title, date, subtasks, list name, tag color, completion status) with user relationship.
- **CoreDataManager:** Centralized singleton for all Core Data operations.
- **User-Specific Tasks:** All tasks are automatically filtered by logged-in user.
- **CRUD Operations:** Full Create, Read, Update, Delete support for tasks.
- **Automatic User Linking:** Tasks are automatically associated with current user.
- **Sample Data:** First-time users get pre-populated sample tasks.

### Custom Side Menu
- **Central Navigation:** Navigate between "Today", "Upcoming", "Calendar", "Sticky Wall", and custom Lists.
- **Dynamic Content:** Lists can be expanded, and new lists can be added directly from the menu.
- **Sign Out:** Integrated logout functionality with Core Data cleanup.

### Advanced Calendar Integration
- **Three-Mode View:** Seamlessly toggle between **Day**, **Week**, and **Month** views using a Segmented Control.
- **Day View (Timeline):** A vertical timeline layout using a custom `UITableView`. Features visual time markers, event blocks, and a horizontal week strip header.
- **Week View (Columns):** A horizontal grid using `UICollectionView` to visualize events across 7 days with color-coded categories.
- **Month View:** A full-sized calendar implementation using `FSCalendar` with custom styling (hidden default headers, sticky weekday rows, and custom fonts).
- **Synchronization:** Real-time state syncing—selecting a date in the Month view automatically updates the Day and Week views.

### Task Management
- **User-Specific Filtering:** Each user sees only their own tasks.
- **Task Completion:** Toggle task completion status with checkbox interaction.
- **Quick Task Creation:** Add tasks directly from Today view with minimal input.
- **Detailed Task Creation:** Full task details via Task Detail screen.
- **Swipe to Delete:** Intuitive swipe gesture for task deletion.
- **Automatic Persistence:** All changes saved immediately to Core Data.

### Upcoming Task Management
- **Multi-Section Layout:** Tasks categorized by "Today", "Tomorrow", and "This Week".
- **Smart Input Fields:** Each section has a dedicated "Add New Task" row that allows typing without navigation.
- **Gesture Handling:** Smart keyboard dismissal that distinguishes between tapping a button (to type) and tapping the background (to close).

### Work & Project Lists
- **Custom List Views:** Dedicated screens for specific projects (like "Work").
- **Task Metadata:** Tasks display subtask counts, due dates, and color-coded list tags.
- **Reusability:** Uses a shared, highly configurable `TaskTableViewCell` to ensure consistent design across all screens.

### Sticky Wall (Visual Notes Board)
- **Grid-Based Layout:** Built using `UICollectionView` with a custom flow layout.
- **Mixed Card Sizes:**
  - A large, full-width sticky note at the top.
  - Smaller two-column sticky notes below.
- **Color-Coded Cards:** Each sticky note has a soft background color for visual grouping.
- **Dynamic Text Support:** Cards automatically expand based on content length.
- **Clean UI:** Rounded corners, consistent spacing, and minimal styling to match modern iOS design.
- **Navigation:** Opens directly from the Menu under the "Sticky Wall" option.

### Technical Highlights
- **Architecture:** MVC (Model-View-Controller).
- **Data Persistence:** Core Data for local storage with user-specific filtering.
- **Authentication:** Firebase Authentication with Core Data synchronization.
- **UIKit & Storyboards:** Layouts built using Interface Builder and programmatic constraints.
- **Advanced TableView:** Handling multiple cell types, custom headers, and conflict resolution between touch gestures and table selection.
- **CollectionView Layouts:** Custom sizing logic for grid-based and full-width cards.
- **Third-Party Integration:** Implementation of **FSCalendar** via Swift Package Manager (SPM).
- **Compatibility:** Optimized for iOS 12+ (using fallbacks for SF Symbols).

---

## Screenshots

<div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img width="200" src="https://github.com/user-attachments/assets/76601711-2cec-4a8b-9044-f6becb890de0" alt="Onboarding" />
  <img width="200" src="https://github.com/user-attachments/assets/eb411fe0-2493-4fd6-a2a0-d473ba589938" alt="Sign In" />
  <img width="200" src="https://github.com/user-attachments/assets/f5ebe084-4fa3-4a19-b625-b9a474efda01" alt="Sign Up" />
  <img width="200" src="https://github.com/user-attachments/assets/d2090eef-3cf6-4cd3-8aeb-ef6989ba8e69" alt="Today List" />
  <img width="200" src="https://github.com/user-attachments/assets/abb2ba58-6e10-4b7d-83e8-e28c38f71227" alt="Detail Screen" />
  <img width="200" src="https://github.com/user-attachments/assets/eb3fd823-ba06-4695-a899-effb7c359005" alt="Menu Screen" />
  <img width="200" src="https://github.com/user-attachments/assets/388aabd4-d1a3-4501-915a-9bbe0f3ed725" alt="Upcoming Screen" />
  <img width="200" src="https://github.com/user-attachments/assets/991c50d6-d704-4c08-988c-ee75b0b0095e" alt="Work Screen" />
  <img width="200" src="https://github.com/user-attachments/assets/3cd8ba0e-a4b4-43b7-a2f9-f83dc494a8ce" alt="StickyWall Screen" />
  <img width="200" src="https://github.com/user-attachments/assets/0c446861-19ce-48b9-ac05-7f054bcd71e8" alt="Calendar-Day Screen" />
  <img width="200" src="https://github.com/user-attachments/assets/347738e2-34d4-4f69-8464-8396faed52d7" alt="Calendar-Week Screen" />
  <img width="200" src="https://github.com/user-attachments/assets/a28930d9-c7e3-4cc2-be2f-87d4da897e2f" alt="Calendar-Month Screen" />
</div>

---

## Prerequisites

- Xcode **12.4** or later  
- iOS **12.0** or later  
- Firebase project with **Email/Password Authentication enabled**

---


## Key Features Implemented

### Firebase Authentication
- Email/password sign up and sign in
- Automatic user profile creation in Core Data
- Secure authentication flow with validation
- Sign out with Core Data cleanup

### Core Data Integration
- User entity with Firebase UID mapping
- Task entity with user relationship
- Automatic data persistence
- User-specific task filtering
- Sample data generation for new users

### Task Management
- Create, read, update, delete tasks
- Task completion tracking
- Quick task creation from Today view
- Detailed task editing
- Swipe-to-delete functionality

---

## Demo Video

🎬 **Watch Full Demo**  
https://go.screenpal.com/watch/cOVIl7nrg0h

---

## License

This project is created for **learning and portfolio purposes**.

---

## Contributing

Contributions are welcome. Feel free to submit an issue or create a pull request for improvements.
