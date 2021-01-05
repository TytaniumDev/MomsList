import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

const defaultPrimaryColor = const Color(0xFFFFD873);
const defaultScaffoldBackgroundColor = const Color(0xFFFFF5DB);

final themeProvider = StateProvider<ThemeData>((ref) {
  return ThemeData(
    primaryColor: defaultPrimaryColor,
    scaffoldBackgroundColor: defaultScaffoldBackgroundColor,
  );
});