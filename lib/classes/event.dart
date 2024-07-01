import '../classes/user.dart';
import '../classes/publication.dart';

class Event extends Publication {
  DateTime eventDate;
  bool recurring;

  Event(
      User user,
      User? admin,
      String desc,
      String title,
      bool validated,
      int subCategory,
      DateTime postDate,
      String? imgPath,
      String? location,
      this.eventDate,
      this.recurring)
      : super(user, admin, desc, title, validated, subCategory, postDate, imgPath, location);
}
