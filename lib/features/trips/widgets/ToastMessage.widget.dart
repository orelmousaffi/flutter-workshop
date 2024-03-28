import 'package:flutter/material.dart';
import 'package:flutter_workshop/constants/trip.constants.dart';

class ToastMessage extends StatelessWidget {
  final ToastStatus status;
  final String message;

  const ToastMessage({super.key, required this.status, required this.message});

  Color getColorByStatus() {
    switch (status) {
      case ToastStatus.success:
        return Colors.greenAccent;
      case ToastStatus.error:
        return Colors.redAccent;
      case ToastStatus.info:
        return Colors.blueAccent;
    }
  }

  IconData getIconByStatus() {
    switch (status) {
      case ToastStatus.success:
        return Icons.check;
      case ToastStatus.error:
        return Icons.error;
      case ToastStatus.info:
        return Icons.info;
    }
  }

  Widget buildToast() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: getColorByStatus(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(getIconByStatus()),
          const SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildToast();
  }
}
