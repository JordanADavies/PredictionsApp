import 'package:meta/meta.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/data/teams.dart';
import 'package:predictions/util/utils.dart';

class Over2Checker {
  final FootballMatch match;

  Over2Checker({@required this.match});

  bool getPrediction() {
    final roundedHomeGoals =
        Utils.roundProjectedGoals(match.homeProjectedGoals);
    final roundedAwayGoals =
        Utils.roundProjectedGoals(match.awayProjectedGoals);
    return roundedHomeGoals + roundedAwayGoals > 2;
  }

  bool getPredictionIncludingPerformance() {
    final prediction = getPrediction();
    if (!prediction) {
      return false;
    }

    return overPerformingTeams.contains("(H) ${match.homeTeam}") &&
        overPerformingTeams.contains("(A) ${match.awayTeam}");
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore + match.awayFinalScore > 2;
  }
}
