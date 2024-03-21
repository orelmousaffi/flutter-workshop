import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workshop/constants/trip.constants.dart';
import 'package:flutter_workshop/features/trips/screens/addTrip/addTrip.controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddTripScreen extends ConsumerStatefulWidget {
  const AddTripScreen({super.key});

  @override
  ConsumerState<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends ConsumerState<AddTripScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  void handleFieldChange(String fieldName, dynamic newValue) {
    // Create a map to hold the updated fields
    Map<String, dynamic> updatedFields = {};
    // Set the updated field in the map
    updatedFields[fieldName] = newValue;

    // Update the fields in the state using the controller
    ref.read(addTripControllerProvider.notifier).updateFields(updatedFields);
  }

  void handleOnPress() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      var formState = _formKey.currentState;

      if (formState != null) {
        formState.fields.forEach((key, field) {
          var value = field.value;
          print("$key: $value");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> formFields = [
      FormBuilderTextField(
        name: AddTripForm.title.name,
        decoration: InputDecoration(labelText: AddTripForm.title.label),
        validator: FormBuilderValidators.required(),
        onChanged: (String? newValue) {
          handleFieldChange('title', newValue);
        },
      ),
      FormBuilderTextField(
        name: AddTripForm.description.name,
        decoration: InputDecoration(labelText: AddTripForm.description.label),
        validator: FormBuilderValidators.required(),
        onChanged: (String? newValue) {
          handleFieldChange('description', newValue);
        },
      ),
      FormBuilderTextField(
        name: AddTripForm.location.name,
        decoration: InputDecoration(labelText: AddTripForm.location.label),
        validator: FormBuilderValidators.required(),
        onChanged: (String? newValue) {
          handleFieldChange('location', newValue);
        },
      ),
      FormBuilderDateTimePicker(
        name: AddTripForm.date.name,
        decoration: InputDecoration(labelText: AddTripForm.date.label),
        initialDate: DateTime.now().add(const Duration(days: 15)),
        firstDate: DateTime.now().add(const Duration(days: 15)),
        lastDate: DateTime.now().add(const Duration(days: 30)),
        validator: (DateTime? date) {
          if (date == null) {
            return 'Date is required';
          }

          return null;
        },
        onChanged: (DateTime? newValue) {
          handleFieldChange('date', newValue);
        },
      ),
      FormBuilderTextField(
        name: AddTripForm.photoURL.name,
        decoration: InputDecoration(labelText: AddTripForm.photoURL.label),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.url(),
        ]),
        onChanged: (String? newValue) {
          handleFieldChange('photoURL', newValue);
        },
      )
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...formFields,
                const SizedBox(height: 32.0),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: handleOnPress,
                  child: const Text(
                    'Create Trip',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
