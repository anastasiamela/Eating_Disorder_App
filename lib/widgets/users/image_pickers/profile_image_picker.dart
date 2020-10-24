import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  ProfileImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File _pickedImage;
  final picker = ImagePicker();

  void _pickImageFromCamera() async {
    final pickedImageFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 150,
    );
    setState(() {
      if (pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);
      } else {
        print('No image selected.');
      }
    });
    widget.imagePickFn(_pickedImage);
  }

  void _pickImageFromGallery() async {
    final pickedImageFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 150,
    );
    setState(() {
      if (pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);
      } else {
        print('No image selected.');
      }
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_pickedImage != null)
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage:
                _pickedImage != null ? FileImage(_pickedImage) : null,
          ),
        if (_pickedImage == null)
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).primaryColor,
            child: Image.asset(
              'assets/images/no_profile_image.png',
              fit: BoxFit.cover,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              onPressed: _pickImageFromGallery,
              icon: Icon(Icons.image),
              label: Text('Gallery'),
            ),
            FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              onPressed: _pickImageFromCamera,
              icon: Icon(Icons.camera_alt),
              label: Text('Camera'),
            ),
          ],
        ),
      ],
    );
  }
}
