import 'package:flutter/material.dart';
import 'package:song/services/song_services.dart';

import 'song_detail_page.dart';

class SongListPage extends StatefulWidget {
  final String playlistId;
  SongListPage({required this.playlistId});

  @override
  _SongListPageState createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final songService = SongService();
  List songs = [];
  String search = '';
  Set<String> likedSongs = {}; // Menyimpan ID lagu yang disukai

  void fetchSongs() async {
    songs = await songService.getSongs(widget.playlistId, search);
    setState(() {});
  }

  void toggleLike(String songId) {
    setState(() {
      if (likedSongs.contains(songId)) {
        likedSongs.remove(songId);
      } else {
        likedSongs.add(songId);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Songs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search song...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                search = val;
                fetchSongs();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final isLiked = likedSongs.contains(song['uuid']);
                final imageUrl = song['thumbnail'] == null ||
                        song['thumbnail'] == ''
                    ? null
                    : song['thumbnail'].toString().startsWith('http')
                        ? song['thumbnail']
                        : 'https://learn.smktelkom-mlg.sch.id/ukl2/thumbnail/${song['thumbnail']}';

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: 40),
                            )
                          : Icon(Icons.music_note, size: 40),
                    ),
                    title: Text(
                      song['title'] ?? '-',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      song['artist'] ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => toggleLike(song['uuid']),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SongDetailPage(songId: song['uuid']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
