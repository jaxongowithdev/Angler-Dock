enum EquipmentType { rod, reel, hook, line, net, harpoon }

class Equipment {
  final String id;
  final String name;
  final EquipmentType type;
  final int level;
  final int durability;
  final int maxDurability;
  final double power;
  final int price;
  final String emoji;

  const Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.level,
    required this.durability,
    required this.maxDurability,
    required this.power,
    required this.price,
    required this.emoji,
  });

  Equipment copyWith({
    String? id,
    String? name,
    EquipmentType? type,
    int? level,
    int? durability,
    int? maxDurability,
    double? power,
    int? price,
    String? emoji,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      level: level ?? this.level,
      durability: durability ?? this.durability,
      maxDurability: maxDurability ?? this.maxDurability,
      power: power ?? this.power,
      price: price ?? this.price,
      emoji: emoji ?? this.emoji,
    );
  }

  Equipment repair() {
    return copyWith(durability: maxDurability);
  }

  Equipment useDurability(int amount) {
    return copyWith(durability: (durability - amount).clamp(0, maxDurability));
  }

  double get durabilityPercent => maxDurability > 0 ? durability / maxDurability : 0;

  static List<Equipment> get defaultRods => [
        const Equipment(
          id: 'wooden_rod',
          name: 'Wooden Rod',
          type: EquipmentType.rod,
          level: 1,
          durability: 100,
          maxDurability: 100,
          power: 1.0,
          price: 50,
          emoji: '🎣',
        ),
        const Equipment(
          id: 'bamboo_rod',
          name: 'Bamboo Rod',
          type: EquipmentType.rod,
          level: 2,
          durability: 150,
          maxDurability: 150,
          power: 1.3,
          price: 150,
          emoji: '🎣',
        ),
        const Equipment(
          id: 'carbon_rod',
          name: 'Carbon Rod',
          type: EquipmentType.rod,
          level: 3,
          durability: 200,
          maxDurability: 200,
          power: 1.6,
          price: 350,
          emoji: '🎣',
        ),
        const Equipment(
          id: 'titanium_rod',
          name: 'Titanium Rod',
          type: EquipmentType.rod,
          level: 4,
          durability: 300,
          maxDurability: 300,
          power: 2.0,
          price: 750,
          emoji: '🎣',
        ),
        const Equipment(
          id: 'legendary_rod',
          name: 'Legendary Rod',
          type: EquipmentType.rod,
          level: 5,
          durability: 500,
          maxDurability: 500,
          power: 3.0,
          price: 2000,
          emoji: '🎣',
        ),
      ];

  static List<Equipment> get defaultReels => [
        const Equipment(
          id: 'basic_reel',
          name: 'Basic Reel',
          type: EquipmentType.reel,
          level: 1,
          durability: 100,
          maxDurability: 100,
          power: 1.0,
          price: 40,
          emoji: '⚙️',
        ),
        const Equipment(
          id: 'speed_reel',
          name: 'Speed Reel',
          type: EquipmentType.reel,
          level: 2,
          durability: 150,
          maxDurability: 150,
          power: 1.4,
          price: 120,
          emoji: '⚙️',
        ),
        const Equipment(
          id: 'pro_reel',
          name: 'Pro Reel',
          type: EquipmentType.reel,
          level: 3,
          durability: 200,
          maxDurability: 200,
          power: 1.8,
          price: 300,
          emoji: '⚙️',
        ),
      ];

  static List<Equipment> get defaultHooks => [
        const Equipment(
          id: 'iron_hook',
          name: 'Iron Hook',
          type: EquipmentType.hook,
          level: 1,
          durability: 80,
          maxDurability: 80,
          power: 1.0,
          price: 30,
          emoji: '🪝',
        ),
        const Equipment(
          id: 'steel_hook',
          name: 'Steel Hook',
          type: EquipmentType.hook,
          level: 2,
          durability: 120,
          maxDurability: 120,
          power: 1.3,
          price: 80,
          emoji: '🪝',
        ),
        const Equipment(
          id: 'diamond_hook',
          name: 'Diamond Hook',
          type: EquipmentType.hook,
          level: 3,
          durability: 200,
          maxDurability: 200,
          power: 1.8,
          price: 250,
          emoji: '🪝',
        ),
      ];
}
