import 'dart:io';

import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/user.dart';

class Publication {
  final API api = API();
  int? _id;
  User _user;
  String _desc, _title;
  bool? validated;
  DateTime _postDate;
  int _subCategory;
  late String subAreaName;
  String? location;
  File? img;
  double? aval, price;

  Publication(
    this._id,
    this._user,
    this._desc,
    this._title,
    this.validated,
    this._subCategory,
    this._postDate,
    this.img,
    this.location,
    this.aval,
    this.price
  );

  User get user => _user;
  String get desc => _desc;
  String get title => _title;
  int get subCategory => _subCategory;
  int get id => _id!;

  DateTime get datePost => _postDate;

  set user(User value) {
    _user = value;
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

  set postDate(DateTime value) {
    _postDate = value;
  }

  Future<void> getSubAreaName() async {
    subAreaName = await api.getSubAreaName(subCategory);
  }
}
