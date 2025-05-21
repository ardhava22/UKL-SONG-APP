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
  Set<String> likedSongs = {};

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('🎵 Daftar Lagu', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Cari lagu...',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                search = val;
                fetchSongs();
              },
            ),
          ),
          Expanded(
            child: songs.isEmpty
                ? Center(
                    child: Text(
                      "🎧 Tidak ada lagu ditemukan",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.white30),
                                  )
                                : Icon(Icons.music_note,
                                    size: 40, color: Colors.white30),
                          ),
                          title: Text(
                            song['title'] ?? '-',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            song['artist'] ?? '',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color:
                                  isLiked ? Colors.greenAccent : Colors.white38,
                            ),
                            onPressed: () => toggleLike(song['uuid']),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SongDetailPage(songId: song['uuid']),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
