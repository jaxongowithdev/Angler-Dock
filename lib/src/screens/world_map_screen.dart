import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/fish.dart';

class WorldMapScreen extends StatelessWidget {
  final Function(OceanArea) onAreaSelected;

  const WorldMapScreen({super.key, required this.onAreaSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildAreaCard(context, OceanArea.river, '🏞️', 'River', 'Calm freshwater fishing', 1),
                    const SizedBox(height: 16),
                    _buildAreaCard(context, OceanArea.lake, '🌊', 'Lake', 'Deep lakes with big catches', 1),
                    const SizedBox(height: 16),
                    _buildAreaCard(context, OceanArea.coast, '🏖️', 'Coast', 'Coastal waters with variety', 2),
                    const SizedBox(height: 16),
                    _buildAreaCard(context, OceanArea.deepSea, '🌊', 'Deep Sea', 'Legendary ocean giants', 5),
                    const SizedBox(height: 16),
                    _buildAreaCard(context, OceanArea.coralReef, '🪸', 'Coral Reef', 'Colorful tropical paradise', 3),
                    const SizedBox(height: 16),
                    _buildAreaCard(context, OceanArea.frozenSea, '❄️', 'Frozen Sea', 'Arctic fishing adventure', 4),
                    const SizedBox(height: 16),
                    _buildAreaCard(context, OceanArea.volcanoSea, '🌋', 'Volcano Sea', 'Extreme volcanic waters', 6),
                  ],
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
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          const Expanded(
            child: Text(
              'World Map',
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

  Widget _buildAreaCard(
    BuildContext context,
    OceanArea area,
    String emoji,
    String name,
    String description,
    int requiredLevel,
  ) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        final isUnlocked = gameState.stats.level >= requiredLevel;
        final fishInArea = Fish.getFishByArea(area);

        return GestureDetector(
          onTap: isUnlocked
              ? () {
                  gameState.setCurrentArea(area);
                  onAreaSelected(area);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isUnlocked
                    ? [const Color(0xFF1E3A8A), const Color(0xFF1E40AF)]
                    : [Colors.grey.shade800, Colors.grey.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUnlocked
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isUnlocked
                      ? Colors.blue.withOpacity(0.3)
                      : Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: TextStyle(
                        fontSize: 48,
                        color: isUnlocked ? null : Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: isUnlocked ? Colors.white : Colors.white54,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!isUnlocked) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.lock,
                              color: Colors.white.withOpacity(0.5),
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: isUnlocked ? Colors.white70 : Colors.white38,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isUnlocked
                                  ? Colors.amber.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Lv $requiredLevel',
                              style: TextStyle(
                                color: isUnlocked ? Colors.amber : Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${fishInArea.length} Fish',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
