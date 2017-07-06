Template.space_recharge_qrcode_modal.helpers


Template.space_recharge_qrcode_modal.onRendered ()->
	console.log this
	that = this
	qrnode = new AraleQRCode({
		text: that.code_url
	})
	document.getElementById('qrcodeDefault').appendChild(qrnode)

Template.space_recharge_qrcode_modal.events
