import 'package:flutter/material.dart';
import 'package:predictions/matches/matches_page.dart';
import 'package:predictions/data/matches_provider.dart';

void main() => runApp(PredictionsApp());

final theme = ThemeData(
  primaryColor: Color(0xFFF26627),
  accentColor: Color(0xFF9BD7D1),
  backgroundColor: Color(0xFFFFFFFF),
  canvasColor: Color(0xFFEFEEEE),
  scaffoldBackgroundColor: Color(0xFFEFEEEE),
  secondaryHeaderColor: Color(0xFFF9A26C),
  textTheme: TextTheme(
    display1: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFFFF),
    ),
    display2: TextStyle(
      fontSize: 19.0,
      color: Color(0xFF325D79),
    ),
    display3: TextStyle(
      fontSize: 36.0,
      color: Color(0xFFF9A26C),
    ),
    headline: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF9A26C),
    ),
    subhead: TextStyle(
      color: Color(0xFF325D79),
    ),
    subtitle: TextStyle(
      fontSize: 15.0,
      color: Color(0xFF325D79),
    ),
    body1: TextStyle(
      color: Color(0xFF325D79),
    ),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Color(0xFFF26627),
  scaffoldBackgroundColor: Color(0xFFF26627),
  accentColor: Colors.white,
);

class PredictionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MatchesProvider(
      child: MaterialApp(
        theme: theme,
        home: MatchesPage(),
      ),
    );
  }
}
