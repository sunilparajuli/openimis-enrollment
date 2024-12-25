import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselExample extends StatelessWidget {
  final List<String> images = [
    'https://openimis.org/sites/default/files/styles/news/public/2024-11/_u2k4288.jpg?itok=CdyxDe-x',
    'https://openimis.org/sites/default/files/styles/news/public/2024-06/yolande_goswell-202405_0.jpeg?itok=qK3Tc1fN',
    'https://openimis.org/sites/default/files/styles/news/public/2023-03/1200x627_1_-_kopie.jpg?itok=Xoux5jII',
    'https://openimis.org/sites/default/files/styles/news/public/2022-09/Cameroon-Health%20Insurance.png?itok=w_enq7EH',
  ];

  final CarouselController _controller = CarouselController();

  CarouselExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate 16:9 height based on screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    final double sliderHeight = screenWidth * 9 / 16;

    return CarouselSlider.builder(
      carouselController: _controller,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0), // Smooth corners
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: sliderHeight, // 16:9 aspect ratio
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enableInfiniteScroll: true,
        enlargeCenterPage: false,
        viewportFraction: 1.0, // Full-width slider
        aspectRatio: 16 / 9,
        initialPage: 0,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          debugPrint('Page changed to $index');
        },
      ),
    );
  }
}
