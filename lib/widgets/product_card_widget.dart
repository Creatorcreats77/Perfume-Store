import 'package:flutter/material.dart';
import 'package:perfume_store/theme/colors.dart';

class ProductCardWidget extends StatefulWidget {
  final List<String> imageUrls;
  final String name;
  final double price;
  final double? oldPrice;
  final double rating;

  const ProductCardWidget({
    super.key,
    required this.imageUrls,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.rating,
  });

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  late final PageController _pageController;
  static const int _initialPage = 1000;
  int _currentPage = _initialPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final imageCount = widget.imageUrls.length;
  final int activeIndex = _currentPage % imageCount;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 8,
    child: Column(
      // mainAxisSize: MainAxisSize.min, // <--- Add this line
      children: [
        // Image Slider with Favorite Icon and Dots
        SizedBox(
          height: 148,
          width: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final actualIndex = index % imageCount;
                    return ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.asset(
                        widget.imageUrls[actualIndex],
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.favorite_border, color: AppColors.brown),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(imageCount, (index) {
                    final isActive = index == activeIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 10 : 6,
                      height: isActive ? 10 : 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.amber
                            : AppColors.charcoalLight.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),

        // Product Info
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.price.toStringAsFixed(2)} tmt',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if(widget.oldPrice != null && widget.oldPrice != 0) Text(
                      widget.oldPrice!.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                  
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(widget.rating.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add to bag', style: TextStyle(color: AppColors.lightBeige),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}