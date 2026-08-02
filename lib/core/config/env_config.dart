/// Build environments the app will eventually ship as separate flavors
/// (e.g. distinct Firebase projects, API base URLs, app icons per stage).
///
/// No flavor wiring exists yet — this enum only reserves the concept so
/// that adding `--flavor dev|staging|prod` later does not require touching
/// every module that reads [AppConfig.environment].
enum Environment { dev, staging, prod }
