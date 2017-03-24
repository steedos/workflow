BQQ = {};

OAuth.registerService('bqq', 2, null, function(query) {

  var response = BQQ.getTokenResponse(query);
  if (response.company_id) {
    spaceExists = db.spaces.find({"services.bqq.company_id": response.company_id}).count()>0;
    if (!spaceExists)
      throw "您的企业尚未开通审批王应用，请联系系统管理员。"
  }
  return {
    serviceData: {
      id: response.open_id,
      accessToken: response.access_token
    }
  };
});

BQQ.getTokenResponse = function (query) {
  var config = ServiceConfiguration.configurations.findOne({service: 'bqq'});

  if (!config)
    throw new ServiceConfiguration.ConfigError();

  var tokenResponse;
  try {
    tokenResponse = HTTP.get(
      "https://openapi.b.qq.com/oauth2/token", {
        params: {
          code: query.code,
          app_id: config.clientId,
          redirect_uri: OAuth._redirectUri("bqq", config),
          app_secret: OAuth.openSecret(config.secret),
          grant_type: 'authorization_code'
        }
      });
    
    if (tokenResponse.data.ret) // if the http response was an error
        throw tokenResponse.data.msg;
  } catch (err) {
    throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err.message),
                   {response: err.response});
  }

  return tokenResponse.data.data

};

BQQ.retrieveCredential = function(credentialToken, credentialSecret) {
  return OAuth.retrieveCredential(credentialToken, credentialSecret);
};
