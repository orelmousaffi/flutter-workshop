import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/constants/trip.constants.dart';
import 'package:flutter_workshop/features/trips/view/pages/addTrip/addTrip.controller.dart';
import 'package:flutter_workshop/features/trips/view/widgets/ToastMessage.widget.dart';
import 'package:flutter_workshop/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddTripScreen extends ConsumerStatefulWidget {
  final Function(int) navigateToPage;

  const AddTripScreen({required this.navigateToPage, super.key});

  @override
  ConsumerState<AddTripScreen> createState() => _addTripFormState();
}

class _addTripFormState extends ConsumerState<AddTripScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final fToast = FToast();
    fToast.init(navigatorKey.currentContext!);

    List<Widget> formFields = [
      FormBuilderTextField(
          name: AddTripForm.TITLE.name,
          decoration: InputDecoration(labelText: AddTripForm.TITLE.label),
          validator: FormBuilderValidators.required(),
          onChanged: ref.read(addTripControllerProvider.notifier).updateTitle),
      FormBuilderTextField(
          name: AddTripForm.DESCRIPTION.name,
          decoration: InputDecoration(labelText: AddTripForm.DESCRIPTION.label),
          validator: FormBuilderValidators.required(),
          onChanged:
              ref.read(addTripControllerProvider.notifier).updateDescription),
      FormBuilderTextField(
          name: AddTripForm.LOCATION.name,
          decoration: InputDecoration(labelText: AddTripForm.LOCATION.label),
          validator: FormBuilderValidators.required(),
          onChanged:
              ref.read(addTripControllerProvider.notifier).updateLocation),
      FormBuilderDateTimePicker(
        name: 'date',
        decoration: const InputDecoration(labelText: 'Date of Trip'),
        onChanged: ref.read(addTripControllerProvider.notifier).updateDate,
        firstDate: DateTime.now().add(const Duration(days: 15)),
        initialDate: DateTime.now().add(const Duration(days: 15)),
        lastDate: DateTime.now().add(const Duration(days: 299)),
        validator: (DateTime? date) {
          if (date == null) {
            return 'Date is required.';
          }

          return null;
        },
      ),
      FormBuilderTextField(
          name: AddTripForm.PHOTO.name,
          decoration: InputDecoration(labelText: AddTripForm.PHOTO.label),
          validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(), FormBuilderValidators.url()]),
          onChanged: ref.read(addTripControllerProvider.notifier).updatePhoto),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
            key: _formKey,
            child: Column(children: [
              ...formFields,
              const SizedBox(height: 10),
              MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final isAdded = await ref
                          .read(addTripControllerProvider.notifier)
                          .addTrip(ref);
                      final toast = ToastMessage(
                          status: (isAdded)
                              ? ToastStatus.success
                              : ToastStatus.error,
                          message: (isAdded)
                              ? TRIP_SUCCESSFULLY_ADDED
                              : ERROR_ADDING_TRIP);

                      fToast.showToast(
                        child: toast,
                        gravity: ToastGravity.BOTTOM,
                        toastDuration: const Duration(seconds: 2),
                      );

                      if (isAdded) {
                        _formKey.currentState?.reset();
                        widget.navigateToPage(TripPages.MY_TRIPS.index);
                      }
                    }
                  },
                  child: const Text(CREATE_TRIP_LABEL,
                      style: TextStyle(color: Colors.white)))
            ])),
      ),
    );
  }
}
