import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/features/trips/data/models/trip.model.dart';
import 'package:flutter_workshop/features/trips/view/pages/main/main.screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive
  Hive.registerAdapter(TripModelAdapter());
  Hive.registerAdapter(ForecastAdapter());
  Hive.registerAdapter(ForecastDayAdapter());
  Hive.registerAdapter(DayAdapter());
  Hive.registerAdapter(HourAdapter());

  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox<TripModel>('trips');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
      title: 'Travel App',
      home: const MainScreen(),
    );
  }
}
