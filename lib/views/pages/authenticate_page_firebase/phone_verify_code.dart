import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/views/data/constants.dart';
import 'package:perfume_store/views/pages/authenticate_page_firebase/login_page.dart';
import 'package:perfume_store/views/widget_tree.dart';
import 'package:perfume_store/widgets/navigator_widgets/navigator_blur_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../../widgets/navigator_widgets/navigator_3d_flip_widget.dart';
import '../../../widgets/navigator_widgets/navigator_scale_fade_widget.dart';

class PhoneVerifyCode extends StatefulWidget {
  const PhoneVerifyCode({
    super.key,
    required this.userName,
    required this.phoneNumber,
    required this.id,
  });

  final String userName;
  final String phoneNumber;
  final String id;

  @override
  State<PhoneVerifyCode> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<PhoneVerifyCode>
    with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  StreamSubscription<DocumentSnapshot>? _subscription;
  bool isLoading = false;
  bool messageFirebase = false;
  bool checkTime = true;
  bool checkTime2 = false;
  bool resendOne = false;
  bool navigateOne = false;
  Timer? _timer;
  int _remainingSeconds = 59;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void compareCodes() {
    _subscription?.cancel(); // Cancel previous if any

    _subscription = FirebaseFirestore.instance
        .collection('phoneNumber')
        .doc(widget.id)
        .snapshots()
        .distinct(
          (prev, next) => prev.data()?['message'] == next.data()?['message'],
        )
        .listen((snapshot) {
          if (!mounted) return;
          final data = snapshot.data();
          final message = data?['message'];
          print("message: $message");

          if (message == 'success' && !navigateOne) {
            navigateOne = true;
            navigate();
          } else if (message == 'failed' && !resendOne) {
            resendOne = true;
            showErrorSnackBar(context, 'Invalid code!', 'red');
          }
          setState(() {
            isLoading = false;
          });
        });
  }

  Future<void> addCodeToDb(String code, String id) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('phoneNumber')
          .doc(id)
          .update({"code": code, 'time': FieldValue.serverTimestamp()})
          .timeout(
            Duration(seconds: 12),
            onTimeout: () {
              showErrorSnackBar(
                context,
                'Firebase took so long try again',
                'red',
              );
              throw Exception("Timeout: Firebase took so long.");
            },
          );
      await Future.delayed(Duration(seconds: 8));
      compareCodes();
      print("wewewewewe");
    } on FirebaseException catch (e) {
      showErrorSnackBar(context, "Firebase error: ${e.message}", 'red');
    } finally {}
  }

  Future<void> _register(String id) async {
    String code = _codeController.text.trim();
    addCodeToDb(code, id);
  }

  void _validate(String id) {
    if (_formKey.currentState!.validate()) {
      _register(id);
    }
  }

  void navigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('username', '${widget.userName}');
    await prefs.setString('user_id', '${widget.id}');
    await prefs.setString('phoneNumber', '${widget.phoneNumber}');
    navigatorBlurWidget(context, WidgetTree(), 'pushReplacement');
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 50) {
        checkTime2 = true;
      }
      if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() {
          checkTime = false;
          checkTime2 = false;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  Future<void> uploadNumberToDb(
    String id,
    String userName,
    String phoneNumber,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('phoneNumber')
          .doc(id)
          .set({
            "ownerNumber": userName,
            'phoneNumber': "+993$phoneNumber",
            'resend': 'true',
            'time': FieldValue.serverTimestamp(),
          })
          .timeout(
            Duration(seconds: 12),
            onTimeout: () {
              throw Exception("Timeout: Firebase took too long.");
            },
          );
    } on FirebaseException catch (e) {
      showErrorSnackBar(context, '${e.message}', 'red');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resenCode(String id, String userName, String phoneNumber) async {
    setState(() {
      _remainingSeconds = 59;
      checkTime = true;
      resendOne = true;
    });
    _startCountdown();
    await uploadNumberToDb(id, userName, phoneNumber);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(''), backgroundColor: AppColors.lightBeige),
      backgroundColor: AppColors.lightBeige,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 84.0,
              horizontal: 24.0,
            ),
            child: Card(
              elevation: 10,
              shadowColor: AppColors.brown,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '0:${_remainingSeconds.toString()}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'We sent verification code to this \n +993 ${widget.phoneNumber} number',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildInputField(
                            controller: _codeController,
                            label: "Write code that you received",
                            rule: "code",
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

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
                              onPressed: () {
                                checkTime
                                    ? _validate(widget.id)
                                    : _resenCode(
                                        widget.id,
                                        widget.userName,
                                        widget.phoneNumber,
                                      );
                              },
                              child: Text(
                                checkTime ? "Verify Code" : 'Resend Code',
                                style: TextStyle(
                                  color: AppColors.lightBeige,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),

                    checkTime2
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                _resenCode(
                                  widget.id,
                                  widget.userName,
                                  widget.phoneNumber,
                                );
                              },
                              child: Text('Resend Code'),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 12),

                    /// Already have an account?
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
      ),
    );
  }
}
