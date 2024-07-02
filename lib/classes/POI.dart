import 'dart:io';

import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';

class POI extends Publication {
  double _aval;

  POI(User user, User? admin, String desc, String title, bool validated,
      int subCategory, DateTime postDate,  File? imgPath, String? location, this._aval,)
      : super(user, admin, desc, title, validated, subCategory, postDate, imgPath, location);

  double get aval => _aval;

  set aval(double value) {
    _aval = value;
  }
}
