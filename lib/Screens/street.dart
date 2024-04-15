import 'package:flutter/material.dart';
import 'package:practice/Screens/landscape.dart';
import 'package:practice/Screens/street.dart';
import 'package:practice/Screens/potrait.dart';
import 'package:practice/Screens/sport.dart';
import 'package:practice/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:practice/Screens/discoverp2.dart';

class street extends StatefulWidget {
  const street({super.key});

  @override
  State<street> createState() => _streetState();
}

class _streetState extends State<street> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.postcolor,
          iconTheme: IconThemeData(color: Palette.thirdcolor),
          title: const Text(
            "Xenon",
            style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontFamily: 'Ale',
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const landscape()),
                        );
                      },
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(105.0, 20.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Palette.postcolor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white10))),
                      ),
                      child: Text("Landscape",
                          style: TextStyle(
                              fontFamily: 'Ale',
                              fontSize: 12,
                              color: Palette.thirdcolor)),
                    )),
                    Container(
                        child: ElevatedButton(
                      onPressed: () { Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const street()),
                              );},
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(87.0, 10.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Palette.postcolor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white10))),
                      ),
                      child: Text("Street",
                          style: TextStyle(
                              fontFamily: 'Ale',
                              fontSize: 12,
                              color: Palette.thirdcolor)),
                    )),
                    Container(
                        child: ElevatedButton(
                      onPressed: () { Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const potrait()),
                              );},
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(90.0, 10.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Palette.postcolor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white10))),
                      ),
                      child: Text("Potrait",
                          style: TextStyle(
                              fontFamily: 'Ale',
                              fontSize: 12,
                              color: Palette.thirdcolor)),
                    )),
                    Container(
                        child: ElevatedButton(
                      onPressed: () { Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const sport()),
                              );},
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(87.0, 10.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Palette.postcolor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white10))),
                      ),
                      child: Text("Sport",
                          style: TextStyle(
                              fontFamily: 'Ale',
                              fontSize: 12,
                              color: Palette.thirdcolor)),
                    )),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('category', isEqualTo: "1")
                      .get(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.all(5.0),
                              child: GestureDetector(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Post1(
                                            snap: (snapshot.data! as dynamic)
                                                .docs[index]
                                                .data()),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['postUrl']),
                                  ),
                                ),
                              ),
                            ),
                        staggeredTileBuilder: (index) =>
                            const StaggeredTile.fit(1));
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}
