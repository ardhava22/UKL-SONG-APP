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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

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
        SnackBar(content: Text('Please choose a thumbnail')),
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
              title: Text('Berhasil'),
              content: Text('Lagu berhasil ditambahkan!'),
            ),
          );

          await Future.delayed(Duration(seconds: 3));
          if (mounted) {
            Navigator.of(context).pop(); // tutup dialog
            Navigator.of(context).pop('success'); // kembali ke PlaylistPage
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: $respStr')),
          );
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error: $e')),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String validatorMsg,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) => value!.isEmpty ? validatorMsg : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🎶 Tambah Lagu Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Informasi Lagu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              SizedBox(height: 12),
              _buildTextField(
                controller: titleController,
                label: 'Judul Lagu',
                validatorMsg: 'Judul tidak boleh kosong',
              ),
              SizedBox(height: 12),
              _buildTextField(
                controller: artistController,
                label: 'Artis / Penyanyi',
                validatorMsg: 'Artis tidak boleh kosong',
              ),
              SizedBox(height: 12),
              _buildTextField(
                controller: descriptionController,
                label: 'Deskripsi',
                maxLines: 3,
                validatorMsg: 'Deskripsi tidak boleh kosong',
              ),
              SizedBox(height: 12),
              _buildTextField(
                controller: sourceController,
                label: 'Link YouTube',
                validatorMsg: 'Link tidak boleh kosong',
              ),
              SizedBox(height: 20),
              Text(
                'Thumbnail Lagu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: Icon(Icons.upload_file),
                    label: Text('Pilih File'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      thumbnail?.path.split('/').last ?? 'Belum dipilih',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (thumbnail != null) ...[
                SizedBox(height: 16),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      thumbnail!,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.cancel),
                    label: Text('Batal'),
                  ),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : saveSong,
                    icon: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.save),
                    label: Text('Simpan Lagu'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
