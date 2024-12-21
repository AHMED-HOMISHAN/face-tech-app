class FaceTecConfig {
  // Available at https://dev.facetec.com/account
  static const String deviceKeyIdentifier = "YOUR_DEVICE_KEY_IDENTIFIER";

  // The FaceScan Encryption Key you define for your application.
  // Please see https://dev.facetec.com/facemap-encryption-keys for more information.
  static const String publicFaceScanEncryptionKey = '''
-----BEGIN PUBLIC KEY-----
YOUR_PUBLIC_KEY
-----END PUBLIC KEY-----''';
}
