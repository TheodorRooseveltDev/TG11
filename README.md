# 🎯 Bingo Clash

A professional, production-ready Flutter Bingo game with bot AI, theme customization, and progression systems.

## ✨ Features

### 🎮 Core Gameplay
- **Full Bingo Experience**: Classic 5x5 bingo card with B-I-N-G-O column structure
- **Smart Bot AI**: 4 difficulty levels (Easy, Medium, Hard, Expert) with realistic behavior
- **Win Conditions**: Horizontal, vertical, diagonal lines, four corners, and full house
- **Real-time Gameplay**: Automated number calling with visual feedback
- **Interactive Cards**: Tap cells to mark numbers as they're called

### 🎨 Design System
- **7 Gorgeous Themes**:
  - Modern Vibrant (default)
  - Minimalist Modern
  - 80's Retro (Synthwave)
  - 90's Nostalgia  
  - Space Opera
  - Cyberpunk
  - Nature Zen
- **60:30:10 Color Theory**: Professional color distribution for visual harmony
- **8-Point Grid System**: Consistent spacing across all screens
- **Modular Typography**: Scale-based text sizing with Inter font
- **Dark Mode Ready**: All themes optimized for dark environments

### 💰 Economy System
- **Coin Rewards**: Earn coins based on bot difficulty (1x - 3x multipliers)
- **Theme Unlocking**: Purchase themes with earned coins
- **Persistent Storage**: Coins and progress saved locally
- **Win Streak Bonuses**: Coming soon

### 🎯 Future Features (Roadmap)
- Power-ups system (Bonus Ball, Freeze, Peek, Swap, Double Coins)
- Achievement system with 20+ achievements
- Stats tracking (win rate, games played, records)
- Daily challenges and rewards
- Geo Bingo (world map progression)
- Multiplayer mode

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                    # App entry point
├── core/                        # Core utilities & design system
│   ├── constants/              # Spacing, radii, elevations, animations
│   └── theme/                  # Theme system, color tokens, typography
├── data/                        # Data layer
│   └── models/                 # Game models (Card, Number, Player, etc.)
├── domain/                      # Business logic
│   └── game_controller.dart   # Game state management & bot AI
└── presentation/               # UI layer
    ├── screens/               # App screens
    └── widgets/               # Reusable components
```

### Design Patterns
- **Provider**: State management for theme and game state
- **Repository Pattern**: Data access abstraction
- **MVVM**: Separation of concerns (Model-View-ViewModel)
- **Factory Pattern**: Model creation and initialization

## 🎨 Design System

### Color Tokens (60:30:10 Rule)
- **60% Primary**: Backgrounds, large surfaces
- **30% Secondary**: Cards, containers, panels
- **10% Accent**: Buttons, highlights, CTAs

### Spacing Scale (8pt Grid)
```dart
xxxs: 2px, xxs: 4px, xs: 8px, sm: 12px, md: 16px, 
lg: 24px, xl: 32px, xxl: 48px, xxxl: 64px, mega: 96px
```

### Typography (Modular Scale 1.25)
- Display: 56px, 44px
- Headers: 36px, 28px, 24px, 20px
- Body: 18px, 16px, 14px
- UI: Button, Caption, Overline

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart 3.9.2 or higher
- iOS 12.0+ / Android 5.0+

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/bingo_clash.git
cd bingo_clash

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Run on Specific Platform
```bash
flutter run -d chrome      # Web
flutter run -d macos       # macOS
flutter run -d ios         # iOS
flutter run -d android     # Android
```

## 📦 Dependencies

### Core
- `provider: ^6.1.1` - State management
- `shared_preferences: ^2.2.2` - Local storage

### UI/UX
- `google_fonts: ^6.1.0` - Typography (Inter font)
- `flutter_svg: ^2.0.9` - Vector graphics
- `confetti: ^0.7.0` - Celebration effects
- `flutter_animate: ^4.5.0` - Smooth animations

### Audio
- `audioplayers: ^5.2.1` - Sound effects (future)

## 🎮 How to Play

1. **Launch the App**: Tap "PLAY VS BOT" on the home screen
2. **Select Difficulty**: Choose from Easy, Medium, Hard, or Expert bot
3. **Play the Game**: 
   - Numbers are called automatically every 3 seconds
   - Tap cells on your card to mark called numbers
   - Watch the bot mark its card in real-time
4. **Win the Game**: Complete a line, diagonal, corners, or full house
5. **Earn Coins**: Collect coins based on difficulty (Easy: 50, Expert: 500)
6. **Unlock Themes**: Use coins to purchase new visual themes

## 🎯 Bot AI Details

### Easy Bot
- **Speed**: 60% marking rate
- **Delay**: 2-4 seconds per mark
- **Coins**: 1x multiplier (50 coins on win)

### Medium Bot
- **Speed**: 80% marking rate
- **Delay**: 1-2 seconds per mark
- **Coins**: 1.5x multiplier (100 coins on win)

### Hard Bot
- **Speed**: 95% marking rate
- **Delay**: 0.5-1 second per mark
- **Coins**: 2x multiplier (200 coins on win)

### Expert Bot
- **Speed**: 100% marking rate
- **Delay**: Instant (0-0.1 seconds)
- **Coins**: 3x multiplier (500 coins on win)

## 🎨 Theme Gallery

### Modern Vibrant (Default)
Royal blue and electric pink with gradient accents. Unlocked by default.

### Minimalist Modern
Clean, simple design with vibrant blue highlights. Unlocked by default.

### 80's Retro
Neon synthwave aesthetics with hot pink and cyan. **Cost: 500 coins**

### 90's Nostalgia
Bright yellow, magenta, and radical patterns. **Cost: 500 coins**

### Nature Zen
Peaceful sage green and earth tones. **Cost: 1,000 coins**

### Space Opera
Deep space blues with lightsaber accents. **Cost: 2,000 coins**

### Cyberpunk
Dark futuristic with neon pink and purple. **Cost: 5,000 coins**

## 🏆 Game Stats

The app tracks:
- Total games played
- Win/loss record
- Current win streak
- Best win streak
- Total coins earned
- Fastest win time
- Most efficient wins (fewest numbers called)

## 🔧 Development

### Run Tests
```bash
flutter test
```

### Build for Production
```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
flutter build appbundle --release

# Web
flutter build web --release

# macOS
flutter build macos --release
```

### Code Analysis
```bash
flutter analyze
```

## 🗺️ Roadmap

### Phase 1: MVP (Current)
- [x] Core bingo gameplay
- [x] Bot AI with 4 difficulties
- [x] 7 theme system
- [x] Coin economy
- [x] Theme unlocking

### Phase 2: Enhanced Features
- [ ] Power-ups system
- [ ] Achievement system
- [ ] Stats screen with charts
- [ ] Daily challenges
- [ ] Sound effects and music

### Phase 3: Advanced Features
- [ ] Geo Bingo (world map)
- [ ] Country-specific content
- [ ] Settings screen
- [ ] User profiles
- [ ] Cloud save (optional)

### Phase 4: Multiplayer
- [ ] Real-time multiplayer
- [ ] Private rooms
- [ ] Ranked mode
- [ ] Tournaments

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👏 Acknowledgments

- Design system inspired by Material Design 3
- Color theory based on 60:30:10 rule
- Typography using Google Fonts (Inter)
- Bot AI designed for realistic gameplay

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**

Made by following professional design principles and production-ready best practices.
