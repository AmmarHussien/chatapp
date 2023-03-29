import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../pickers/chat_image_picker.dart';

enum ImageOptions {
  camera,
  galary,
}

class NewMessage extends StatefulWidget {
  const NewMessage(this.imagePickFn, {super.key});
  final void Function(File pickedImage)? imagePickFn;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final User? user = auth.currentUser;
    final uid = user!.uid;
    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'chatImage': 'text',
      'createdAt': Timestamp.now(),
      'userId': uid,
      'username': userdata['username'],
      'userImage': userdata['image_url'],
    });
    _controller.clear();
    _controller.clearComposing();
  }

  File? _pickedImage;
  void _pickImageCamera() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickFn!(File(pickedImageFile!.path));
    uploadImage();
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    var ref = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('$fileName.png');
    var upload = await ref.putFile(_pickedImage!);
    String imageUrl = await upload.ref.getDownloadURL();
  }

  void _pickImageGallery() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickFn!(File(pickedImageFile!.path));
    uploadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
      ),
      padding: const EdgeInsets.all(
        8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Send a messages...',
              ),
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PopupMenuButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                onSelected: (ImageOptions value) {
                  setState(() {
                    if (value == ImageOptions.camera) {
                      _pickImageCamera();
                    } else {
                      _pickImageGallery();
                    }
                  });
                },
                icon: Icon(
                  Icons.image_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: ImageOptions.camera,
                    child: Text('Camera'),
                  ),
                  const PopupMenuItem(
                    value: ImageOptions.galary,
                    child: Text('galary'),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
