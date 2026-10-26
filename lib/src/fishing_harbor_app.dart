import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'screens/home_screen.dart';
import 'screens/harbor_screen.dart';
import 'screens/world_map_screen.dart';
import 'screens/advanced_fishing_screen.dart';
import 'screens/fish_encyclopedia_screen.dart';
import 'screens/support_cards_screen.dart';
import 'screens/boat_garage_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/real_tasks_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'services/save_service.dart';

class FishingHarborApp extends StatefulWidget {
  const FishingHarborApp({super.key});

  @override
  State<FishingHarborApp> createState() => _FishingHarborAppState();
}

class _FishingHarborAppState extends State<FishingHarborApp> {
  GameState? _gameState;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    final savedGame = await SaveService.loadGame();
    setState(() {
      _gameState = savedGame ?? GameState();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A4D68), Color(0xFF05161A)],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🎣',
                    style: TextStyle(fontSize: 100),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Angler Dock',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ChangeNotifierProvider.value(
      value: _gameState!,
      child: MaterialApp(
        title: 'Angler Dock',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onNavigateToHarbor: () => setState(() => _currentIndex = 1),
            onNavigateToFishing: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdvancedFishingScreen()),
              );
            },
            onNavigateToMap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorldMapScreen(
                    onAreaSelected: (area) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdvancedFishingScreen()),
                      );
                    },
                  ),
                ),
              );
            },
            onNavigateToTasks: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RealTasksScreen()),
              );
            },
          ),
          const HarborScreen(),
          const FishEncyclopediaScreen(),
          const SupportCardsScreen(),
          const MenuScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, '🏠', 'Home'),
                _buildNavItem(1, '⚓', 'Harbor'),
                _buildNavItem(2, '🐟', 'Fish'),
                _buildNavItem(3, '⚡', 'Boosts'),
                _buildNavItem(4, '☰', 'Menu'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String emoji, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: isSelected ? 28 : 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: isSelected ? 12 : 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2C3E50),
            Color(0xFF000000),
          ],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildMenuCard(
              context,
              '🗺️',
              'World Map',
              'Explore different ocean areas',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorldMapScreen(
                      onAreaSelected: (area) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdvancedFishingScreen()),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              '⛵',
              'Boat Garage',
              'Manage and upgrade your boats',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BoatGarageScreen()),
                );
              },
            ),
            _buildMenuCard(
              context,
              '🏪',
              'Equipment Shop',
              'Buy rods, reels, and hooks',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopScreen()),
                );
              },
            ),
            _buildMenuCard(
              context,
              '📋',
              'Tasks & Achievements',
              'Complete missions for rewards',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RealTasksScreen()),
                );
              },
            ),
            _buildMenuCard(
              context,
              '👤',
              'Profile',
              'View your fishing stats',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            _buildMenuCard(
              context,
              '⚙️',
              'Settings',
              'Customize your experience',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String emoji,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
