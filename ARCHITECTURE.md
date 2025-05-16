# PiggyBet - Project Architecture

## Project Structure
```
piggybet/
├── lib/
│   ├── core/
│   │   ├── firebase_options.dart
│   │   └── theme.dart
│   ├── features/
│   │   ├── auth/
│   │   │   └── auth_screen.dart
│   │   ├── checkin/
│   │   │   └── checkin_screen.dart
│   │   ├── friends/
│   │   │   └── friends_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   └── place_bet/
│   │       └── place_bet_screen.dart
│   ├── models/
│   │   ├── invite.dart
│   │   └── piggy_bet.dart
│   ├── routing/
│   │   └── app_router.dart
│   ├── services/
│   │   ├── app_links_service.dart
│   │   ├── auth_service.dart
│   │   ├── bet_service.dart
│   │   └── invite_service.dart
│   └── main.dart
├── android/
│   ├── app/
│   │   ├── src/
│   │   │   └── main/
│   │   │       ├── AndroidManifest.xml
│   │   │       └── res/
│   │   │           └── raw/
│   │   │               └── asset_statements.json
│   │   └── build.gradle.kts
│   └── build.gradle.kts
└── web/
    └── index.html

## Technology Stack
- Flutter 3.29.3
- Dart 3.7.2
- Firebase
  - Authentication
  - Firestore
  - Dynamic Links (deprecated, using App Links instead)
- Android App Links
  - GitHub Pages for hosting assetlinks.json

## Key Components

### Services
1. **AuthService**
   - Handles user authentication
   - Anonymous sign-in fallback
   - Google Sign-In integration

2. **BetService**
   - CRUD operations for bets
   - Real-time bet status updates
   - Streak tracking

3. **InviteService**
   - Generate invite links
   - Handle bet invitations
   - Track invite status

4. **AppLinksService**
   - Deep linking configuration
   - App-to-web navigation
   - Universal link handling

### Models
1. **PiggyBet**
   - Challenge description
   - Reward details
   - Progress tracking
   - Participant information

2. **Invite**
   - Invitation status
   - Bet reference
   - Participant details

### Features
1. **Authentication**
   - Google Sign-In
   - Anonymous authentication
   - User state management

2. **Place Bet**
   - Challenge creation
   - Reward setting
   - Friend invitation

3. **Check-in**
   - Daily progress tracking
   - Streak management
   - Joker system

4. **Friends**
   - Social connections
   - Challenge sharing
   - Leaderboards

### Deep Linking
- Host: profiler666.github.io
- Path: /piggybet
- Schemes: https, piggybet
- Verification: .well-known/assetlinks.json

## Firebase Collections
```javascript
/bets
  ├── betId
  │   ├── challengeDescription: string
  │   ├── rewardTitle: string
  │   ├── status: string
  │   ├── streakCount: number
  │   └── participants: array

/invites
  ├── inviteId
  │   ├── betId: string
  │   ├── inviterId: string
  │   ├── status: string
  │   └── createdAt: timestamp
```

## Build & Deployment
- Android SDK: API 35
- Target SDK: 35
- Min SDK: 23
- Kotlin Version: 1.9.22
- Gradle Version: 8.2.0

## Development Guidelines
1. Feature-first folder structure
2. Service-based architecture
3. Clean Architecture principles
4. Platform-specific implementations separated