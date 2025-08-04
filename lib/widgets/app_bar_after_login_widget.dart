import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';

class AppBarAfterLoginWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarAfterLoginWidget({super.key, required this.title, required this.showBackButton});


  final String title;
  final bool showBackButton;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      toolbarHeight: 90,
      automaticallyImplyLeading: showBackButton,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20, // optional
            child: Icon(Icons.person, color: Colors.brown, size: 24),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to our shop ✨",
                style: TextStyle(fontSize: 14, color: Colors.brown),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.notifications_none, color: AppColors.brown),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          color: AppColors.lightBeige, // Line color
          height: 1, // Line thickness
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
