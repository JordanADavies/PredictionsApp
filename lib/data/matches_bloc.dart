import 'package:collection/collection.dart';
import 'package:predictions/data/api/matches_api.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:rxdart/subjects.dart';

class MatchesBloc {
  final BehaviorSubject<List<FootballMatch>> allMatches = BehaviorSubject<List<FootballMatch>>();
  final BehaviorSubject<Map<String, Map<String, List<FootballMatch>>>> groupedMatches =
      BehaviorSubject<Map<String, Map<String, List<FootballMatch>>>>();

  MatchesBloc() {
    _loadMatches();
  }

  Future _loadMatches() async {
    final api = MatchesApi();
    final matches = await api.fetchMatches();
    allMatches.add(matches);

    final grouped = _groupMatches(matches);
    groupedMatches.add(grouped);
  }

  Map<String, Map<String, List<FootballMatch>>> _groupMatches(List<FootballMatch> matches) {
    final groupedByDay = groupBy(matches, (obj) => obj.date);
    return groupedByDay.map(
        (key, value) => MapEntry(key, groupBy(value, (obj) => obj.league)));
  }

  void dispose() {
    groupedMatches.close();
    allMatches.close();
  }
}
