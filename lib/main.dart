import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/core/theme/app_theme.dart';
import 'package:dynamic_plates_edu/core/localization/app_strings.dart';
import 'package:dynamic_plates_edu/features/tectonic_lab/presentation/tectonic_lab_page.dart';
import 'package:dynamic_plates_edu/features/extreme_phenomena/presentation/extreme_phenomena_page.dart';
import 'package:dynamic_plates_edu/features/world_atlas/presentation/world_atlas_page.dart';
import 'package:dynamic_plates_edu/features/quiz/presentation/quiz_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DynamicPlatesEduApp());
}

class DynamicPlatesEduApp extends StatefulWidget {
  const DynamicPlatesEduApp({super.key});

  @override
  State<DynamicPlatesEduApp> createState() => _DynamicPlatesEduAppState();
}

class _DynamicPlatesEduAppState extends State<DynamicPlatesEduApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  AppLanguage _currentLanguage = AppLanguage.fr;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _changeLanguage(AppLanguage lang) {
    setState(() {
      _currentLanguage = lang;
      AppStrings.currentLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Plates Edu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: MainShellScreen(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
        currentLanguage: _currentLanguage,
        onChangeLanguage: _changeLanguage,
      ),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final AppLanguage currentLanguage;
  final ValueChanged<AppLanguage> onChangeLanguage;

  const MainShellScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
    required this.currentLanguage,
    required this.onChangeLanguage,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  void _navigateToSimulation(int simIndex) {
    setState(() {
      _currentIndex = 0;
    });
  }

  List<Widget> get _pages => [
    const TectonicLabPage(),
    const ExtremePhenomenaPage(),
    WorldAtlasPage(onNavigateToSimulation: _navigateToSimulation),
    const QuizPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 720;
    final isDark = widget.themeMode == ThemeMode.dark;

    if (isWide) {
      // Disposition Tablette (iPad) / Ordinateur / Web avec NavigationRail
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.public, color: Colors.orangeAccent, size: 28),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Dynamic\nPlates',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, height: 1.1),
                    ),
                  ],
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                          tooltip: isDark ? 'Mode clair' : 'Mode sombre',
                          onPressed: widget.onToggleTheme,
                        ),
                        const SizedBox(height: 8),
                        _buildLanguageDropdown(),
                      ],
                    ),
                  ),
                ),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.layers_outlined),
                  selectedIcon: const Icon(Icons.layers),
                  label: Text(AppStrings.get('nav_tectonic_lab')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.volcano_outlined),
                  selectedIcon: const Icon(Icons.volcano),
                  label: Text(AppStrings.get('nav_extreme_phenomena')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.map_outlined),
                  selectedIcon: const Icon(Icons.map),
                  label: Text(AppStrings.get('nav_world_atlas')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.school_outlined),
                  selectedIcon: const Icon(Icons.school),
                  label: Text(AppStrings.get('nav_quiz')),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      );
    }

    // Disposition Smartphone (Portrait / Étroit) avec NavigationBar
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public, color: Colors.orangeAccent, size: 24),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppStrings.get('app_title'),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Mode clair' : 'Mode sombre',
            onPressed: widget.onToggleTheme,
          ),
          _buildLanguageDropdown(),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.layers_outlined),
            selectedIcon: const Icon(Icons.layers),
            label: AppStrings.get('nav_tectonic_lab'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.volcano_outlined),
            selectedIcon: const Icon(Icons.volcano),
            label: AppStrings.get('nav_extreme_phenomena'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: AppStrings.get('nav_world_atlas'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_outlined),
            selectedIcon: const Icon(Icons.school),
            label: AppStrings.get('nav_quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return PopupMenuButton<AppLanguage>(
      tooltip: 'Changer de langue',
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          widget.currentLanguage.name.toUpperCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
      onSelected: widget.onChangeLanguage,
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: AppLanguage.fr, child: Text('Français (FR - Suisse PER)')),
        const PopupMenuItem(value: AppLanguage.de, child: Text('Deutsch (DE)')),
        const PopupMenuItem(value: AppLanguage.it, child: Text('Italiano (IT)')),
        const PopupMenuItem(value: AppLanguage.en, child: Text('English (EN)')),
      ],
    );
  }
}
