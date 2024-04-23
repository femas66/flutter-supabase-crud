import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditScreen extends StatefulWidget {
  static const String routeName = '/edit-screen';
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController cName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      body: ListView(
        children: [
          TextField(
            controller: cName,
          ),
          ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client
                    .from('city')
                    .update({"name": cName.text}).eq('id', args);
                Navigator.pop(context);
              },
              child: Text("Simpan"))
        ],
      ),
    );
  }
}
