Meteor.startup ->
    Migrations.add
        version: 2
        up: ->
