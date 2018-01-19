cfs:upload-ddp
=========================

This is a Meteor package that provides DDP uploads for
[CollectionFS](https://github.com/CollectionFS/Meteor-CollectionFS).

CollectionFS uses HTTP uploads by default because they currently work better,
but anyone with an interest in uploading over DDP can swap in this package
instead of the cfs:upload-http package.

## Custom Connection

To use a custom DDP connection for uploads, override the default
transfer queue with your own, passing in your custom connection:

```js
if (Meteor.isClient) {
  // There is a single downloads transfer queue per client (not per FS.Collection)
  FS.uploadQueue = new UploadTransferQueue({ connection: DDP.connect(myUrl) });
}
```
