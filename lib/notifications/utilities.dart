import 'package:flutter/material.dart';

int ctreateUniqueId(){
  return DateTime.now().microsecondsSinceEpoch.remainder(2);
}