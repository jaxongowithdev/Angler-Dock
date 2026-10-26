import 'dart:math';
import '../models/fish.dart';
import '../models/game_state.dart';
import '../models/support_card.dart';
import '../models/harbor_building.dart';

class FishingService {
  static const double baseCastDistance = 50.0;
  static const double maxCastDistance = 100.0;

  /// Calculate cast distance based on power (0.0 to 1.0)
  static double calculateCastDistance(double power, GameState gameState) {
    double distance = baseCastDistance + (power * (maxCastDistance - baseCastDistance));

    // Apply equipment bonus
    distance *= gameState.currentRod.power;

    // Apply support card bonus
    final castCards = gameState.selectedCards.where(
      (c) => c.effect == CardEffect.castDistanceBoost,
    );
    for (final card in castCards) {
      distance *= (1 + card.value / 100);
    }

    return distance;
  }

  /// Calculate fish bite chance based on distance and area
  static double calculateBiteChance(double castDistance, OceanArea area) {
    // Longer distance = better fish, but also depends on area
    double baseChance = 0.7;

    // Distance bonus (50-100m = 0% to 30% bonus)
    double distanceBonus = ((castDistance - baseCastDistance) / (maxCastDistance - baseCastDistance)) * 0.3;

    return (baseChance + distanceBonus).clamp(0.5, 0.95);
  }

  /// Select a fish based on rarity weights and modifiers
  static Fish selectFish(OceanArea area, double castDistance, GameState gameState) {
    final fishList = Fish.getFishByArea(area);
    if (fishList.isEmpty) return Fish.allFish.first;

    // Calculate rarity modifiers
    double rarityBoost = 0.0;

    // Support card boost
    final rareFishCards = gameState.selectedCards.where(
      (c) => c.effect == CardEffect.rareFishChanceBoost,
    );
    for (final card in rareFishCards) {
      rarityBoost += card.value / 100;
    }

    // Cast distance boost (longer cast = better chance)
    rarityBoost += ((castDistance - baseCastDistance) / (maxCastDistance - baseCastDistance)) * 0.2;

    // Boat radar boost
    rarityBoost += gameState.currentBoat.radarLevel * 0.05;

    final random = Random();
    final roll = random.nextDouble() * (1 - rarityBoost);

    Fish selectedFish;

    if (roll < 0.40) {
      // Common (40%)
      final commonFish = fishList.where((f) => f.rarity == FishRarity.common).toList();
      selectedFish = commonFish.isNotEmpty
          ? commonFish[random.nextInt(commonFish.length)]
          : fishList[random.nextInt(fishList.length)];
    } else if (roll < 0.65) {
      // Uncommon (25%)
      final uncommonFish = fishList.where((f) => f.rarity == FishRarity.uncommon).toList();
      selectedFish = uncommonFish.isNotEmpty
          ? uncommonFish[random.nextInt(uncommonFish.length)]
          : fishList[random.nextInt(fishList.length)];
    } else if (roll < 0.83) {
      // Rare (18%)
      final rareFish = fishList.where((f) => f.rarity == FishRarity.rare).toList();
      selectedFish = rareFish.isNotEmpty
          ? rareFish[random.nextInt(rareFish.length)]
          : fishList[random.nextInt(fishList.length)];
    } else if (roll < 0.95) {
      // Epic (12%)
      final epicFish = fishList.where((f) => f.rarity == FishRarity.epic).toList();
      selectedFish = epicFish.isNotEmpty
          ? epicFish[random.nextInt(epicFish.length)]
          : fishList[random.nextInt(fishList.length)];
    } else {
      // Legendary (5%)
      final legendaryFish = fishList.where((f) => f.rarity == FishRarity.legendary).toList();
      selectedFish = legendaryFish.isNotEmpty
          ? legendaryFish[random.nextInt(legendaryFish.length)]
          : fishList[random.nextInt(fishList.length)];
    }

    return selectedFish;
  }

