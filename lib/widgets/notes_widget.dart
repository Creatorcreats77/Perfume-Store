import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';

class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  State<NotesWidget> createState() => _BrandsWidgetState();
}

class _BrandsWidgetState extends State<NotesWidget> {
  final List<String> images = [
    'assets/images/notes/pine.png',
    'assets/images/notes/fig.webp',
    'assets/images/notes/eucalyptus.png',
    'assets/images/notes/frangipini.webp',
    'assets/images/notes/orris.png',
    'assets/images/notes/strawberry.png',
  ];

  final List<String> titles = [
    'pine',
    'fig',
    'eucalyptus',
    'frangipini',
    'orris',
    'strawberry',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
  height: 100, // increased to fit image + text
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: images.length,
    separatorBuilder: (_, __) => const SizedBox(width: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          // Your onTap logic here
        },
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.beige,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                titles[index],
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    },
  ),
);

  }
}
