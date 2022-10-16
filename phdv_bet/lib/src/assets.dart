class Assets {
  static final icons = AppIcons();
  static final images = AppImages();
  static final animations = AppAnimations();
}

class AppAnimations {
  static const String root = "assets/animations";
  final String indicator = "$root/indicator.json";
}

class AppIcons {
  static const String root = "assets/icons";
  final String iconPauseNormal = "$root/ic_pause_normal.svg";
}

class AppImages {
  static const String root = "assets/images";
  final String logo = "$root/logo.png";
}
