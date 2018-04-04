Meteor.methods {
    getHeapdump: () ->

        if not this.userId
            return

        if Meteor.users.find({ _id: this.userId, is_cloudadmin: true }).count() < 1
            return 'reject'

        heapdump = Npm.require("heapdump")
        path = Npm.require('path')

        dumpPath = Meteor.settings.heapdump?.path || '/tmp/'
        filename = path.resolve(path.resolve(dumpPath) + '/' + Date.now() + '.heapsnapshot')

        heapdump.writeSnapshot(filename)
        console.log filename
        return "dump succeed"
}
