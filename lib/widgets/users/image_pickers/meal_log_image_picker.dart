import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MealLogImagePicker extends StatefulWidget {
  MealLogImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _MealLogImagePickerState createState() => _MealLogImagePickerState();
}

class _MealLogImagePickerState extends State<MealLogImagePicker> {
  File _pickedImage;
  final picker = ImagePicker();

  void _pickImage() async {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_pickedImage != null)
          Container(
            height: 150,
            width: double.infinity,
            child: Image.file(
              _pickedImage,
              fit: BoxFit.cover,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'What did you eat?',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: _pickImage,
                ),
              ],
            )
          ],
        ),
        // CircleAvatar(
        //   radius: 40,
        //   backgroundColor: Colors.grey,
        //   backgroundImage:
        //       _pickedImage != null ? FileImage(_pickedImage) : null,
        // ),
        // FlatButton.icon(
        //   textColor: Theme.of(context).primaryColor,
        //   onPressed: _pickImage,
        //   icon: Icon(Icons.image),
        //   label: Text('Add Image'),
        // ),
      ],
    );
  }
}
