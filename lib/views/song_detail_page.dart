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
    final videoId = YoutubePlayer.convertUrlToId(source);

    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
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
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          song['title'] ?? 'Song Detail',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: song.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text(
                    song['title'] ?? '',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'by ${song['artist'] ?? '-'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    song['description'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_youtubeController != null)
                    YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressColors: ProgressBarColors(
                          playedColor: Colors.greenAccent,
                          handleColor: Colors.white,
                        ),
                      ),
                      builder: (context, player) => ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: player,
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '🎬 Video tidak tersedia atau link salah.',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  SizedBox(height: 28),
                  Divider(color: Colors.grey[700]),
                  Text(
                    '💬 Komentar:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  if (comments.isEmpty)
                    Text(
                      'Belum ada komentar.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ...comments.map((c) => Card(
                        color: Colors.grey[900],
                        margin: EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading:
                              Icon(Icons.comment, color: Colors.greenAccent),
                          title: Text(
                            c['creator'] ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            c['comment_text'] ?? '',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
