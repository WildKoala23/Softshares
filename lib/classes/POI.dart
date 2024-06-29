import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';

class POI extends Publication {
  int _aval;
  String? imgPath;

  POI(
      User user,
      User admin,
      String desc,
      String office,
      String title,
      bool validated,
      String category,
      String subCategory,
      DateTime postDate,
      this._aval,
      this.imgPath)
      : super(user, admin, desc, office, title, validated, category,
            subCategory, postDate);

  int get aval => _aval;

  set aval(int value) {
    _aval = value;
  }
}
