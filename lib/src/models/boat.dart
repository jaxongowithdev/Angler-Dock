class Boat {
  final String id;
  final String name;
  final int engineLevel;
  final int fuelCapacity;
  final int storageCapacity;
  final int radarLevel;
  final int rodRackSlots;
  final int hullLevel;
  final String emoji;

  const Boat({
    required this.id,
    required this.name,
    this.engineLevel = 1,
    this.fuelCapacity = 100,
    this.storageCapacity = 50,
    this.radarLevel = 1,
    this.rodRackSlots = 1,
    this.hullLevel = 1,
    this.emoji = '⛵',
  });

  int get upgradeCost => (engineLevel + fuelCapacity ~/ 20 + storageCapacity ~/ 10 + radarLevel + hullLevel) * 100;

  Boat copyWith({
    String? id,
    String? name,
    int? engineLevel,
    int? fuelCapacity,
    int? storageCapacity,
    int? radarLevel,
    int? rodRackSlots,
    int? hullLevel,
    String? emoji,
  }) {
    return Boat(
      id: id ?? this.id,
      name: name ?? this.name,
      engineLevel: engineLevel ?? this.engineLevel,
      fuelCapacity: fuelCapacity ?? this.fuelCapacity,
      storageCapacity: storageCapacity ?? this.storageCapacity,
      radarLevel: radarLevel ?? this.radarLevel,
      rodRackSlots: rodRackSlots ?? this.rodRackSlots,
      hullLevel: hullLevel ?? this.hullLevel,
      emoji: emoji ?? this.emoji,
    );
  }

  static const List<Boat> availableBoats = [
    Boat(
      id: 'rowboat',
      name: 'Rowboat',
      engineLevel: 1,
      fuelCapacity: 50,
      storageCapacity: 30,
      radarLevel: 0,
      rodRackSlots: 1,
      hullLevel: 1,
      emoji: '🚣',
    ),
    Boat(
      id: 'fishing_boat',
      name: 'Fishing Boat',
      engineLevel: 2,
      fuelCapacity: 100,
      storageCapacity: 50,
      radarLevel: 1,
      rodRackSlots: 2,
      hullLevel: 2,
      emoji: '⛵',
    ),
    Boat(
      id: 'trawler',
      name: 'Trawler',
      engineLevel: 3,
      fuelCapacity: 150,
      storageCapacity: 80,
      radarLevel: 2,
      rodRackSlots: 3,
      hullLevel: 3,
      emoji: '🚤',
    ),
    Boat(
      id: 'yacht',
      name: 'Fishing Yacht',
      engineLevel: 5,
      fuelCapacity: 250,
      storageCapacity: 150,
      radarLevel: 4,
      rodRackSlots: 5,
      hullLevel: 5,
      emoji: '🛥️',
    ),
  ];
}
