Meteor.methods({
    setKeyValue: function(key, value) {
        check(key, String);
        check(value, Object);

        obj = {};
        obj.user = this.userId;
        obj.key = key;
        obj.value = value;
        db.steedos_keyvalues.insert(obj);

        return true;
    }
})