import 'package:flutter/material.dart';


class AnalysisPage extends StatelessWidget {
  final Map<String, dynamic> analysis;


  const AnalysisPage({
    super.key,
    required this.analysis,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Analysis'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              'Analysis page is working!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Primary emotion: ${analysis['primary_emotion']}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

          ],
        ),
      ),
    );
  }
}