import 'package:flutter/foundation.dart';
import 'boat.dart';
import 'equipment.dart';
import 'fish.dart';
import 'harbor_building.dart';
import 'support_card.dart';
import 'mission.dart';
import '../services/save_service.dart';

enum WeatherType { sunny, rain, storm, fog, night }

class PlayerStats {
  final int level;
  final int xp;
  final int coins;
  final int energy;
  final int maxEnergy;

  const PlayerStats({
    this.level = 1,
    this.xp = 0,
    this.coins = 500,
    this.energy = 100,
    this.maxEnergy = 100,
  });

  int get xpToNextLevel => level * 100;

  PlayerStats copyWith({
    int? level,
    int? xp,
    int? coins,
    int? energy,
    int? maxEnergy,
  }) {
    return PlayerStats(
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      energy: energy ?? this.energy,
      maxEnergy: maxEnergy ?? this.maxEnergy,
    );
  }
}

class CaughtFish {
  final Fish fish;
  final double weight;
  final int value;
  final DateTime caughtAt;

  const CaughtFish({
    required this.fish,
    required this.weight,
    required this.value,
    required this.caughtAt,
  });
}

class GameState extends ChangeNotifier {
  PlayerStats _stats;
  Boat _currentBoat;
  List<Boat> _ownedBoats;
  Equipment _currentRod;
  Equipment? _currentReel;
  Equipment? _currentHook;
  List<Equipment> _ownedEquipment;
  List<HarborBuilding> _buildings;
  List<SupportCard> _ownedCards;
  List<SupportCard> _selectedCards;
  List<CaughtFish> _caughtFish;
  Map<int, double> _fishRecords; // fish id -> max weight
  WeatherType _currentWeather;
  OceanArea _currentArea;
  List<Mission> _dailyMissions;
  List<Mission> _weeklyMissions;
  List<Mission> _achievements;
  DateTime _lastMissionRefresh;
  DateTime _lastEnergyRegenTime;

  GameState({
    PlayerStats? stats,
    Boat? currentBoat,
    List<Boat>? ownedBoats,
    Equipment? currentRod,
    Equipment? currentReel,
    Equipment? currentHook,
    List<Equipment>? ownedEquipment,
    List<HarborBuilding>? buildings,
    List<SupportCard>? ownedCards,
    List<SupportCard>? selectedCards,
    List<CaughtFish>? caughtFish,
    Map<int, double>? fishRecords,
    WeatherType? currentWeather,
    OceanArea? currentArea,
    List<Mission>? dailyMissions,
    List<Mission>? weeklyMissions,
    List<Mission>? achievements,
    DateTime? lastMissionRefresh,
    DateTime? lastEnergyRegenTime,
  })  : _stats = stats ?? const PlayerStats(),
        _currentBoat = currentBoat ?? Boat.availableBoats.first,
        _ownedBoats = ownedBoats ?? [Boat.availableBoats.first],
        _currentRod = currentRod ?? Equipment.defaultRods.first,
        _currentReel = currentReel,
        _currentHook = currentHook,
        _ownedEquipment = ownedEquipment ?? [Equipment.defaultRods.first],
        _buildings = buildings ?? HarborBuilding.defaultBuildings,
        _ownedCards = ownedCards ?? SupportCard.allCards,
        _selectedCards = selectedCards ?? [],
        _caughtFish = caughtFish ?? [],
        _fishRecords = fishRecords ?? {},
        _currentWeather = currentWeather ?? WeatherType.sunny,
        _currentArea = currentArea ?? OceanArea.river,
        _dailyMissions = dailyMissions ?? Mission.generateDailyMissions(DateTime.now()),
        _weeklyMissions = weeklyMissions ?? Mission.generateWeeklyMissions(DateTime.now()),
        _achievements = achievements ?? Mission.achievements,
        _lastMissionRefresh = lastMissionRefresh ?? DateTime.now(),
        _lastEnergyRegenTime = lastEnergyRegenTime ?? DateTime.now() {
    _checkAndRefreshMissions();
    _unlockAllCards();
    _regenerateEnergy();
  }

  // Getters
  PlayerStats get stats => _stats;
  Boat get currentBoat => _currentBoat;
  List<Boat> get ownedBoats => List.unmodifiable(_ownedBoats);
  Equipment get currentRod => _currentRod;
  Equipment? get currentReel => _currentReel;
  Equipment? get currentHook => _currentHook;
  List<Equipment> get ownedEquipment => List.unmodifiable(_ownedEquipment);
  List<HarborBuilding> get buildings => List.unmodifiable(_buildings);
  List<SupportCard> get ownedCards => List.unmodifiable(_ownedCards);
  List<SupportCard> get selectedCards => List.unmodifiable(_selectedCards);
  List<CaughtFish> get caughtFish => List.unmodifiable(_caughtFish);
  Map<int, double> get fishRecords => Map.unmodifiable(_fishRecords);
  WeatherType get currentWeather => _currentWeather;
  OceanArea get currentArea => _currentArea;
  List<Mission> get dailyMissions => List.unmodifiable(_dailyMissions);
  List<Mission> get weeklyMissions => List.unmodifiable(_weeklyMissions);
  List<Mission> get achievements => List.unmodifiable(_achievements);
  DateTime get lastEnergyRegenTime => _lastEnergyRegenTime;

