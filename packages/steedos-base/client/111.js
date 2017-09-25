CoreForm.custom_numToCny = function (num) {
console.log(num);
console.log("custom_numToCny:",num);
console.log(typeof num);
// num = num.replace(/,/g,"");

if(isNaN(num))return "无效数值！";

var strPrefix="";

if(num<0)strPrefix ="(负)";

num=Math.abs(num);

if(num>=1000000000000)return "无效数值！";

var strOutput = "";

var strUnit = '仟佰拾亿仟佰拾万仟佰拾元角分';

var strCapDgt='零壹贰叁肆伍陆柒捌玖';

num += "00";

var intPos = num.indexOf('.');

if (intPos >= 0){

num = num.substring(0, intPos) + num.substr(intPos + 1, 2);

}

strUnit = strUnit.substr(strUnit.length - num.length);

for (var i=0; i < num.length; i++){

strOutput += strCapDgt.substr(num.substr(i,1),1) + strUnit.substr(i,1);

}

return strPrefix+strOutput.replace(/零角零分$/, '整').replace(/零[仟佰拾]/g, '零').replace(/零{2,}/g, '零').replace(/零([亿|万])/g,'$1').replace(/零+元/, '元').replace(/亿零{0,3}万/, '亿').replace(/^元/, "零元");

};