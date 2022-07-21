class Config {
  Config._();

  static final _instance = Config._();

  factory Config() {
    return _instance;
  }

  String colorPaletteName = 'Colors';
  String iconSetName = 'Icons';
}
