class Vehicle {
  String brand;
  int year;
  Vehicle(this.brand, this.year);

  void startEngine() {
    print('Khởi động phương tiện...');
  }
}

class Car extends Vehicle {
  bool isElectric;

  Car(String brand, int year, this.isElectric) : super(brand, year);

  Car.tesla(int year)
      : isElectric = true,
        super('Tesla', year);

  @override
  void startEngine() {
    if (isElectric) {
      print('$brand ($year): Động cơ điện khởi động êm ái... Vroom (không tiếng ồn)!');
    } else {
      print('$brand ($year): Động cơ xăng nổ máy... Brum brum!');
    }
  }
}
