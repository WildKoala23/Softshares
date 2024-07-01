import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';

class Forum extends Publication{

  Forum(User user, User? admin, String desc, String title,
      bool validated, int subCategory, DateTime postDate)
      : super(user, admin, desc, title, validated, subCategory, postDate);
}

