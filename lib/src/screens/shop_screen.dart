import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/equipment.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF6B4226),
                Color(0xFF3E2723),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  indicatorColor: Colors.amber,
                  tabs: [
                    Tab(text: 'Rods'),
                    Tab(text: 'Reels'),
                    Tab(text: 'Hooks'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildEquipmentList(Equipment.defaultRods),
                      _buildEquipmentList(Equipment.defaultReels),
                      _buildEquipmentList(Equipment.defaultHooks),
                    ],
                  ),
                ),
              ],
            ),
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
              'Equipment Shop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Consumer<GameState>(
            builder: (context, gameState, _) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Text('💰', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      '${gameState.stats.coins}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentList(List<Equipment> equipment) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: equipment.length,
          itemBuilder: (context, index) {
            final item = equipment[index];
            final isOwned = gameState.ownedEquipment.any((e) => e.id == item.id);
            final isEquipped = gameState.currentRod.id == item.id ||
                gameState.currentReel?.id == item.id ||
                gameState.currentHook?.id == item.id;
            return _buildEquipmentCard(context, item, isOwned, isEquipped, gameState);
          },
        );
      },
    );
  }

  Widget _buildEquipmentCard(
    BuildContext context,
    Equipment equipment,
    bool isOwned,
    bool isEquipped,
    GameState gameState,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isEquipped
              ? [Colors.amber.shade700, Colors.amber.shade900]
              : isOwned
                  ? [Colors.green.shade700, Colors.green.shade900]
                  : [Colors.brown.shade600, Colors.brown.shade800],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEquipped
              ? Colors.amber
              : isOwned
                  ? Colors.green.withOpacity(0.5)
                  : Colors.brown.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                equipment.emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      equipment.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Level ${equipment.level}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (isEquipped) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'EQUIPPED',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Power', equipment.power.toStringAsFixed(1)),
              _buildStatColumn('Durability', '${equipment.durability}'),
              _buildStatColumn('Price', '${equipment.price}'),
            ],
          ),
          const SizedBox(height: 12),
          if (!isOwned)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: gameState.stats.coins >= equipment.price
                    ? () => gameState.purchaseEquipment(equipment)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Buy for ${equipment.price} coins',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            )
          else if (!isEquipped)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => gameState.equipRod(equipment),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Equip',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
