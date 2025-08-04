import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/views/pages/admin_pages/create_product.dart';

class AppBarWithoutLoginWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarWithoutLoginWidget({
    super.key,
    required this.title,
    required this.showBackButton,
  });

  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.lightBeige,
      elevation: 1,
      toolbarHeight: 90,
      automaticallyImplyLeading: showBackButton,
      title: Row(
        children: [
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.charcoal,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePerfumeProduct()),
              );
            },
            icon: Icon(Icons.error_outline, color: AppColors.brown),
          ),
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
