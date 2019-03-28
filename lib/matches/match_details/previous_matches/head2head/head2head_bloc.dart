import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/match_details/previous_matches/match_finder.dart';

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

  void _fetchHead2HeadMatches(Matches matches) async {
    final map = {
      "Match": match,
      "AllMatches": matches.allMatches,
    };
    final head2HeadMatches = await compute(_getHead2HeadMatches, map);
    _head2HeadMatches.add(head2HeadMatches);
  }

  static _getHead2HeadMatches(Map<String, dynamic> map) {
    final allMatches = map["AllMatches"];
    final finder = MatchFinder(allMatches: allMatches);
    final match = map["Match"];
    return finder.findLastHead2HeadMatches(match).reversed.toList();
  }
}
