import 'dart:math';
import 'package:flutter/material.dart';

/// Contrôle parental conforme aux exigences de l'Apple App Store (Catégorie Enfants / Éducation).
/// Intercepte tout lien externe par un défi arithmétique pour les adultes.
class ParentalGateDialog extends StatefulWidget {
  final VoidCallback onPassed;

  const ParentalGateDialog({super.key, required this.onPassed});

  static Future<void> show(BuildContext context, {required VoidCallback onPassed}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ParentalGateDialog(onPassed: onPassed),
    );
  }

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog> {
  late final int _a;
  late final int _b;
  late final int _answer;
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _a = 6 + rng.nextInt(4); // 6 à 9
    _b = 6 + rng.nextInt(4); // 6 à 9
    _answer = _a * _b;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _verify() {
    final input = int.tryParse(_controller.text.trim());
    if (input == _answer) {
      Navigator.of(context).pop();
      widget.onPassed();
    } else {
      setState(() {
        _error = 'Réponse incorrecte. Demandez à un adulte ou enseignant.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.orange),
          SizedBox(width: 10),
          Text('Contrôle Enseignant / Parent'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pour accéder à cette section ou ressource externe, veuillez résoudre cette multiplication :',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '$_a × $_b = ?',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Votre résultat',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _verify(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _verify,
          child: const Text('Confirmer'),
        ),
      ],
    );
  }
}
