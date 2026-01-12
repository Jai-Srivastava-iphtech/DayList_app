# DayList – iOS To-Do Application

## Introduction  

DayList is a clean and minimal **iOS To-Do application** built using **Swift**, **UIKit**, and **Storyboards**.  
The project focuses on building a solid **authentication and task-management foundation**, starting from onboarding and authentication to viewing and managing daily tasks.

This repository demonstrates a **real-world iOS app flow** including **Onboarding**, **Authentication**, a **Today task list**, and a **Task Detail screen**, integrated with **Firebase Email & Password Authentication**.

---

## Screens Included  

- **Onboarding Screen**  
  Introductory screen displayed on first launch  

- **Sign In Screen**  
  Login using email and password  

- **Sign Up Screen**  
  Account creation using email and password  

- **Today Screen (Task List)**  
  Displays the user’s daily tasks in a clean list  

- **Task Detail Screen**  
  Displays detailed information about a selected task  

---

## Features  

### Onboarding Screen  

- Acts as the entry point of the application  
- Introduces the purpose of the app  
- Clean and distraction-free UI  
- Navigates users to the authentication flow  

---

### Sign Up Screen  

- User registration using **Email & Password**  
- Integrated with **Firebase Authentication**  
- Input validation for empty fields  
- Password confirmation matching  
- Smooth navigation to Sign In after successful registration  

---

### Sign In Screen  

- User login using **Email & Password**  
- Firebase Authentication integration  
- Proper error handling for invalid credentials  
- Secure password input with visibility toggle  
- Keyboard dismissal on outside tap  

---

### Today Screen (Task List)  

- Displays a list of daily tasks using **UITableView**  
- Each task cell includes:
  - Task title  
  - Due date (optional)  
  - Subtask count (optional)  
  - List/category tag with color indicator  
- Custom dynamic cells that adapt based on available task data  
- Clean separators between tasks for better readability  

---

### Task Detail Screen  

- Opens when a task is tapped from the Today screen  
- Displays detailed task information such as:
  - Task title  
  - Description field  
  - Due date  
  - List/category selection  
- Designed using **UIKit + Storyboard**, compatible with iOS 12  
- Acts as the foundation for future task editing and management features  

---

### Firebase Authentication  

- Firebase **Email & Password Authentication** implemented  
- Secure user registration and login  
- Authentication state managed using Firebase APIs  
- Code structure ready for future enhancements such as:
  - Password reset  
  - Email verification  

---

### Keyboard Handling  

- Keyboard dismisses when tapping outside input fields  
- Improves usability on real devices  
- Implemented using an **iOS 12-compatible approach**  

---

### Navigation  

- Uses **UINavigationController** for screen transitions  
- Navigation handled via **Storyboards**  
- Smooth and predictable back-navigation behavior  
- Task selection navigates to the Task Detail screen  

---

## Screenshots  

<div style="display: flex; flex-wrap: wrap; gap: 10px;">

  <img width="250" src="https://github.com/user-attachments/assets/52b9fafa-1f2c-4308-a54c-22dd89a3a420" alt="Onboarding Screen" />

  <img width="250" src="https://github.com/user-attachments/assets/1c9d7b57-5d0d-40e5-9b2e-3c942a5b46f6" alt="Sign In Screen" />

  <img width="250" src="https://github.com/user-attachments/assets/a5965370-0b07-4f89-b289-e9e4e352f35b" alt="Sign Up Screen" />

  <img width="250" src="https://github.com/user-attachments/assets/fbfecc8a-3b42-450c-a09e-43bdab49cdfc" alt="Today Task List Screen" />

  <img width="250" src="https://github.com/user-attachments/assets/dc169049-17cb-4b69-9616-91c895f69952" alt="Task Detail Screen" />

</div>

---

## Demo Video  

🎬 **Watch Full Demo**  
https://go.screenpal.com/watch/cOV1XknrbFj 

---

## Prerequisites  

- Xcode **12.4** or later  
- iOS **12.0** or later  
- Firebase project with **Email/Password Authentication enabled**  

---

## Installation  

1. Clone the repository  
2. Open the project in Xcode  
3. Add your `GoogleService-Info.plist` file  
4. Run the project on a simulator or real device  

---

## License  

This project is created for **learning and portfolio purposes**.

---

## Contributing  

Contributions are welcome.  
Feel free to submit an issue or create a pull request for improvements.

---

## Support  

If you encounter any issues or have questions, please contact the project maintainer.

---

## Acknowledgements  

Thanks to the **Apple Developer Documentation** and **Firebase Documentation**,  
which greatly helped during the development of this project.
