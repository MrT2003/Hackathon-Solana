import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  final List<String> banners;
  const BannerCarousel({Key? key, required this.banners}) : super(key: key);

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentBanner = 0;
  late final PageController _bannerController;

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: (banners.isEmpty)
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                )
              : PageView.builder(
                  controller: _bannerController,
                  itemCount: banners.length,
                  padEnds: false,
                  onPageChanged: (index) {
                    setState(() {
                      _currentBanner = index;
                    });
                  },
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(banners[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        if (banners.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentBanner == index
                      ? Colors.grey[700]
                      : Colors.grey[400],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
