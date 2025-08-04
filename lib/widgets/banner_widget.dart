import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({
    super.key,
    required this.message,
    required this.imageAssetPath,
    this.onClose,
  });

  final String message;
  final String imageAssetPath; // 👈 Local asset image
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 248,
        margin: const EdgeInsets.symmetric(horizontal: 16),

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageAssetPath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                    0.3,
                  ), // overlay for text readability
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
