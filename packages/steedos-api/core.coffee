Steedos.uri = new URI(Meteor.absoluteUrl());

@Setup = {}

if Meteor.isServer
    @API = new Restivus
        apiPath: 'steedos/api/',
        useDefaultAuth: true
        prettyJson: true
        enableCors: false
        defaultHeaders:
          'Content-Type': 'application/json'