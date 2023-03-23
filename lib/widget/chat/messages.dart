import 'package:chatapp/widget/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => MessageBubble(
            chatDocs[index].data()['text'],
            chatDocs[index].data()['userId'] == user!.uid,
            chatDocs[index].data()['username'],
            keys: ValueKey(
              chatDocs[index].id,
            ),
          ),
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
