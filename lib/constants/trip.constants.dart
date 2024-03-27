import 'package:flutter/material.dart';
import 'package:flutter_workshop/features/trips/screens/addTrip/addTrip.screen.dart';
import 'package:flutter_workshop/features/trips/screens/myTrips/myTrips.screen.dart';

enum TripPage {
  myTrips('My Trips', Icons.list),
  addTrips('Add Trip', Icons.add);

  final String label;
  final IconData icon;

  const TripPage(this.label, this.icon);

  BottomNavigationBarItem getBottomNavigationBarItem() {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  Widget getScreen() {
    switch (this) {
      case myTrips:
        return const MyTripsScreen();
      case addTrips:
        return AddTripScreen();
    }
  }
}

enum AddTripForm {
  title('title', 'Title'),
  description('description', 'Description'),
  location('location', 'Location'),
  date('date', 'Trip Date'),
  photoURL('photo_url', 'Photo URL');

  final String name;
  final String label;

  const AddTripForm(this.name, this.label);
}
