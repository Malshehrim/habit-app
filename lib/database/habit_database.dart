import 'package:flutter/material.dart';
import 'package:habit/models/app_settings.dart';
import 'package:habit/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;
//  SET UP

// I N T I L A I Z   D A T A B A Z
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([HabitatSchema, AppSettingsSchema],
        directory: dir.path);
  }

// Save first app lunche
  static Future<void> saveFirstAppLunched() async {
    final existingSettings = await isar.appSettings.where().findAll();
    if (existingSettings.isEmpty) {
      final settings = AppSettings()..firstLunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }
// get first app lunche

  Future<DateTime?> getFirstAppLunched() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLunchDate;
  }

  // List of habits

  final List<Habitat> currentHabits = [];

  // create a habit
  Future<void> addHabit(String habitName) async {
    // crete a new habit
    final newHabit = Habitat()..name = habitName;

    // sabe to db
    await isar.writeTxn(() => isar.habitats.put(newHabit));

    // re-read form db

    readHabit();
  }

  // read a habit
  Future<void> readHabit() async {
    // fetch all habits from db
    List<Habitat> fetchedHabits = await isar.habitats.where().findAll();

    //give to curren habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    //fetchedHabits.addAll(currentHabits);

    // Update Ui
    notifyListeners();
  }
  // upeate -  a habit on or off

  Future<void> upeateHabitCompletion(int id, bool isCompleted) async {
    // fined the specific habit

    final habit = await isar.habitats.get(id);

    // update complation status
    if (habit != null) {
      await isar.writeTxn(
        () async {
          // if habit is completed -> add the current data to copleatDay list

          if (isCompleted && !habit.completedDayes.contains(DateTime.now())) {
            // today

            final today = DateTime.now();

            //add the current data to copleatDay list if it is already in copleatDay list
            habit.completedDayes.add(
              DateTime(
                today.year,
                today.month,
                today.day,
              ),
            );

            // if habit is not completed remove the current data from copleatDay list
          } else {
            habit.completedDayes.removeWhere(
              (date) =>
                  date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day,
            );
          }
        },
      );
      // save the updated habit to db
      await isar.habitats.put(habit);
    }

    // re-read form db
    readHabit();
  }

  // upeate a habit- name

  Future<void> updateHabitName(int id, String newName) async {
    // fine specific habit

    final habit = await isar.habitats.get(id);

    // update habit name
    if (habit != null) {
      //update name
      await isar.writeTxn(
        () async {
          //   Habitat().name = newName;
          habit.name = newName;

          // save updated habit name back to database
          await isar.habitats.put(habit);
        },
      );
    }
    // re-read form db
    readHabit();
  }

// update -check habit on and off

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // fined the specific habit
    final habit = await isar.habitats.get(id);

    if (habit != null) {
      await isar.writeTxn(
        () async {
          // if habit completed -> add the current date to the completedDays list

          if (isCompleted && !habit.completedDayes.contains(DateTime.now())) {
            // today
            final today = DateTime.now();
            // add the current date to the list if it is not already in the list
            habit.completedDayes.add(
              DateTime(
                today.year,
                today.month,
                today.day,
              ),
            );
          } else {
            // if habit in Not completed, remove the current date from the list

            // remove the current date from the list if the habit is marked as completed

            habit.completedDayes.removeWhere(
              (date) =>
                  date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day,
            );
          }
          // save the updated habit back to database
          await isar.habitats.put(habit);
        },
      );
    }
    // update complation status

    // re-read from db
    readHabit();
  }

  // delete a habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(
      () async {
        isar.habitats.delete(id);
      },
    );
    //re-read form db
    readHabit();
  }
}
