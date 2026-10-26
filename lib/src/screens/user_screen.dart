import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'home_screen.dart';
import 'harbor_screen.dart';
import 'world_map_screen.dart';
import 'advanced_fishing_screen.dart';
import 'fish_encyclopedia_screen.dart';
import 'support_cards_screen.dart';
import 'boat_garage_screen.dart';
import 'shop_screen.dart';
import 'real_tasks_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../services/save_service.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
                colors: [
                  Color(0xFF0A4D68),
                  Color(0xFF05161A),
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Loading Angler Dock...',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
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

  void _navigateToFishing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdvancedFishingScreen()),
    );
  }

  void _navigateToHarbor() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HarborScreen()),
    );
  }

  void _navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorldMapScreen(
          onAreaSelected: (area) {
            final gameState = Provider.of<GameState>(context, listen: false);
            gameState.setCurrentArea(area);
            Navigator.pop(context);
            _navigateToFishing();
          },
        ),
      ),
    );
  }

  void _navigateToTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RealTasksScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onNavigateToFishing: _navigateToFishing,
        onNavigateToHarbor: _navigateToHarbor,
        onNavigateToMap: _navigateToMap,
        onNavigateToTasks: _navigateToTasks,
      ),
      const FishEncyclopediaScreen(),
      const MenuScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1A2E),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Fish'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A5F),
              Color(0xFF0A1128),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                child: const Center(
                  child: Text(
                    'Game Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildMenuButton(
                      context,
                      icon: Icons.directions_boat,
                      title: 'Boat Garage',
                      subtitle: 'Manage and upgrade your boats',
                      color: Colors.blue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BoatGarageScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      context,
                      icon: Icons.shopping_bag,
                      title: 'Shop',
                      subtitle: 'Buy equipment and upgrades',
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShopScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      context,
                      icon: Icons.location_city,
                      title: 'Harbor',
                      subtitle: 'Build and upgrade harbor buildings',
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HarborScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      context,
                      icon: Icons.bolt,
                      title: 'Harbor Boosts',
                      subtitle: 'Equip boosts before sailing',
                      color: Colors.purple,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SupportCardsScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      context,
                      icon: Icons.map,
                      title: 'World Map',
                      subtitle: 'Explore ocean areas',
                      color: Colors.cyan,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorldMapScreen(
                            onAreaSelected: (area) {
                              final gameState = Provider.of<GameState>(context, listen: false);
                              gameState.setCurrentArea(area);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AdvancedFishingScreen()),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      context,
                      icon: Icons.task,
                      title: 'Missions',
                      subtitle: 'Complete daily and weekly tasks',
                      color: Colors.amber,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RealTasksScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      context,
                      icon: Icons.phishing,
                      title: 'Go Fishing',
                      subtitle: 'Start your fishing adventure',
                      color: Colors.teal,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdvancedFishingScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
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
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
