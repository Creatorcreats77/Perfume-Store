import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/pages/authenticate_page_firebase/get_phone_number.dart';
import '../navigator_widgets/navigator_slide_bottom_widget.dart';

class FavoriteButtonWidget extends StatefulWidget {
  final String productId;
  final VoidCallback? onRemoved;


  const FavoriteButtonWidget({Key? key, required this.productId, this.onRemoved}) : super(key: key);

  @override
  State<FavoriteButtonWidget> createState() => _FavoriteButtonWidgetState();
}

class _FavoriteButtonWidgetState extends State<FavoriteButtonWidget>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  bool isUser = false;
  String id = '';
  bool loading = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true); // Loop back and forth

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('is_logged_in') ?? false;
    final userId = prefs.getString('user_id') ?? '';
    if (mounted) {
      setState(() {
        isUser = loggedIn;
        id = userId;
      });
    }

    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    if (!isUser || id.isEmpty) return;

    final doc = await FirebaseFirestore.instance
        .collection('phoneNumber')
        .doc(id)
        .collection('favorites')
        .doc(widget.productId)
        .get();
if(mounted){
  setState(() {
    isFavorite = doc.exists;
  });
}

  }

  Future<void> _toggleFavorite() async {
    if (!isUser) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Notice"),
            content: Text("If you want to add it to your favorites you need to sign up first!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  navigatorSlideBottomWidget(
                    context,
                    GetPhoneNumber(),
                    'push',
                  );
                },
                child: Text("Sign up"),
              ),
            ],
          );
        },
      );
    }

    if (id.isEmpty) return; // ✅ Prevent Firestore crash

    setState(() {
      loading = true;
    });

    final ref = FirebaseFirestore.instance
        .collection('phoneNumber')
        .doc(id)
        .collection('favorites')
        .doc(widget.productId);

    if (isFavorite) {
      await ref.delete();
      widget.onRemoved?.call();

    } else {
      await ref.set({'favorited': true});
    }

    if (mounted) {
      setState(() {
        isFavorite = !isFavorite;
        loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: loading ? _scaleAnimation.value : 1.0,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : AppColors.brown,
              size: 24,
            ),
          );
        },
      ),
    );
  }
}
