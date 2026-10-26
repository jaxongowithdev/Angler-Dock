# Migration Guide: BrainFlip → Fishing Harbor

## Overview

This document outlines the complete transformation from BrainFlip (memory card game) to Fishing Harbor (fishing simulation game). This change was made to avoid Apple App Store duplicate/spam rejection.

## What Changed

### Package Name & Identity
- **Old**: `memory_match` - BrainFlip card matching game
- **New**: `fishing_harbor` - Fishing Harbor simulation game

### App Concept
- **Old**: Memory card matching with emoji/card themes
- **New**: Fishing simulation with harbor management

### Core Gameplay
- **Old**: Match pairs of cards in a grid (100% card matching)
- **New**:
  - 80% Fishing gameplay (cast, catch, reel)
  - 20% Support card system (52 SVG cards)

### File Structure Changes

#### Deleted Files (Old Game)
```
lib/src/game/
├── card_component.dart      ❌ Removed
├── game_theme.dart          ❌ Removed
└── memory_game.dart         ❌ Removed

lib/src/screens/
├── theme_selection_screen.dart  ❌ Removed
└── user_screen.dart             ❌ Removed
```

#### New Files (Fishing Harbor)
```
lib/src/
├── models/
│   ├── fish.dart                ✅ 180+ fish species
│   ├── boat.dart                ✅ 4 boat types
│   ├── equipment.dart           ✅ Rods, reels, hooks
│   ├── support_card.dart        ✅ 52 support cards
│   ├── harbor_building.dart     ✅ 7 building types
│   └── game_state.dart          ✅ Global state management
│
├── screens/
│   ├── home_screen.dart         ✅ Main hub
│   ├── harbor_screen.dart       ✅ Building management
│   ├── fishing_screen.dart      ✅ Main gameplay
│   ├── world_map_screen.dart    ✅ Area selection
│   ├── fish_encyclopedia_screen.dart  ✅ Collection tracker
│   ├── support_cards_screen.dart      ✅ Card management
│   ├── boat_garage_screen.dart        ✅ Boat upgrades
│   ├── shop_screen.dart               ✅ Equipment shop
│   ├── tasks_screen.dart              ✅ Missions
│   ├── profile_screen.dart            ✅ Player stats
│   └── settings_screen.dart           ✅ Game settings
│
└── fishing_harbor_app.dart      ✅ Main app
```

## UI/UX Changes

### Color Schemes
**Old BrainFlip:**
- Dark purple theme (#1A1A2E, #16213E)
- Card-centric design
- Grid layout

**New Fishing Harbor:**
- Ocean blue/teal gradients (#0A4D68, #05161A)
- Nature-inspired colors
- Harbor/nautical theme
- Multiple distinct screens with different color palettes

### Navigation
**Old:**
- Theme selection → Game screen
- 2 screens total

**New:**
- Bottom navigation with 5 tabs
- 11+ unique screens
- Deep navigation hierarchy

### Gameplay Loop
**Old:**
```
Select Theme → Play Memory Game → Win/Lose → Repeat
```

**New:**
```
Home → Select Area → Prepare Boat → Choose 5 Cards →
Go Fishing → Catch Fish → Return Harbor → Sell Fish →
Upgrade Boat/Buildings → Repeat
```

## Asset Usage

### Playing Card SVGs
**Old Usage:**
- Main gameplay mechanic
- Players match card pairs
- 8 cards used per game

**New Usage:**
- Support items (20% of gameplay)
- Optional power-ups
- Players select 5 cards before fishing
- Provides buffs and bonuses

## Data Models

### Old (BrainFlip)
```dart
class GameTheme {
  final String name;
  final List<String> emojis;
  final GameThemeType type;
}

class CardComponent {
  final int cardValue;
  final String label;
  bool isFlipped;
  bool isMatched;
}
```

### New (Fishing Harbor)
```dart
class Fish {
  final int id;
  final String name;
  final FishRarity rarity;
  final double baseWeight;
  final OceanArea habitat;
}

class Boat {
  final String id;
  final int engineLevel;
  final int fuelCapacity;
  final int storageCapacity;
}

class SupportCard {
  final CardSuit suit;
  final CardRank rank;
  final CardType type;
  final CardEffect effect;
}

class GameState extends ChangeNotifier {
  PlayerStats _stats;
  List<CaughtFish> _caughtFish;
  Map<int, double> _fishRecords;
  List<HarborBuilding> _buildings;
}
```

## Dependencies Changes

### Added
```yaml
provider: ^6.1.2  # State management
```

### Kept (from old app)
```yaml
flame: ^1.21.0
flame_svg: ^1.10.0
flutter_svg: ^2.0.10
```

## How to Run

### Development
```bash
cd example
fvm flutter run
```

### Build Release
```bash
# Android
cd example
fvm flutter build apk --release

# iOS
cd example
fvm flutter build ios --release
```

## Testing Checklist

- [ ] Home screen displays correctly
- [ ] Harbor building upgrades work
- [ ] Fishing gameplay (cast, bite, reel) works
- [ ] Fish are caught and stored
- [ ] Fish can be sold for coins
- [ ] World map shows 7 areas
- [ ] Fish encyclopedia tracks collection
- [ ] Support cards can be selected (max 5)
- [ ] Boat garage shows all boats
- [ ] Equipment shop allows purchases
- [ ] Profile displays accurate stats
- [ ] Settings persist changes
- [ ] Navigation works smoothly
- [ ] No crashes or errors

## Key Differences for App Store Review

### Rejection Avoidance
1. **Completely different gameplay**: Fishing simulation vs. memory matching
2. **Different UI/UX**: Ocean theme vs. card game theme
3. **Different target audience**: Casual fishing game vs. brain training
4. **Different features**: Harbor management, equipment upgrades, fish collection
5. **Different game loop**: Extended progression vs. quick matches
6. **Support cards are secondary**: Only 20% of gameplay vs. 100% in old app

### What Stayed the Same
- 52 SVG card assets (but used differently)
- Flutter/Flame framework
- Offline-first gameplay

### App Store Metadata Changes
```
Old:
- Name: BrainFlip
- Subtitle: Memory Card Matching Game
- Category: Puzzle / Brain Training
- Keywords: memory, cards, matching, brain, puzzle

New:
- Name: Fishing Harbor
- Subtitle: Fish • Sail • Upgrade • Build
- Category: Simulation / Adventure / Casual
- Keywords: fishing, simulation, harbor, boat, ocean, fish
```

## Rollback (If Needed)

If you need to rollback to the old BrainFlip game:

```bash
git checkout [commit-hash-before-migration]
```

Or restore from backup if you created one.

## Support

For issues related to this migration:
1. Check this guide first
2. Review the README.md
3. Check Flutter/Flame documentation
4. Contact the development team

---

**Migration Date**: [Current Date]
**Migrated By**: Claude Sonnet 4.5
**Reason**: Avoid Apple App Store duplicate/spam rejection
**Status**: ✅ Complete
