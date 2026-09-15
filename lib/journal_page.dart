import 'package:flutter/material.dart';

import 'package:emo_star_star/ananlysis_page.dart';
import 'package:emo_star_star/model/journal_entry.dart';
import 'package:emo_star_star/services/journal_storage.dart';
import 'package:emo_star_star/services/api_service.dart';


class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}


class _JournalPageState extends State<JournalPage> {

  // Controls the text inside the journal text box.
  final TextEditingController _journalController =
  TextEditingController();


  // Prevents the user from pressing Save multiple times
  // while the backend is processing the journal.
  bool _isSaving = false;


  // Saves the journal and sends it to the backend for analysis.
  Future<void> _saveJournal() async {

    // Remove unnecessary spaces from the beginning and end.
    final text = _journalController.text.trim();


    // Don't save an empty journal.
    if (text.isEmpty) {
      return;
    }


    // Show the loading state.
    setState(() {
      _isSaving = true;
    });


    // Create a local journal entry first.
    //
    // This means the journal is saved locally
    // even if the backend is temporarily unavailable.
    print('1. Starting save');

    final localEntry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
    );

    print('2. Created local entry');


    // Save the original journal locally.
    await JournalStorage.saveEntry(localEntry);

    print('3. Saved locally');


    try {

      // Send the journal to FastAPI.
      //
      // The backend will:
      // 1. Run the emotion model.
      // 2. Save the journal and analysis to MongoDB.
      // 3. Return the analysis to Flutter.
      final result = await ApiService.analyzeJournal(text);

      // Print exactly what the backend sent to Flutter.
      print('4. BACKEND RESULT: $result');


      // Get the emotion analysis returned by FastAPI.
      final emotionAnalysis =
      Map<String, dynamic>.from(result['analysis']);

      print('5. Got analysis');


      // Create an updated version of the journal entry
      // containing the emotion analysis.
      final updatedEntry = JournalEntry(
        id: localEntry.id,
        text: localEntry.text,
        createdAt: localEntry.createdAt,
        analysisStatus: 'complete',
        analysis: emotionAnalysis,
      );

      print('6. Created updated entry');


      // Update the local copy with the analysis.
      await JournalStorage.updateEntry(updatedEntry);

      print('7. Updated local entry');


      // Clear the text box after successful processing.
      _journalController.clear();


      // Make sure the page is still available before navigating.
      if (!mounted) return;


      // Open the Analysis page and pass the analysis to it.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisPage(
            analysis: emotionAnalysis,
          ),
        ),
      );


      // Tell the user that the journal was processed.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Journal analyzed successfully'),
        ),
      );

    } catch (e) {

      // The journal is already saved locally,
      // so we haven't lost the user's entry.
      print('JOURNAL ERROR: $e');


      // Make sure the page is still available.
      if (!mounted) return;


      // Tell the user that the local copy was saved,
      // but the analysis could not be completed.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Journal saved, but emotion analysis failed.',
          ),
        ),
      );
    }


    // Stop showing the loading state.
    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });
  }


  @override
  void dispose() {

    // Clean up the text controller when this page is removed.
    _journalController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry'),
        backgroundColor: Colors.pink,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // Journal text box
            TextField(
              controller: _journalController,

              // Allow the user to write a reasonably large entry.
              maxLines: 10,

              decoration: const InputDecoration(
                hintText: 'Write about your day...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),


            // Save/analyze button
            ElevatedButton(
              onPressed: _isSaving ? null : _saveJournal,

              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save Journal'),
            ),
          ],
        ),
      ),
    );
  }
}