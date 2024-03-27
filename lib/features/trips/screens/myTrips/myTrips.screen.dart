import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/features/trips/providers/trip.provider.dart';

import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/features/trips/widgets/TravelCard.widget.dart';

class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripList = ref.watch(tripNotifierProvider);

    Widget itemBuilder(BuildContext context, int index) {
      Trip trip = tripList[index];
      return TravelCard(trip: trip);
    }

    if (tripList.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(16.0), child: Text('No trips found')));
    }

    return ListView.builder(
        itemCount: tripList.length, itemBuilder: itemBuilder);
  }
}
