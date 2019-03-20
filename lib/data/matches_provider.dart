import 'package:flutter/material.dart';
import 'package:predictions/data/matches_bloc.dart';

class MatchesProvider extends InheritedWidget {
  final MatchesBloc matchesBloc;

  MatchesProvider({
    Key key,
    MatchesBloc matchesBloc,
    Widget child,
  })  : matchesBloc = matchesBloc ?? MatchesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static MatchesBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(MatchesProvider) as MatchesProvider)
          .matchesBloc;
}
