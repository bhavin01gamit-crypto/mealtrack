# Meal Tracker - Flutter Android App

A modern, calendar-based Meal Tracker Android application built with Flutter and Material 3.

## Features
- **Monthly Calendar**: Visual badges for morning (🌅) and night (🌙) meals.
- **Daily Meal Tracker**: Seamless `[ ✓ Taken ]` and `[ ○ Not Taken ]` switches.
- **Monthly Summary**: Live counters for Morning, Night, Total meals, and Complete days.
- **Yearly Statistics**: Tracked days, totals, and month-by-month progress cards.
- **Offline Persistence**: Uses `shared_preferences` for instantaneous local storage.
- **Material 3 Design**: Clean typography, emerald accenting, and thumb-friendly touch targets.

## Project Structure
```
flutter_meal_tracker/
├── android/               # Android native configuration & Gradle scripts
│   └── app/src/main/
│       └── AndroidManifest.xml
├── lib/
│   ├── main.dart          # App entrypoint and theme setup
│   ├── models/            # Data models (MealDayRecord, MonthlyStats, YearlyStats)
│   ├── services/          # StorageService & StatsService
│   ├── screens/           # HomeScreen (Calendar + Statistics navigation)
│   └── widgets/           # CalendarWidget, DailyTrackerCard, MonthlySummaryCard, etc.
└── pubspec.yaml           # Flutter dependencies (shared_preferences, intl)
```

## How to Run

1. **Install Flutter**: Ensure you have Flutter 3.x installed. Verify with:
   ```bash
   flutter doctor
   ```

2. **Navigate into the project directory**:
   ```bash
   cd flutter_meal_tracker
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run on an Android device or emulator**:
   ```bash
   flutter run
   ```

5. **Build Release APK**:
   ```bash
   flutter build apk --release
   ```
   The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.
