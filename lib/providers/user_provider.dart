import 'dart:convert';

import "package:flutter/foundation.dart";
import "package:github_stats/models/user.dart";
import 'package:github_stats/requests/github_request.dart';

class UserProvider with ChangeNotifier {
  User user;
  String errMessage;
  bool loading = false;

  Future<bool> fetchUser(username) async {
    setLoading(true);

    await Github(username).fetchUser().then((data) {
      setLoading(false);

      if (data.statusCode != 200) {
        Map<String, dynamic> result = json.decode(data.body);
        setMessage(result["message"]);
        print(result["message"]);
        return;
      }

      setUser(User.fromJson(json.decode(data.body)));
    });

    return isUser();
  }

  void setLoading(payload) {
    loading = payload;

    notifyListeners();
  }

  bool get isLoading {
    return loading;
  }

  void setUser(payload) {
    user = payload;

    notifyListeners();
  }

  User get userData {
    return user;
  }

  void setMessage(payload) {
    errMessage = payload;

    notifyListeners();
  }

  String get message {
    return errMessage;
  }

  bool isUser() {
    return user != null ? true : false;
  }
}
