package com.aetherdesk.aetherdesk

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity (not FlutterActivity) is required by local_auth to
// show the biometric prompt (BiometricPrompt needs a FragmentActivity host).
class MainActivity : FlutterFragmentActivity()
