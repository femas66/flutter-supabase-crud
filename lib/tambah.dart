import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahScreen extends StatefulWidget {
  static const String routeName = '/tambah-screen';
  const TambahScreen({super.key});

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  TextEditingController cName = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    .insert({"name": cName.text});
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text("Tambah"))
        ],
      ),
    );
  }
}
