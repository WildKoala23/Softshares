import 'package:softshares/classes/user.dart';

class Publication {
  User _user, _admin;
  String _desc, _title;
  bool _validated;
  int _office;

  Publication(this._user, this._admin, this._desc, this._office, this._title,
      this._validated);
  
  
}
