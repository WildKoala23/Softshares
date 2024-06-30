class User {
  String _firstname, _lastName, _email;
  String? _profileImg;
  int _id;

  User(this._id, this._firstname, this._lastName, this._email);

  // Getters
  String get firstname => _firstname;
  String get lastName => _lastName;
  String get email => _email;
  String? get profileImg => _profileImg;
  int get id => _id;

  // Setters
  set firstname(String value) {
    _firstname = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  set profileImg(String? value) {
    _profileImg = value;
  }
}

User user1 = User(1, 'John', 'Doe', 'john.doe@example.com');
User user2 = User(2, 'Jane', 'Smith', 'jane.smith@example.com');
User user3 = User(3, 'Emily', 'Johnson', 'emily.johnson@example.com');
User user4 = User(4, 'Michael', 'Brown', 'michael.brown@example.com');
User user5 = User(5, 'Sarah', 'Davis', 'sarah.davis@example.com');
