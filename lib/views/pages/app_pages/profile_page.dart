import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:perfume_store/main.dart';
import 'package:perfume_store/views/pages/app_pages/home_page.dart';
import 'package:perfume_store/views/pages/authenticate_page_firebase/get_phone_number.dart';
import 'package:perfume_store/views/widget_tree.dart';
import 'package:perfume_store/widgets/navigator_widgets/navigator_blur_widget.dart';
import 'package:perfume_store/widgets/navigator_widgets/navigator_scale_fade_widget.dart';
import 'package:perfume_store/widgets/navigator_widgets/navigator_simple_widget.dart';
import 'package:perfume_store/widgets/navigator_widgets/navigator_slide_bonus_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/colors.dart';
import '../../../widgets/app_bar_after_login_widget.dart';
import '../../../widgets/app_bar_without_login_widget.dart';
import '../../../widgets/navigator_widgets/navigator_slide_bottom_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isUser = false;
  String userName = '';
  String phoneNumber = '';
  String id = '';
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('is_logged_in') ?? false;
    final name = prefs.getString('username') ?? '';
    final userPhoneNumber = prefs.getString('phoneNumber') ?? '';
    final UserId = prefs.getString('user_id') ?? '';

    setState(() {
      isUser = loggedIn;
      userName = name;
      phoneNumber = userPhoneNumber;
      id = UserId;
    });
  }

  void deleteAccount() async {
    if (!mounted) return;
    setState(() {
      isDeleting = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('username');
    await prefs.remove('user_id');
    await prefs.remove('phoneNumber');
    await prefs.clear();
    await prefs.setBool('checkOnBoarding', true);
    await FirebaseFirestore.instance.collection('phoneNumber').doc(id).delete();

    if (!mounted) return;
    navigatorScaleFadeWidget(context, MyApp(), 'pushReplacement');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isUser
          ? AppBarAfterLoginWidget(title: userName, showBackButton: false)
          : const AppBarWithoutLoginWidget(
              title: 'Sign Up',
              showBackButton: false,
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
          child: !isUser
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Center(
                      child: Lottie.asset('assets/lotties/hello_sign_up.json'),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        navigatorSlideBottomWidget(
                          context,
                          GetPhoneNumber(),
                          'push',
                        );
                      },
                      child: Text(
                        'Sign Up Now!',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.brown,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                )
              : Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(text: 'Hi '),
                          TextSpan(
                            text: '$userName! ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'We are glad to see you in Our PerfumeStore. You can find here any kind of perfumes that you need. Stay with us and enjoy ordering!',
                          ),
                          TextSpan(text: '\nThis PerfumeStore is made by'),
                          TextSpan(
                            text: ' Creator. ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '\nIt is his first flutter project.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    isDeleting
                        ? Center(
                            child: Lottie.asset('assets/lotties/Fire.json'),
                          )
                        : Center(
                            child: Lottie.asset(
                              'assets/lotties/shake_hand.json',
                            ),
                          ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: isDeleting ? null : deleteAccount,

                      child: Text(
                        'Delete account!',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.red,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
        ),
      ),
    );
  }
}