  int get collectedFishCount => _fishRecords.length;
  int get totalFishSpecies => Fish.allFish.length;
  double get collectionPercent => (collectedFishCount / totalFishSpecies) * 100;

  // Auto-save after changes
  void _autoSave() {
    SaveService.saveGame(this);
  }

  // Auto-unlock all 52 cards (for existing saves that only had 5 cards)
  void _unlockAllCards() {
    final ownedCardIds = _ownedCards.map((c) => '${c.rank.name}_${c.suit.name}').toSet();

    // Add any missing cards
    for (final card in SupportCard.allCards) {
      final cardId = '${card.rank.name}_${card.suit.name}';
      if (!ownedCardIds.contains(cardId)) {
        _ownedCards.add(card);
      }
    }
  }

  // Regenerate energy based on time passed (1 energy per minute)
  void _regenerateEnergy() {
    final now = DateTime.now();
    final minutesPassed = now.difference(_lastEnergyRegenTime).inMinutes;

    if (minutesPassed > 0) {
      final energyToAdd = minutesPassed;
      final currentEnergy = _stats.energy;
      final maxEnergy = _stats.maxEnergy;
      final newEnergy = (currentEnergy + energyToAdd).clamp(0, maxEnergy);

      if (newEnergy != currentEnergy) {
        _stats = _stats.copyWith(energy: newEnergy);
        _lastEnergyRegenTime = now;
        // Don't call notifyListeners or autoSave here since this is called in constructor
      }
    }
  }

  // Public method to manually trigger energy regeneration
  void checkEnergyRegeneration() {
    _regenerateEnergy();
    notifyListeners();
    _autoSave();
  }

  // Methods
  void addCoins(int amount) {
    _stats = _stats.copyWith(coins: _stats.coins + amount);
    notifyListeners();
    _autoSave();
  }

  void spendCoins(int amount) {
    if (_stats.coins >= amount) {
      _stats = _stats.copyWith(coins: _stats.coins - amount);
      notifyListeners();
      _autoSave();
    }
  }

  void addXP(int amount) {
    int newXP = _stats.xp + amount;
    int newLevel = _stats.level;

    while (newXP >= newLevel * 100) {
      newXP -= newLevel * 100;
      newLevel++;
    }

    _stats = _stats.copyWith(xp: newXP, level: newLevel);
    notifyListeners();
    _autoSave();
  }

  void useEnergy(int amount) {
    _stats = _stats.copyWith(
      energy: (_stats.energy - amount).clamp(0, _stats.maxEnergy),
    );
    notifyListeners();
    _autoSave();
  }

  void restoreEnergy(int amount) {
    _stats = _stats.copyWith(
      energy: (_stats.energy + amount).clamp(0, _stats.maxEnergy),
    );
    notifyListeners();
    _autoSave();
  }

  void catchFish(Fish fish, double weight, int value) {
    final caught = CaughtFish(
      fish: fish,
      weight: weight,
      value: value,
      caughtAt: DateTime.now(),
    );
    _caughtFish.add(caught);

    // Update record
    if (!_fishRecords.containsKey(fish.id) || weight > _fishRecords[fish.id]!) {
      _fishRecords[fish.id] = weight;
    }

    // Update missions
    _updateMissionProgress(MissionGoal.catchFish, 1);
    if (fish.rarity.index >= FishRarity.rare.index) {
      _updateMissionProgress(MissionGoal.catchRareFish, 1);
    }

    notifyListeners();
    _autoSave();
  }

  void sellAllFish() {
    int totalValue = 0;
    for (final caught in _caughtFish) {
      totalValue += caught.value;
    }

    addCoins(totalValue);
    _updateMissionProgress(MissionGoal.earnCoins, totalValue);
    _caughtFish.clear();
    notifyListeners();
    _autoSave();
  }

  void selectCard(SupportCard card) {
    if (_selectedCards.length < 5 && !_selectedCards.contains(card)) {
      _selectedCards.add(card);
      notifyListeners();
      _autoSave();
    }
  }

  void deselectCard(SupportCard card) {
    _selectedCards.remove(card);
    notifyListeners();
    _autoSave();
  }

  void clearSelectedCards() {
    _selectedCards.clear();
    notifyListeners();
    _autoSave();
  }

  void upgradeBuilding(BuildingType type) {
    final index = _buildings.indexWhere((b) => b.type == type);
    if (index != -1) {
      final building = _buildings[index];
      if (_stats.coins >= building.upgradeCost) {
        spendCoins(building.upgradeCost);
        _buildings[index] = building.copyWith(
          level: building.level + 1,
          isUnlocked: true,
        );
        notifyListeners();
        _autoSave();
      }
    }
  }

