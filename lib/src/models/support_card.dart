enum CardSuit { spades, hearts, diamonds, clubs }

enum CardRank {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king
}

enum CardType { fishing, recovery, discovery, utility }

enum CardEffect {
  castDistanceBoost,
  hookStrengthBoost,
  reelSpeedBoost,
  perfectHook,
  instantCatch,
  recoverEnergy,
  repairRod,
  repairBoat,
  reduceFatigue,
  recoverFuel,
  rareFishChanceBoost,
  revealFishingSpot,
  treasureChanceBoost,
  doubleCoins,
  calmSea,
  freezeFishEscape,
  extraStorage,
  fastTravel,
  autoReel,
}

class SupportCard {
  final String assetName;
  final CardSuit suit;
  final CardRank rank;
  final CardType type;
  final CardEffect effect;
  final double value;
  final int cooldown;
  final int level;
  final String name;
  final String description;

  const SupportCard({
    required this.assetName,
    required this.suit,
    required this.rank,
    required this.type,
    required this.effect,
    required this.value,
    required this.cooldown,
    this.level = 1,
    required this.name,
    required this.description,
  });

  String get displayName => name;

  SupportCard copyWith({int? level}) {
    return SupportCard(
      assetName: assetName,
      suit: suit,
      rank: rank,
      type: type,
      effect: effect,
      value: value * (level ?? this.level),
      cooldown: (cooldown / (level ?? this.level)).round(),
      level: level ?? this.level,
      name: name,
      description: description,
    );
  }

  static List<SupportCard> get allCards => [
        // Spades - Fishing Cards
        const SupportCard(
          assetName: 'ace_of_spades.svg',
          suit: CardSuit.spades,
          rank: CardRank.ace,
          type: CardType.fishing,
          effect: CardEffect.instantCatch,
          value: 100,
          cooldown: 120,
          name: 'Instant Catch',
          description: 'Instantly catch any fish without minigame',
        ),
        const SupportCard(
          assetName: 'king_of_spades.svg',
          suit: CardSuit.spades,
          rank: CardRank.king,
          type: CardType.fishing,
          effect: CardEffect.perfectHook,
          value: 100,
          cooldown: 90,
          name: 'Perfect Hook',
          description: 'Next hook is guaranteed to succeed',
        ),
        const SupportCard(
          assetName: 'queen_of_spades.svg',
          suit: CardSuit.spades,
          rank: CardRank.queen,
          type: CardType.fishing,
          effect: CardEffect.reelSpeedBoost,
          value: 30,
          cooldown: 60,
          name: 'Speed Reel',
          description: 'Increase reel speed by 30%',
        ),
        const SupportCard(
          assetName: '10_of_spades.svg',
          suit: CardSuit.spades,
          rank: CardRank.ten,
          type: CardType.fishing,
          effect: CardEffect.hookStrengthBoost,
          value: 25,
          cooldown: 60,
          name: 'Strong Hook',
          description: 'Increase hook strength by 25%',
        ),
        const SupportCard(
          assetName: '8_of_spades.svg',
          suit: CardSuit.spades,
          rank: CardRank.eight,
          type: CardType.fishing,
          effect: CardEffect.castDistanceBoost,
          value: 20,
          cooldown: 45,
          name: 'Long Cast',
          description: 'Increase cast distance by 20%',
        ),
        // Hearts - Recovery Cards
        const SupportCard(
          assetName: 'ace_of_hearts.svg',
          suit: CardSuit.hearts,
          rank: CardRank.ace,
          type: CardType.recovery,
          effect: CardEffect.recoverEnergy,
          value: 100,
          cooldown: 180,
          name: 'Full Recovery',
          description: 'Restore all energy',
        ),
        const SupportCard(
          assetName: 'king_of_hearts.svg',
          suit: CardSuit.hearts,
          rank: CardRank.king,
          type: CardType.recovery,
          effect: CardEffect.repairBoat,
          value: 100,
          cooldown: 120,
          name: 'Boat Repair',
          description: 'Fully repair your boat',
        ),
        const SupportCard(
          assetName: 'queen_of_hearts.svg',
          suit: CardSuit.hearts,
          rank: CardRank.queen,
          type: CardType.recovery,
          effect: CardEffect.repairRod,
          value: 100,
          cooldown: 90,
          name: 'Rod Repair',
          description: 'Fully repair your fishing rod',
        ),
        const SupportCard(
          assetName: '10_of_hearts.svg',
          suit: CardSuit.hearts,
          rank: CardRank.ten,
          type: CardType.recovery,
          effect: CardEffect.recoverFuel,
          value: 50,
          cooldown: 60,
          name: 'Fuel Up',
          description: 'Restore 50% fuel',
        ),
        const SupportCard(
          assetName: '7_of_hearts.svg',
          suit: CardSuit.hearts,
          rank: CardRank.seven,
          type: CardType.recovery,
          effect: CardEffect.reduceFatigue,
          value: 50,
          cooldown: 45,
          name: 'Rest',
          description: 'Reduce fatigue by 50%',
        ),
        // Diamonds - Discovery Cards
        const SupportCard(
          assetName: 'ace_of_diamonds.svg',
          suit: CardSuit.diamonds,
          rank: CardRank.ace,
          type: CardType.discovery,
          effect: CardEffect.treasureChanceBoost,
          value: 50,
          cooldown: 180,
          name: 'Treasure Hunter',
          description: 'Increase treasure chance by 50%',
        ),
        const SupportCard(
          assetName: 'king_of_diamonds.svg',
          suit: CardSuit.diamonds,
          rank: CardRank.king,
          type: CardType.discovery,
          effect: CardEffect.doubleCoins,
          value: 100,
          cooldown: 120,
          name: 'Double Money',
          description: 'Earn double coins from this trip',
        ),
        const SupportCard(
          assetName: 'queen_of_diamonds.svg',
          suit: CardSuit.diamonds,
          rank: CardRank.queen,
          type: CardType.discovery,
          effect: CardEffect.rareFishChanceBoost,
          value: 30,
          cooldown: 90,
          name: 'Rare Fish Finder',
          description: 'Increase rare fish chance by 30%',
        ),
        const SupportCard(
          assetName: '9_of_diamonds.svg',
          suit: CardSuit.diamonds,
          rank: CardRank.nine,
          type: CardType.discovery,
          effect: CardEffect.revealFishingSpot,
          value: 100,
          cooldown: 60,
          name: 'Fish Radar',
          description: 'Reveal nearby fishing spots',
        ),
        // Clubs - Utility Cards
        const SupportCard(
          assetName: 'ace_of_clubs.svg',
          suit: CardSuit.clubs,
          rank: CardRank.ace,
          type: CardType.utility,
          effect: CardEffect.fastTravel,
          value: 100,
          cooldown: 120,
          name: 'Fast Travel',
          description: 'Instantly return to harbor',
        ),
        const SupportCard(
          assetName: 'king_of_clubs.svg',
          suit: CardSuit.clubs,
          rank: CardRank.king,
          type: CardType.utility,
          effect: CardEffect.autoReel,
          value: 60,
          cooldown: 90,
          name: 'Auto Reel',
          description: 'Automatically reel for 60 seconds',
        ),
        const SupportCard(
          assetName: 'queen_of_clubs.svg',
          suit: CardSuit.clubs,
          rank: CardRank.queen,
          type: CardType.utility,
          effect: CardEffect.extraStorage,
          value: 50,
          cooldown: 90,
          name: 'Extra Storage',
          description: 'Increase storage by 50% this trip',
        ),
        const SupportCard(
          assetName: 'jack_of_clubs.svg',
          suit: CardSuit.clubs,
          rank: CardRank.jack,
          type: CardType.utility,
          effect: CardEffect.calmSea,
          value: 300,
          cooldown: 120,
          name: 'Calm Waters',
          description: 'Calm the sea for 5 minutes',
        ),
        const SupportCard(
          assetName: '10_of_clubs.svg',
          suit: CardSuit.clubs,
          rank: CardRank.ten,
          type: CardType.utility,
          effect: CardEffect.freezeFishEscape,
          value: 5,
          cooldown: 60,
          name: 'Freeze',
          description: 'Fish cannot escape for 5 catches',
        ),
        // Additional cards for full 52-card deck
        ..._generateRemainingCards(),
      ];

