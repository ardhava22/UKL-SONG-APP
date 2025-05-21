import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ServiceSong {
  final String baseUrl = 'https://learn.smktelkom-mlg.sch.id/ukl2';

  Future<http.StreamedResponse> createSong({
    required String title,
    required String artist,
    required String description,
    required String source,
    required File thumbnail,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/playlists/song'),
    );

    request.fields['title'] = title;
    request.fields['artist'] = artist;
    request.fields['description'] = description;
    request.fields['source'] = source;

    request.files.add(await http.MultipartFile.fromPath(
      'thumbnail',
      thumbnail.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    return await request.send();
  }
}
