import 'package:Euro_prediction/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Euro_prediction/display/current_match.dart';
import 'package:Euro_prediction/functions/calculate_write_points.dart';

List<PlayerMatchPoints> playerMatchPointsList = [];

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
    super.initState();
    //getCurrentUser();
  }

  /*void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }*/

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
                          child: TextField(
                            controller: matchResultTextController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              matchResult = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Colors.red,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                              ),
                            ),
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
                          child: TextField(
                            controller: manOfMatchTextController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              manOfMatch = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Colors.red,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                              ),
                            ),
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
                          child: TextField(
                            controller: bestAttackerTextController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              bestAttacker = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Colors.red,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                              ),
                            ),
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
                          child: TextField(
                            controller: bestDefenderTextController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              bestDefender = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Colors.red,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                              ),
                            ),
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
                    _firestore.collection('matchresult').add({
                      'matchnum': widget.matchNum,
                      'matchresult': matchResult,
                      'manofmatch': manOfMatch,
                      'bestattacker': bestAttacker,
                      'bestdefender': bestDefender
                    });
                    playerMatchPointsList = calculatePoints(widget.matchNum,
                        matchResult, manOfMatch, bestAttacker, bestDefender);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
