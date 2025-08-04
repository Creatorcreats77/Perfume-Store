import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/views/data/constants.dart';
import 'package:perfume_store/views/pages/authenticate_page_firebase/login_page.dart';
import 'package:perfume_store/views/pages/authenticate_page_firebase/phone_verify_code.dart';
import 'package:perfume_store/widgets/navigator_widgets/navigator_slide_right_widget.dart';

import 'package:uuid/uuid.dart';

import '../../../widgets/navigator_widgets/navigator_scale_fade_widget.dart';

class GetPhoneNumber extends StatefulWidget {
  const GetPhoneNumber({super.key});

  @override
  State<GetPhoneNumber> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<GetPhoneNumber>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _userController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> uploadNumberToDb(String phoneNumber, String userName) async {
    setState(() {
      isLoading = true;
    });
    try {
      final id = Uuid().v4();
      await FirebaseFirestore.instance
          .collection('phoneNumber')
          .doc(id)
          .set({
            "ownerNumber": userName,
            'phoneNumber': "+993$phoneNumber",
            // 'message': '',
            'time': FieldValue.serverTimestamp(),
          })
          .timeout(
            Duration(seconds: 12),
            onTimeout: () {
              throw Exception("Timeout: Firebase took too long.");
            },
          );
      _userController.clear();
      _phoneController.clear();
      navigatorSlideRightWidget(
        context,
        PhoneVerifyCode(phoneNumber: phoneNumber, userName: userName, id: id),
        'push',
      );
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

  Future<void> _register() async {
    final phoneNumber = _phoneController.text.trim();
    final userName = _userController.text.trim();

    uploadNumberToDb(phoneNumber, userName);
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('phone', phoneNumber);
    // await prefs.setInt('code', randomCode);
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      _register();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(''), backgroundColor: AppColors.lightBeige),
      backgroundColor: AppColors.lightBeige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 84),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 10,
                    shadowColor: AppColors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: const Text(
                              'Welcome to\nScentStore',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: const Text(
                              'Please enter your phone number to get verification code',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                buildInputField(
                                  controller: _userController,
                                  label: "Username",
                                  rule: "required",
                                ),
                                const SizedBox(height: 16),
                                buildInputField(
                                  controller: _phoneController,
                                  label: "Phone Number",
                                  rule: "phone",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: !isLoading
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.brown,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: _validate,
                                    child: const Text(
                                      "Get code",
                                      style: TextStyle(
                                        color: AppColors.lightBeige,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                onPressed: () {
                                  navigatorScaleFadeWidget(
                                    context,
                                    LoginPage(),
                                    'push',
                                  );
                                },
                                child: const Text(
                                  "Log in",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
