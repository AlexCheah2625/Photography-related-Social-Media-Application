import 'dart:math';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:practice/Screens/discoverp2.dart';
import 'package:practice/Screens/posttemplate.dart';
import 'package:practice/color.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class POTWScreen extends StatefulWidget {
  const POTWScreen({super.key});

  @override
  State<POTWScreen> createState() => _POTWScreenState();
}

class _POTWScreenState extends State<POTWScreen> {
  bool loading = false;
  List<String> documentIds = [];
  String finaldocumentid = "";
  //late Cron _cron;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Create a cron expression for 12 am every day
    // _cron = Cron()
    //   ..schedule(Schedule.parse('0 0 * * *'), () {
    //     // Run your function here
    //     clearSharedPreferences();
    getDocumentID();
    //   });
  }

  @override
  void dispose() {
    // Stop the cron scheduler when the widget is disposed
    //_cron.close();
    super.dispose();
  }

  // checkExecuted() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   finaldocumentid = prefs.getString('finaldocumentid') ?? '';
  // }

  getDocumentID() async {
    setState(() {
      loading = true;
    });

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('posts');

    try {
      QuerySnapshot querySnapshot = await collectionReference.get();

      documentIds.clear();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        // Access the document ID and add it to the list
        documentIds.add(docSnapshot.id);
      }

      Random random = Random();

      int randomNum = random.nextInt(documentIds.length);

      finaldocumentid = documentIds[randomNum];
    } catch (e) {
      print("Error getting document IDs: $e");
    }
    setState(() {
      loading = false;
    });
  }

  clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('hasExecutedToday');
    prefs.remove('finaldocumentid');
    print("SharedPreferences cleared");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.postcolor,
        title: const Text(
          "Daily Recommendation",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: 'Ale',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(finaldocumentid)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Post2(snap: (snapshot.data! as dynamic).data());
              },
            ),
    );
  }
}
