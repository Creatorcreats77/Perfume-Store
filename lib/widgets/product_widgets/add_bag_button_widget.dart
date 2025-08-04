import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/pages/authenticate_page_firebase/get_phone_number.dart';
import '../../widgets/navigator_widgets/navigator_slide_bottom_widget.dart';
import '../../theme/colors.dart';

class AddBagButtonWidget extends StatefulWidget {
  final String productId;
  final String? icon;
  final VoidCallback? onRemoved;

  const AddBagButtonWidget({Key? key, required this.productId, this.icon, this.onRemoved})
      : super(key: key);

  @override
  State<AddBagButtonWidget> createState() => _AddBagButtonWidgetState();
}

class _AddBagButtonWidgetState extends State<AddBagButtonWidget> {
  bool isBag = false;
  bool isUser = false;
  String id = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('is_logged_in') ?? false;
    final userId = prefs.getString('user_id') ?? '';

    setState(() {
      isUser = loggedIn;
      id = userId;
    });

    _loadBagStatus();
  }

  Future<void> _loadBagStatus() async {
    if (!isUser || id.isEmpty) return;

    final doc = await FirebaseFirestore.instance
        .collection('phoneNumber')
        .doc(id)
        .collection('storeBag')
        .doc(widget.productId)
        .get();

    setState(() {
      isBag = doc.exists;
    });
  }

  Future<void> _toggleBag() async {
    if (!isUser) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Notice"),
          content: const Text("To add items to your bag, please sign up first."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                navigatorSlideBottomWidget(context, const GetPhoneNumber(), 'push');
              },
              child: const Text("Sign up"),
            ),
          ],
        ),
      );
    }

    if (id.isEmpty) return;

    setState(() {
      loading = true;
    });

    final ref = FirebaseFirestore.instance
        .collection('phoneNumber')
        .doc(id)
        .collection('storeBag')
        .doc(widget.productId);

    if (isBag) {
      await ref.delete();
      widget.onRemoved?.call();
    } else {
      await ref.set({'addedBag': true});
    }

    setState(() {
      isBag = !isBag;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.icon == 'icon' ? IconButton(
      onPressed: loading ? null : _toggleBag,
      icon: Icon(Icons.shopping_bag_outlined,
          color: AppColors.amber),
    ):
    ElevatedButton.icon(
      onPressed: loading ? null : _toggleBag,
      icon: Icon(Icons.shopping_bag_outlined,
          color: isBag ? AppColors.amber : Colors.white),
      label: Text(
        isBag ? 'Added to bag' : 'Add to bag',
        style: TextStyle(
          color: isBag ? AppColors.amber : AppColors.beige,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
