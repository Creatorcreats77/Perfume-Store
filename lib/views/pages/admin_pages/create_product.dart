import 'dart:async';
import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perfume_store/widgets/app_bar_without_login_widget.dart';

import '../../../theme/colors.dart';
import '../../../widgets/firebase_widgets/ImageInput_widget.dart';
import '../../data/constants.dart';

class CreatePerfumeProduct extends StatefulWidget {
  const CreatePerfumeProduct({super.key});

  @override
  State<CreatePerfumeProduct> createState() => _PerfumeHomePageState();
}

class _PerfumeHomePageState extends State<CreatePerfumeProduct> {
  final TextEditingController _productTitleController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDiscountController =
      TextEditingController();
  bool isLoading = false;
  List<String> _base64Images = [];
  List<double> _imageSizes = [];

  final _formKey = GlobalKey<FormState>();
  void _onImagesSelected(List<String> base64List, List<double> sizeList) {
    setState(() {
      _base64Images = base64List;
      _imageSizes = sizeList;
    });
    // print("This is list ${_base64Images}");
    for (int i = 0; i < _base64Images.length; i++) {
      if (_imageSizes[i] >= 1) {
        print("Image ${i + 1} size: ${_imageSizes[i]} MB bigger than 1Mb");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Image ${i + 1} size: ${_imageSizes[i].toStringAsFixed(2)} MB bigger than 1Mb",
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Color(0xF4AC3511), // Background color
          ),
        );
      }
    }
  }

  // ///////////////////////////////////////////////////// ///////////////////////////////////////////////////
  Future<void> uploadTaskToDb() async {
    setState(() {
      isLoading = true;
    });
    try {
      final id = Uuid().v4();
      await FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .set({
            "title": _productTitleController.text.trim(),
            'description': _productDescriptionController.text.trim(),
            'price': _productPriceController.text.trim(),
            'discount': _productDiscountController.text.trim(),
            'date': FieldValue.serverTimestamp(),
            // 'image': "$_imageBase64String",
          })
          .timeout(
            Duration(seconds: 20),
            onTimeout: () {
              throw Exception("Timeout: Firebase took too long.");
            },
          );

      for (int i = 0; i < _base64Images.length; i++) {
        if (_imageSizes[i] > 1.0) {
          throw Exception('Image ${i + 1} exceeds 1MB and cannot be saved.');
        }

        final imageId = Uuid().v4();

        await FirebaseFirestore.instance
            .collection('products')
            .doc(id)
            .collection('images')
            .doc(imageId)
            .set({'image': _base64Images[i]})
            .timeout(
              Duration(seconds: 20),
              onTimeout: () {
                throw Exception("Timeout: Firebase took too long.");
              },
            );
        ;
      }

      print(id);
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text('Your information is now on cloud!'),
          backgroundColor: Color(0xF441BC11),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );

      _productTitleController.clear();
      _productDescriptionController.clear();
      _productPriceController.clear();
      _productDiscountController.clear();
      setState(() {
        _base64Images.clear();
        _imageSizes.clear();
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Firebase error: ${e.message}",
            style: TextStyle(color: Colors.white), // Text color
          ),
          backgroundColor: Color(0xF4AC3511), // Background color
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ///////////////////////////////////////////////////// ///////////////////////////////////////////////////
  @override
  void dispose() {
    _productTitleController.dispose();
    _productDescriptionController.dispose();
    _productPriceController.dispose();
    _productDiscountController.dispose();
    super.dispose();
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      int byteTitle = utf8.encode(_productTitleController.text.trim()).length;
      int byteDescription = utf8
          .encode(_productDescriptionController.text.trim())
          .length;
      int bytePrice = utf8.encode(_productPriceController.text.trim()).length;
      int byteDiscount = utf8
          .encode(_productDiscountController.text.trim())
          .length;

      double MbSizeText =
          (byteTitle + byteDescription + bytePrice + byteDiscount) / (1024 * 2);

      if (MbSizeText <= 0.99) {
        uploadTaskToDb();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Your information size is big ${(MbSizeText).toStringAsFixed(2)}Mb . It should be less than 1 Mb!',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Color(0xF4AC3511), // Background color
          ),
        );
      }
      //
      // print("Title ${_productTitleController.text.trim()} and byte of ${(utf8.encode(_productTitleController.text.trim())).length}");
      // print("desc ${_productDescriptionController.text.trim()} and byte of ${(utf8.encode(_productDescriptionController.text.trim())).length}");
      // print("price ${_productPriceController.text.trim()} and byte of ${(utf8.encode(_productPriceController.text.trim())).length}");
      // print("disc ${_productDiscountController.text.trim()} and byte of ${(utf8.encode(_productDiscountController.text.trim()).length)}");
      // print("Title ${_imageBase64String}");
      // print ("every thing ok");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: Opacity(
            opacity: isLoading ? 0.5 : 1.0,
            child: Scaffold(
              appBar: AppBarWithoutLoginWidget(
                title: 'Profile',
                showBackButton: true,
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 24.0,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // <--- Add this line
                            children: [
                              // Image Slider with Favorite Icon and Dots
                              SizedBox(
                                height: 338,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: ImageInput(
                                        onImagesSelected: _onImagesSelected,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Product Info
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildInputField(
                                          controller: _productTitleController,
                                          label: "Product Title",
                                          rule: "required",
                                        ),
                                        const SizedBox(height: 18),
                                        buildDescriptionField(
                                          controller:
                                              _productDescriptionController,
                                          label: "Product Description",
                                        ),
                                        const SizedBox(height: 18),
                                        buildInputField(
                                          controller: _productPriceController,
                                          label: "Product Price",
                                          rule: "number",
                                        ),
                                        const SizedBox(height: 18),
                                        buildInputField(
                                          controller:
                                              _productDiscountController,
                                          label: "Product Discount",
                                          rule: "discount",
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0,
                                            vertical: 18.0,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: _validate,
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 20.0,
                                                ),
                                                backgroundColor:
                                                    AppColors.brown,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                              ),
                                              child: const Text(
                                                'Add to bag',
                                                style: TextStyle(
                                                  color: AppColors.beige,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoading) Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
