import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/features/trips/providers/trip.provider.dart';

class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Trip> trips = ref.watch(tripNotifierProvider);

    Widget itemBuilder(BuildContext context, int index) {
      final trip = trips[index];

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          direction: Axis.vertical,
          spacing: 5,
          children: [
            Image(
              image: NetworkImage(trip.photo),
              width: MediaQuery.of(context).size.width - 32,
            ),
            const Text(
              'Title:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(trip.title),
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(trip.description),
            const Text(
              'Location:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(trip.location),
            const Text(
              'Trip Date:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(trip.date.toString()),
          ],
        ),
      );
    }

    if (trips.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No trips found"),
        ),
      );
    }

    return ListView.builder(
      itemBuilder: itemBuilder,
      itemCount: trips.length,
    );
  }
}
