import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Euro_prediction/display/predictions_display.dart';

/*final _firestore = FirebaseFirestore.instance;
List<PredictionsDisplay> predictions = [];
int matchNum;
String playerId;
String matchResult;
String manOfMatch;
String bestAttacker;
String bestDefender;

void getPredictions(List<PredictionsDisplay> predictions) async {
  final matchPrediction = await _firestore.collection('matchprediction').get();

  for (var match in matchPrediction.docs) {
    matchNum = match.data()['matchnum'];
    playerId = match.data()['playerid'];
    matchResult = match.data()['matchresult'];
    manOfMatch = match.data()['manofmatch'];
    bestAttacker = match.data()['bestattacker'];
    bestDefender = match.data()['bestdefender'];

    print(playerId);
    print(matchResult);
    print(manOfMatch);
    print(bestAttacker);
    print(bestDefender);

    final predictionDisplay = PredictionsDisplay(
      playerId: playerId,
      matchResult: matchResult,
      manOfMatch: manOfMatch,
      bestAttacker: bestAttacker,
      bestDefender: bestDefender,
    );
    predictions.add(predictionDisplay);
  }
}
*/
