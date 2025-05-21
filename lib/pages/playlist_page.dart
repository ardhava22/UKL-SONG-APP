import 'package:flutter/material.dart';
import '../services/playlist_service.dart';
import 'song_list_page.dart';
import 'add_song_page.dart'; // Tambahkan ini

class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final playlistService = PlaylistService();
  List playlists = [];

  void fetchData() async {
    playlists = await playlistService.getPlaylists();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Playlist'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddSongPage()),
              );
              if (result == 'success') {
                fetchData(); // refresh otomatis
              }
            },
          ),
        ],
      ),
      body: playlists.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  '🎵 Pilih Playlist Favoritmu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final item = playlists[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.music_note),
                        title: Text(item['playlist_name']),
                        subtitle: Text('${item['song_count']} lagu'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SongListPage(playlistId: item['uuid']),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