  // Generate remaining cards (2-9, Jack) for all suits
  static List<SupportCard> _generateRemainingCards() {
    final cards = <SupportCard>[];

    // Define which cards are already explicitly defined above
    final alreadyDefined = {
      'spades': [8, 10],
      'hearts': [7, 10],
      'diamonds': [9],
      'clubs': [],
    };

    for (final suit in CardSuit.values) {
      final suitName = suit.name;
      final skipRanks = alreadyDefined[suitName] ?? [];

      // Add 2-7 (except those already defined)
      for (int i = 2; i <= 7; i++) {
        if (skipRanks.contains(i)) continue;

        final rank = CardRank.values[i - 1]; // two=1, three=2, etc
        final effect = _getGenericEffect(suit);
        final type = _getCardTypeForSuit(suit);

        cards.add(SupportCard(
          assetName: '${i}_of_$suitName.svg',
          suit: suit,
          rank: rank,
          type: type,
          effect: effect,
          value: 10 + i * 2,
          cooldown: 30 + i * 5,
          name: '${rank.name[0].toUpperCase()}${rank.name.substring(1)} Boost',
          description: 'Basic ${type.name} card effect',
        ));
      }

      // Add 9 if not already defined
      if (!skipRanks.contains(9)) {
        cards.add(SupportCard(
          assetName: '9_of_$suitName.svg',
          suit: suit,
          rank: CardRank.nine,
          type: _getCardTypeForSuit(suit),
          effect: _getGenericEffect(suit),
          value: 25,
          cooldown: 60,
          name: 'Nine Power',
          description: 'Mid-tier ${_getCardTypeForSuit(suit).name} boost',
        ));
      }

      // Add Jack if not clubs (jack_of_clubs is already defined)
      if (suit != CardSuit.clubs) {
        cards.add(SupportCard(
          assetName: 'jack_of_$suitName.svg',
          suit: suit,
          rank: CardRank.jack,
          type: _getCardTypeForSuit(suit),
          effect: _getGenericEffect(suit),
          value: 30,
          cooldown: 75,
          name: 'Jack Bonus',
          description: 'Strong ${_getCardTypeForSuit(suit).name} effect',
        ));
      }
    }

    return cards;
  }

  static CardType _getCardTypeForSuit(CardSuit suit) {
    switch (suit) {
      case CardSuit.spades:
        return CardType.fishing;
      case CardSuit.hearts:
        return CardType.recovery;
      case CardSuit.diamonds:
        return CardType.discovery;
      case CardSuit.clubs:
        return CardType.utility;
    }
  }

  static CardEffect _getGenericEffect(CardSuit suit) {
    switch (suit) {
      case CardSuit.spades:
        return CardEffect.castDistanceBoost;
      case CardSuit.hearts:
        return CardEffect.recoverEnergy;
      case CardSuit.diamonds:
        return CardEffect.rareFishChanceBoost;
      case CardSuit.clubs:
        return CardEffect.extraStorage;
    }
  }
}
