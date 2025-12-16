## 📱SMS Cash Summary App

#### This is a small utility application that fetches and analyzes SMS data from the user's device based on specific provider names (such as mobile financial services). The app reads relevant SMS messages and categorizes them into Cash In and Cash Out transactions, then calculates the total amounts accordingly.

## ✨Features
- Fetches SMS messages from the device inbox using Android platform channels

- Filters SMS based on predefined provider names

- Separates transactions into:
   - Cash In
   - Cash Out
- Calculates and displays:
   - Total Cash In amount for Current Month
   - Total Cash Out amount for Current Month
   - Overall transaction summary
- Uses a clean and modular feature-first architecture
- Permission handling for secure SMS access

## 🏗 Architecture
#### The project follows a feature-first architecture, where each feature is organized with its own:
- Controllers
- Services
- Models
- Screens
- Utility classes
## 🛠 Technologies
- Flutter
- Dart
- Kotlin(Android Platform Channel)
- GetX for State Management
- Regular Expressions for SMS parsing
## 🔐 Permissions
#### The app requests READ_SMS permission to access and analyze SMS data locally on the device. No SMS data is stored or shared externally.
