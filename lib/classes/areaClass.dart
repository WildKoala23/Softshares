import 'package:flutter/material.dart';

class AreaClass {
  String areaName;
  IconData? icon;
  int id;
  List<AreaClass>? subareas;

  AreaClass({required this.id, required this.areaName, this.icon,  this.subareas});
}
