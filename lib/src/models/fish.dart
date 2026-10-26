import 'package:flutter/material.dart';

enum FishRarity { common, uncommon, rare, epic, legendary }

enum OceanArea {
  river,
  lake,
  coast,
  deepSea,
  coralReef,
  frozenSea,
  volcanoSea,
}

class Fish {
  final int id;
  final String name;
  final FishRarity rarity;
  final double baseWeight;
  final double baseValue;
  final OceanArea habitat;
  final String emoji;
  final String description;
  final List<String> seasons;

  const Fish({
    required this.id,
    required this.name,
    required this.rarity,
    required this.baseWeight,
    required this.baseValue,
    required this.habitat,
    required this.emoji,
    required this.description,
    this.seasons = const ['Spring', 'Summer', 'Fall', 'Winter'],
  });

  Color get rarityColor {
    switch (rarity) {
      case FishRarity.common:
        return Colors.grey;
      case FishRarity.uncommon:
        return Colors.green;
      case FishRarity.rare:
        return Colors.blue;
      case FishRarity.epic:
        return Colors.purple;
      case FishRarity.legendary:
        return Colors.orange;
    }
  }

  String get rarityName {
    switch (rarity) {
      case FishRarity.common:
        return 'Common';
      case FishRarity.uncommon:
        return 'Uncommon';
      case FishRarity.rare:
        return 'Rare';
      case FishRarity.epic:
        return 'Epic';
      case FishRarity.legendary:
        return 'Legendary';
    }
  }

