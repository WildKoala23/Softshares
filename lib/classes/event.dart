import '../classes/user.dart';
import '../classes/publication.dart';

class Event extends Publication {
  DateTime eventDate;
  String? eventLocation, imgPath;
  bool recurring;

  Event(
    User user,
    User? admin,
    String desc,
    String office,
    String title,
    bool validated,
    String category,
    String subCategory,
    DateTime postDate,
    this.eventDate,
    this.imgPath, 
    String this.eventLocation,
    this.recurring 
  ) : super(user, admin, desc, office, title, validated, category, subCategory, postDate);

}
