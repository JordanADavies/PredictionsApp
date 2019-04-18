import 'package:flutter/material.dart';
import 'package:predictions/data/matches_provider.dart';
import 'package:predictions/matches/stats/testing/testing_bloc.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  TestingBloc _testingBloc;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final matchesBloc = MatchesProvider.of(context);
    _testingBloc ??= TestingBloc(matchesBloc: matchesBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
