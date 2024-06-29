import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';

class Forum extends Publication{

  Forum(User user, User admin, String desc, int office, String title,
      bool validated, String category, String subCategory, DateTime postDate)
      : super(user, admin, desc, office, title, validated, category, subCategory, postDate);
}

