import 'package:softshares/classes/user.dart';

class Publication {
  User _user;
  User? _admin;
  String _desc, _title, _category, _subCategory, _office;
  bool _validated;
  DateTime _postDate;

  Publication(
    this._user,
    this._admin,
    this._desc,
    this._office,
    this._title,
    this._validated,
    this._category,
    this._subCategory,
    this._postDate,);

  User get user => _user;
  User get admin => _admin!;
  String get desc => _desc;
  String get title => _title;
  String get category => _category;
  String get subCategory => _subCategory;
  bool get validated => _validated;
  String get office => _office;
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

  set category(String value) {
    _category = value;
  }

  set subCategory(String value) {
    _subCategory = value;
  }

  set validated(bool value) {
    _validated = value;
  }

  set office(String value) {
    _office = value;
  }

  set postDate(DateTime value) {
    _postDate = value;
  }
}
