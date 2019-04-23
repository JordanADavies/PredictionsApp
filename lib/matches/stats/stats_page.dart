import 'package:flutter/material.dart';
import 'package:predictions/main.dart';
import 'package:predictions/matches/stats/all_leagues/stats_all_leagues_page.dart';
import 'package:predictions/matches/stats/all_teams/stats_all_teams_page.dart';
import 'package:predictions/matches/stats/selected_leagues/stats_selected_leagues_page.dart';
import 'package:predictions/matches/stats/testing/testing_page.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Stats"),
          elevation: 0.0,
        ),
        body: DefaultTabController(
          length: 4,
          child: Column(
            children: <Widget>[
              TabBar(
                indicatorColor: Theme.of(context).canvasColor,
                tabs: [
                  Tab(text: "Highlighted"),
                  Tab(text: "All Leagues"),
                  Tab(text: "All Teams"),
                  Tab(text: "Testing"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    StatsSelectedLeaguesPage(),
                    StatsAllLeaguesPage(),
                    StatsAllTeamsPage(),
                    TestingPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
