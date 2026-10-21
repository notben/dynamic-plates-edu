import 'package:flutter/material.dart';

/// Module 3 : Atlas Géologique Mondial & Histoire des Sciences
/// Placeholder prêt pour le Jalon 3.
class WorldAtlasPage extends StatelessWidget {
  const WorldAtlasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atlas Géologique Mondial & Histoire'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.public, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Module 3 : Atlas Géologique Mondial',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Carte vectorielle des plaques, sites remarquables et frise de Wegener.',
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
