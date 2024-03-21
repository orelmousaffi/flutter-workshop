import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/features/trips/view/pages/addTrip/addTrip.screen.dart';
import 'package:flutter_workshop/features/trips/view/pages/myTrips/myTrips.screen.dart';
import 'package:flutter_workshop/features/trips/view/providers/trip.provider.dart';
import 'package:flutter_workshop/constants/trip.constants.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  String _pageTitle = TripPages.MY_TRIPS.label;

  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage =
      ValueNotifier<int>(TripPages.MY_TRIPS.index);

  @override
  Widget build(BuildContext context) {
    ref.watch(tripNotifierProvider.notifier).loadTrips();

    _pageController.addListener(() {
      _currentPage.value = _pageController.page!.round();
    });

    List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(
          icon: const Icon(Icons.list), label: TripPages.MY_TRIPS.label),
      BottomNavigationBarItem(
          icon: const Icon(Icons.add), label: TripPages.ADD_TRIPS.label),
    ];

    void navigateToPage(int pageIndex) {
      _pageController.jumpToPage(pageIndex);

      setState(() {
        String pageTitle = bottomNavItems[_currentPage.value].label ?? '';
        _pageTitle = pageTitle;
      });
    }

    List<Widget> pages = [
      const MyTripsScreen(),
      AddTripScreen(navigateToPage: navigateToPage)
    ];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Column(children: [
            Text(
              _pageTitle,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ]),
        ),
        body: PageView(controller: _pageController, children: pages),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: _currentPage,
            builder: (context, index, child) {
              return BottomNavigationBar(
                currentIndex: index,
                items: bottomNavItems,
                onTap: navigateToPage,
              );
            }));
  }
}
