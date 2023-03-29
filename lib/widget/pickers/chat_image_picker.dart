import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

enum ImageOptions {
  camera,
  galary,
}

class ChatImagePicker extends StatefulWidget {
  const ChatImagePicker(this.imagePickFn, {super.key});
  final void Function(File pickedImage) imagePickFn;
  @override
  State<ChatImagePicker> createState() => _ChatImagePickerState();
}

class _ChatImagePickerState extends State<ChatImagePicker> {
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
    widget.imagePickFn(File(pickedImageFile!.path));
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
    widget.imagePickFn(File(pickedImageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CircleAvatar(
        //   radius: 40,
        //   backgroundColor: Colors.grey,
        //   backgroundImage:
        //       _pickedImage != null ? FileImage(_pickedImage!) : null,
        // ),
        // TextButton.icon(
        //   onPressed: _pickImage,
        //   icon: Icon(
        //     Icons.image_rounded,
        //     color: Theme.of(context).primaryColor,
        //   ),
        //   label: Text(
        //     'Add image',
        //     style: TextStyle(
        //       color: Theme.of(context).primaryColor,
        //     ),
        //   ),
        // ),
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
      ],
    );
  }
}
