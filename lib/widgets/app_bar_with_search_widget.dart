import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/widgets/search_widget.dart';

class AppBarWithSearchWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSearch;
  final bool hideTitle;
  final TextEditingController? searchController;
  final ValueChanged<String>? onChanged;

  const AppBarWithSearchWidget({
    super.key,
    required this.title,
    required this.showBackButton,
    this.showSearch = false,
    this.hideTitle = false,
    this.searchController,
    this.onChanged,
  });

  @override
  State<AppBarWithSearchWidget> createState() => _AppBarWithSearchWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(146);
}

class _AppBarWithSearchWidgetState extends State<AppBarWithSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(146),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
        ),
        decoration: const BoxDecoration(
          color: AppColors.lightBeige,
          border: Border(
            bottom: BorderSide(color: AppColors.brown, width: 1.0),
          ),
        ),
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: widget.hideTitle ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 600),
              child: !widget.hideTitle
                  ? Row(
                children: [
                  if (widget.showBackButton)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                    ),
                  ),
                ],
              )
                  : null,
            ),
            AnimatedOpacity(
              opacity: widget.hideTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: widget.hideTitle && widget.searchController != null && widget.onChanged != null
                  ? SearchWidget(
                controller: widget.searchController!,
                onChanged: widget.onChanged!,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
