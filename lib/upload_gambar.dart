import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadGambar extends StatefulWidget {
  static const String routeName = '/upload-gambar';
  const UploadGambar({super.key});

  @override
  State<UploadGambar> createState() => _UploadGambarState();
}

final supabase = Supabase.instance.client;

class _UploadGambarState extends State<UploadGambar> {
  bool _isLoading = false;
  void _pickFile() async {
    if (!_isLoading) {
      // pilih file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        File selectedFile = File(result.files.single.path!);
        setState(() {
          _isLoading = true;
        });

        // angka acak
        int length = 8;
        String randomNumbers = String.fromCharCodes(
            List.generate(length, (index) => Random().nextInt(10) + 48));
        // ekstensi file
        String extensionFile = selectedFile.path.split('.').last;

        //nma fle
        String fileName = "$randomNumbers.$extensionFile";

        // upload ke srver
        await supabase.storage.from('photos').upload(
              fileName,
              File(result.files.single.path!),
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false),
            );

        // mengambil publik url filenya
        final urlDownload =
            supabase.storage.from('photos').getPublicUrl(fileName);

        // insert ke server
        await supabase.from('photos').insert({"photo": urlDownload});
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  // stream photos
  final _stream = supabase.from('photos').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(onPressed: _pickFile, child: const Text("Pilih file")),
          Visibility(visible: _isLoading, child: const CircularProgressIndicator()),
          StreamBuilder(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var photos = snapshot.data!;
                return ListView.builder(
                    itemCount: photos.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Image.network(
                          photos[index]['photo'],
                          width: 100,
                          height: 100,
                        ),
                      );
                    });
              } else {
                return const CircularProgressIndicator();
              }
              // Return your widget with the data from the snapshot
            },
          ),
        ],
      ),
    );
  }
}
