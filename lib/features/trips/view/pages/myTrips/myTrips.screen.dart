import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/constants/trip.constants.dart';
import 'package:flutter_workshop/features/trips/domain/entities/trip.entity.dart';
import 'package:flutter_workshop/features/trips/view/providers/trip.provider.dart';
import 'package:flutter_workshop/features/trips/view/widgets/ToastMessage.widget.dart';
import 'package:flutter_workshop/features/trips/view/widgets/TravelCard.widget.dart';
import 'package:flutter_workshop/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripList = ref.watch(tripNotifierProvider);
    final FToast fToast = FToast();
    fToast.init(navigatorKey.currentContext!);

    Future<void> onDelete(int index) async {
      final bool isDeleted =
          await ref.read(tripNotifierProvider.notifier).removeTrip(index);

      final toast = ToastMessage(
          status: (isDeleted) ? ToastStatus.success : ToastStatus.error,
          message:
              (isDeleted) ? TRIP_SUCCESSFULLY_DELETED : ERROR_DELETING_TRIP);

      fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    }

    Widget itemBuilder(BuildContext context, int index) {
      final Trip trip = tripList[index];
      return TravelCard(
          trip: trip,
          onDeleteHandler: () {
            onDelete(index);
          });
    }

    if (tripList.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(16.0), child: Text(NO_TRIP_FOUND)));
    }

    return ListView.builder(
        itemCount: tripList.length, itemBuilder: itemBuilder);
  }
}
