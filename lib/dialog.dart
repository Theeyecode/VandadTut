import 'package:example5/main.dart';
import 'package:flutter/material.dart';

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(BuildContext context,
    [Person? existingPerson]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  nameController.text = name ?? '';
  ageController.text = age?.toString() ?? '';
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Create a person'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter name here...',
                  ),
                  onChanged: ((value) => name = value),
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Enter age here...',
                  ),
                  onChanged: ((value) => age = int.tryParse(value)),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    if (name != null && age != null) {
                      if (existingPerson != null) {
                        final newPerson = existingPerson.updated(
                          name,
                          age,
                        );
                        Navigator.of(context).pop(newPerson);
                      } else {
                        Navigator.of(context)
                            .pop(Person(name: name!, age: age!));
                      }
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save')),
            ],
          ));
}
