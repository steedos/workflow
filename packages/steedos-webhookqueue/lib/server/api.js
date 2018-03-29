var isConfigured = false;
var sendWorker = function(task, interval) {

	if (WebhookQueue.debug) {
		console.log('WebhookQueue: Send worker started, using interval: ' + interval);
	}

	return Meteor.setInterval(function() {
		try {
			task();
		} catch (error) {
			if (WebhookQueue.debug) {
				console.log('WebhookQueue: Error while sending: ' + error.message);
			}
		}
	}, interval);
};

/*
	options: {
		// Controls the sending interval
		sendInterval: Match.Optional(Number),
		// Controls the sending batch size per interval
		sendBatchSize: Match.Optional(Number),
		// Allow optional keeping notifications in collection
		keepWebhooks: Match.Optional(Boolean)
	}
*/
WebhookQueue.Configure = function(options) {
	var self = this;
	options = _.extend({
		sendTimeout: 60000, // Timeout period for webhook send
	}, options);

	// Block multiple calls
	if (isConfigured) {
		throw new Error('WebhookQueue.Configure should not be called more than once!');
	}

	isConfigured = true;

	// Add debug info
	if (WebhookQueue.debug) {
		console.log('WebhookQueue.Configure', options);
	}

	self.sendWebhook = function(webhook) {
		if (WebhookQueue.debug) {
			console.log("sendWebhook");
			console.log(webhook);
		}

		HTTP.call('POST', webhook.webhook.payload_url, {
			headers: {
				"Content-Type": webhook.webhook.content_type
			},
			data: {
				instance: webhook.webhook.instance,
				current_approve: webhook.webhook.current_approve,
				action: webhook.webhook.action,
				from_user: webhook.webhook.from_user,
				to_users: webhook.webhook.to_users
			}
		}, function(error, result) {
			if (error) {
				console.error(error);
			}
		});

	}

	// Universal send function
	var _querySend = function(options) {

		if (self.sendWebhook) {
			self.sendWebhook(options);
		}

		return {
			webhook: [options._id]
		};
	};

	self.serverSend = function(options) {
		options = options || {};
		return _querySend(options);
	};


	// This interval will allow only one webhook to be sent at a time, it
	// will check for new webhooks at every `options.sendInterval`
	// (default interval is 15000 ms)
	//
	// It looks in webhooks collection to see if theres any pending
	// webhooks, if so it will try to reserve the pending webhook.
	// If successfully reserved the send is started.
	//
	// If webhook.query is type string, it's assumed to be a json string
	// version of the query selector. Making it able to carry `$` properties in
	// the mongo collection.
	//
	// Pr. default webhooks are removed from the collection after send have
	// completed. Setting `options.keepWebhooks` will update and keep the
	// webhook eg. if needed for historical reasons.
	//
	// After the send have completed a "send" event will be emitted with a
	// status object containing webhook id and the send result object.
	//
	var isSendingWebhook = false;

	if (options.sendInterval !== null) {

		// This will require index since we sort webhooks by createdAt
		WebhookQueue.collection._ensureIndex({
			createdAt: 1
		});
		WebhookQueue.collection._ensureIndex({
			sent: 1
		});
		WebhookQueue.collection._ensureIndex({
			sending: 1
		});


		var sendWebhook = function(webhook) {
			// Reserve webhook
			var now = +new Date();
			var timeoutAt = now + options.sendTimeout;
			var reserved = WebhookQueue.collection.update({
				_id: webhook._id,
				sent: false, // xxx: need to make sure this is set on create
				sending: {
					$lt: now
				}
			}, {
				$set: {
					sending: timeoutAt,
				}
			});

			// Make sure we only handle webhooks reserved by this
			// instance
			if (reserved) {

				// Send the webhook
				var result = WebhookQueue.serverSend(webhook);

				if (!options.keepWebhooks) {
					// Pr. Default we will remove webhooks
					WebhookQueue.collection.remove({
						_id: webhook._id
					});
				} else {

					// Update the webhook
					WebhookQueue.collection.update({
						_id: webhook._id
					}, {
						$set: {
							// Mark as sent
							sent: true,
							// Set the sent date
							sentAt: new Date(),
							// Not being sent anymore
							sending: 0
						}
					});

				}

				// Emit the send
				self.emit('send', {
					webhook: webhook._id,
					result: result
				});

			} // Else could not reserve
		}; // EO sendWebhook

		sendWorker(function() {

			if (isSendingWebhook) {
				return;
			}
			// Set send fence
			isSendingWebhook = true;

			var batchSize = options.sendBatchSize || 1;

			var now = +new Date();

			// Find webhooks that are not being or already sent
			var pendingWebhooks = WebhookQueue.collection.find({
				$and: [
					// Message is not sent
					{
						sent: false
					},
					// And not being sent by other instances
					{
						sending: {
							$lt: now
						}
					}
				]
			}, {
				// Sort by created date
				sort: {
					createdAt: 1
				},
				limit: batchSize
			});

			pendingWebhooks.forEach(function(webhook) {
				try {
					sendWebhook(webhook);
				} catch (error) {

					if (WebhookQueue.debug) {
						console.log('WebhookQueue: Could not send webhook id: "' + webhook._id + '", Error: ' + error.message);
					}
				}
			}); // EO forEach

			// Remove the send fence
			isSendingWebhook = false;
		}, options.sendInterval || 15000); // Default every 15th sec

	} else {
		if (WebhookQueue.debug) {
			console.log('WebhookQueue: Send server is disabled');
		}
	}

};
