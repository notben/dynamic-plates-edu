import 'package:flutter/material.dart';

/// Module 2 : Phénomènes Extrêmes (Volcans, Séismes, Tsunamis)
/// Placeholder prêt pour le Jalon 2.
class ExtremePhenomenaPage extends StatelessWidget {
  const ExtremePhenomenaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phénomènes Extrêmes (Volcans, Séismes, Tsunamis)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.volcano, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Module 2 : Phénomènes Extrêmes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Simulateur des 4 régimes éruptifs, séismes et double-vue tsunami.',
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
