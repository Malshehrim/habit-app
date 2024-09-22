import 'package:flutter/material.dart';
import 'package:habit/components/drawer.dart';
import 'package:habit/components/habit_tile.dart';
import 'package:habit/database/habit_database.dart';
import 'package:habit/models/habit.dart';
import 'package:habit/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabit();
    super.initState();
  }

  //text field controller

  final textFieldController = TextEditingController();
  // create a new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Habit'),
        content: TextField(
          controller: textFieldController,
          decoration: const InputDecoration(
            //  border: InputBorder.none,
            hintText: 'Create a new habit',
          ),
        ),
        actions: [
          // save button

          MaterialButton(
            onPressed: () {
              // get the new habit name
              final String newHabit = textFieldController.text;

              // save to db
              context.read<HabitDatabase>().addHabit(newHabit);
              // pop box
              Navigator.of(context).pop();
              // clear controller
              textFieldController.clear();
            },
            child: const Text('Save'),
          ),

          //cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.of(context).pop();

              // clear controller
              textFieldController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // check habit on or off

  void checkHabitOnOff(bool? value, Habitat habit) {
// update habit complation status

    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

// edit habit box
  void editHabitBox(Habitat habit) {
    // set the contoller's text to the habit's current name
    textFieldController.text == habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textFieldController,
        ),
        actions: [
          // save buton
          MaterialButton(
            onPressed: () {
              String habitName = textFieldController.text;

              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, habitName);

              // pop box
              Navigator.of(context).pop();
              textFieldController.clear();
            },
            child: const Text('Save '),
          ),

          // cancel button

          MaterialButton(
            onPressed: () {
              // pop

              Navigator.of(context).pop();
              textFieldController.clear();
            },
            child: const Text('Cancle'),
          ),
        ],
      ),
    );
  }

//delete habit box

  void deleteHabit(Habitat habit) {
    // delete button
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        actions: [
          // delete button
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              // pop after delete
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),

          //cancel button
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: createNewHabit,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: _buildHabitList(),
    );
  }

  // build habit list
  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits

    List<Habitat> currentHabitList = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabitList.length,
      itemBuilder: (ctx, index) {
        // get indvadual habit
        final habit = currentHabitList[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDayes);

        // return habit tile UI
        return HabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deletHabit: (context) => deleteHabit(habit),
        );
      },
    );
  }
}
