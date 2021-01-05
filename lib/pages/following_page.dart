import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_stats/models/user.dart';
import 'package:github_stats/providers/user_provider.dart';
import 'package:github_stats/requests/github_request.dart';
import 'package:provider/provider.dart';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  User user;
  List<User> users;

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<UserProvider>(context).userData;

      Github(user.login).fetchFollowing().then((data) {
        Iterable list = json.decode(data.body);

        setState(() {
          users = list.map((model) => User.fromJson(model)).toList();
        });
      });
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              brightness: Brightness.light,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.white,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        user.login,
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                height: 500,
                child: users != null
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[200]))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 60,
                                      height: 60,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            users[index].avatarUrl),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      users[index].login,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[700]),
                                    )
                                  ],
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(color: Colors.blue),
                                )
                              ],
                            ),
                          );
                        })
                    : Container(child: Align(child: Text("Loading data..."))),
              )
            ]))
          ],
        ),
      ),
    );
  }
}
