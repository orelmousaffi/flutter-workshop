import 'package:flutter/material.dart';
import 'package:flutter_workshop/constants/trip.constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TripPage _currentPage = TripPage.values[0];

  final _bottomNavItems =
      TripPage.values.map((e) => e.getBottomNavigationBarItem()).toList();
  final _pages = TripPage.values.map((e) => e.getScreen()).toList();

  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = TripPage.values[_pageController.page!.round()];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          _currentPage.label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: PageView(controller: _pageController, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage.index,
        items: _bottomNavItems,
        onTap: (pageIndex) {
          setState(() {
            _pageController.jumpToPage(pageIndex);
            _currentPage = TripPage.values[pageIndex];
          });
        },
      ),
    );
  }
}
