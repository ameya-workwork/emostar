import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:emo_star_star/model/journal_entry.dart' ;


class JournalStorage {

  // The key used to store all journal entries.
  static const String _key = 'journal_entries';


  // Get all saved journal entries.
  static Future<List<JournalEntry>> getEntries() async {

    final prefs = await SharedPreferences.getInstance();

    final stored = prefs.getStringList(_key) ?? [];

    return stored
        .map((item) => JournalEntry.fromJson(jsonDecode(item)))
        .toList();
  }


  // Save a new journal entry.
  static Future<void> saveEntry(JournalEntry entry) async {

    final prefs = await SharedPreferences.getInstance();

    final entries = await getEntries();

    // Put the newest journal at the beginning.
    entries.insert(0, entry);

    final data = entries
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();

    await prefs.setStringList(_key, data);
  }


  // Update an existing journal entry.
  //
  // We will use this after FastAPI returns the
  // emotion analysis for the journal.
  static Future<void> updateEntry(JournalEntry updatedEntry) async {

    final prefs = await SharedPreferences.getInstance();

    final entries = await getEntries();


    // Find the journal with the same ID.
    final index = entries.indexWhere(
          (entry) => entry.id == updatedEntry.id,
    );


    // If the journal exists, replace it with
    // the updated version.
    if (index != -1) {
      entries[index] = updatedEntry;
    }


    // Convert the updated list back into JSON.
    final data = entries
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();


    // Save the updated journals.
    await prefs.setStringList(_key, data);
  }
}