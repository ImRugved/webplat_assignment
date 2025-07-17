# Webplat Assignment - User Directory App

A modern Flutter application that fetches and displays user data from a public API with advanced search functionality, responsive design, and a unified design system.

## 📱 Features

### Core Functionality

- **User List Display**: Shows users with name, username, email, and phone information
- **User Details Screen**: Detailed view of all user information with beautiful UI
- **Real-time Search**: Search through users by name, email
- **Recent Searches**: Track and display the last 10 search terms
- **Responsive Design**: Optimized for both mobile and tablet screens
- **Pull-to-Refresh**: Refresh data by pulling down the list
- **Smooth Navigation**: Animated transitions between screens

### Search Features

- **Smart Search**: Searches across multiple fields (name, username, email)
- **Debounced Input**: Only adds completed searches to recent searches (1.5s delay)
- **Quick Access**: Tap on recent search chips to quickly search again
- **Clear Functionality**: Clear individual searches or all recent searches
- **Persistent Storage**: Recent searches are saved locally and persist between app sessions

### UI/UX Features

- **Modern Design**: Material Design 3 with beautiful card layouts
- **Unified Design System**: Centralized colors and text styles for consistency
- **Loading States**: Shimmer loading effects while fetching data
- **Error Handling**: User-friendly error messages with retry functionality
- **Empty States**: Helpful messages when no results are found
- **Keyboard Management**: Auto-dismiss keyboard when tapping outside
- **Splash Screen**: Animated welcome screen with app branding

## 🏗️ Architecture

### MVP Pattern with Provider State Management

```
lib/
├── model/
│   └── user_model.dart          # Data models (User, Address, Company, Geo)
├── provider/
│   └── user_provider.dart       # State management with Provider
├── view/
│   ├── splash_screen.dart       # Animated splash screen
│   ├── user_list_screen.dart    # Main user list screen
│   └── user_details_screen.dart # Detailed user information screen
├── global/
│   ├── global.dart              # Global constants and configurations
│   ├── colors.dart              # App color constants
│   └── text_styles.dart         # App text style constants
└── main.dart                    # App entry point
```

### Model Layer

- **User Model**: Complete user data structure
- **Address Model**: User address information
- **Company Model**: Company details
- **Geo Model**: Geographic coordinates

### Provider Layer

- **UserProvider**: Manages application state
  - User data fetching and caching
  - Search functionality
  - Recent searches management
  - Loading and error states

### View Layer

- **SplashScreen**: Animated welcome screen
  - Beautiful gradient background
  - Animated logo and text
  - Smooth transition to main app
- **UserListScreen**: Main application screen
  - Responsive design using MediaQuery
  - Search bar with real-time filtering
  - Recent searches display
  - User cards with contact information
- **UserDetailsScreen**: Detailed user information
  - Comprehensive user data display
  - Organized sections (Personal, Contact, Address, Company)
  - Responsive design for all screen sizes

### Global Layer

- **Global Constants**: App-wide configurations
  - API endpoints and timeouts
  - Responsive breakpoints
  - App metadata
- **Color System**: Centralized color management
  - Primary, secondary, and accent colors
  - Text colors and background colors
  - Status colors (error, success, warning)
- **Text Style System**: Consistent typography
  - Heading styles (h1, h2, h3)
  - Body text styles (large, medium, small)
  - Specialized styles (button, chip, search, etc.)

## 🔌 API Integration

### Endpoint

```
GET https://jsonplaceholder.typicode.com/users
```

### Response Structure

```json
[
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  }
]
```

### API Features

- **Public API**: No authentication required
- **CORS Enabled**: Works with web applications
- **JSON Response**: Structured data format
- **Error Handling**: Proper HTTP status codes

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android Emulator or Physical Device (Android 6.0+)
- iOS Simulator (for iOS development)

### Android 15 Support

- **Target SDK**: 35 (Android 15)
- **Minimum SDK**: 23 (Android 6.0)
- **Compile SDK**: 35 (Android 15)
- **Back Navigation**: Enhanced back navigation support
- **Modern APIs**: Full access to latest Android features

### Installation Steps

1. **Clone the Repository**

   ```bash
   git clone <repository-url>
   cd webplat_demo
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```

### Platform Support

