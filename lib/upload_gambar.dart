
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
  File? selectedFile;
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });

      // ekstensi file
      String extensionFile = selectedFile!.path.split('.').last;

      // angka acak
      int length = 8;
      String randomNumbers = String.fromCharCodes(
          List.generate(length, (index) => Random().nextInt(10) + 48));

      final path = await supabase.storage.from('photos').upload(
            "$randomNumbers.$extensionFile",
            File(result.files.single.path!),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      final String signedUrl = await supabase.storage
          .from('photos')
          .createSignedUrl("$randomNumbers.$extensionFile", 10000);
      print(signedUrl);
      await supabase.from('photos').insert({"photo": signedUrl});
    }
  }

  final _stream = supabase.from('photos').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: _pickFile, child: Text("Pilih file")),
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
