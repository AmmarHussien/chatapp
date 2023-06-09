import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ImageOptions {
  camera,
  galary,
}

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.imagePickFn, {super.key});

  final void Function(File pickedImage) imagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
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
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
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
            const Text('Upload Image'),
            PopupMenuButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              padding: EdgeInsets.all(0),
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
