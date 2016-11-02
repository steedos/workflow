Meteor.publishComposite("tabular_flow_positions", function(tableName, ids, fields) {
  check(tableName, String);
  check(ids, Array);
  check(fields, Match.Optional(Object));

  this.unblock(); // requires meteorhacks:unblock package

  return {
    find: function() {
      this.unblock();

      return db.flow_positions.find({
        _id: {
          $in: ids
        }
      }, {
        fields: fields
      });
    },
    children: [{
      find: function(position) {
        this.unblock();
        // Publish the related flow_roles
        return db.flow_roles.find({
          _id: position.role
        }, {
          fields: {
            name: 1
          }
        });
      }
    }, {
      find: function(position) {
        this.unblock();
        // Publish the related organizations
        return db.organizations.find({
          _id: position.org
        }, {
          fields: {
            fullname: 1
          }
        });
      }
    }, {
      find: function(position) {
        this.unblock();
        // Publish the related user
        return db.space_users.find({
          space: position.space,
          user: {
            $in: position.users
          }
        }, {
          fields: {
            space: 1,
            user: 1,
            name: 1
          }
        });
      }
    }]
  };
});