import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;

class Github {
  final String username;
  final String url = "https://api.github.com/";

  Github(this.username);

  Future<http.Response> fetchUser() {
    Map<String, String> headers = {
      "Authorization": "token ${DotEnv().env['AUTH_TOKEN']}"
    };

    return http.get(url + "users/" + username, headers: headers);
  }

  Future<http.Response> fetchFollowing() {
    return http.get(url + "users/" + username + "/following");
  }

  Future<http.Response> fetchFollowers() {
    return http.get(url + "users/" + username + "/followers");
  }

  Future<http.Response> fetchStars() {
    return http.get(url + "users/" + username + "/starred");
  }

  Future<http.Response> fetchOrgs() {
    return http.get(url + "users/" + username + "/orgs");
  }
}
