import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/boat.dart';
import '../models/equipment.dart';
import '../models/harbor_building.dart';
import '../models/support_card.dart';
import '../models/fish.dart';

class SaveService {
  static const String _keyPlayerStats = 'player_stats';
  static const String _keyCurrentBoat = 'current_boat';
  static const String _keyOwnedBoats = 'owned_boats';
  static const String _keyCurrentRod = 'current_rod';
  static const String _keyOwnedEquipment = 'owned_equipment';
  static const String _keyBuildings = 'buildings';
  static const String _keyOwnedCards = 'owned_cards';
  static const String _keyFishRecords = 'fish_records';
  static const String _keyCurrentArea = 'current_area';
  static const String _keyLastSave = 'last_save';
  static const String _keyLastEnergyRegen = 'last_energy_regen';

  static Future<void> saveGame(GameState gameState) async {
    final prefs = await SharedPreferences.getInstance();

    // Save player stats
    await prefs.setString(_keyPlayerStats, jsonEncode({
      'level': gameState.stats.level,
      'xp': gameState.stats.xp,
      'coins': gameState.stats.coins,
      'energy': gameState.stats.energy,
      'maxEnergy': gameState.stats.maxEnergy,
    }));

    // Save current boat
    await prefs.setString(_keyCurrentBoat, gameState.currentBoat.id);

    // Save owned boats
    await prefs.setStringList(
      _keyOwnedBoats,
      gameState.ownedBoats.map((b) => b.id).toList(),
    );

    // Save current rod
    await prefs.setString(_keyCurrentRod, gameState.currentRod.id);

    // Save owned equipment
    await prefs.setStringList(
      _keyOwnedEquipment,
      gameState.ownedEquipment.map((e) => e.id).toList(),
    );

    // Save buildings
    final buildingsData = gameState.buildings.map((b) => {
      'type': b.type.index,
      'level': b.level,
      'isUnlocked': b.isUnlocked,
    }).toList();
    await prefs.setString(_keyBuildings, jsonEncode(buildingsData));

    // Save owned cards
    await prefs.setStringList(
      _keyOwnedCards,
      gameState.ownedCards.map((c) => c.assetName).toList(),
    );

    // Save fish records
    final fishRecordsData = gameState.fishRecords.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    await prefs.setString(_keyFishRecords, jsonEncode(fishRecordsData));

    // Save current area
    await prefs.setInt(_keyCurrentArea, gameState.currentArea.index);

    // Save last energy regen time
    await prefs.setString(_keyLastEnergyRegen, gameState.lastEnergyRegenTime.toIso8601String());

    // Save timestamp
    await prefs.setString(_keyLastSave, DateTime.now().toIso8601String());
  }

  static Future<GameState?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_keyPlayerStats)) {
      return null; // No save data
    }

    try {
      // Load player stats
      final statsJson = jsonDecode(prefs.getString(_keyPlayerStats)!);
      final stats = PlayerStats(
        level: statsJson['level'],
        xp: statsJson['xp'],
        coins: statsJson['coins'],
        energy: statsJson['energy'],
        maxEnergy: statsJson['maxEnergy'],
      );

      // Load boats
      final currentBoatId = prefs.getString(_keyCurrentBoat);
      final ownedBoatIds = prefs.getStringList(_keyOwnedBoats) ?? [];
      final ownedBoats = Boat.availableBoats
          .where((b) => ownedBoatIds.contains(b.id))
          .toList();
      final currentBoat = Boat.availableBoats
          .firstWhere((b) => b.id == currentBoatId, orElse: () => Boat.availableBoats.first);

      // Load equipment
      final currentRodId = prefs.getString(_keyCurrentRod);
      final ownedEquipmentIds = prefs.getStringList(_keyOwnedEquipment) ?? [];
      final allEquipment = [
        ...Equipment.defaultRods,
        ...Equipment.defaultReels,
        ...Equipment.defaultHooks,
      ];
      final ownedEquipment = allEquipment
          .where((e) => ownedEquipmentIds.contains(e.id))
          .toList();
      final currentRod = Equipment.defaultRods
          .firstWhere((r) => r.id == currentRodId, orElse: () => Equipment.defaultRods.first);

      // Load buildings
      final buildingsJson = jsonDecode(prefs.getString(_keyBuildings) ?? '[]') as List;
      final buildings = buildingsJson.map((b) {
        final defaultBuilding = HarborBuilding.defaultBuildings[b['type']];
        return defaultBuilding.copyWith(
          level: b['level'],
          isUnlocked: b['isUnlocked'],
        );
      }).toList();

      // Load cards
      final ownedCardNames = prefs.getStringList(_keyOwnedCards) ?? [];
      final ownedCards = SupportCard.allCards
          .where((c) => ownedCardNames.contains(c.assetName))
          .toList();

      // Load fish records
      final fishRecordsJson = jsonDecode(prefs.getString(_keyFishRecords) ?? '{}');
      final fishRecords = <int, double>{};
      fishRecordsJson.forEach((key, value) {
        fishRecords[int.parse(key)] = value;
      });

      // Load current area
      final areaIndex = prefs.getInt(_keyCurrentArea) ?? 0;
      final currentArea = OceanArea.values[areaIndex];

      // Load last energy regen time
      final lastEnergyRegenStr = prefs.getString(_keyLastEnergyRegen);
      final lastEnergyRegenTime = lastEnergyRegenStr != null
          ? DateTime.parse(lastEnergyRegenStr)
          : DateTime.now();

      return GameState(
        stats: stats,
        currentBoat: currentBoat,
        ownedBoats: ownedBoats,
        currentRod: currentRod,
        ownedEquipment: ownedEquipment,
        buildings: buildings,
        ownedCards: ownedCards,
        fishRecords: fishRecords,
        currentArea: currentArea,
        lastEnergyRegenTime: lastEnergyRegenTime,
      );
    } catch (e) {
      print('Error loading game: $e');
      return null;
    }
  }

  static Future<void> clearSave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<DateTime?> getLastSaveTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSaveStr = prefs.getString(_keyLastSave);
    if (lastSaveStr != null) {
      return DateTime.parse(lastSaveStr);
    }
    return null;
  }
}
