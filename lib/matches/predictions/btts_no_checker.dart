import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';

class BttsNoChecker {
  final FootballMatch match;

  BttsNoChecker({@required this.match});

  bool getPrediction() {
    final leagueToNotScoreAverage = toNotScoreAverages[match.leagueId] - 0.45;
    return match.homeProjectedGoals < leagueToNotScoreAverage ||
        match.awayProjectedGoals < leagueToNotScoreAverage;
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore < 1 || match.awayFinalScore < 1;
  }
}
