import 'package:github_stats/pages/following_page.dart';
import "package:provider/provider.dart";

import "package:flutter/material.dart";
import 'package:github_stats/providers/user_provider.dart';

void main() => runApp(ChangeNotifierProvider<UserProvider>(
      child: MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false),
      create: (context) => UserProvider(),
    ));

class HomePage extends StatefulWidget {
  // HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();

  void _getUser() {
    if (_controller.text == "") {
      Provider.of<UserProvider>(context, listen: false)
          .setMessage("Please enter your username");

      return;
    }

    Provider.of<UserProvider>(context, listen: false)
        .fetchUser(_controller.text)
        .then((value) {
      if (value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FollowingPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        "https://icon-library.net/images/github-icon-png/github-icon-png-29.jpg"),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Github",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 150,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(.1)),
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<UserProvider>(context, listen: false)
                          .setMessage(null);
                    },
                    controller: _controller,
                    enabled: !Provider.of<UserProvider>(context, listen: false)
                        .isLoading,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        errorText: Provider.of<UserProvider>(context).message,
                        hintText: "Github username",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Align(
                    child: Provider.of<UserProvider>(context).isLoading
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            "Get Following",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                  onPressed: () {
                    _getUser();
                  },
                ),
                SizedBox(
                  height:
                      165, // this is just a hack to stretch the page to full height till I figure out something more intuitive
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
