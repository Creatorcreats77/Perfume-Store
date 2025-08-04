import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:perfume_store/theme/colors.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onImagesSelected});

  final Function(List<String>, List<double>) onImagesSelected;

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  List<File> _selectedImages = [];

  Future<String> convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(Uint8List.fromList(bytes));
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles == null || pickedFiles.isEmpty) return;

    final List<File> imageFiles =
    pickedFiles.map((xfile) => File(xfile.path)).toList();

    final List<String> base64Images = [];
    final List<double> imageSizes = [];

    for (File image in imageFiles) {
      String base64 = await convertImageToBase64(image);
      double sizeMB = (base64.length / 1024.0) / 1024.0;
      base64Images.add(base64);
      imageSizes.add(sizeMB);
    }

    setState(() {
      _selectedImages = imageFiles;
    });

    widget.onImagesSelected(base64Images, imageSizes);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImages,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _selectedImages.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 40, color: AppColors.brown),
            SizedBox(height: 10),
            Text('Tap to select images', style: TextStyle(fontSize: 16)),
          ],
        )
            : _selectedImages.length == 1
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            _selectedImages.first,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
            : GridView.builder(
          itemCount: _selectedImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _selectedImages[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
