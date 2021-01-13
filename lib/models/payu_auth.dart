class PayUAuthResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String grantType;

  PayUAuthResponse.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        tokenType = json['token_type'],
        expiresIn = json['expires_in'],
        grantType = json['grant_type'];
}
