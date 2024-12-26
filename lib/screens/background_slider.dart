import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Separate widget to handle the sliding background
class BackgroundSlider extends StatefulWidget {
  const BackgroundSlider({Key? key}) : super(key: key);

  @override
  State<BackgroundSlider> createState() => _BackgroundSliderState();
}

class _BackgroundSliderState extends State<BackgroundSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> imageList = [
    'assets/slider/slider1.jpg',
    'assets/slider/slider2.jpg',
    'assets/slider/slider3.jpg',
    'assets/slider/slider4.jpg',
    'assets/slider/slider5.jpg',
    'assets/slider/slider6.jpg',
    'assets/slider/slider7.jpg',
    'assets/slider/slider8.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < imageList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
      },
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        return Image.asset(
          imageList[index],
          fit: BoxFit.cover,
        );
      },
    );
  }
}
