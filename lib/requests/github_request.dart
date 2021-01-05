import "package:http/http.dart" as http;

class Github {
  final String username;
  final String url = "https://api.github.com/";
  static String clientId = "68db445067740a3044fa";
  static String clientSecret = "90e9da8b0207bf3abdade5bde4f25d4cb96bb2cb";
  final String query = "?client_id=$clientId&client_secret=$clientSecret";

  Github(this.username);

  Future<http.Response> fetchUser() {
    return http.get(url + "users/" + username + query);
  }

  Future<http.Response> fetchFollowing() {
    return http.get(url + "users/" + username + "/following" + query);
  }
}
