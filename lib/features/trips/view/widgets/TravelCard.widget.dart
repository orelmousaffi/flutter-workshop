import 'package:flutter/material.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:intl/intl.dart';

class TravelCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onDeleteHandler;

  const TravelCard(
      {super.key, required this.trip, required this.onDeleteHandler});

  Card buildCard() {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              title: Text(
                trip.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(trip.location),
              trailing: IconButton(
                onPressed: onDeleteHandler,
                icon: const Icon(Icons.delete,
                    color: Color.fromRGBO(186, 0, 13, 1.0)),
              )
              //
              ),
          SizedBox(
            width: double.infinity,
            child: Image.network(
              trip.photos[0],
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Text(
                  'Weather Info',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                    "High Temp: ${trip.forecast?.forecastDay.first.day.maxtemp_f}F"),
                Text(
                    "Low Temp: ${trip.forecast?.forecastDay.first.day.mintemp_f}F"),
              ],
            ),
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
