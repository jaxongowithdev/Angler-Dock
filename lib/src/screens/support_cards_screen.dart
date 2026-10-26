import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/support_card.dart';
import '../widgets/support_card_visual.dart';

class SupportCardsScreen extends StatelessWidget {
  const SupportCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D1B69),
              Color(0xFF1A0B3E),
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
                    return Column(
                      children: [
                        _buildSelectedCards(gameState),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(20),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: gameState.ownedCards.length,
                            itemBuilder: (context, index) {
                              final card = gameState.ownedCards[index];
                              final isSelected = gameState.selectedCards.contains(card);
                              return _buildCardItem(context, card, isSelected, gameState);
                            },
                          ),
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
              'Harbor Boosts',
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

  Widget _buildSelectedCards(GameState gameState) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Active Boosts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${gameState.selectedCards.length}/5',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (gameState.selectedCards.isEmpty)
            const Center(
              child: Text(
                'Tap boosts to equip before sailing (max 5)',
                style: TextStyle(color: Colors.white54),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: gameState.selectedCards.map((card) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getCardTypeColor(card.type).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getCardTypeColor(card.type),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SupportCardVisual(card: card, size: 28),
                      const SizedBox(width: 6),
                      Text(
                        card.name,
                        style: TextStyle(
                          color: _getCardTypeColor(card.type),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          if (gameState.selectedCards.isNotEmpty) ...[
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => gameState.clearSelectedCards(),
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, SupportCard card, bool isSelected, GameState gameState) {
    final typeColor = _getCardTypeColor(card.type);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          gameState.deselectCard(card);
        } else if (gameState.selectedCards.length < 5) {
          gameState.selectCard(card);
        }
      },
      onLongPress: () => _showCardDetail(context, card),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [typeColor.withOpacity(0.6), typeColor.withOpacity(0.3)]
                : [typeColor.withOpacity(0.3), typeColor.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? typeColor : typeColor.withOpacity(0.3),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: typeColor.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            if (isSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle, color: Colors.white, size: 24),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: SupportCardVisual(card: card, size: 64),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getCardTypeName(card.type),
                      style: TextStyle(
                        color: typeColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    flex: 1,
                    child: Text(
                      card.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetail(BuildContext context, SupportCard card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A0B3E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SupportCardVisual(card: card, size: 90),
            const SizedBox(height: 16),
            Text(
              card.name,
              style: TextStyle(
                color: _getCardTypeColor(card.type),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getCardTypeName(card.type),
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              card.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              'Power ${card.value.round()} • Cooldown ${card.cooldown}s • Lv.${card.level}',
              style: const TextStyle(color: Colors.amber, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardTypeColor(CardType type) {
    switch (type) {
      case CardType.fishing:
        return Colors.blue;
      case CardType.recovery:
        return Colors.green;
      case CardType.discovery:
        return Colors.amber;
      case CardType.utility:
        return Colors.purple;
    }
  }

  String _getCardTypeName(CardType type) {
    switch (type) {
      case CardType.fishing:
        return 'Fishing';
      case CardType.recovery:
        return 'Recovery';
      case CardType.discovery:
        return 'Discovery';
      case CardType.utility:
        return 'Utility';
    }
  }
}
