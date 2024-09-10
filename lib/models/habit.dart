import 'package:isar/isar.dart';

// run: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habitat {
  // habit id
  Id id = Isar.autoIncrement;
  // habit name
  late String name;
  // completed habit

  List<DateTime> completedDayes = [
    //DateTime(year, month, day)
  ];
}
