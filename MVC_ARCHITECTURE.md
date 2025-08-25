# IdeaSpark Mobile App - MVC Architecture

This Flutter project follows a clean **Model-View-Controller (MVC)** architecture pattern for better code organization, maintainability, and scalability.

## Project Structure

```
lib/
├── main.dart                          # App entry point & splash screen
├── models/                           # Data models
│   └── startup_idea.dart             # StartupIdea model class
├── views/                            # UI layer
│   ├── main_screen.dart              # Main navigation screen
│   ├── screens/                      # App screens
│   │   ├── idea_submission_screen.dart    # Submit new ideas
│   │   ├── idea_listen_screen.dart        # Browse & vote on ideas
│   │   └── leaderboard_screen.dart        # Top ideas leaderboard
│   └── widgets/                      # Reusable UI components
├── controllers/                      # Business logic controllers
│   ├── idea_controller.dart          # Idea-related business logic
│   └── theme_controller.dart         # Theme management logic
├── services/                         # Data services & external APIs
│   └── storage_service.dart          # Local storage operations
└── utils/                           # Utilities & constants
    ├── themes.dart                   # App theme definitions
    └── constants.dart                # App constants & strings
```

## Architecture Overview

### Model Layer (`models/`)
- **Purpose**: Data structures and business entities
- **Contains**: Data classes with serialization methods
- **Example**: `StartupIdea` class with JSON serialization

### View Layer (`views/`)
- **Purpose**: User interface and presentation logic
- **Contains**: Screens, widgets, and UI components
- **Responsibilities**:
  - Render UI based on data from controllers
  - Handle user interactions
  - Display data in appropriate formats

### Controller Layer (`controllers/`)
- **Purpose**: Business logic and state management
- **Contains**: Controllers that manage app logic
- **Responsibilities**:
  - Process user inputs
  - Coordinate between models and views
  - Handle business rules and validations

### Services Layer (`services/`)
- **Purpose**: Data access and external service integration
- **Contains**: Service classes for data operations
- **Responsibilities**:
  - Local storage operations
  - API calls (future enhancement)
  - Data persistence

### Utils Layer (`utils/`)
- **Purpose**: Shared utilities and configuration
- **Contains**: Themes, constants, and helper functions
- **Responsibilities**:
  - App-wide constants
  - Theme definitions
  - Utility functions

## Key Features

### 🎨 **Theme Management**
- Dark/Light mode support
- Persistent theme preferences
- Material Design 3 theming

### 💡 **Idea Management**
- Submit startup ideas
- AI-powered rating system (simulated)
- Vote on ideas
- Delete ideas with swipe actions

### 🏆 **Leaderboard System**
- Top ideas ranking
- Vote-based sorting
- AI rating tie-breakers

### 📱 **Modern UI/UX**
- Material Design 3
- Smooth animations
- Responsive design
- Pull-to-refresh functionality

## Development Benefits

### 🔄 **Separation of Concerns**
- Each layer has distinct responsibilities
- Easier to test individual components
- Better code maintainability

### 🧩 **Modular Design**
- Components are loosely coupled
- Easy to add new features
- Reusable code components

### 🚀 **Scalability**
- Easy to extend functionality
- Clean architecture for team development
- Future-proof design pattern

### 🐛 **Debugging & Testing**
- Isolated business logic in controllers
- Testable service layer
- Clear data flow

## Usage Guidelines

### Adding New Features
1. **Model**: Define data structures in `models/`
2. **Service**: Implement data operations in `services/`
3. **Controller**: Add business logic in `controllers/`
4. **View**: Create UI components in `views/`

### Best Practices
- Keep views focused on UI rendering
- Centralize business logic in controllers
- Use services for all data operations
- Maintain constants in utils layer

## Dependencies
- `flutter`: Core Flutter framework
- `shared_preferences`: Local data persistence
- `google_fonts`: Custom typography
- `flutter_slidable`: Swipe actions
- `share_plus`: Social sharing functionality

## Getting Started

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Build for Production**
   ```bash
   flutter build apk  # Android
   flutter build ios  # iOS
   ```

## Future Enhancements
- Real AI integration for idea rating
- User authentication system
- Cloud database integration
- Push notifications
- Social features (comments, follows)
- Idea categories and filtering

---

This MVC architecture provides a solid foundation for building scalable Flutter applications while maintaining clean, organized, and testable code.
