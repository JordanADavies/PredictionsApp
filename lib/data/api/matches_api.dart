import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:predictions/data/model/football_match.dart';

class MatchesApi {
  static const _url = "https://projects.fivethirtyeight.com/soccer-api/club/spi_matches.csv";

  Future<List<FootballMatch>> fetchMatches() async {
    final response = await get(_url);
    return await compute(_getMatches, response.bodyBytes);
  }

  static List<FootballMatch> _getMatches(List<int> bytes) {
    final csvString = utf8.decode(bytes);

    final result = CsvToListConverter(eol: "\n").convert(csvString);
    result.removeAt(0); //Remove headings

    return _parseMatches(result);
  }

  static List<FootballMatch> _parseMatches(List csvMatches) {
    return csvMatches.map((match) => FootballMatch.fromCsv(match)).toList();
  }
}