class PayUAuthResponse {
  late final String accessToken;
  late final String tokenType;
  late final int expiresIn;
  late final String grantType;

  PayUAuthResponse.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        tokenType = json['token_type'],
        expiresIn = json['expires_in'],
        grantType = json['grant_type'];
}
