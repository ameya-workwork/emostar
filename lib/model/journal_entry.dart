class JournalEntry {
  final String id;
  final String text;
  final DateTime createdAt;
  final String analysisStatus;
  final Map<String, dynamic>? analysis;

  JournalEntry({
    //constructor , all variables required when creating journal entry
    required this.id,
    required this.text,
    required this.createdAt,
    this.analysisStatus = 'pending', //default
    this.analysis,
  });

  Map<String, dynamic> toJson() {
    //shared preferences our local storage module cant store objects so we're saving it in json as json obj
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'analysisStatus': analysisStatus,
      'analysis': analysis,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    // got back from json need to convert to dart so we can display it in our app
    return JournalEntry(
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      analysisStatus: json['analysisStatus'] ?? 'pending',
      analysis: json['analysis'] != null
          ? Map<String, dynamic>.from(json['analysis'])
          : null,
    );
  }
}