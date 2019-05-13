import 'package:flutter/material.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/matches/stats/profitloss/stats_profit_loss_bloc.dart';

class StatsProfitLossPage extends StatefulWidget {
  @override
  _StatsProfitLossPageState createState() => _StatsProfitLossPageState();
}

class _StatsProfitLossPageState extends State<StatsProfitLossPage> {
  StatsProfitLossBloc _statsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final matchesBloc = MatchesProvider.of(context);
    _statsBloc ??= StatsProfitLossBloc(matchesBloc: matchesBloc);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: _statsBloc.profitLoss.stream,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildProfitLoss(snapshot.data);
      },
    );
  }

  Widget _buildProfitLoss(double profitLoss) {
    return Center(
      child: Text(
        "${profitLoss.toStringAsFixed(2)}u",
        style: TextStyle(fontSize: 32.0),
      ),
    );
  }
}
