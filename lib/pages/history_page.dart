import 'package:flutter/material.dart';

import 'package:emo_star_star/model/journal_entry.dart' ;
import 'package:emo_star_star/services/journal_storage.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}


class _HistoryPageState extends State<HistoryPage> {

  // Stores all journal entries loaded from local storage.
  List<JournalEntry> _entries = [];

  // Shows a loading indicator while entries are being loaded.
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();

    // Load the saved journals when this page opens.
    _loadEntries();
  }


  // Loads journal entries from local storage.
  Future<void> _loadEntries() async {

    final entries = await JournalStorage.getEntries();

    if (!mounted) return;

    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal History'),
        backgroundColor: Colors.pink,
      ),

      body: _isLoading

      // Show this while journals are loading.
          ? const Center(
        child: CircularProgressIndicator(),
      )

      // Show this when there are no journals.
          : _entries.isEmpty
          ? const Center(
        child: Text(
          'No journal entries yet.',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )

      // Display the saved journals.
          : ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: _entries.length,

        itemBuilder: (context, index) {

          final entry = _entries[index];

          return Card(
            margin: const EdgeInsets.only(
              bottom: 12,
            ),

            child: ListTile(

              // Show the date of the journal.
              leading: const Icon(
                Icons.book,
                color: Colors.pink,
              ),

              title: Text(
                entry.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              subtitle: Text(
                _formatDate(entry.createdAt),
              ),

              // We'll use this later to open
              // the complete journal + analysis.
              trailing: const Icon(
                Icons.chevron_right,
              ),
            ),
          );
        },
      ),
    );
  }


  // Converts the DateTime into a simple readable format.
  String _formatDate(DateTime date) {

    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}