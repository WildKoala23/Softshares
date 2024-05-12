class User {
  String _firstname, _lastName, _job, _location, _email;
  String? _profileImg;
  int _day, _month, _year;

  User(this._firstname, this._lastName, this._job, this._location, this._email,
      this._day, this._month, this._year);

  // Getters
  String get firstname => _firstname;
  String get lastName => _lastName;
  String get job => _job;
  String get email => _email;
  String get location => _location;
  String? get profileImg => _profileImg;
  int get year => _year;
  int get month => _month;
  int get day => _day;

  // Setters
  set firstname(String value) {
    _firstname = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  set job(String value) {
    _job = value;
  }

  set location(String value) {
    _location = value;
  }

  set profileImg(String? value) {
    _profileImg = value;
  }

  set day(int value){
     _day = value;
  }

  set month(int value){
     _month = value;
  }

  set year(int value){
     _year = value;
  }
}
