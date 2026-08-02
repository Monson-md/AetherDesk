/// Response of `POST https://github.com/login/device/code`: the codes and
/// timing the user needs to complete the device authorization flow.
class GithubDeviceCode {
  const GithubDeviceCode({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.expiresIn,
    required this.interval,
  });

  /// Opaque code sent back when polling for the access token. Never shown
  /// to the user.
  final String deviceCode;

  /// Short code the user types in at [verificationUri]. Safe to display.
  final String userCode;

  /// Page the user opens in a browser to enter [userCode].
  final String verificationUri;

  /// Seconds until [deviceCode]/[userCode] expire.
  final int expiresIn;

  /// Minimum seconds to wait between polling requests.
  final int interval;
}
