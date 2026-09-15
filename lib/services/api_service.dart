import 'dart:convert';
import 'package:http/http.dart' as http;


// Handles communication between Flutter and FastAPI.
class ApiService {

  // FastAPI address.
  static const String baseUrl = 'http://127.0.0.1:8000';


  // Sends a journal to the backend for emotion analysis.
  static Future<Map<String, dynamic>> analyzeJournal(
      String text) async {

    final url = Uri.parse('$baseUrl/journal');


    // Send the journal to FastAPI.
    final response = await http.post(
      url,

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'text': text,
      }),
    );


    // Print the HTTP status.
    print('API STATUS: ${response.statusCode}');


    // Print the actual response body.
    print('API BODY: ${response.body}');


    // If the backend successfully responded,
    // convert its JSON response into a Dart Map.
    if (response.statusCode == 200) {

      final decoded = jsonDecode(response.body);

      print('DECODED ANALYSIS: ${decoded['analysis']}');

      return Map<String, dynamic>.from(decoded);
    }


    // Something went wrong with the backend.
    throw Exception(
      'Failed to analyze journal: ${response.statusCode}',
    );
  }
}