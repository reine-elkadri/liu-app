# liu-app
A Flutter mobile app for managing student attendance — login, dashboard, student list, and attendance tracking.

## Features

- 🔐 User login/authentication
- 📊 Dashboard overview
- 👥 Student list management
- ➕ Add new students
- ✅ Mark and track attendance

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.9.2)
- Android Studio or VS Code with Flutter extension

### Installation

1. Clone the repository
   ```
   git clone https://github.com/reine-elkadri/projectapp3.git
   cd projectapp3
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Run the app
   ```
   flutter run
   ```

## Built With

- [Flutter](https://flutter.dev/) - UI framework
- [http](https://pub.dev/packages/http) - API requests
- [shared_preferences](https://pub.dev/packages/shared_preferences) - Local storage

## Project Structure

```
lib/
├── main.dart          # App entry point
├── login.dart         # Login screen
├── dashboard.dart      # Main dashboard
├── studentslist.dart   # Student list view
├── addstudent.dart     # Add student form
└── attendance.dart     # Attendance tracking
```

## License

This project is for educational/personal use.
