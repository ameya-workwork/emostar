import 'package:flutter/material.dart';

class AnalysisPage extends StatelessWidget {
  final Map<String, dynamic> analysis;

  const AnalysisPage({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final primaryEmotion =
        analysis['primary_emotion'] ?? 'Unknown';

    final secondaryEmotions =
        analysis['secondary_emotions'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Analysis'),
        backgroundColor: Colors.pink,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Your emotional breakdown',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              'Primary emotion',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              primaryEmotion.toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              'Secondary emotions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              secondaryEmotions.isEmpty
                  ? 'None detected'
                  : secondaryEmotions.join(', '),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}