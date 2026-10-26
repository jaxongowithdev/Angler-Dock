enum MissionType { daily, weekly, achievement }

enum MissionGoal {
  catchFish,
  catchRareFish,
  earnCoins,
  visitArea,
  upgradeBoat,
  upgradeBuilding,
  useCard,
  sellFish,
  reachLevel,
}

class Mission {
  final String id;
  final String title;
  final String description;
  final MissionType type;
  final MissionGoal goal;
  final int targetValue;
  final int currentValue;
  final int rewardCoins;
  final int rewardXP;
  final DateTime? expiresAt;
  final bool isCompleted;
  final bool isClaimed;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.goal,
    required this.targetValue,
    this.currentValue = 0,
    required this.rewardCoins,
    required this.rewardXP,
    this.expiresAt,
    this.isCompleted = false,
    this.isClaimed = false,
  });

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    MissionType? type,
    MissionGoal? goal,
    int? targetValue,
    int? currentValue,
    int? rewardCoins,
    int? rewardXP,
    DateTime? expiresAt,
    bool? isCompleted,
    bool? isClaimed,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      goal: goal ?? this.goal,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      rewardXP: rewardXP ?? this.rewardXP,
      expiresAt: expiresAt ?? this.expiresAt,
      isCompleted: isCompleted ?? this.isCompleted,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }

  double get progress => currentValue / targetValue;

  String get progressText => '$currentValue/$targetValue';

  static List<Mission> generateDailyMissions(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final missions = <Mission>[];

    // Mission 1: Catch fish
    missions.add(Mission(
      id: 'daily_catch_${seed}_1',
      title: 'Catch 10 Fish',
      description: 'Catch any 10 fish today',
      type: MissionType.daily,
      goal: MissionGoal.catchFish,
      targetValue: 10,
      rewardCoins: 100,
      rewardXP: 50,
      expiresAt: DateTime(date.year, date.month, date.day, 23, 59, 59),
    ));

    // Mission 2: Catch rare fish
    missions.add(Mission(
      id: 'daily_rare_${seed}_2',
      title: 'Catch 2 Rare Fish',
      description: 'Catch 2 rare or higher rarity fish',
      type: MissionType.daily,
      goal: MissionGoal.catchRareFish,
      targetValue: 2,
      rewardCoins: 150,
      rewardXP: 75,
      expiresAt: DateTime(date.year, date.month, date.day, 23, 59, 59),
    ));

    // Mission 3: Earn coins
    missions.add(Mission(
      id: 'daily_coins_${seed}_3',
      title: 'Earn 500 Coins',
      description: 'Earn 500 coins from selling fish',
      type: MissionType.daily,
      goal: MissionGoal.earnCoins,
      targetValue: 500,
      rewardCoins: 200,
      rewardXP: 100,
      expiresAt: DateTime(date.year, date.month, date.day, 23, 59, 59),
    ));

    return missions;
  }

  static List<Mission> generateWeeklyMissions(DateTime date) {
    final weekNumber = _getWeekNumber(date);
    final missions = <Mission>[];

    final endOfWeek = date.add(Duration(days: 7 - date.weekday));

    missions.add(Mission(
      id: 'weekly_areas_$weekNumber',
      title: 'Visit All Ocean Areas',
      description: 'Fish in all 7 ocean areas this week',
      type: MissionType.weekly,
      goal: MissionGoal.visitArea,
      targetValue: 7,
      rewardCoins: 500,
      rewardXP: 300,
      expiresAt: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
    ));

    missions.add(Mission(
      id: 'weekly_fish_$weekNumber',
      title: 'Catch 50 Fish',
      description: 'Catch a total of 50 fish this week',
      type: MissionType.weekly,
      goal: MissionGoal.catchFish,
      targetValue: 50,
      rewardCoins: 400,
      rewardXP: 250,
      expiresAt: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
    ));

    missions.add(Mission(
      id: 'weekly_upgrade_$weekNumber',
      title: 'Upgrade Your Boat',
      description: 'Upgrade any boat stat once',
      type: MissionType.weekly,
      goal: MissionGoal.upgradeBoat,
      targetValue: 1,
      rewardCoins: 300,
      rewardXP: 200,
      expiresAt: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
    ));

    return missions;
  }

  static List<Mission> get achievements => [
        const Mission(
          id: 'ach_first_catch',
          title: 'First Catch',
          description: 'Catch your first fish',
          type: MissionType.achievement,
          goal: MissionGoal.catchFish,
          targetValue: 1,
          rewardCoins: 50,
          rewardXP: 25,
        ),
        const Mission(
          id: 'ach_fisher_100',
          title: 'Skilled Fisher',
          description: 'Catch 100 fish',
          type: MissionType.achievement,
          goal: MissionGoal.catchFish,
          targetValue: 100,
          rewardCoins: 500,
          rewardXP: 300,
        ),
        const Mission(
          id: 'ach_legendary',
          title: 'Legendary Fisher',
          description: 'Catch 1000 fish',
          type: MissionType.achievement,
          goal: MissionGoal.catchFish,
          targetValue: 1000,
          rewardCoins: 5000,
          rewardXP: 3000,
        ),
        const Mission(
          id: 'ach_millionaire',
          title: 'Millionaire',
          description: 'Earn 1,000,000 coins total',
          type: MissionType.achievement,
          goal: MissionGoal.earnCoins,
          targetValue: 1000000,
          rewardCoins: 10000,
          rewardXP: 5000,
        ),
        const Mission(
          id: 'ach_master_builder',
          title: 'Master Builder',
          description: 'Unlock all 7 harbor buildings',
          type: MissionType.achievement,
          goal: MissionGoal.upgradeBuilding,
          targetValue: 7,
          rewardCoins: 1000,
          rewardXP: 500,
        ),
        const Mission(
          id: 'ach_explorer',
          title: 'Ocean Explorer',
          description: 'Visit all ocean areas',
          type: MissionType.achievement,
          goal: MissionGoal.visitArea,
          targetValue: 7,
          rewardCoins: 300,
          rewardXP: 200,
        ),
      ];

  static int _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(startOfYear).inDays;
    return (days / 7).ceil();
  }
}
