import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:song/services/service_song.dart';

class AddSongPage extends StatefulWidget {
  @override
  _AddSongPageState createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final descriptionController = TextEditingController();
  final sourceController = TextEditingController();

  File? thumbnail;
  bool isLoading = false;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        thumbnail = File(picked.path);
      });
    }
  }

  Future<void> saveSong() async {
    if (!_formKey.currentState!.validate()) return;
    if (thumbnail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan pilih thumbnail')),
      );
      return;
    }

    if (mounted) setState(() => isLoading = true);

    try {
      final songService = ServiceSong();
      final response = await songService.createSong(
        title: titleController.text,
        artist: artistController.text,
        description: descriptionController.text,
        source: sourceController.text,
        thumbnail: thumbnail!,
      );

      final respStr = await response.stream.bytesToString();
      if (mounted) setState(() => isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: Text('✅ Sukses'),
              content: Text('Lagu berhasil ditambahkan!'),
            ),
          );
          await Future.delayed(Duration(seconds: 3));
          if (mounted) {
            Navigator.of(context).pop(); // tutup dialog
            Navigator.of(context).pop('success'); // kembali ke playlist
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal: $respStr')),
          );
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[300])),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Wajib diisi' : null,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('🎶 Tambah Lagu'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField(
                controller: titleController,
                label: 'Judul Lagu',
                hint: 'Contoh: Cinta Luar Biasa',
              ),
              _buildField(
                controller: artistController,
                label: 'Artis / Penyanyi',
                hint: 'Contoh: Andmesh',
              ),
              _buildField(
                controller: descriptionController,
                label: 'Deskripsi',
                hint: 'Isi deskripsi lagu',
                maxLines: 3,
              ),
              _buildField(
                controller: sourceController,
                label: 'Link YouTube',
                hint: 'https://youtube.com/...',
              ),
              Text(
                'Thumbnail Lagu',
                style: TextStyle(color: Colors.grey[300]),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: Icon(Icons.image),
                    label: Text('Pilih Gambar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[700],
                      foregroundColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      thumbnail?.path.split('/').last ?? 'Belum dipilih',
                      style: TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (thumbnail != null) ...[
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    thumbnail!,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.cancel, color: Colors.grey),
                    label: Text('Batal', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : saveSong,
                    icon: isLoading
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                color: Colors.black, strokeWidth: 2),
                          )
                        : Icon(Icons.save),
                    label: Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[700],
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
