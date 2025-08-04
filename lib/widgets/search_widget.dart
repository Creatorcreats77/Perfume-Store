import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmit;

  const SearchWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
              onSubmitted: (_) => onSubmit?.call(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
