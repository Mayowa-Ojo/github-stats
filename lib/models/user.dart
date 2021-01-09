class User {
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final int repos;
  final int gists;

  User(this.login, this.avatarUrl, this.htmlUrl, this.repos, this.gists);

  Map toJson() => {
        "login": login,
        "avatarUrl": avatarUrl,
        "htmlUrl": htmlUrl,
        "repos": repos,
        "gists": gists
      };

  User.fromJson(Map json)
      : login = json["login"],
        avatarUrl = json["avatar_url"],
        htmlUrl = json["html_url"],
        repos = json["public_repos"],
        gists = json["public_gists"];
}
