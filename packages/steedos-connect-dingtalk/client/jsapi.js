if (navigator.userAgent.indexOf('AliApp') > -1 && navigator.userAgent.indexOf('DingTalk') > -1) {
	// 移动端jsApi引入
	document.write('<script type="text/javascript" src="https://g.alicdn.com/ilw/ding/0.9.2/scripts/dingtalk.js"></script>');
} else if (navigator.userAgent.indexOf('AliApp') == -1 && navigator.userAgent.indexOf('DingTalk') > -1) {
	// PC端jsApi引入
	document.write('<script type="text/javascript" src="http://g.alicdn.com/dingding/dingtalk-pc-api/2.3.1/index.js"></script>');
}