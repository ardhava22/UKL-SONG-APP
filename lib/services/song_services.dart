import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class SongService {
  final baseUrl = 'https://learn.smktelkom-mlg.sch.id/ukl2';

  Future<List> getSongs(String playlistId, [String search = '']) async {
    final url =
        Uri.parse('$baseUrl/playlists/song-list/$playlistId?search=$search');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to fetch songs');
    }
  }

  Future<Map<String, dynamic>> getSongDetail(String songId) async {
    final url = Uri.parse('$baseUrl/playlists/song/$songId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to fetch song detail');
    }
  }

  Future<bool> uploadSong({
    required String title,
    required String artist,
    required String description,
    required String source,
    required File thumbnail,
  }) async {
    final url = Uri.parse('$baseUrl/playlists/song');
    final request = http.MultipartRequest('POST', url);
    request.fields['title'] = title;
    request.fields['artist'] = artist;
    request.fields['description'] = description;
    request.fields['source'] = source;
    request.files.add(await http.MultipartFile.fromPath(
        'thumbnail', thumbnail.path,
        contentType: MediaType('image', 'jpeg')));

    final response = await request.send();
    return response.statusCode == 200;
  }
}
