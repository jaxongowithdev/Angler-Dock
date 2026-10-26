import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/fish.dart';

class FishEncyclopediaScreen extends StatelessWidget {
  const FishEncyclopediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F4C75),
              Color(0xFF1B262C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Consumer<GameState>(
                  builder: (context, gameState, _) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: Fish.allFish.length,
                      itemBuilder: (context, index) {
                        final fish = Fish.allFish[index];
                        final isCaught = gameState.fishRecords.containsKey(fish.id);
                        final maxWeight = gameState.fishRecords[fish.id];
                        return _buildFishCard(fish, isCaught, maxWeight);
                      },
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
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                  const Expanded(
                    child: Text(
                      'Fish Encyclopedia',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Collected',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${gameState.collectedFishCount}/${gameState.totalFishSpecies}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Completion',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${gameState.collectionPercent.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
      },
    );
  }

  Widget _buildFishCard(Fish fish, bool isCaught, double? maxWeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCaught ? fish.rarityColor.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isCaught
                    ? fish.rarityColor.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  isCaught ? fish.emoji : '?',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCaught ? fish.name : '???',
                    style: TextStyle(
                      color: isCaught ? Colors.white : Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isCaught) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: fish.rarityColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            fish.rarityName,
                            style: TextStyle(
                              color: fish.rarityColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getAreaName(fish.habitat),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (maxWeight != null)
                      Text(
                        'Best: ${maxWeight.toStringAsFixed(2)} kg',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ] else
                    const Text(
                      'Not yet caught',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            if (isCaught)
              Icon(
                Icons.check_circle,
                color: fish.rarityColor,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  String _getAreaName(OceanArea area) {
    switch (area) {
      case OceanArea.river:
        return 'River';
      case OceanArea.lake:
        return 'Lake';
      case OceanArea.coast:
        return 'Coast';
      case OceanArea.deepSea:
        return 'Deep Sea';
      case OceanArea.coralReef:
        return 'Coral Reef';
      case OceanArea.frozenSea:
        return 'Frozen Sea';
      case OceanArea.volcanoSea:
        return 'Volcano Sea';
    }
  }
}
