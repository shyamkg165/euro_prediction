import 'dart:io';
import 'package:Euro_prediction/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class PlayerMatchPoints {
  String playerID;
  int playerResultPoints;
  int playerMomPoints;
  int playerAttackerPoints;
  int playerDefenderPoints;
  PlayerMatchPoints(
      {this.playerID,
      this.playerResultPoints,
      this.playerMomPoints,
      this.playerAttackerPoints,
      this.playerDefenderPoints});
}

class MatchPrediction {
  int matchNum;
  String playerId;
  String matchResult;
  String manOfMatch;
  String bestAttacker;
  String bestDefender;
  MatchPrediction(
      {this.matchNum,
      this.playerId,
      this.matchResult,
      this.manOfMatch,
      this.bestAttacker,
      this.bestDefender});
}

class NumCorrectPrediction {
  int numOfCorrectResult;
  int numOfCorrectMom;
  int numOfCorrectAttacker;
  int numOfCorrectDefender;
}

List<PlayerMatchPoints> playerMatchPointsList = [];
List<MatchPrediction> matchPredictionList = [];

List<PlayerMatchPoints> calculatePoints(int matchNum, String matchResult,
    String manOfMatch, String bestAttacker, String bestDefender) {
  readPredictions(
      matchNum, matchResult, manOfMatch, bestAttacker, bestDefender);
  sleep(Duration(milliseconds: 1000));
  writePlayerPoints(playerMatchPointsList);
  return playerMatchPointsList;
}

void readPredictions(
    int actualMatchNumber,
    String actualMatchResult,
    String actualManOfMatch,
    String actualBestAttacker,
    String actualBestDefender) async {
  int numOfCorrectResult = 0;
  int numOfCorrectMom = 0;
  int numOfCorrectAttacker = 0;
  int numOfCorrectDefender = 0;

  int matchNum;
  String playerId;
  String matchResult;
  String manOfMatch;
  String bestAttacker;
  String bestDefender;

  int playerResultPoints;
  int playerMomPoints;
  int playerAttackerPoints;
  int playerDefenderPoints;

  final readPrediction = await _firestore
      .collection('matchprediction')
      .where("matchnum", isEqualTo: actualMatchNumber)
      .get();

  matchPredictionList.clear();

  for (var match in readPrediction.docs) {
    matchNum = match.data()['matchnum'];
    playerId = match.data()['playerid'];
    matchResult = match.data()['matchresult'];
    manOfMatch = match.data()['manofmatch'];
    bestAttacker = match.data()['bestattacker'];
    bestDefender = match.data()['bestdefender'];

    if (matchResult == actualMatchResult) {
      numOfCorrectResult++;
    }
    if (manOfMatch == actualManOfMatch) {
      numOfCorrectMom++;
    }
    if (bestAttacker == actualBestAttacker) {
      numOfCorrectAttacker++;
    }
    if (bestDefender == actualBestDefender) {
      numOfCorrectDefender++;
    }

    final matchPrediction = MatchPrediction(
      playerId: playerId,
      matchNum: matchNum,
      matchResult: matchResult,
      manOfMatch: manOfMatch,
      bestAttacker: bestAttacker,
      bestDefender: bestDefender,
    );
    matchPredictionList.add(matchPrediction);
  }
  print('numOfCorrectResult =' + numOfCorrectResult.toString());
  print('numOfCorrectMom =' + numOfCorrectMom.toString());
  print('numOfCorrectAttacker =' + numOfCorrectAttacker.toString());
  print('numOfCorrectDefender =' + numOfCorrectDefender.toString());
  playerMatchPointsList.clear();

  print('List length =' + matchPredictionList.length.toString());
  for (var num = 0; num < matchPredictionList.length; num++) {
    playerId = matchPredictionList[num].playerId;

    if (matchPredictionList[num].matchResult == actualMatchResult) {
      playerResultPoints = (kResultPoints ~/ numOfCorrectResult).toInt();
    } else {
      playerResultPoints = 0;
    }
    if (matchPredictionList[num].manOfMatch == actualManOfMatch) {
      playerMomPoints = (kMOMPoints ~/ numOfCorrectMom).toInt();
    } else {
      playerMomPoints = 0;
    }
    if (matchPredictionList[num].bestAttacker == actualBestAttacker) {
      playerAttackerPoints = (kAttackerPoints ~/ numOfCorrectAttacker).toInt();
    } else {
      playerAttackerPoints = 0;
    }
    if (matchPredictionList[num].bestDefender == actualBestDefender) {
      playerDefenderPoints = (kDefenderPoints ~/ numOfCorrectDefender).toInt();
    } else {
      playerDefenderPoints = 0;
    }
    final playerMatchPoints = PlayerMatchPoints(
        playerID: playerId,
        playerResultPoints: playerResultPoints,
        playerMomPoints: playerMomPoints,
        playerAttackerPoints: playerAttackerPoints,
        playerDefenderPoints: playerDefenderPoints);
    playerMatchPointsList.add(playerMatchPoints);

    print(playerMatchPoints.playerID);
    print(playerMatchPoints.playerResultPoints);
    print(playerMatchPoints.playerMomPoints);
    print(playerMatchPoints.playerAttackerPoints);
    print(playerMatchPoints.playerDefenderPoints);
  }
}

void writePlayerPoints(List<PlayerMatchPoints> playerMatchPointsList) {
  print('Player List length =' + playerMatchPointsList.length.toString());
  for (var num = 0; num < playerMatchPointsList.length; num++) {
    _firestore.collection('matchpoints').add({
      'playerId': playerMatchPointsList[num].playerID,
      'resultpoints': playerMatchPointsList[num].playerResultPoints,
      'mompoints': playerMatchPointsList[num].playerMomPoints,
      'attackerpoints': playerMatchPointsList[num].playerAttackerPoints,
      'defenderpoints': playerMatchPointsList[num].playerDefenderPoints
    });
  }
}
