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
  List<dynamic> followers;
  List<dynamic> following;
  int stars = 0;
  String currentTab = "stats";

  Future fetchData() async {
    setState(() {
      user = Provider.of<UserProvider>(context, listen: false).userData;

      Github(user.login).fetchFollowing().then((data) {
        Iterable list = json.decode(data.body);

        setState(() {
          following = list.map((model) => User.fromJson(model)).toList();
        });
      });

      Github(user.login).fetchFollowers().then((data) {
        Iterable list = json.decode(data.body);

        setState(() {
          followers = list.map((model) => User.fromJson(model)).toList();
        });
      });

      Github(user.login).fetchStars().then((data) {
        Iterable list = json.decode(data.body);

        final result = list.map((e) => 0);

        setState(() {
          stars = result.length;
        });
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchData().then((_) => {print("fetching initial data...")});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                expandedHeight: 280,
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
                            backgroundImage: NetworkImage(user?.avatarUrl ??
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI7Qzqax4Gi25RgwRqExEB1nH8aI3zLpnGQQ&usqp=CAU"),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          user?.login ?? "",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(
                    onTap: (index) {
                      switch (index) {
                        case 0:
                          setState(() {
                            currentTab = "stats";
                          });
                          break;
                        case 1:
                          setState(() {
                            currentTab = "followers";
                          });
                          break;
                        case 2:
                          setState(() {
                            currentTab = "following";
                          });
                          break;
                        default:
                      }
                    },
                    tabs: <Widget>[
                      Tab(
                          child: Text(
                        "Stats",
                        style: TextStyle(
                            color: currentTab == "stats"
                                ? Colors.blue
                                : Colors.black54.withOpacity(.3)),
                      )),
                      Tab(
                          child: Text(
                        "Followers",
                        style: TextStyle(
                            color: currentTab == "followers"
                                ? Colors.blue
                                : Colors.black54.withOpacity(.3)),
                      )),
                      Tab(
                          child: Text(
                        "Following",
                        style: TextStyle(
                            color: currentTab == "following"
                                ? Colors.blue
                                : Colors.black54.withOpacity(.3)),
                      )),
                    ]),
              ),
              SliverFillRemaining(
                  child: TabBarView(children: [
                stars != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        Text(
                                          stars.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(
                                          Icons.account_tree_outlined,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        Text(
                                          user?.repos?.toString() ?? "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(
                                          Icons.mark_chat_unread_outlined,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        Text(
                                          user?.gists?.toString() ?? "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(
                                          Icons.home_work_outlined,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        Text(
                                          "0",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                        ]),
                      )
                    : Container(child: Align(child: Text("Loading data..."))),
                Container(
                  height: 500,
                  child: followers != null
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: followers.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 60,
                                        height: 60,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              followers[index].avatarUrl),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        followers[index].login,
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
                ),
                Container(
                  height: 500,
                  child: following != null
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: following.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 60,
                                        height: 60,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              following[index].avatarUrl),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        following[index].login,
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
                ),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
