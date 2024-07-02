import 'dart:io';

import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/user.dart';

class Publication {
  final API api = API();
  User _user;
  User? _admin;
  String _desc, _title;
  bool _validated;
  DateTime _postDate;
  int _subCategory;
  late String subAreaName;
  String? location;
  File? img;

  Publication(this._user, this._admin, this._desc, this._title, this._validated,
      this._subCategory, this._postDate, this.img, this.location);

  User get user => _user;
  User get admin => _admin!;
  String get desc => _desc;
  String get title => _title;
  int get subCategory => _subCategory;
  bool get validated => _validated;

  DateTime get datePost => _postDate;

  set user(User value) {
    _user = value;
  }

  set admin(User value) {
    _admin = value;
  }

  set desc(String value) {
    _desc = value;
  }

  set title(String value) {
    _title = value;
  }

  set subCategory(int value) {
    _subCategory = value;
  }

  set validated(bool value) {
    _validated = value;
  }

  set postDate(DateTime value) {
    _postDate = value;
  }

  Future<void> getSubAreaName() async {
    subAreaName = await api.getSubAreaName(subCategory);
  }
}
