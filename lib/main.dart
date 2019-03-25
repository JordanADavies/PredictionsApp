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
);

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Color(0xFFF26627),
  scaffoldBackgroundColor: Color(0xFFF26627),
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
