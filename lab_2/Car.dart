class Car {
  String brand;

  // Constructor bình thường
  Car(this.brand);

  // Named constructor
  Car.unknownBrand() : brand = 'Unknown';

  void drive() {
    print(brand + ' is driving.');
  }
}

// Class con kế thừa Car
class ElectricCar extends Car {
  int batteryCapacity;

  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  @override
  void drive() {
    print('$brand is driving with battery at $batteryCapacity%.');
  }
}