  /// Calculate fish weight with variations
  static double calculateFishWeight(Fish fish, double castDistance, GameState gameState) {
    final random = Random();

    // Base weight with 70-130% variation
    double weight = fish.baseWeight * (0.7 + random.nextDouble() * 0.6);

    // Cast distance bonus (longer cast = bigger fish)
    double distanceMultiplier = 1.0 + ((castDistance - baseCastDistance) / (maxCastDistance - baseCastDistance)) * 0.3;
    weight *= distanceMultiplier;

    // Equipment bonus
    weight *= (1.0 + (gameState.currentRod.power - 1.0) * 0.2);

    return weight;
  }

  /// Calculate reel difficulty (0-1, higher = harder)
  static double calculateReelDifficulty(Fish fish, double fishWeight) {
    double baseDifficulty = 0.3;

    // Rarity adds difficulty
    switch (fish.rarity) {
      case FishRarity.common:
        baseDifficulty = 0.2;
        break;
      case FishRarity.uncommon:
        baseDifficulty = 0.3;
        break;
      case FishRarity.rare:
        baseDifficulty = 0.45;
        break;
      case FishRarity.epic:
        baseDifficulty = 0.6;
        break;
      case FishRarity.legendary:
        baseDifficulty = 0.8;
        break;
    }

    // Weight adds difficulty
    double weightMultiplier = (fishWeight / fish.baseWeight).clamp(0.8, 1.5);

    return (baseDifficulty * weightMultiplier).clamp(0.1, 0.95);
  }

  /// Calculate if fish escapes during reel
  static bool checkFishEscape(double tension, double difficulty, GameState gameState) {
    // Freeze effect prevents escape
    final freezeCards = gameState.selectedCards.where(
      (c) => c.effect == CardEffect.freezeFishEscape,
    );
    if (freezeCards.isNotEmpty) {
      return false;
    }

    // Tension above safe zone = escape chance
    if (tension > 0.7) {
      final escapeChance = (tension - 0.7) * difficulty;
      return Random().nextDouble() < escapeChance;
    }

    return false;
  }

  /// Calculate fish value with modifiers
  static int calculateFishValue(Fish fish, double weight, GameState gameState) {
    double value = fish.baseValue * (weight / fish.baseWeight);

    // Fish Market building bonus
    final marketBuilding = gameState.buildings.firstWhere(
      (b) => b.type == BuildingType.fishMarket,
      orElse: () => HarborBuilding.defaultBuildings.first,
    );
    if (marketBuilding.isUnlocked) {
      value *= (1 + marketBuilding.level * 0.05);
    }

    // Double coins card
    final doubleCoinsCards = gameState.selectedCards.where(
      (c) => c.effect == CardEffect.doubleCoins,
    );
    if (doubleCoinsCards.isNotEmpty) {
      value *= 2;
    }

    return value.round();
  }

  /// Calculate XP reward
  static int calculateXPReward(Fish fish, double weight) {
    int baseXP = 10;

    // Rarity multiplier
    switch (fish.rarity) {
      case FishRarity.common:
        baseXP = 10;
        break;
      case FishRarity.uncommon:
        baseXP = 20;
        break;
      case FishRarity.rare:
        baseXP = 35;
        break;
      case FishRarity.epic:
        baseXP = 60;
        break;
      case FishRarity.legendary:
        baseXP = 100;
        break;
    }

    // Weight bonus
    double weightBonus = (weight / fish.baseWeight).clamp(0.8, 1.5);

    return (baseXP * weightBonus).round();
  }

  /// Apply support card effects
  static void applyCardEffects(GameState gameState, CardEffect effect) {
    switch (effect) {
      case CardEffect.recoverEnergy:
        gameState.restoreEnergy(gameState.stats.maxEnergy);
        break;
      case CardEffect.repairRod:
        // Implement rod repair
        break;
      case CardEffect.repairBoat:
        // Implement boat repair
        break;
      case CardEffect.recoverFuel:
        // Implement fuel recovery
        break;
      case CardEffect.reduceFatigue:
        gameState.restoreEnergy(gameState.stats.maxEnergy ~/ 2);
        break;
      default:
        // Other effects are passive and applied in calculations
        break;
    }
  }

  /// Check if player can afford fishing trip
  static bool canAffordFishing(GameState gameState) {
    return gameState.stats.energy >= 10;
  }

  /// Calculate energy cost (can be modified by cards/buildings)
  static int getEnergyCost(GameState gameState) {
    int cost = 10;

    // Could add modifiers here

    return cost;
  }
}
