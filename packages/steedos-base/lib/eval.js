// 因为meteor编译coffeescript会导致eval函数报错，所以单独写在一个js文件中。
Steedos.evalInContext = function(js, context) {
    //# Return the results of the in-line anonymous function we .call with the passed context
    return function() { 
    	return eval(js); 
	}.call(context);
}


Steedos.eval = function(js){
	try {
		var Template;
		if(this.Template){
			Template = this.Template
		}
		return eval(js)
	} catch (e) {
		console.log(js ,"error:" + e.message)
	}
}