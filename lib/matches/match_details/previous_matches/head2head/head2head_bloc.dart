import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/prediction_tracking/match_finder.dart';

class Head2HeadBloc {
  final MatchesBloc matchesBloc;
  final FootballMatch match;

  StreamController<List<FootballMatch>> _head2HeadMatches = StreamController();

  Head2HeadBloc({@required this.matchesBloc, @required this.match}) {
    matchesBloc.matches.listen(_fetchHead2HeadMatches);
  }

  Stream<List<FootballMatch>> get head2HeadMatches => _head2HeadMatches.stream;

  void dispose() {
    _head2HeadMatches.close();
  }

  void _fetchHead2HeadMatches(Matches matches) {
    final finder = MatchFinder(allMatches: matches.allMatches);
    final head2HeadMatches =
        finder.findLastHead2HeadMatches(match).reversed.toList();
    _head2HeadMatches.add(head2HeadMatches);
  }
}
