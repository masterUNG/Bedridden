import 'package:bedridden/Screen/my_service.dart';
import 'package:flutter/material.dart';
import 'Screen/homepage.dart';
import 'Screen/login.dart';
import 'Screen/signup.dart';
import 'Screen/my_service.dart';

final Map<String, WidgetBuilder> routes = {
  '/Homepage': (BuildContext context) => Homepage(),
  '/LoginPage': (BuildContext context) => LoginPage(),
  '/myService': (BuildContext context) => MyService(),
  '/SignupPage': (BuildContext context) => SignupPage(),
};
