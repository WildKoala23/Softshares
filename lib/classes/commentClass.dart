import 'package:softshares/classes/user.dart';

class Comment {
  User user;
  int likes;
  String comment;

  Comment({required this.user, required this.comment, required this.likes});
}
