import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';

class Forum extends Publication{

  Forum(int? id, User user, User? admin, String desc, String title,
      bool validated, int subCategory, DateTime postDate)
      : super(id, user, admin, desc, title, validated, subCategory, postDate, null, null, null, null);
}

