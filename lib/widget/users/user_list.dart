import 'package:chatapp/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              ),
            );
          },
          child: ListView.builder(
            itemBuilder: (context, index) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.amber,
                          backgroundImage:
                              NetworkImage(chatDocs[index].data()['image_url']),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          chatDocs[index].data()['username'],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            itemCount: chatDocs.length <= 0 ? null : chatDocs.length,
          ),
        );
      },
    );
  }
}
