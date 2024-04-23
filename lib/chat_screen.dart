import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final supabase = Supabase.instance.client;

class _ChatScreenState extends State<ChatScreen> {
  final _stream = supabase.from('chat').stream(primaryKey: ['id']);
  TextEditingController cMessage = TextEditingController();

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
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(users[index]['message']),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(users[index]['created_at']),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: cMessage,
                decoration: const InputDecoration(hintText: "Masukan pesan"),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await Supabase.instance.client
                      .from('chat')
                      .insert({"message": cMessage.text});
                  cMessage.clear();
                },
                child: const Icon(Icons.send))
          ],
        ),
      ),
    );
  }
}
