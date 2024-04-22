import 'dart:developer';

import 'package:crud_superbase/edit.dart';
import 'package:crud_superbase/tambah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.get('URL'),
    anonKey: dotenv.get('ANON_KEY'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries',
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        TambahScreen.routeName: (context) => const TambahScreen(),
        EditScreen.routeName: (context) => const EditScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _notesStream =
      Supabase.instance.client.from('city').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, TambahScreen.routeName);
              },
              child: Text("Tambah")),
          StreamBuilder<List<Map<String, dynamic>>>(
              stream: _notesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final users = snapshot.data!;
                  print(users);
                  return ListView.builder(
                      itemCount: users.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(users[index]['name']),
                          subtitle: Row(
                            children: [
                              ElevatedButton(
                                child: Text("Edit"),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, EditScreen.routeName,
                                      arguments: users[index]['id']);
                                },
                              ),
                              ElevatedButton(
                                child: Text("Hapus"),
                                onPressed: () async {
                                  await Supabase.instance.client
                                      .from('city')
                                      .delete()
                                      .eq('id', users[index]['id']);
                                  Navigator.pushReplacementNamed(
                                      context, HomePage.routeName);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                }
              })
        ],
      ),
    );
  }
}
