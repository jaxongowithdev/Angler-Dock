# Fishing Harbor

**Fish • Sail • Upgrade • Build**

A fishing simulation adventure game where players manage their own fishing harbor, explore various ocean areas, catch fish, upgrade boats, and build their harbor empire.

## Game Features

### Core Gameplay (80%)
- 🎣 **Fishing** - Cast your line, wait for bites, and reel in your catch
- ⛵ **Boat Upgrade** - Improve engine, storage, fuel capacity, and more
- ⚓ **Harbor Management** - Build and upgrade various harbor buildings
- 🐟 **Aquarium Collection** - Display rare fish and earn passive income
- 📋 **Fishing Missions** - Complete daily, weekly, and achievement tasks

### Support Card System (20%)
- 🃏 **52 Playing Card SVG Assets** - Used as support cards
- 4 Card Types:
  - ♠️ **Fishing Cards** - Boost fishing abilities
  - ♥️ **Recovery Cards** - Restore energy and repair equipment
  - ♦️ **Discovery Cards** - Increase rare fish and treasure chances
  - ♣️ **Utility Cards** - Special abilities and conveniences

## Game Areas

### Ocean Locations
1. 🏞️ **River** - Calm freshwater fishing (Level 1)
2. 🌊 **Lake** - Deep lakes with big catches (Level 1)
3. 🏖️ **Coast** - Coastal waters with variety (Level 2)
4. 🌊 **Deep Sea** - Legendary ocean giants (Level 5)
5. 🪸 **Coral Reef** - Colorful tropical paradise (Level 3)
6. ❄️ **Frozen Sea** - Arctic fishing adventure (Level 4)
7. 🌋 **Volcano Sea** - Extreme volcanic waters (Level 6)

## Fish Collection

- **180+ Fish Species** across all rarities:
  - Common (Grey)
  - Uncommon (Green)
  - Rare (Blue)
  - Epic (Purple)
  - Legendary (Orange)

Each fish has unique:
- Weight and size ranges
- Value and market price
- Habitat location
- Seasonal appearance
- Description and lore

## Harbor Buildings

Build and upgrade 7 different buildings:
1. 🏪 **Fish Market** - Increase fish sell prices
2. ⚓ **Dock** - Park and maintain more boats
3. 📦 **Warehouse** - Expand storage capacity
4. ❄️ **Ice Storage** - Keep fish fresh longer
5. 🔧 **Repair Shop** - Reduce equipment repair costs
6. 🐠 **Aquarium** - Display rare fish, earn passive income
7. 🍽️ **Restaurant** - Cook fish for bonus rewards

## Equipment System

Upgrade your fishing gear:
- 🎣 **Fishing Rods** (5 tiers)
- ⚙️ **Reels** (3 tiers)
- 🪝 **Hooks** (3 tiers)

Each equipment has:
- Level and power rating
- Durability system
- Upgrade costs

## Boat System

Choose from 4 boats:
1. 🚣 **Rowboat** - Starter boat
2. ⛵ **Fishing Boat** - Basic fishing vessel
3. 🚤 **Trawler** - Advanced commercial boat
4. 🛥️ **Fishing Yacht** - Luxury fishing experience

Upgrade stats:
- Engine level
- Fuel capacity
- Storage capacity
- Radar level
- Rod rack slots
- Hull durability

## App Structure

### Screens
- 🏠 **Home** - Main hub with stats and quick actions
- ⚓ **Harbor** - Manage and upgrade buildings
- 🎣 **Fishing** - Main gameplay screen
- 🗺️ **World Map** - Select fishing locations
- 🐟 **Fish Encyclopedia** - View collected fish
- 🃏 **Support Cards** - Manage card deck
- ⛵ **Boat Garage** - Purchase and upgrade boats
- 🏪 **Shop** - Buy equipment
- 📋 **Tasks** - Daily missions and achievements
- 👤 **Profile** - View stats and progress
- ⚙️ **Settings** - Audio, graphics, and preferences

### Tech Stack
- **Framework**: Flutter 3.32.0+
- **Game Engine**: Flame 1.21.0
- **State Management**: Provider 6.1.2
- **Assets**: SVG playing cards (52 cards)

## Getting Started

### Prerequisites
- Flutter SDK 3.32.0 or higher
- Dart SDK 3.4.0 or higher
- FVM (Flutter Version Management) recommended

### Installation

```bash
# Clone the repository
git clone [repository-url]

# Navigate to project directory
cd Fishing-Harbor

# Get dependencies
fvm flutter pub get

# Navigate to example directory
cd example

# Run the app
fvm flutter run
```

### Build Commands

```bash
# Run in debug mode
cd example && fvm flutter run

# Build for release
cd example && fvm flutter build apk # Android
cd example && fvm flutter build ios # iOS
```

## Game Design

### Target Session Time
2-8 minutes per fishing session

### Game Mode
Offline-first - Play without internet connection

### Monetization (Optional)
- Premium boats and equipment
- Energy refills
- Cosmetic items (boat paint, decorations)
- Ad-free experience

## Project Structure

```
lib/
├── src/
│   ├── models/
│   │   ├── fish.dart           # Fish species data
│   │   ├── boat.dart           # Boat types and stats
│   │   ├── equipment.dart      # Fishing equipment
│   │   ├── support_card.dart   # Card system
│   │   ├── harbor_building.dart # Building management
│   │   └── game_state.dart     # Global game state
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── harbor_screen.dart
│   │   ├── fishing_screen.dart
│   │   ├── world_map_screen.dart
│   │   ├── fish_encyclopedia_screen.dart
│   │   ├── support_cards_screen.dart
│   │   ├── boat_garage_screen.dart
│   │   ├── shop_screen.dart
│   │   ├── tasks_screen.dart
│   │   ├── profile_screen.dart
│   │   └── settings_screen.dart
│   └── fishing_harbor_app.dart  # Main app widget
├── fishing_harbor_app.dart      # Public export
└── user_screen.dart             # Legacy export (deprecated)

assets/
└── cards/                        # 52 SVG playing card assets
```

## Development Notes

- This app was transformed from a memory card game to avoid Apple App Store duplicate spam
- All game mechanics are completely different from the previous app
- The UI uses completely different color schemes and layouts
- The 52 SVG card assets are repurposed as support cards (not main gameplay)

## License

[Your License Here]

## Credits

- Game Design: Fishing Harbor Team
- SVG Card Assets: [Source]
- Built with Flutter and Flame

## Contact

For support or feedback, please contact: [Your Contact Info]
