var putMethodName = '/cfs/files/put';

/*
 * DDP Upload Transfer Queue
 */

// XXX: we dont have to use a subqueue - a task can do next(null) to be rerun later
// It could be an optimization if needed.
// XXX: we should make the queue connection aware - in case of failures and no
// connection it should pause the queue - and start again when online again.
// XXX: we should have a handle to pause or cancel the file upload
// XXX: we should have a handle to the file when uploading
// XXX: we should refactor this package into ddp transfer making the tranfer
// package the general mechanism for chunk uploading - dispite protocol.

/**
 * @private
 * @param {Object} task
 * @param {Function} next
 * @return {undefined}
 */
var _taskHandler = function(task, next) {
  FS.debug && console.log("uploading chunk " + task.chunk + ", bytes " + task.start + " to " + Math.min(task.end, task.fileObj.size) + " of " + task.fileObj.size);
  task.fileObj.data.getBinary(task.start, task.end, function gotBinaryCallback(err, data) {
    if (err) {
      next(new Meteor.Error(err.error, err.message));
    } else {
      var b = new Date();

      //task.connection.apply(task.methodName,
      //XXX using Meteor.apply for now because login isn't working
      Meteor.apply(task.methodName,
              [task.fileObj, data, task.start],
              { // We pass in options
                // wait should be false if Meteor issue is fixed: https://github.com/meteor/meteor/issues/1826
                wait: false, // Dont queue this on the client
                onResultReceived: function(err, result) {
                  // This callback is called as soon as the data is recieved
                  var e = new Date();
                  FS.debug && console.log("server took " + (e.getTime() - b.getTime()) + "ms");
                  task = null;
                  if (err) {
                    next(new Meteor.Error(err.error, err.message));
                  } else {
                    next();
                  }
                }
              });
    }
  });
};

/**
 * @private
 * @param {Object} data
 * @param {Function} addTask
 * @return {undefined}
 */
var _errorHandler = function(data, addTask) {
  // What to do if file upload failes - we could check connection and pause the
  // queue?
  //if (data.connection)
};

/** @method UploadTransferQueue
 * @namespace UploadTransferQueue
 * @constructor
 * @param {Object} [options]
 * @param {Object} [options.connection=a separate connection to the default Meteor DDP URL] The connection to use
 */
UploadTransferQueue = function(options) {
  // Rig options
  options = options || {};

  // Init the power queue
  var self = new PowerQueue({
    name: 'UploadTransferQueue',
    // spinalQueue: ReactiveList,
    maxProcessing: 1,
    maxFailures: 5,
    jumpOnFailure: true,
    autostart: true,
    isPaused: false,
    filo: false,
    debug: true
  });

  // Create a seperate ddp connection or use the passed in connection
  self.connection = options.connection || DDP.connect(Meteor.connection._stream.rawUrl);

  // Tie login for this connection to login for the main connection
  // XXX does not seem to work right now
  FS.Utility.connectionLogin(self.connection);

  // Keep track of uploaded files via this queue
  self.files = {};

  self.isUploadingFile = function(fileObj) {
    // Check if file is already in queue
    return !!(fileObj && fileObj._id && fileObj.collectionName && (self.files[fileObj.collectionName] || {})[fileObj._id]);
  };

  /** @method UploadTransferQueue.resumeUploadingFile
   * @param {FS.File} File to resume uploading
   * @todo Not sure if this is the best way to handle resumes
   */
  self.resumeUploadingFile = function (fileObj) {
    // Make sure we are handed a FS.File
    if (!(fileObj instanceof FS.File)) {
      throw new Error('Transfer queue expects a FS.File');
    }

    if (fileObj.isMounted()) {
      // This might still be true, preventing upload, if
      // there was a server restart without client restart.
      self.files[fileObj.collectionName] = self.files[fileObj.collectionName] || {};
      self.files[fileObj.collectionName][fileObj._id] = false;
      // Kick off normal upload
      self.uploadFile(fileObj);
    }
  };

  /** @method UploadTransferQueue.uploadFile
   * @param {FS.File} File to upload
   * @todo Check that a file can only be added once - maybe a visual helper on the FS.File?
   */
  self.uploadFile = function(fileObj) {
    // Make sure we are handed a FS.File
    if (!(fileObj instanceof FS.File)) {
      throw new Error('Transfer queue expects a FS.File');
    }

    // Make sure that we have size as number
    if (typeof fileObj.size !== 'number') {
      throw new Error('TransferQueue upload failed: fileObj size not set');
    }

    // We don't add the file if it's already in transfer or if already uploaded
    if (self.isUploadingFile(fileObj) || fileObj.isUploaded()) {
      return;
    }

    // Make sure the file object is mounted on a collection
    if (fileObj.isMounted()) {

      // Get the collection chunk size
      var chunkSize = fileObj.collection.options.chunkSize;

      // Calculate the number of chunks to upload
      var chunks = Math.ceil(fileObj.size / chunkSize);

      if (chunks === 0) return;

      // Create a sub queue
      var chunkQueue = new PowerQueue({
        onEnded: function oneChunkQueueEnded() {
          // Remove from list of files being uploaded
          self.files[fileObj.collectionName][fileObj._id] = false;
        },
        spinalQueue: ReactiveList,
        maxProcessing: 1,
        maxFailures: 5,
        jumpOnFailure: true,
        autostart: true,
        isPaused: false,
        filo: false
      });

      // Rig the custom task handler
      chunkQueue.taskHandler = _taskHandler;

      // Rig the error handler
      chunkQueue.errorHandler = _errorHandler;

      // Set flag that this file is being transfered
      self.files[fileObj.collectionName] = self.files[fileObj.collectionName] || {};
      self.files[fileObj.collectionName][fileObj._id] = true;

      // Add chunk upload tasks
      for (var chunk = 0, start; chunk < chunks; chunk++) {
        start = chunk * chunkSize;
        // Create and add the task
        // XXX should we somehow make sure we haven't uploaded this chunk already, in
        // case we are resuming?
        chunkQueue.add({
          chunk: chunk,
          name: fileObj.name,
          methodName: putMethodName,
          fileObj: fileObj,
          start: start,
          end: (chunk + 1) * chunkSize,
          connection: self.connection
        });
      }

      // Add the queue to the main upload queue
      self.add(chunkQueue);
    }

  };

  return self;
};

FS.DDP = {};

/**
 * @namespace FS
 * @type UploadTransferQueue
 *
 * There is a single uploads transfer queue per client (not per CFS)
 */
FS.DDP.uploadQueue = new UploadTransferQueue();
