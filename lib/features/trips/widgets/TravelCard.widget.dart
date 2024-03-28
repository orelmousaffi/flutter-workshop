import 'package:flutter/material.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';

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
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(trip.location),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete,
                    color: Color.fromRGBO(186, 0, 13, 1.0)),
              )),
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
