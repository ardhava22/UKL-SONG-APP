import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaylistService {
  final baseUrl = 'https://learn.smktelkom-mlg.sch.id/ukl2';

  Future<List> getPlaylists() async {
    final response = await http.get(Uri.parse('$baseUrl/playlists'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to fetch playlists');
    }
  }
}
