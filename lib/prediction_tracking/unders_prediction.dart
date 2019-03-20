import 'package:intl/intl.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/prediction_tracking/match_finder.dart';

class UndersPrediction {
  List<FootballMatch> predictedMatches;
  List<FootballMatch> predictedAndFinishedMatches;
  List<FootballMatch> predictedCorrectlyMatches;

  MatchFinder matchFinder;

  UndersPrediction(List<FootballMatch> allMatches) {
    matchFinder = MatchFinder(allMatches);
    predictedMatches = allMatches.where((m) => _isThisSeason(m) && _under2Predicted(m)).toList();

    predictedAndFinishedMatches =
        predictedMatches.where((m) => m.hasBeenPlayed()).toList();
    predictedCorrectlyMatches =
        predictedAndFinishedMatches.where(_under3PredictedCorrectly).toList();
  }

  bool _isThisSeason(FootballMatch match) {
    final format = DateFormat("yyyy-MM-dd");
    final date = format.parse(match.date);

    return date.year == 2019 || date.year == 2018 && date.month > 8;
  }

  bool _under2Predicted(FootballMatch match) {
    final homeTeamsLastMatchGoals =
        matchFinder.findGoalsInLastMatchForHomeTeam(match: match);
    final awayTeamsLastMatchGoals =
        matchFinder.findGoalsInLastMatchForAwayTeam(match: match);

    return match.homeProjectedGoals + match.awayProjectedGoals < 2 &&
        homeTeamsLastMatchGoals < 2 &&
        awayTeamsLastMatchGoals < 2;
  }

  bool _under3PredictedCorrectly(FootballMatch match) {
    return match.homeFinalScore + match.awayFinalScore < 3;
  }
}