  static List<Fish> get allFish => [
        // River Fish
        const Fish(
          id: 1,
          name: 'Catfish',
          rarity: FishRarity.common,
          baseWeight: 3.5,
          baseValue: 20,
          habitat: OceanArea.river,
          emoji: '🐟',
          description: 'A common river dweller with whisker-like barbels.',
        ),
        const Fish(
          id: 2,
          name: 'Rainbow Trout',
          rarity: FishRarity.uncommon,
          baseWeight: 2.8,
          baseValue: 35,
          habitat: OceanArea.river,
          emoji: '🐠',
          description: 'Colorful freshwater fish with distinctive markings.',
        ),
        const Fish(
          id: 3,
          name: 'Pike',
          rarity: FishRarity.rare,
          baseWeight: 8.5,
          baseValue: 65,
          habitat: OceanArea.river,
          emoji: '🐊',
          description: 'Aggressive predator with sharp teeth.',
        ),
        // Lake Fish
        const Fish(
          id: 4,
          name: 'Bass',
          rarity: FishRarity.common,
          baseWeight: 4.2,
          baseValue: 25,
          habitat: OceanArea.lake,
          emoji: '🐟',
          description: 'Popular sport fish found in lakes.',
        ),
        const Fish(
          id: 5,
          name: 'Perch',
          rarity: FishRarity.common,
          baseWeight: 1.5,
          baseValue: 15,
          habitat: OceanArea.lake,
          emoji: '🐠',
          description: 'Small schooling fish with striped pattern.',
        ),
        const Fish(
          id: 6,
          name: 'Sturgeon',
          rarity: FishRarity.legendary,
          baseWeight: 45.0,
          baseValue: 350,
          habitat: OceanArea.lake,
          emoji: '🐋',
          description: 'Ancient giant of freshwater, prized for caviar.',
        ),
        // Coast Fish
        const Fish(
          id: 7,
          name: 'Mackerel',
          rarity: FishRarity.common,
          baseWeight: 1.8,
          baseValue: 18,
          habitat: OceanArea.coast,
          emoji: '🐟',
          description: 'Fast-swimming coastal fish.',
        ),
        const Fish(
          id: 8,
          name: 'Sea Bass',
          rarity: FishRarity.uncommon,
          baseWeight: 6.5,
          baseValue: 45,
          habitat: OceanArea.coast,
          emoji: '🐠',
          description: 'Prized coastal fish with delicate flavor.',
        ),
        const Fish(
          id: 9,
          name: 'Salmon',
          rarity: FishRarity.rare,
          baseWeight: 12.0,
          baseValue: 85,
          habitat: OceanArea.coast,
          emoji: '🐟',
          description: 'Migratory fish known for upstream journeys.',
          seasons: ['Fall', 'Spring'],
        ),
        // Deep Sea Fish
        const Fish(
          id: 10,
          name: 'Tuna',
          rarity: FishRarity.rare,
          baseWeight: 35.0,
          baseValue: 150,
          habitat: OceanArea.deepSea,
          emoji: '🐟',
          description: 'Large fast-swimming ocean predator.',
        ),
        const Fish(
          id: 11,
          name: 'Swordfish',
          rarity: FishRarity.epic,
          baseWeight: 75.0,
          baseValue: 250,
          habitat: OceanArea.deepSea,
          emoji: '🗡️',
          description: 'Powerful fish with distinctive sword-like bill.',
        ),
        const Fish(
          id: 12,
          name: 'Marlin',
          rarity: FishRarity.epic,
          baseWeight: 85.0,
          baseValue: 300,
          habitat: OceanArea.deepSea,
          emoji: '🐟',
          description: 'Trophy fish sought by sport fishermen.',
        ),
        const Fish(
          id: 13,
          name: 'Giant Squid',
          rarity: FishRarity.legendary,
          baseWeight: 150.0,
          baseValue: 500,
          habitat: OceanArea.deepSea,
          emoji: '🦑',
          description: 'Mysterious deep-sea creature of legend.',
        ),
        // Coral Reef Fish
        const Fish(
          id: 14,
          name: 'Clownfish',
          rarity: FishRarity.common,
          baseWeight: 0.3,
          baseValue: 35,
          habitat: OceanArea.coralReef,
          emoji: '🐠',
          description: 'Small colorful reef dweller.',
        ),
        const Fish(
          id: 15,
          name: 'Angelfish',
          rarity: FishRarity.uncommon,
          baseWeight: 0.8,
          baseValue: 55,
          habitat: OceanArea.coralReef,
          emoji: '🐠',
          description: 'Beautiful tropical fish with vibrant colors.',
        ),
        const Fish(
          id: 16,
          name: 'Parrotfish',
          rarity: FishRarity.uncommon,
          baseWeight: 3.5,
          baseValue: 60,
          habitat: OceanArea.coralReef,
          emoji: '🐠',
          description: 'Colorful fish that feeds on coral.',
        ),
        const Fish(
          id: 17,
          name: 'Seahorse',
          rarity: FishRarity.rare,
          baseWeight: 0.1,
          baseValue: 120,
          habitat: OceanArea.coralReef,
          emoji: '🦄',
          description: 'Unique tiny fish with horse-like appearance.',
        ),
        const Fish(
          id: 18,
          name: 'Manta Ray',
          rarity: FishRarity.epic,
          baseWeight: 200.0,
          baseValue: 280,
          habitat: OceanArea.coralReef,
          emoji: '🦋',
          description: 'Graceful giant of the reef.',
        ),
        // Frozen Sea Fish
        const Fish(
          id: 19,
          name: 'Arctic Cod',
          rarity: FishRarity.common,
          baseWeight: 2.5,
          baseValue: 30,
          habitat: OceanArea.frozenSea,
          emoji: '🐟',
          description: 'Hardy fish adapted to freezing waters.',
        ),
        const Fish(
          id: 20,
          name: 'Icefish',
          rarity: FishRarity.uncommon,
          baseWeight: 1.8,
          baseValue: 75,
          habitat: OceanArea.frozenSea,
          emoji: '❄️',
          description: 'Transparent fish with antifreeze proteins.',
        ),
        const Fish(
          id: 21,
          name: 'Halibut',
          rarity: FishRarity.rare,
          baseWeight: 25.0,
          baseValue: 140,
          habitat: OceanArea.frozenSea,
          emoji: '🐟',
          description: 'Large flatfish from cold waters.',
        ),
        const Fish(
          id: 22,
          name: 'Narwhal',
          rarity: FishRarity.legendary,
          baseWeight: 800.0,
          baseValue: 800,
          habitat: OceanArea.frozenSea,
          emoji: '🦄',
          description: 'Arctic whale with a long spiral tusk.',
        ),
        // Volcano Sea Fish
        const Fish(
          id: 23,
          name: 'Volcanic Crab',
          rarity: FishRarity.uncommon,
          baseWeight: 1.2,
          baseValue: 65,
          habitat: OceanArea.volcanoSea,
          emoji: '🦀',
          description: 'Heat-resistant crustacean.',
        ),
        const Fish(
          id: 24,
          name: 'Lava Eel',
          rarity: FishRarity.rare,
          baseWeight: 8.0,
          baseValue: 125,
          habitat: OceanArea.volcanoSea,
          emoji: '🔥',
          description: 'Mysterious eel thriving in extreme heat.',
        ),
        const Fish(
          id: 25,
          name: 'Magma Shark',
          rarity: FishRarity.epic,
          baseWeight: 120.0,
          baseValue: 380,
          habitat: OceanArea.volcanoSea,
          emoji: '🦈',
          description: 'Fearsome predator of volcanic waters.',
        ),
        const Fish(
          id: 26,
          name: 'Phoenix Fish',
          rarity: FishRarity.legendary,
          baseWeight: 50.0,
          baseValue: 999,
          habitat: OceanArea.volcanoSea,
          emoji: '🔥',
          description: 'Mythical fish said to be reborn from ashes.',
        ),
      ];

  static List<Fish> getFishByArea(OceanArea area) {
    return allFish.where((fish) => fish.habitat == area).toList();
  }
}
