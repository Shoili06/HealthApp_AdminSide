import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:moodle/tools/board.dart';

class NoticeBoard extends StatefulWidget {

  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  CollectionReference collectionReference;
  List<DocumentSnapshot> noticeList;
  StreamSubscription<QuerySnapshot> subscription;

  @override
  void initState() {
    super.initState();
    collectionReference = Firestore.instance.collection("AppointmentData");
    subscription = collectionReference.snapshots().listen((data) {
      setState(() {
        noticeList = data.documents;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: noticeList != null
                ? Container(
                    child: ListView.builder(
                      itemCount: noticeList.length,
                      itemBuilder: (_, i) {
                        return Board((noticeList[i])["patient_name"],
                            (noticeList[i])["doctor_name"], (noticeList[i])["patient_syntom"]);
                      },
                    ),
                  )
                : Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  )));
  }
}
