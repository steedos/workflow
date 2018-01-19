Meteor.methods({
  '/cfs/files/put': function CfsDdpUpload(fileObj, data, start) {
    var self = this;
    check(fileObj, FS.File);
    
    if (!EJSON.isBinary(data)) {
      throw new Error("DDP Upload expects binary data");
    }

    if (typeof start !== "number")
      start = 0;

    self.unblock();

    if (!fileObj.isMounted()) {
      // No file data found
      throw new Error("DDP Upload expects a file that has been inserted into a collection");
    }

    // validators and temp store require that we have the full file record loaded
    fileObj.getFileRecord();

    FS.Utility.validateAction(fileObj.collection.files._validators['update'], fileObj, self.userId);

    // Save chunk in temporary store
    FS.TempStore.saveChunk(fileObj, FS.Utility.binaryToBuffer(data), start, function(err) {
      if (err) {
        throw new Error("Unable to load binary chunk at position " + start + ": " + err.message);
      }
    });

  }
});