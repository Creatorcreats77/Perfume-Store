import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widgets/firebase_widgets/ImageInput_widget.dart';

class CreateCardPage extends StatefulWidget {
  const CreateCardPage({super.key});

  @override
  State<CreateCardPage> createState() => _TitleDescriptionPageState();
}

void _storeImage(File image) {
  // Do something with the image file
  print('Image selected: ${image.path}');
}

class _TitleDescriptionPageState extends State<CreateCardPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _imageBase64String;

  void _onImageDataReceived(String base64String, double byteOfImage) {
    setState(() {
      _imageBase64String = base64String;
    });
    // You can use the base64String and byteOfImage here
    print("$base64String");
    print('Image Size: $byteOfImage MB');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> uploadTaskToDb() async {
    try {
      final data = await FirebaseFirestore.instance.collection('products').add({
        "title": _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': FieldValue.serverTimestamp(),
        'image': "$_imageBase64String",
      });
      print(data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Info')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          children: [
            /// Title input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),

            /// Description input
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            // ImageInput(onDataReceived: _onImageDataReceived),
            const SizedBox(height: 32),

            /// Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await uploadTaskToDb();
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Color(0xFF42A5F5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
