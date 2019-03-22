import 'package:collection/collection.dart';
import 'package:predictions/data/api/matches_api.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:rxdart/subjects.dart';

class MatchesBloc {
  final BehaviorSubject<List<FootballMatch>> allMatches =
      BehaviorSubject<List<FootballMatch>>();
  final BehaviorSubject<Map<String, Map<String, List<FootballMatch>>>>
      groupedMatches =
      BehaviorSubject<Map<String, Map<String, List<FootballMatch>>>>();

  MatchesBloc() {
    _loadMatches();
  }

  Future _loadMatches() async {
    final api = MatchesApi();
    final matches = await api.fetchMatches();
    final filteredMatches = _filterByThisSeasonMatches(matches);
    allMatches.add(filteredMatches);

    final grouped = _groupMatches(filteredMatches);
    groupedMatches.add(grouped);
  }

  List<FootballMatch> _filterByThisSeasonMatches(List<FootballMatch> matches) {
    return matches
        .where((m) =>
            m.date.split("-")[0] == "2019" ||
            (m.date.split("-")[0] == "2018" &&
                double.parse(m.date.split("-")[1]) > 7))
        .toList();
  }

  Map<String, Map<String, List<FootballMatch>>> _groupMatches(
      List<FootballMatch> matches) {
    final groupedByDay = groupBy(matches, (obj) => obj.date);
    return groupedByDay.map(
        (key, value) => MapEntry(key, groupBy(value, (obj) => obj.league)));
  }

  void dispose() {
    groupedMatches.close();
    allMatches.close();
  }
}
