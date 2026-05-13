# ChangeSite - Claude Code Guide

## Project Overview
iOS app for tracking insulin pump site changes. Helps users track when they last changed their pump site, schedule reminders, and view change history on a calendar.

## Build System
- **Xcode workspace**: Open `ChangeSite.xcworkspace` (not `.xcodeproj`) — CocoaPods is used
- **Platform**: iOS 15.0+
- **Dependencies**: FSCalendar (via CocoaPods)
- **Targets**: `ChangeSite` (main app), `ChangeSiteWidget` (widget extension), `ChangeSiteTests`, `ChangeSiteUITests`

## Architecture
- **UIKit** main app with storyboards (`Main.storyboard`, `LaunchScreen.storyboard`)
- **SwiftUI** widget extension
- **MVVM + Manager pattern**: ViewModels for screen logic, Managers for shared services
- **CoreData** model: `PumpSite.xcdatamodeld` with `SiteDates` entity (startDate, endDate, expiredDate, daysOverdue)
- **App Groups**: `group.com.EmilyMittleman.ChangeSite` for sharing data between app and widget via `UserDefaults`
- Widget reads from shared UserDefaults only (no CoreData) — guarded by `#if !BUILDING_FOR_EXTENSION`

## Key Directories
```
ChangeSite/                     # Main app source
├── HomeScreen/                 # Home tab (HomeViewController, HomeViewModel)
├── Calendar/                   # Calendar tab (FSCalendar integration)
├── Settings/                   # Settings tab
├── SettingsV2/                 # Settings V2 (in progress)
├── NewUser/                    # Onboarding flow (Launch, Setup)
├── Navigation/                 # Tab bar and navigation
├── PumpSite/                   # Core domain (PumpSite, PumpSiteManager, Reminder, RemindersManager)
├── Persistence/                # CoreDataStack, SiteDates, UserDefaultsAccessHelper
├── Notifications/              # NotificationManager
├── Design/                     # AppColor, Fonts/ (Rubik TTFs), Media.xcassets
├── Debug/                      # Debug tab (DEBUG builds only)
├── AppIntent/                  # SiteStartedIntent for Shortcuts/widget
└── Resources/                  # Data model, images
ChangeSiteWidget/               # Widget extension (SwiftUI)
├── CSDesign/                   # CSFont shared typography
├── ChangeSiteWidgetUI/         # Widget views
```

## Design Conventions
- **Fonts**: Rubik (Light, Regular, Medium) — registered in Info.plist. Widget uses `CSFont` ViewModifier with type scale (H1=32 through CaptionLabel=12)
- **Colors**: Defined in `Design/Media.xcassets` with light/dark mode support. Accessed via `Color.custom.<name>` (SwiftUI) / `UIColor.custom.<name>` (UIKit) from `AppColor.swift`
- **Key colors**: Background, TextPrimary, TextSecondary, TextTertiary, RedText, RedHighlight, ButtonPrimary, TabBarTint

## UserDefaults Keys
Defined in `StorageKey` enum: `newUser`, `startDate`, `daysBetween`, `reminders`, `defaultChangeTime`

## Git Workflow
- **Main branch**: `master`
- **Development branch**: `develop`
- Feature branches off `develop`, PRs to `master`

## Bundle IDs
- App: `com.EmilyMittleman.ChangeSite`
- Widget: `com.EmilyMittleman.ChangeSite.ChangeSiteWidget`
