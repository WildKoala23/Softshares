class User {
  String _firstname, _lastName, _job, _location, _email;
  String? _profileImg;
  DateTime _birthday;
  bool _isAdmin;

  User(this._firstname, this._lastName, this._job, this._location, this._email,
      this._birthday, this._isAdmin);

  // Getters
  String get firstname => _firstname;
  String get lastName => _lastName;
  String get job => _job;
  String get email => _email;
  String get location => _location;
  String? get profileImg => _profileImg;
  DateTime get birthday => _birthday;

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

  set birthday(DateTime value) {
    _birthday = value;
  }
}

User user1 = User('John', 'Doe', 'Software Engineer', 'San Francisco, CA',
    'john.doe@example.com', DateTime(1990, 5, 15), false);
User user2 = User('Jane', 'Smith', 'Product Manager', 'New York, NY',
    'jane.smith@example.com', DateTime(1985, 8, 25), true);
User user3 = User('Emily', 'Johnson', 'Designer', 'Los Angeles, CA',
    'emily.johnson@example.com', DateTime(1992, 11, 30), false);
User user4 = User('Michael', 'Brown', 'Data Scientist', 'Chicago, IL',
    'michael.brown@example.com', DateTime(1988, 3, 10), true);
User user5 = User('Sarah', 'Davis', 'Marketing Specialist', 'Boston, MA',
    'sarah.davis@example.com', DateTime(1995, 1, 5), false);
