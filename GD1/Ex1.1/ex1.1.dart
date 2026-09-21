import 'Vehicle.dart';

void main() {
  Car toyota = Car('Toyota', 2020, false);
  toyota.startEngine();
  Car myTesla = Car.tesla(2024);
  myTesla.startEngine();
}