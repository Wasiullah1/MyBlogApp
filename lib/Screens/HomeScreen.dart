import 'package:blog/Screens/loginScreen.dart';
import 'package:blog/Screens/uploadblog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.reference().child('Posts');
  TextEditingController seachcontroller = TextEditingController();
  String search = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Blogs Newsfeed'),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UploadBlog()));
              },
              child: Icon(Icons.add),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                auth.signOut().then((value) => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen())));
              },
              child: Icon(Icons.logout),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  controller: seachcontroller,
                  decoration: InputDecoration(
                      hintText: "Search with blog title",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      labelStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal)),
                  onChanged: (String value) {
                    search = value;
                  }),
            ),
            Expanded(
                child: FirebaseAnimatedList(
                    query: dbRef.child('Post List'),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      String tempTitle =
                          snapshot.child('pTitle').value.toString();
                      if (seachcontroller.text.isEmpty) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 187, 184, 184),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/blog.png',
                                      image: snapshot
                                          .child('pImage')
                                          .value!
                                          .toString(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      snapshot
                                          .child('pTitle')
                                          .value!
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      snapshot
                                          .child('pDescription')
                                          .value!
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ));
                      } else if (tempTitle
                          .toLowerCase()
                          .contains(seachcontroller.text.toString())) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 187, 184, 184),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/logo.png',
                                        image: snapshot
                                            .child('pImage')
                                            .value!
                                            .toString(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        snapshot
                                            .child('pTitle')
                                            .value!
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        snapshot
                                            .child('pDescription')
                                            .value!
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                            ));
                      } else {
                        return Container();
                      }
                    })),
          ],
        ),
      ),
    );
  }
}
