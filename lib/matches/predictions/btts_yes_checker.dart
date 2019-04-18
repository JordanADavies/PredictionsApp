import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';

class BttsYesChecker {
  final FootballMatch match;

  BttsYesChecker({@required this.match});

  bool getPrediction() {
    final leagueToScoreAverage = toScoreAverages[match.leagueId];
    return match.homeProjectedGoals > leagueToScoreAverage &&
        match.awayProjectedGoals > leagueToScoreAverage;
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore >= 1 && match.awayFinalScore >= 1;
  }
}