  void unlockBuilding(BuildingType type, int cost) {
    final index = _buildings.indexWhere((b) => b.type == type);
    if (index != -1 && _stats.coins >= cost) {
      spendCoins(cost);
      _buildings[index] = _buildings[index].copyWith(isUnlocked: true);
      notifyListeners();
      _autoSave();
    }
  }

  void setCurrentArea(OceanArea area) {
    _currentArea = area;
    notifyListeners();
    _autoSave();
  }

  void setWeather(WeatherType weather) {
    _currentWeather = weather;
    notifyListeners();
  }

  void equipBoat(Boat boat) {
    if (_ownedBoats.any((b) => b.id == boat.id)) {
      _currentBoat = boat;
      notifyListeners();
      _autoSave();
    }
  }

  void purchaseBoat(Boat boat) {
    if (!_ownedBoats.any((b) => b.id == boat.id)) {
      _ownedBoats.add(boat);
      notifyListeners();
      _autoSave();
    }
  }

  void equipRod(Equipment rod) {
    if (_ownedEquipment.any((e) => e.id == rod.id) && rod.type == EquipmentType.rod) {
      _currentRod = rod;
      notifyListeners();
      _autoSave();
    }
  }

  void purchaseEquipment(Equipment equipment) {
    if (_stats.coins >= equipment.price) {
      spendCoins(equipment.price);
      _ownedEquipment.add(equipment);
      notifyListeners();
      _autoSave();
    }
  }

  void unlockCard(SupportCard card) {
    if (!_ownedCards.any((c) => c.assetName == card.assetName)) {
      _ownedCards.add(card);
      notifyListeners();
      _autoSave();
    }
  }

  // Mission management
  void _checkAndRefreshMissions() {
    final now = DateTime.now();
    final lastRefresh = _lastMissionRefresh;

    // Refresh daily missions if new day
    if (now.day != lastRefresh.day ||
        now.month != lastRefresh.month ||
        now.year != lastRefresh.year) {
      _dailyMissions = Mission.generateDailyMissions(now);
      _lastMissionRefresh = now;
    }

    // Refresh weekly missions if new week
    if (now.difference(lastRefresh).inDays >= 7) {
      _weeklyMissions = Mission.generateWeeklyMissions(now);
      _lastMissionRefresh = now;
    }
  }

  void _updateMissionProgress(MissionGoal goal, int amount) {
    bool updated = false;

    // Update daily missions
    for (int i = 0; i < _dailyMissions.length; i++) {
      if (_dailyMissions[i].goal == goal && !_dailyMissions[i].isCompleted) {
        final newValue = _dailyMissions[i].currentValue + amount;
        _dailyMissions[i] = _dailyMissions[i].copyWith(
          currentValue: newValue,
          isCompleted: newValue >= _dailyMissions[i].targetValue,
        );
        updated = true;
      }
    }

    // Update weekly missions
    for (int i = 0; i < _weeklyMissions.length; i++) {
      if (_weeklyMissions[i].goal == goal && !_weeklyMissions[i].isCompleted) {
        final newValue = _weeklyMissions[i].currentValue + amount;
        _weeklyMissions[i] = _weeklyMissions[i].copyWith(
          currentValue: newValue,
          isCompleted: newValue >= _weeklyMissions[i].targetValue,
        );
        updated = true;
      }
    }

    // Update achievements
    for (int i = 0; i < _achievements.length; i++) {
      if (_achievements[i].goal == goal && !_achievements[i].isCompleted) {
        final newValue = _achievements[i].currentValue + amount;
        _achievements[i] = _achievements[i].copyWith(
          currentValue: newValue,
          isCompleted: newValue >= _achievements[i].targetValue,
        );
        updated = true;
      }
    }

    if (updated) {
      notifyListeners();
    }
  }

  void claimMissionReward(Mission mission) {
    if (!mission.isCompleted || mission.isClaimed) return;

    addCoins(mission.rewardCoins);
    addXP(mission.rewardXP);

    // Update mission status
    if (mission.type == MissionType.daily) {
      final index = _dailyMissions.indexWhere((m) => m.id == mission.id);
      if (index != -1) {
        _dailyMissions[index] = mission.copyWith(isClaimed: true);
      }
    } else if (mission.type == MissionType.weekly) {
      final index = _weeklyMissions.indexWhere((m) => m.id == mission.id);
      if (index != -1) {
        _weeklyMissions[index] = mission.copyWith(isClaimed: true);
      }
    } else {
      final index = _achievements.indexWhere((m) => m.id == mission.id);
      if (index != -1) {
        _achievements[index] = mission.copyWith(isClaimed: true);
      }
    }

    notifyListeners();
    _autoSave();
  }
}
