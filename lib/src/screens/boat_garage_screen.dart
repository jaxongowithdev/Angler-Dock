import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/boat.dart';

class BoatGarageScreen extends StatelessWidget {
  const BoatGarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A4D68),
              Color(0xFF0C2D3E),
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
                      itemCount: Boat.availableBoats.length,
                      itemBuilder: (context, index) {
                        final boat = Boat.availableBoats[index];
                        final isOwned = gameState.ownedBoats.any((b) => b.id == boat.id);
                        final isEquipped = gameState.currentBoat.id == boat.id;
                        return _buildBoatCard(context, boat, isOwned, isEquipped, gameState);
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
              'Boat Garage',
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

  Widget _buildBoatCard(BuildContext context, Boat boat, bool isOwned, bool isEquipped, GameState gameState) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isEquipped
              ? [Colors.blue.shade700, Colors.blue.shade900]
              : isOwned
                  ? [Colors.teal.shade700, Colors.teal.shade900]
                  : [Colors.grey.shade700, Colors.grey.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEquipped
              ? Colors.blue
              : isOwned
                  ? Colors.teal.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                boat.emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boat.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isEquipped)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'EQUIPPED',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (!isOwned)
                const Icon(Icons.lock, color: Colors.white54, size: 28),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow('⚙️ Engine', 'Level ${boat.engineLevel}'),
          _buildStatRow('⛽ Fuel', '${boat.fuelCapacity}'),
          _buildStatRow('📦 Storage', '${boat.storageCapacity}'),
          _buildStatRow('📡 Radar', 'Level ${boat.radarLevel}'),
          _buildStatRow('🎣 Rod Slots', '${boat.rodRackSlots}'),
          _buildStatRow('🛡️ Hull', 'Level ${boat.hullLevel}'),
          const SizedBox(height: 16),
          if (!isOwned)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: gameState.stats.coins >= boat.upgradeCost * 5
                    ? () {
                        gameState.spendCoins(boat.upgradeCost * 5);
                        gameState.purchaseBoat(boat);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Buy for ${boat.upgradeCost * 5} coins',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          else if (!isEquipped)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => gameState.equipBoat(boat),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Equip',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
