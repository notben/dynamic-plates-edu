import 'package:flutter/material.dart';
import 'package:dynamic_plates_edu/features/extreme_phenomena/presentation/sub_modules/volcano_simulator_view.dart';
import 'package:dynamic_plates_edu/features/extreme_phenomena/presentation/sub_modules/earthquake_simulator_view.dart';
import 'package:dynamic_plates_edu/features/extreme_phenomena/presentation/sub_modules/tsunami_simulator_view.dart';

/// Module 2 : Phénomènes Extrêmes (Volcans, Séismes, Tsunamis)
/// Regroupe les 3 simulateurs interactifs dédiés aux risques géologiques.
class ExtremePhenomenaPage extends StatefulWidget {
  const ExtremePhenomenaPage({super.key});

  @override
  State<ExtremePhenomenaPage> createState() => _ExtremePhenomenaPageState();
}

class _ExtremePhenomenaPageState extends State<ExtremePhenomenaPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            tabs: const [
              Tab(
                icon: Icon(Icons.volcano, size: 18),
                text: 'Volcanisme (4 types)',
              ),
              Tab(
                icon: Icon(Icons.flash_on, size: 18),
                text: 'Séismes (Ondes P/S)',
              ),
              Tab(
                icon: Icon(Icons.waves, size: 18),
                text: 'Tsunami (Double vue)',
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          VolcanoSimulatorView(),
          EarthquakeSimulatorView(),
          TsunamiSimulatorView(),
        ],
      ),
    );
  }
}
