# HabitFlow - MVP Specification

## 1. Project Overview
- **Name**: HabitFlow
- **Type**: Cross-platform mobile app (iOS/Android)
- **Core Functionality**: AI-powered habit tracker with streaks, reminders, and personalized coaching
- **Target Users**: Adults looking to build positive habits with gamification and AI guidance

## 2. UI/UX Specification

### Screen Structure
1. **Home Screen** — Today's habits, quick stats
2. **Add Habit Screen** — Create new habit
3. **Habit Detail Screen** — View habit history & stats
4. **Profile/Settings Screen** — User preferences, subscription

### Navigation
- Bottom navigation bar (Home, Add, Profile)
- Stack navigation for detail screens

### Visual Design
- **Primary Color**: #6366F1 (Indigo)
- **Secondary Color**: #10B981 (Emerald for success/streaks)
- **Background**: #F9FAFB (Light gray)
- **Surface**: #FFFFFF (White cards)
- **Text Primary**: #111827
- **Text Secondary**: #6B7280

### Typography
- Headlines: Bold, 24-32sp
- Body: Regular, 16sp
- Captions: Medium, 12-14sp

### Components
- **HabitCard**: Shows habit name, streak count, checkbox
- **StreakBadge**: Shows flame icon + day count
- **StatCard**: Completion percentage, best streak
- **AIChatBubble**: AI coach messages

## 3. Functionality Specification

### Core Features (MVP)

#### Habit Management
- Create habit: name, frequency (daily/weekly), reminder time
- Edit/delete habits
- Mark habit as complete/incomplete

#### Streaks
- Track consecutive days completed
- Visual streak counter with flame icon
- Streak recovery (1 miss = -1, not reset to 0)

#### Statistics
- Weekly completion rate
- Best streak
- Total completions

#### AI Coach (Premium)
- Personalized habit suggestions
- Motivation messages
- Tips based on habit performance

### Data Model

```dart
class Habit {
  String id;
  String name;
  int frequency; // 1-7 days per week
  TimeOfDay reminderTime;
  DateTime createdAt;
  int currentStreak;
  int bestStreak;
  List<DateTime> completions;
}

class UserProfile {
  String name;
  int totalHabits;
  int premium; // boolean
}
```

### State Management
- Provider pattern (simple, effective for MVP)

## 4. Technical Specification

### Tech Stack
- **Framework**: Flutter 3.x
- **Backend**: Firebase (Auth, Firestore, Cloud Functions)
- **AI**: OpenAI API (GPT-4o mini for AI Coach)
- **Notifications**: Firebase Cloud Messaging

### Project Structure
```
lib/
├── main.dart
├── models/
│   ├── habit.dart
│   └── user_profile.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_habit_screen.dart
│   ├── habit_detail_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── habit_card.dart
│   ├── streak_badge.dart
│   ├── stat_card.dart
│   └── ai_chat_bubble.dart
├── services/
│   ├── firebase_service.dart
│   ├── habit_service.dart
│   └── ai_coach_service.dart
└── theme/
    └── app_theme.dart
```

## 5. Monetization

### Free Tier
- Up to 3 habits
- Basic streaks
- Daily reminders

### Premium ($4.99/mo)
- Unlimited habits
- AI Coach
- Advanced analytics
- Custom themes

### AI Coach Add-on ($2.99/mo)
- Personalized suggestions
- Daily motivation
- Habit optimization tips
