import 'package:Euro_prediction/components/rounded_button.dart';
import 'package:Euro_prediction/screens/completed_match_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Euro_prediction/display/current_match.dart';
import 'package:Euro_prediction/functions/calculate_write_points.dart';

List<PlayerMatchPoints> playerMatchPointsList = [];
List<String> playerNameList = [];
User loggedInUser;
final _firestore = FirebaseFirestore.instance;

final matchResultTextController = TextEditingController();
final manOfMatchTextController = TextEditingController();
final bestAttackerTextController = TextEditingController();
final bestDefenderTextController = TextEditingController();

class UpdateResultScreen extends StatefulWidget {
  UpdateResultScreen(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg});

  static const String id = 'update_result_screen';

  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;

  @override
  _UpdateResultScreenState createState() => _UpdateResultScreenState();
}

class _UpdateResultScreenState extends State<UpdateResultScreen> {
  String matchResult;
  String manOfMatch;
  String bestAttacker;
  String bestDefender;

  @override
  void initState() {
    playerNameList.clear();
    readPlayerNames(widget.firstTeam, false);
    readPlayerNames(widget.secondTeam, true);
    super.initState();
  }

  void readPlayerNames(String teamName, bool callBuild) async {
    final readPlayers =
        await _firestore.collection('Squads/euro2020/' + teamName).get();
    for (var players in readPlayers.docs) {
      print('adding Player' + players.data()['Player'].toString());
      playerNameList.add(players.data()['Player']);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EURO PREDICTION'),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: FittedBox(
                child: CurrentMatch(
                    matchNum: widget.matchNum,
                    firstTeam: widget.firstTeam,
                    secondTeam: widget.secondTeam,
                    firstImg: widget.firstImg,
                    secondImg: widget.secondImg),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Match Result',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: matchResult,
                            items: [widget.firstTeam, widget.secondTeam]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                matchResult = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Man of the Match',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: manOfMatch,
                            items: playerNameList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                manOfMatch = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Best Attacker',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: bestAttacker,
                            items: playerNameList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                bestAttacker = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Best Defender',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: bestDefender,
                            items: playerNameList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                bestDefender = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 900.0,
              height: 100.0,
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Color(0xFF1D1E33),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SubmitButton(
                  title: 'UPDATE RESULT',
                  colour: Colors.blue[900],
                  onPressed: () {
                    matchResultTextController.clear();
                    manOfMatchTextController.clear();
                    bestAttackerTextController.clear();
                    bestDefenderTextController.clear();
                    _firestore
                        .collection('matchresult')
                        .doc(widget.matchNum.toString())
                        .set({
                      'matchnum': widget.matchNum,
                      'matchresult': matchResult,
                      'manofmatch': manOfMatch,
                      'bestattacker': bestAttacker,
                      'bestdefender': bestDefender
                    }, SetOptions(merge: true)).then((_) {
                      print("Success!");
                    });
                    playerMatchPointsList = calculatePoints(widget.matchNum,
                        matchResult, manOfMatch, bestAttacker, bestDefender);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompletedMatchPage()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
