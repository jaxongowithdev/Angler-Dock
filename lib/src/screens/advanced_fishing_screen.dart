import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/fish.dart';
import '../services/fishing_service.dart';

enum FishingPhase { idle, casting, waiting, biting, reeling, caught, escaped }

class AdvancedFishingScreen extends StatefulWidget {
  const AdvancedFishingScreen({super.key});

  @override
  State<AdvancedFishingScreen> createState() => _AdvancedFishingScreenState();
}

class _AdvancedFishingScreenState extends State<AdvancedFishingScreen>
    with SingleTickerProviderStateMixin {
  FishingPhase _phase = FishingPhase.idle;
  double _castPower = 0.0;
  double _castDistance = 0.0;
  Fish? _currentFish;
  double _fishWeight = 0.0;
  int _fishValue = 0;
  double _reelTension = 0.0;
  double _reelDifficulty = 0.5;
  bool _isHolding = false;
  late AnimationController _powerMeterController;

  @override
  void initState() {
    super.initState();
    _powerMeterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addListener(() {
        if (_phase == FishingPhase.casting) {
          setState(() {
            _castPower = _powerMeterController.value;
          });
        }
      });
  }

  @override
  void dispose() {
    _powerMeterController.dispose();
    super.dispose();
  }

  void _startCast(GameState gameState) {
    if (!FishingService.canAffordFishing(gameState)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough energy!')),
      );
      return;
    }

    setState(() {
      _phase = FishingPhase.casting;
      _castPower = 0.0;
    });

    _powerMeterController.repeat();
  }

  void _releaseCast(GameState gameState) {
    if (_phase != FishingPhase.casting) return;

    _powerMeterController.stop();
    _powerMeterController.reset();

    final distance = FishingService.calculateCastDistance(_castPower, gameState);

    setState(() {
      _castDistance = distance;
      _phase = FishingPhase.waiting;
    });

    gameState.useEnergy(FishingService.getEnergyCost(gameState));

    // Simulate bite
    final biteChance = FishingService.calculateBiteChance(distance, gameState.currentArea);
    final biteDelay = Random().nextInt(3) + 2;

    Future.delayed(Duration(seconds: biteDelay), () {
      if (!mounted || _phase != FishingPhase.waiting) return;

      if (Random().nextDouble() < biteChance) {
        setState(() => _phase = FishingPhase.biting);

        // Auto-start reel after 2 seconds if not tapped
        Future.delayed(const Duration(seconds: 2), () {
          if (_phase == FishingPhase.biting) {
            _missedBite();
          }
        });
      } else {
        _noBite();
      }
    });
  }

  void _onBiteTap(GameState gameState) {
    if (_phase != FishingPhase.biting) return;

    // Select fish
    _currentFish = FishingService.selectFish(
      gameState.currentArea,
      _castDistance,
      gameState,
    );

    _fishWeight = FishingService.calculateFishWeight(
      _currentFish!,
      _castDistance,
      gameState,
    );

    _reelDifficulty = FishingService.calculateReelDifficulty(
      _currentFish!,
      _fishWeight,
    );

    setState(() {
      _phase = FishingPhase.reeling;
      _reelTension = 0.3;
    });

    _startReeling();
  }

  void _startReeling() {
    // Reel tension increases over time
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted || _phase != FishingPhase.reeling) return;

      setState(() {
        if (_isHolding) {
          // Holding increases tension
          _reelTension = (_reelTension + _reelDifficulty * 0.05).clamp(0.0, 1.0);
        } else {
          // Not holding decreases tension
          _reelTension = (_reelTension - 0.02).clamp(0.0, 1.0);
        }
      });

      // Check escape
      final gameState = context.read<GameState>();
      if (FishingService.checkFishEscape(_reelTension, _reelDifficulty, gameState)) {
        _fishEscaped();
        return;
      }

      // Check success (tension stays in safe zone)
      if (_reelTension > 0.1 && _reelTension < 0.7) {
        // Success after ~3 seconds of good reeling
        // You could add a progress bar here
      }

      _startReeling();
    });
  }

  void _onReelHoldStart() {
    setState(() => _isHolding = true);
  }

  void _onReelHoldEnd(GameState gameState) {
    setState(() => _isHolding = false);

    // Check if fish is caught (after sufficient time)
    if (_reelTension > 0.2 && _reelTension < 0.6) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_phase == FishingPhase.reeling && !_isHolding) {
          _fishCaught(gameState);
        }
      });
    }
  }

  void _fishCaught(GameState gameState) {
    _fishValue = FishingService.calculateFishValue(
      _currentFish!,
      _fishWeight,
      gameState,
    );

    final xp = FishingService.calculateXPReward(_currentFish!, _fishWeight);

    gameState.catchFish(_currentFish!, _fishWeight, _fishValue);
    gameState.addXP(xp);

    setState(() => _phase = FishingPhase.caught);

    _showResultDialog(true);
  }

  void _fishEscaped() {
    setState(() => _phase = FishingPhase.escaped);
    _showResultDialog(false);
  }

  void _noBite() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No bite... Try again!')),
    );
    setState(() => _phase = FishingPhase.idle);
  }

  void _missedBite() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Missed the bite!')),
    );
    setState(() => _phase = FishingPhase.idle);
  }

  void _showResultDialog(bool success) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          success ? 'Fish Caught!' : 'Fish Escaped!',
          style: TextStyle(
            color: success ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: success
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_currentFish!.emoji, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    _currentFish!.name,
                    style: TextStyle(
                      color: _currentFish!.rarityColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _currentFish!.rarityColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _currentFish!.rarityName,
                      style: TextStyle(
                        color: _currentFish!.rarityColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_fishWeight.toStringAsFixed(2)} kg',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Value: $_fishValue coins',
                    style: const TextStyle(color: Colors.amber, fontSize: 16),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎣', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text(
                    'The fish got away!',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _phase = FishingPhase.idle);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Continue', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E40AF), Color(0xFF1E3A8A), Color(0xFF0F172A)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, gameState),
                  Expanded(
                    child: Center(
                      child: _buildPhaseContent(gameState),
                    ),
                  ),
                  _buildBottomActions(context, gameState),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, GameState gameState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              ),
              Expanded(
                child: Text(
                  _getAreaName(gameState.currentArea),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip('⚡', '${gameState.stats.energy}/${gameState.stats.maxEnergy}'),
              _buildStatChip('🐟', '${gameState.caughtFish.length}'),
              _buildStatChip('📏', '${_castDistance.toStringAsFixed(0)}m'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String emoji, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPhaseContent(GameState gameState) {
    switch (_phase) {
      case FishingPhase.idle:
        return _buildIdleState(gameState);
      case FishingPhase.casting:
        return _buildCastingState(gameState);
      case FishingPhase.waiting:
        return _buildWaitingState();
      case FishingPhase.biting:
        return _buildBitingState(gameState);
      case FishingPhase.reeling:
        return _buildReelingState(gameState);
      case FishingPhase.caught:
      case FishingPhase.escaped:
        return _buildIdleState(gameState);
    }
  }

  Widget _buildIdleState(GameState gameState) {
    return Column(
      children: [
        const Text('🎣', style: TextStyle(fontSize: 120)),
        const SizedBox(height: 24),
        const Text(
          'Ready to Fish',
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: FishingService.canAffordFishing(gameState)
              ? () => _startCast(gameState)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Cast Line', style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildCastingState(GameState gameState) {
    return GestureDetector(
      onTapDown: (_) => _releaseCast(gameState),
      child: Column(
        children: [
          const Text('CASTING', style: TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          const Text('Tap to release!', style: TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 40),
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: _castPower,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.yellow, Colors.red],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${(_castPower * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingState() {
    return const Column(
      children: [
        Text('🪝', style: TextStyle(fontSize: 80)),
        SizedBox(height: 24),
        Text('Waiting for bite...', style: TextStyle(color: Colors.white, fontSize: 24)),
        SizedBox(height: 24),
        CircularProgressIndicator(color: Colors.white),
      ],
    );
  }

  Widget _buildBitingState(GameState gameState) {
    return GestureDetector(
      onTap: () => _onBiteTap(gameState),
      child: Container(
        color: Colors.transparent,
        child: const Column(
          children: [
            Text('!!!', style: TextStyle(color: Colors.red, fontSize: 100, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Text(
              'BITE!',
              style: TextStyle(color: Colors.amber, fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('TAP NOW!', style: TextStyle(color: Colors.white, fontSize: 28)),
          ],
        ),
      ),
    );
  }

  Widget _buildReelingState(GameState gameState) {
    final isSafe = _reelTension >= 0.2 && _reelTension <= 0.7;
    final isDanger = _reelTension > 0.8;

    return GestureDetector(
      onLongPressStart: (_) => _onReelHoldStart(),
      onLongPressEnd: (_) => _onReelHoldEnd(gameState),
      child: Column(
        children: [
          const Text('REELING', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Text(
            _isHolding ? 'PULLING...' : 'Hold to Reel',
            style: TextStyle(
              color: _isHolding ? Colors.amber : Colors.white70,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: 60,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Stack(
              children: [
                // Danger zone
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 90,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(27)),
                    ),
                    child: const Center(child: Text('💥', style: TextStyle(fontSize: 24))),
                  ),
                ),
                // Safe zone
                Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  height: 150,
                  child: Container(
                    color: Colors.green.withOpacity(0.5),
                    child: const Center(child: Text('✓', style: TextStyle(fontSize: 32, color: Colors.white))),
                  ),
                ),
                // Weak zone
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(27)),
                    ),
                    child: const Center(child: Text('⚠️', style: TextStyle(fontSize: 20))),
                  ),
                ),
                // Tension indicator
                Positioned(
                  bottom: _reelTension * 240,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDanger ? Colors.red : isSafe ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: isDanger ? Colors.red : isSafe ? Colors.green : Colors.orange,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '🎣',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isDanger
                ? 'DANGER! Release!'
                : isSafe
                    ? 'Keep going!'
                    : 'Pull harder!',
            style: TextStyle(
              color: isDanger ? Colors.red : isSafe ? Colors.green : Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, GameState gameState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: gameState.caughtFish.isNotEmpty
                ? () {
                    gameState.sellAllFish();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fish sold!')),
                    );
                  }
                : null,
            icon: const Icon(Icons.sell),
            label: const Text('Sell Fish'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home),
            label: const Text('Return'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
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
