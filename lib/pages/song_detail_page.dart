import 'package:flutter/material.dart';
import 'package:song/services/song_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SongDetailPage extends StatefulWidget {
  final String songId;
  SongDetailPage({required this.songId});

  @override
  _SongDetailPageState createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  final songService = SongService();
  Map song = {};
  List comments = [];
  YoutubePlayerController? _youtubeController;

  void fetchDetail() async {
    final result = await songService.getSongDetail(widget.songId);
    final source = result['source'] ?? '';
    if (YoutubePlayer.convertUrlToId(source) != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(source)!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
    setState(() {
      song = result;
      comments = result['comments'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(song['title'] ?? 'Song Detail')),
      body: song.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text(
                    song['title'] ?? '',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Artist: ${song['artist']}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    song['description'] ?? '',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  if (_youtubeController != null)
                    YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                      ),
                      builder: (context, player) => Column(
                        children: [
                          player,
                        ],
                      ),
                    )
                  else
                    Text('Video tidak tersedia atau link salah.'),
                  SizedBox(height: 16),
                  Divider(),
                  Text(
                    'Comments:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  ...comments.map((c) => ListTile(
                        leading: Icon(Icons.comment),
                        title: Text(c['creator'] ?? ''),
                        subtitle: Text(c['comment_text'] ?? ''),
                      )),
                ],
              ),
            ),
    );
  }
}
