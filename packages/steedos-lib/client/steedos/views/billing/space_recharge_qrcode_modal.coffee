Template.space_recharge_qrcode_modal.helpers


Template.space_recharge_qrcode_modal.onRendered ()->
	console.log this
	qrnode = new AraleQRCode({
		text: 'weixin://wxpay/bizpayurl?sr=XXXXX'
	})
	document.getElementById('qrcodeDefault').appendChild(qrnode)

Template.space_recharge_qrcode_modal.events
