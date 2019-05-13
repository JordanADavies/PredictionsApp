import 'dart:async';

import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/matches/predictions/value_checker.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';

class StatsProfitLossBloc {
  final StreamController<double> profitLoss = StreamController<double>();

  void dispose() {
    profitLoss.close();
  }

  StatsProfitLossBloc({@required MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_calculateProfitLoss);
  }

  void _calculateProfitLoss(Matches matches) async {
    final predictedMatches = matches.winLoseDrawMatches
        .where((m) => m.hasFinalScore() && m.isBeforeToday())
        .toList();

    double resultTotal = 0;
    predictedMatches.forEach((m) {
      final resultChecker = WinLoseDrawChecker(match: m);
      if (resultChecker.isPredictionCorrect()) {
        final value = double.parse(ValueChecker(match: m).getValue());
        resultTotal += value;
      } else {
        resultTotal -= 1;
      }
    });

    profitLoss.add(resultTotal);
  }
}
