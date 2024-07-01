import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';

class POI extends Publication {
  int _aval;

  POI(User user, User? admin, String desc, String title, bool validated,
      int subCategory, DateTime postDate,  String? imgPath, String? location, this._aval,)
      : super(user, admin, desc, title, validated, subCategory, postDate, imgPath, location);

  int get aval => _aval;

  set aval(int value) {
    _aval = value;
  }
}
