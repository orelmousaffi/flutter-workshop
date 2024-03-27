import 'package:flutter/material.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:intl/intl.dart';

class TravelCard extends StatelessWidget {
  final Trip trip;

  const TravelCard({super.key, required this.trip});

  Card buildCard() {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              trip.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(trip.location),
          ),
          SizedBox(
            width: double.infinity,
            child: Image.network(
              trip.photo,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Oops, failed to load image',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(trip.description),
          ),
          GridView.count(
            primary: false,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 5,
            shrinkWrap: true,
            children: trip.forecast?.forecastDay.first.hours
                    .where((element) => element.time.hour % 3 == 0)
                    .map(
                      (hour) => Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        color: Colors.teal[100],
                        child: Text(
                            '${DateFormat('h a').format(hour.time)}\n${hour.temp_f}F'),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [buildCard()]),
      ),
    );
  }
}
