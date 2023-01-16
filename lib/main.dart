import 'dart:collection';

import 'package:example5/Example6/screen/filmscreen.dart';
import 'package:example5/dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const FilmHomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final person = await createOrUpdatePersonDialog(context);
          if (person != null) {
            final dataModel = ref.read(peopleProvider);
            dataModel.add(person);
          }
        },
        tooltip: 'Add new Person',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text('Example 5')),
      body: Consumer(
        builder: (context, ref, child) {
          final dataModel = ref.watch(peopleProvider);
          return Column(
            children: [
              const Text('Hiiii'),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final person = dataModel.people[index];
                    return ListTile(
                      title: GestureDetector(
                          onTap: () async {
                            final updatedPerson =
                                await createOrUpdatePersonDialog(
                                    context, person);
                            if (updatedPerson != null) {
                              dataModel.update(updatedPerson);
                            }
                          },
                          child: Text(person.displayName)),
                    );
                  },
                  itemCount: dataModel.count,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// This trailing comma makes auto-formatting nicer for build methods.

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Person updated([String? name, int? age]) =>
      Person(name: name ?? this.name, age: age ?? this.age, uuid: uuid);

  String get displayName => '$name ($age years old)';

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name : $name , age: $age, uuid : $uuid)';
}

// List<Person> _person = [];
// void update (Person updatedPerson) {
//   final index = _person.indexOf(updatedPerson);
// }

final peopleProvider = ChangeNotifierProvider((_) => DataModel());

class DataModel extends ChangeNotifier {
  final List<Person> _person = [];
  int get count => _person.length;

  UnmodifiableListView<Person> get people => UnmodifiableListView(_person);

  void add(Person newperson) {
    _person.add(newperson);
    notifyListeners();
  }

  void remove(Person person) {
    _person.remove(person);
    notifyListeners();
  }

  void update(Person updatedPerson) {
    final index = _person.indexOf(updatedPerson);
    final oldPerson = _person[index];

    if (updatedPerson.name != oldPerson.name ||
        updatedPerson.age != oldPerson.age) {
      _person[index] = oldPerson.updated(updatedPerson.name, updatedPerson.age);
      notifyListeners();
    }
  }
}