- ✅ Android (API 23+ - Android 6.0 to Android 15)
- ✅ iOS (iOS 11.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ✅ Desktop (Windows, macOS, Linux)

## 📦 Dependencies

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.4.0 # API HTTP requests
  provider: ^6.1.5 # State management
  shimmer: ^3.0.0 # Loading animations
  shared_preferences: ^2.2.2 # Local data persistence
```

### Development Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 🎨 UI Components & Design System

### Design System

- **Unified Color Palette**: Centralized color management in `lib/global/colors.dart`

  - Primary colors (blue theme)
  - Secondary and accent colors
  - Text colors (primary, secondary, light)
  - Status colors (error, success, warning)
  - UI element colors (background, surface, shadow)

- **Typography System**: Consistent text styles in `lib/global/text_styles.dart`
  - Heading styles (h1, h2, h3)
  - Body text styles (large, medium, small)
  - Specialized styles (button, chip, search hint, splash, user card, detail labels/values)

### Splash Screen

- **Animated Welcome**: Beautiful gradient background with app branding
- **Smooth Animations**: Scale and fade animations for logo and text
- **Loading Indicator**: Circular progress indicator with branded colors
- **Auto Navigation**: Automatically transitions to main app after 3 seconds

### Search Bar

- **Real-time filtering** as you type
- **Clear button** to reset search
- **Responsive design** with different layouts for mobile/tablet
- **Keyboard management** with auto-dismiss
- **Branded styling** using design system colors

### User Cards

- **Avatar** with user's first initial
- **Contact information** (name, username, email, phone)
- **Shadow effects** for depth
- **Responsive sizing** based on screen size
- **Tap to navigate** to detailed user information
- **Arrow indicator** showing the card is tappable
- **Consistent styling** using design system colors and typography

### User Details Screen

- **Comprehensive information** display with all user data
- **Organized sections** (Personal, Contact, Address, Company)
- **Beautiful header** with large avatar and user info
- **Responsive design** for mobile and tablet
- **Smooth animations** when navigating back
- **Section cards** with consistent styling and colors

### Recent Searches

- **Chip design** for easy interaction
- **Delete functionality** for individual searches
- **Clear all** option
- **Tap to search** functionality
- **Branded colors** using design system palette

## 🔧 Configuration

### App Constants (`lib/global/global.dart`)

- **API Configuration**:
  - Base URL: `https://jsonplaceholder.typicode.com`
  - Endpoint: `/users`
  - Search debounce time: 1.5 seconds
- **App Metadata**:
  - App Name: "Webplat Assignment"
  - App Version: "1.0.0"
  - Splash duration: 3 seconds
- **Responsive Design**:
  - Tablet breakpoint: 600px
  - Mobile: Screen width ≤ 600px
  - Tablet: Screen width > 600px

### Design System Configuration

- **Color System** (`lib/global/colors.dart`):

  - Primary theme: Blue (#2196F3)
  - Text hierarchy: Primary (#212121), Secondary (#757575), Light (#BDBDBD)
  - Status colors: Error (#D32F2F), Success (#388E3C), Warning (#FFA000)
  - UI elements: Background (#F5F5F5), Surface (white), Shadow (10% black)

- **Typography System** (`lib/global/text_styles.dart`):
  - Headings: 32px, 24px, 20px with bold/600 weights
  - Body text: 16px, 14px, 12px with normal weight
  - Specialized styles for buttons, chips, search hints, etc.

### Search Configuration

- **Debouncing**: 1.5 seconds of no typing
- **Purpose**: Prevents adding partial searches to recent searches
- **Recent Searches**:
  - Maximum: 10 searches
  - Order: Most recent first
  - Storage: Persistent using SharedPreferences (survives app restarts)

## 🧪 Testing

### Manual Testing Checklist

- [ ] App launches with splash screen animation
- [ ] Splash screen transitions to user list after 3 seconds
- [ ] User data loads and displays correctly
- [ ] Search functionality works across all fields
- [ ] Recent searches are saved and displayed
- [ ] Responsive design works on different screen sizes
- [ ] Pull-to-refresh updates data
- [ ] Error states display properly
- [ ] Loading states show shimmer effects
- [ ] User details screen displays all information correctly
- [ ] Design system colors and typography are consistent throughout
- [ ] Navigation animations work smoothly

## 🔄 State Management

### Provider Pattern

- **Single Source of Truth**: All state managed in UserProvider
- **Reactive Updates**: UI automatically updates when state changes
- **Separation of Concerns**: Business logic separated from UI

### State Variables

```dart
List<User> users = [];              // All users from API
List<User> filteredUsers = [];      // Filtered users based on search
List<String> recentSearches = [];   // Recent search terms
bool isLoading = false;             // Loading state
String error = '';                  // Error message
String searchQuery = '';            // Current search query
```

## 🚨 Error Handling

### Network Errors

- Connection timeout
- Invalid response format
- HTTP error status codes

### User Feedback

- Clear error messages
- Retry functionality
- Loading indicators
