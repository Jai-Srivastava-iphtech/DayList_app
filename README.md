# DayList – iOS To-Do Application

## Introduction

DayList is a clean and minimal **iOS To-Do application** built using **Swift**, **UIKit**, and **Storyboards**.
The project focuses on building a solid **authentication and task-management foundation**, featuring **Firebase Authentication**, **Core Data** for local persistence, **Keychain-based secure credential storage**, **session management**, a custom side menu, categorized task lists (Today, Upcoming, Work), a **Calendar** module, and smart user interactions.

This repository demonstrates a **real-world iOS app flow** including **Onboarding**, **Firebase Authentication**, **Secure Session Management**, **Core Data Integration**, **Custom Side Menu Navigation**, and **Advanced TableView handling**.

---

## Screens Included

- **Onboarding Screen**  
  Introductory screen displayed on first launch.

- **Sign In & Sign Up Screens**  
  Secure authentication using Firebase (Email & Password) with Core Data, Keychain, and session integration.

- **Menu Screen (Side Navigation)**  
  A central hub to navigate between Tasks (Today, Upcoming, Calendar), Lists (Personal, Work), Sticky Wall, and Tags. Includes a "Sign Out" feature.

- **Today Screen**  
  Displays the user's daily tasks in a clean list with user-specific task filtering and logout support.

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

### Onboarding, Authentication & Session Management
- **Entry Point:** Clean onboarding flow introducing the app.
- **Validation:** Real-time checks for email format, password strength, and matching confirmation fields.
- **Firebase Auth:** Secure account creation and login handling.
- **Keychain Integration:** Secure storage of sensitive credentials using iOS Keychain (`kSecClassGenericPassword`).
- **SessionManager:** Centralized session handling with login, restore, and logout support.
- **Auto Login:** Automatically navigates logged-in users to Today screen on app relaunch.
- **SceneDelegate Routing:** Session-based root controller selection (Onboarding vs Today).
- **Core Data Integration:** Automatic user entity creation upon Firebase authentication.
- **User Persistence:** Firebase UID mapped to local Core Data user entities.
- **Logout Handling:** Clears Keychain, UserDefaults, and Core Data session context.
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
- **Sign Out:** Integrated logout functionality with Keychain cleanup and session reset.

### Advanced Calendar Integration
- **Three-Mode View:** Seamlessly toggle between **Day**, **Week**, and **Month** views using a Segmented Control.
- **Day View (Timeline):** A vertical timeline layout using a custom `UITableView`. Features visual time markers, event blocks, and a horizontal week strip header.
- **Week View (Columns):** A horizontal grid using `UICollectionView` to visualize events across 7 days with color-coded categories.
- **Month View:** A full-sized calendar implementation using `FSCalendar` with custom styling.
- **Synchronization:** Real-time state syncing across Day, Week, and Month views.

### Task Management
- **User-Specific Filtering:** Each user sees only their own tasks.
- **Task Completion:** Toggle task completion status with checkbox interaction.
- **Quick Task Creation:** Add tasks directly from Today view.
- **Detailed Task Creation:** Full task details via Task Detail screen.
- **Swipe to Delete:** Intuitive swipe gesture for task deletion.
- **Automatic Persistence:** All changes saved immediately to Core Data.

### Technical Highlights
- **Architecture:** MVC (Model-View-Controller).
- **Authentication:** Firebase Authentication with Keychain-backed session persistence.
- **Security:** Secure credential storage using iOS Keychain (iOS 12+ compatible).
- **Session Flow:** SessionManager + SceneDelegate-based navigation.
- **Data Persistence:** Core Data for local storage with user-specific filtering.
- **UIKit & Storyboards:** Layouts built using Interface Builder and programmatic constraints.
- **Third-Party Integration:** FSCalendar via Swift Package Manager (SPM).
- **Compatibility:** Optimized for iOS 12+.

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

## Demo Video

🎬 **Watch Full Demo**  
https://go.screenpal.com/watch/cOVoXgnrmqY

---

## License

This project is created for **learning and portfolio purposes**.

---

## Contributing

Contributions are welcome. Feel free to submit an issue or create a pull request for improvements.
