import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/core/localization/app_strings.dart';
import 'package:dynamic_plates_edu/features/world_atlas/presentation/sub_modules/interactive_map_view.dart';
import 'package:dynamic_plates_edu/features/world_atlas/presentation/sub_modules/wegener_timeline_view.dart';

/// Module 3 : Atlas Géologique Mondial & Histoire des Sciences
/// Affiche la carte tectonique vectorielle des plaques et la frise historique d'Alfred Wegener.
class WorldAtlasPage extends StatefulWidget {
  final void Function(int simulationIndex)? onNavigateToSimulation;

  const WorldAtlasPage({super.key, this.onNavigateToSimulation});

  @override
  State<WorldAtlasPage> createState() => _WorldAtlasPageState();
}

class _WorldAtlasPageState extends State<WorldAtlasPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: theme.colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(
                icon: const Icon(Icons.public, size: 18),
                text: AppStrings.get('tab_tectonic_map'),
              ),
              Tab(
                icon: const Icon(Icons.history_edu, size: 18),
                text: AppStrings.get('tab_wegener'),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InteractiveMapView(
            onNavigateToSimulation: widget.onNavigateToSimulation,
          ),
          const WegenerTimelineView(),
        ],
      ),
    );
  }
}
