class Assets {
  static final icons = AppIcons();
  static final images = AppImages();
  static final animations = AppAnimations();
}

class AppAnimations {
  static const String root = "assets/animations";
  final String indicator = "$root/indicator.json";
  final String football = "$root/football.json";
  final String ranking = "$root/ranking.json";
  final String congratulation = "$root/congratulation.json";
}

class AppIcons {
  static const String root = "assets/icons";
  final String iconPauseNormal = "$root/ic_pause_normal.svg";
  final String ic_gold = "$root/1st_medal.png";
  final String ic_siliver = "$root/2nd_medal.png";
  final String ic_bronze = "$root/3th_medal.png";
}

class AppImages {
  static const String root = "assets/images";
  final String background = "$root/wc_bg.png";
}
