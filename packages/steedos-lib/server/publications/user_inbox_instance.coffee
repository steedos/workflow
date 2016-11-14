Meteor.publishComposite "user_inbox_instance", ()->
    console.log("user_inbox_instance...")
    unless this.userId
        return this.ready()



    userSpaceIds = db.space_users.find({user: this.userId, user_accepted: true},{fields:{space:1}}).fetch().getEach("space");
    query = {inbox_users: this.userId, space: {$in:userSpaceIds}}

    console.log(query);
    find: ->
        db.instances.find(query, {fields: {space: 1, applicant_name: 1, flow: 1, inbox_users: 1, cc_users: 1, state: 1, name: 1, modified: 1}});
    children: [
        {
            find: (instance, post)->
                db.flows.find({_id: instance.flow}, {fields: {name: 1, space: 1}});
        }
    ]

