WXBizMsgCrypt = Npm.require('wechat-crypto')

config = {
	token: "steedos",
	encodingAESKey: "vr8r85bhgaruo482zilcyf6uezqwpxpf88w77t70dow",
	corpId: "wweee647a39f9efa30"
}

newCrypt = new WXBizMsgCrypt(config.token, config.encodingAESKey, config.corpId);

# Meteor.startup ()->
JsonRoutes.add "get", "/api/qiyeweixin/callback", (req, res, next) ->
	console.log "************************"
	console.log req.query
	console.log "========================"

	msg_signature = req.query.msg_signature
	timestamp = req.query.timestamp
	nonce = req.query.nonce
	echostr = req.query.echostr

	if msg_signature!=newCrypt.getSignature(timestamp, nonce, echostr)
		res.writeHead 401
		res.end 'Invalid signature'
		return

	# 解密
	result = newCrypt.decrypt echostr
	message = result?.message

	console.log result
	console.log "========================"

	# 事件接受URL
	res.writeHead 200, {"Content-Type":"text/plain"}
	res.end result?.message || ''