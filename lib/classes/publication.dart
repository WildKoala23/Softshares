import 'dart:ffi';
import 'dart:io';

import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/user.dart';

class Publication {
  final API api = API();
  int? _id;
  User _user;
  User? _admin;
  String _desc, _title;
  bool _validated;
  DateTime _postDate;
  int _subCategory;
  int? price;
  late String subAreaName;
  String? location;
  File? img;
  double? aval;

  Publication(
    this._id,
    this._user,
    this._admin,
    this._desc,
    this._title,
    this._validated,
    this._subCategory,
    this._postDate,
    this.img,
    this.location,
    this.aval
  );

  User get user => _user;
  User get admin => _admin!;
  String get desc => _desc;
  String get title => _title;
  int get subCategory => _subCategory;
  int get id => _id!;
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
