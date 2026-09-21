import 'Employee.dart';

void main() {
  List<Developer> teamA = [Developer("An"), Developer("Bình")];
  List<Developer> teamB = [Developer("Cường")];

  List<Developer> allStaff = [...teamA, ...teamB];

  for (var dev in allStaff) {
    dev.checkIn();
  }
}