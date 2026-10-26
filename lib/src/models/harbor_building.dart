enum BuildingType {
  fishMarket,
  dock,
  warehouse,
  iceStorage,
  repairShop,
  aquarium,
  restaurant,
}

class HarborBuilding {
  final BuildingType type;
  final int level;
  final bool isUnlocked;
  final String name;
  final String emoji;
  final String description;

  const HarborBuilding({
    required this.type,
    required this.level,
    required this.isUnlocked,
    required this.name,
    required this.emoji,
    required this.description,
  });

  int get upgradeCost => 500 * level + 200;

  String get buff {
    switch (type) {
      case BuildingType.fishMarket:
        return '+${level * 5}% Fish sell price';
      case BuildingType.dock:
        return '+${level} Boat slots';
      case BuildingType.warehouse:
        return '+${level * 20} Storage capacity';
      case BuildingType.iceStorage:
        return 'Fish freshness +${level * 10}%';
      case BuildingType.repairShop:
        return 'Repair cost -${level * 10}%';
      case BuildingType.aquarium:
        return '+${level * 50} coins/hour';
      case BuildingType.restaurant:
        return '+${level * 15}% XP from fishing';
    }
  }

  HarborBuilding copyWith({
    BuildingType? type,
    int? level,
    bool? isUnlocked,
    String? name,
    String? emoji,
    String? description,
  }) {
    return HarborBuilding(
      type: type ?? this.type,
      level: level ?? this.level,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
    );
  }

  static List<HarborBuilding> get defaultBuildings => [
        const HarborBuilding(
          type: BuildingType.fishMarket,
          level: 1,
          isUnlocked: true,
          name: 'Fish Market',
          emoji: '🏪',
          description: 'Sell your catch at better prices',
        ),
        const HarborBuilding(
          type: BuildingType.dock,
          level: 1,
          isUnlocked: true,
          name: 'Dock',
          emoji: '⚓',
          description: 'Park and maintain your boats',
        ),
        const HarborBuilding(
          type: BuildingType.warehouse,
          level: 1,
          isUnlocked: false,
          name: 'Warehouse',
          emoji: '📦',
          description: 'Store more fish and equipment',
        ),
        const HarborBuilding(
          type: BuildingType.iceStorage,
          level: 1,
          isUnlocked: false,
          name: 'Ice Storage',
          emoji: '❄️',
          description: 'Keep fish fresh longer',
        ),
        const HarborBuilding(
          type: BuildingType.repairShop,
          level: 1,
          isUnlocked: false,
          name: 'Repair Shop',
          emoji: '🔧',
          description: 'Repair equipment at lower cost',
        ),
        const HarborBuilding(
          type: BuildingType.aquarium,
          level: 1,
          isUnlocked: false,
          name: 'Aquarium',
          emoji: '🐠',
          description: 'Display rare fish and earn passive income',
        ),
        const HarborBuilding(
          type: BuildingType.restaurant,
          level: 1,
          isUnlocked: false,
          name: 'Restaurant',
          emoji: '🍽️',
          description: 'Cook fish for bonus rewards',
        ),
      ];
}
