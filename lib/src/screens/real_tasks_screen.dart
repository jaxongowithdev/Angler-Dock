import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/mission.dart';

class RealTasksScreen extends StatelessWidget {
  const RealTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Consumer<GameState>(
                  builder: (context, gameState, _) {
                    return ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildSection(
                          context,
                          'Daily Tasks',
                          gameState.dailyMissions,
                          gameState,
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          context,
                          'Weekly Tasks',
                          gameState.weeklyMissions,
                          gameState,
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          context,
                          'Achievements',
                          gameState.achievements.where((a) => !a.isClaimed).toList(),
                          gameState,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          const Expanded(
            child: Text(
              'Tasks & Achievements',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Mission> missions,
    GameState gameState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (missions.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No tasks available',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          )
        else
          ...missions.map((mission) => _buildMissionCard(context, mission, gameState)),
      ],
    );
  }

  Widget _buildMissionCard(
    BuildContext context,
    Mission mission,
    GameState gameState,
  ) {
    final canClaim = mission.isCompleted && !mission.isClaimed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mission.isCompleted
            ? (mission.isClaimed
                ? Colors.grey.withOpacity(0.2)
                : Colors.green.withOpacity(0.2))
            : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: mission.isCompleted
              ? (mission.isClaimed
                  ? Colors.grey.withOpacity(0.3)
                  : Colors.green.withOpacity(0.5))
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            _getMissionEmoji(mission.goal),
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: TextStyle(
                    color: mission.isClaimed ? Colors.grey : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: mission.isClaimed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                if (!mission.isCompleted) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: mission.progress,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        mission.progressText,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    const Text(
                      'Reward:',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    const Text('💰', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 2),
                    Text(
                      '${mission.rewardCoins}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('⭐', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 2),
                    Text(
                      '${mission.rewardXP} XP',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (mission.expiresAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Expires: ${_formatTimeRemaining(mission.expiresAt!)}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (canClaim)
            ElevatedButton(
              onPressed: () {
                gameState.claimMissionReward(mission);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Claimed: ${mission.rewardCoins} coins + ${mission.rewardXP} XP!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Claim', style: TextStyle(color: Colors.white)),
            )
          else if (mission.isCompleted && mission.isClaimed)
            const Icon(Icons.check_circle, color: Colors.grey, size: 32)
          else if (mission.isCompleted)
            const Icon(Icons.check_circle, color: Colors.green, size: 32),
        ],
      ),
    );
  }

  String _getMissionEmoji(MissionGoal goal) {
    switch (goal) {
      case MissionGoal.catchFish:
        return '🎣';
      case MissionGoal.catchRareFish:
        return '💎';
      case MissionGoal.earnCoins:
        return '💰';
      case MissionGoal.visitArea:
        return '🌊';
      case MissionGoal.upgradeBoat:
        return '⛵';
      case MissionGoal.upgradeBuilding:
        return '🏗️';
      case MissionGoal.useCard:
        return '⚡';
      case MissionGoal.sellFish:
        return '🏪';
      case MissionGoal.reachLevel:
        return '⭐';
    }
  }

  String _formatTimeRemaining(DateTime expiresAt) {
    final now = DateTime.now();
    final remaining = expiresAt.difference(now);

    if (remaining.isNegative) {
      return 'Expired';
    }

    if (remaining.inDays > 0) {
      return '${remaining.inDays}d ${remaining.inHours % 24}h';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    } else {
      return '${remaining.inMinutes}m';
    }
  }
}
