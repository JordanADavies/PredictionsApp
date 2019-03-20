import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';

class Last5HomeBloc {
  final MatchesBloc matchesBloc;
  final FootballMatch match;

  StreamController<List<FootballMatch>> _homeMatches = StreamController();

  Last5HomeBloc({@required this.matchesBloc, @required this.match}) {
    matchesBloc.allMatches.listen(_fetchLast5Matches);
  }

  Stream<List<FootballMatch>> get homeMatches => _homeMatches.stream;

  void dispose() {
    _homeMatches.close();
  }

  void _fetchLast5Matches(List<FootballMatch> allMatches) {
    final homeMatches = allMatches
        .where((m) => m != match && m.homeTeam == match.homeTeam && m.hasBeenPlayed())
        .toList();
    final sortedHomeMatches = homeMatches.length > 5
        ? homeMatches.sublist(homeMatches.length - 5).reversed.toList()
        : homeMatches;
    _homeMatches.add(sortedHomeMatches);
  }
}
