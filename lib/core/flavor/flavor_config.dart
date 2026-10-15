enum FlavorType {
  staging,
  production,
}

class FlavorConfig {
  final FlavorType flavor;
  final String appName;
  final String baseUrl;

  static FlavorConfig? _instance;

  FlavorConfig._({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
  });

  static void init({
    required FlavorType flavor,
    required String appName,
    required String baseUrl,
  }) {
    _instance = FlavorConfig._(
      flavor: flavor,
      appName: appName,
      baseUrl: baseUrl,
    );
  }

  static FlavorConfig get instance {
    return _instance ??
        FlavorConfig._(
          flavor: FlavorType.staging,
          appName: 'Chat App (Staging)',
          baseUrl: 'https://0684-156-197-118-136.ngrok-free.app/api',
        );
  }

  static bool get isInitialized => _instance != null;

  bool get isStaging => flavor == FlavorType.staging;
  bool get isProduction => flavor == FlavorType.production;
}
