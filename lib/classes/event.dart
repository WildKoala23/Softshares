import 'dart:io';

import '../classes/user.dart';
import '../classes/publication.dart';

class Event extends Publication {
  DateTime eventDate;
  bool recurring;
  Event(
      int? id,
      User user,
      User? admin,
      String desc,
      String title,
      bool validated,
      int subCategory,
      DateTime postDate,
      File? imgPath,
      String? location,
      this.eventDate,
      this.recurring)
      : super(id, user, admin, desc, title, validated, subCategory, postDate,
            imgPath, location);
}
