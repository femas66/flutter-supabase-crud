import 'package:crud_superbase/chat_screen.dart';
import 'package:crud_superbase/edit.dart';
import 'package:crud_superbase/tambah.dart';
import 'package:crud_superbase/upload_gambar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.get('URL'),
    anonKey: dotenv.get('ANON_KEY'),
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 2,
    ),
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City',
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        TambahScreen.routeName: (context) => const TambahScreen(),
        EditScreen.routeName: (context) => const EditScreen(),
        UploadGambar.routeName: (context) => const UploadGambar(),
        ChatScreen.routeName: (context) => const ChatScreen(),
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
  final _stream = supabase.from('city').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var users = snapshot.data!;
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
                            Navigator.pushNamed(context, EditScreen.routeName,
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
                          },
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
          // Return your widget with the data from the snapshot
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, UploadGambar.routeName);
            },
            child: const Text("Gambar"),
          ),
          ElevatedButton(
            child: Text("Tanbah"),
            onPressed: () {
              Navigator.pushNamed(context, TambahScreen.routeName);
            },
          ),
          ElevatedButton(
            child: Text("Chat"),
            onPressed: () {
              Navigator.pushNamed(context, ChatScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
