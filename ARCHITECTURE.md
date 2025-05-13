# PiggyBet Architecture

## Project Structure
```
lib/
├── core/
│   └── firebase_options.dart
├── features/
│   ├── home/
│   │   └── home_screen.dart
│   ├── place_bet/
│   │   ├── place_bet_screen.dart
│   │   └── place_bet_controller.dart
│   ├── checkin/
│   │   └── checkin_screen.dart
│   ├── friends/
│   │   └── friends_screen.dart
│   └── notifications/
│       └── notifications_screen.dart
├── models/
│   └── piggy_bet.dart
├── routing/
│   └── app_router.dart
├── services/
│   ├── auth_service.dart
│   ├── bet_service.dart
│   ├── checkin_service.dart
│   ├── invite_service.dart
│   └── notification_service.dart
├── widgets/
│   ├── app_button.dart
│   ├── bet_card.dart
│   ├── checkin_card.dart
│   └── piggybank_display.dart
└── main.dart
```

## Feature Specifications

### PiggyBet Model
- id: String
- userId: String
- challengeCategory: String
- challengeDescription: String
- rewardTitle: String
- rewardCategory: String
- rewardValue: double
- piggyBankValue: double
- frequency: String (everyday, weekly, weekdays, weekends)
- startDate: DateTime
- endDate: DateTime
- participantType: String (self, friend)
- status: String (active, completed, failed)
- streakCount: int
- jokerCount: int
- participantId: String?
- isPublic: bool

### Home Screen
- Display active bets
- Show streak information
- Quick access to create new bet
- Navigation to other features

### Place Bet Feature
- Challenge Details
  - Category selection
  - Description input
  - Frequency selection
  - Date range selection
- Reward Details
  - Category selection
  - Title input
  - Piggy bank value setting
- Participant Selection
  - Self or Friend option

### Check-in Feature
- Daily check-in for active bets
- Streak tracking
- Joker card usage
- Success/failure recording

### Friends Feature
- Friend list management
- Invite friends to challenges
- View friend activities
- Accept/reject bet invitations

### Notifications
- Daily reminders
- Streak alerts
- Friend requests
- Challenge invitations

### Social Feed Feature
- Display public bets
- Allow bet remixing
- Social interaction options
- Feed filtering and sorting

### Guest Mode Feature
- Anonymous authentication
- Limited feature access
- Upgrade prompts
- Deep link handling

## Services

### BetService
- createBet(PiggyBet bet)
- getUserBets(String userId)
- updateBetStatus(String betId, String status)
- deleteBet(String betId)

### AuthService
- signIn()
- signOut()
- getCurrentUser()
- updateUserProfile()

### CheckinService
- recordCheckin(String betId)
- useJoker(String betId)
- getStreakCount(String betId)

### InviteService
- sendInvite(String betId, String friendId)
- acceptInvite(String inviteId)
- rejectInvite(String inviteId)
- generateDynamicLink(String betId)
- handleInviteLink(String link)
- trackInviteStatus(String inviteId)

### NotificationService
- scheduleReminder(String betId)
- cancelReminder(String betId)
- sendStreakAlert(String betId)

### SocialFeedService
- getPublicBets()
- remixBet(String betId)
- toggleBetVisibility(String betId, bool isPublic)

## Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.13.0
  cloud_firestore: ^5.6.7
  firebase_auth: ^4.15.3
  firebase_messaging: ^14.7.9
```