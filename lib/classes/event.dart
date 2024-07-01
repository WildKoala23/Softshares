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
    String title,
    bool validated,
    int subCategory,
    DateTime postDate,
    this.eventDate,
    this.imgPath, 
    String this.eventLocation,
    this.recurring 
  ) : super(user, admin, desc, title, validated, subCategory, postDate);

}
