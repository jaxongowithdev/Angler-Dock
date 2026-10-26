import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToHarbor;
  final VoidCallback onNavigateToFishing;
  final VoidCallback onNavigateToMap;
  final VoidCallback onNavigateToTasks;

  const HomeScreen({
    super.key,
    required this.onNavigateToHarbor,
    required this.onNavigateToFishing,
    required this.onNavigateToMap,
    required this.onNavigateToTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A4D68),
              Color(0xFF05161A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildQuickActions(context),
                      const SizedBox(height: 24),
                      _buildDailyMissions(context),
                      const SizedBox(height: 24),
                      _buildStats(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        // Regenerate energy when screen is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          gameState.checkEnergyRegeneration();
        });

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Angler Dock',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fish • Sail • Upgrade • Build',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip('💰', '${gameState.stats.coins}', Colors.amber),
                  _buildStatChip('⚡', '${gameState.stats.energy}/${gameState.stats.maxEnergy}', Colors.green),
                  _buildStatChip('🎚️', 'Lv ${gameState.stats.level}', Colors.blue),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatChip(String emoji, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                '⛵',
                'Go Fishing',
                Colors.blue,
                onNavigateToFishing,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                '🗺️',
                'World Map',
                Colors.green,
                onNavigateToMap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                '⚓',
                'Harbor',
                Colors.orange,
                onNavigateToHarbor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                '📋',
                'Tasks',
                Colors.purple,
                onNavigateToTasks,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String emoji, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyMissions(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        final dailyMissions = gameState.dailyMissions.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Missions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (dailyMissions.isEmpty)
              _buildMissionCard('✅', 'All Done!', '0/0', 1.0)
            else
              ...dailyMissions.map((mission) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildMissionCard(
                    _getMissionEmoji(mission.goal),
                    mission.title,
                    mission.progressText,
                    mission.progress,
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  String _getMissionEmoji(dynamic goal) {
    final goalStr = goal.toString();
    if (goalStr.contains('catchFish')) return '🎣';
    if (goalStr.contains('catchRareFish')) return '💎';
    if (goalStr.contains('earnCoins')) return '💰';
    if (goalStr.contains('visitArea')) return '🌊';
    if (goalStr.contains('upgradeBoat')) return '⛵';
    return '🎯';
  }

  Widget _buildMissionCard(String emoji, String title, String progress, double percent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      progress,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Harbor Stats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatRow('🐟', 'Fish Collected', '${gameState.collectedFishCount}/${gameState.totalFishSpecies}'),
              _buildStatRow('🎯', 'Collection Rate', '${gameState.collectionPercent.toStringAsFixed(1)}%'),
              _buildStatRow('⛵', 'Current Boat', gameState.currentBoat.name),
              _buildStatRow('🎣', 'Current Rod', gameState.currentRod.name),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
