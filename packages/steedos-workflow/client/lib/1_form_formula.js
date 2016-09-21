Form_formula = {};

CoreForm = {};

CoreForm.instanceform = {};


Form_formula.initFormScripts = function(formKey, eventName){
    try {
        
        form_version = WorkflowManager.getInstanceFormVersion();
        form_script = form_version.form_script;

        // 过滤换行：/\n/g ； 过滤空格 tab : /\s/g
        if(form_script && form_script.replace(/\n/g,"").replace(/\s/g,"").length > 0){
            //装载表单脚本
            eval(form_script);
            
            //运行OnLoad()脚本;
            if (CoreForm["form_OnLoad"] instanceof Function){
                eval("CoreForm.form_OnLoad();");
            }

            if (CoreForm[formKey][eventName] instanceof Function){
                eval("CoreForm."+formKey+"."+eventName+"();");
            }

        }else{
            console.log("脚本为空, 退出运算程序");
        }

    }catch (e){
        console.log("初始化表单脚本出错，错误信息: \n" + e);
    }
}


/*
    该函数实现把公式串中所有的表单字段加上__values前缀，并把花括号替换成中括号
    即把{字段名}替换成__values["字段名"]，
    子表字段{主表字段名.子表字段名}替换成__values["主表字段名"]["子表字段名"]，
    如果出现{字段名1}.{字段名2}会被替换成__values["字段名1"].__values["字段名2"]，
    字段名内的符号支持空格符，回车符，中英文，甚至纯数字在内的任意字符，
    其中字段名左右两侧如果有空格符，会被清除掉，
    但是中间的回车、空格等符号会保留。
    注意单引号及双引号内的字段名没有被排除，即只要是在花括号内的字符都会进行相关替换。
    另外目前这种做法不支持if/while等本身语句就带花括号符的写法
    参数prefix表示要加上的前缀串，即__values,参数fieldVariable表示要被替换的公式串，即formulaStr。
    在浏览器控制台中输入以下代码并执行可进行调试测试。
    var formulaStr = "{ 字 段1}={字段1 .字段2 };{字段1}={字段1}.{字段2};{字\n段1}={字段2}+1;{字段2}=sum({字段2});{字段2}='{字段2}',f8=\"{字段2}+{字段1}\";{字段1},f7=({字段1}+1),{字段2}=true;err={字段2}/{字段1};sum({字段1}；count({字段1.字段2})";
    CS.Utils.prependPrefixForFormula("__values",formulaStr)
*/
Form_formula.prependPrefixForFormula = function(prefix,fieldVariable){
    //console.debug("进入prependPrefixForFormula");
    var startTrack = new Date *1;
    
    var reg = /(\{[^{}]*\})/g;//匹配包括花括号自身在内的所有符号
    rev = fieldVariable.replace(reg,function(m,$1){
        //参数$1表示正则reg匹配到的每个item，即每对{}内的符号，并且包括花括号本身
        //把reg匹配到的每个item替换成带__values前缀，同时把花括号替换成中括号，并把其中的点号替换成][
        //同时把字段名左右两侧的空格符替换成空字符
        return prefix + $1.replace(/\{\s*/,"[\"").replace(/\s*\}/,"\"]").replace(/\s*\.\s*/g,"\"][\"");
    })

    //console.debug("return value : " + rev);
    //console.debug("退出 prependPrefixForFormula");
    //console.debug("消耗时间：" + (new Date() * 1 - startTrack) + "ms");
    return rev;
};
//return [Object]; Object["code"] , Object["formula"]
Form_formula.getFormulaFieldVariable = function(prefix,fields){
    //console.debug("进入 getFormulaFieldVariable");
    var startTrack = new Date *1;
    if (!fields) return ;
    var formulas = new Array();
    for(var i = 0; i <fields.length; i++){
        var formula = new Object();
        var field = fields[i];

        if (field.type != "table"&&field.type != "section"){
            if (field.formula && field.formula!=''){
                formula["code"] = field.code;
                if(field.type == 'number'){
                    formula["digits"] = field.digits;
                }
                formula["formula"] = '{' + field.code + '}=' + field.formula + ";"
                formulas.push(formula);
            }
        }else if(field.type=="section"){
            var sectionFields = field.fields;
            if(sectionFields) {
                for(var k=0;k<sectionFields.length;k++){
                    if(sectionFields[k].formula && sectionFields[k].formula != ''){
                        var formula = new Object();
                        formula["code"] = sectionFields[k].code;
                        if(sectionFields[k].type == 'number'){
                            formula["digits"] = sectionFields[k].digits;
                        }
                        formula["formula"] = '{' + sectionFields[k].code + '}=' + sectionFields[k].formula + ";"
                        formulas.push(formula);
                    }
                }
            }
        }
    }
    //排序
    var i=formulas.length,j;
    var sort_key;
    while(i > 0){
        for(j=0;j<i-1;j++){
            sort_key = formulas[j];
            field_code = sort_key["code"];
            if (!Form_formula.codeIsUseInFormula(field_code,formulas[j+1]["formula"])){
                formulas[j] = formulas[j + 1];
                formulas[j + 1] = sort_key; //如果当前字段被上一个字段的公式引用， 则当前字段与上个字段的位置互换
            }
        }
        i--;
    }

    for(var j = 0 ; j < formulas.length; j++){
        //给公式添加前缀
        formulas[j]["formula"] = Form_formula.prependPrefixForFormula(prefix,formulas[j]["formula"]);
    }
    //console.log("formula_field is \n" + JSON.stringify(formulas));
    //console.debug("退出 getFormulaFieldVariable 消耗时间：" + (new Date() * 1 - startTrack) + "ms");
    return formulas;
};
/**
* 判断传入参数code在formula中是否被引用
*/
Form_formula.codeIsUseInFormula = function(code,formula){
    if(code&&formula){
        
        //只有formula的长度大于code才可能会被引用
        //普通字段code
        var code2 = "{" + code + "}" ; 

        //如果code和formula相等 则表示直接被引用
        if(code2==formula){
            return true;
        }

        if(formula.length>code2.length){
            var splitFormula = formula.split(code2);
            
            for (var m = splitFormula.length - 2; m >= 0; m--) {
                var code_position = formula.search(code2);
                var pre_char = formula.charAt(code_position-1);
                var aft_char = formula.charAt(code_position+code2.length);
                if (pre_char.match(/\w/) == null && aft_char.match(/\w/) == null){
                    return true;
                }
            }   
        }
        //选人选组
        var code3 = "{" + code + "." ;
        if(formula.length>code3.length){
            var splitFormula = formula.split(code3);
            
            for (var m = splitFormula.length - 2; m >= 0; m--) {
                var code_position = formula.search(code3);
                var pre_char = formula.charAt(code_position-1);
                if (pre_char.match(/\w/) == null){
                    return true;
                }
            }   
        }
    }
    return false;
};

Form_formula.mixin = function(dest, src){
    for(var key in src){
        dest[key] = src[key];
    }
    return dest;
};

Form_formula.field_values = null;

Form_formula.run = function(code, field_prefix, formula_fields, autoFormDoc, fields){
    console.log('Form_formula.run......');
    var startTrack = new Date * 1;
    var run = false;

    if(!formula_fields || formula_fields.length < 1){
        return ;
    }

    if (!Form_formula.field_values || true){
        console.debug("消耗时间s0 ：" + (new Date * 1 - startTrack) + "ms");
        Form_formula.field_values = init_formula_values(fields,autoFormDoc);
        console.debug("消耗时间s1 ：" + (new Date * 1 - startTrack) + "ms");
    }

    //var field_permission = WorkflowManager.getInstanceFieldPermission();
    for(var i = 0 ; i < formula_fields.length; i++){
        formula_field = formula_fields[i];

        /*if(field_permission[formula_field.code] != 'editable'){
            continue;
        }*/

        if (code=='' || formula_field.formula.indexOf("[\"" + code + "\"]") > -1 || true){
            run = true;
        }
        if(run){
            try{
                var fileValue = eval(formula_field.formula.replace(/[\r\n]+/g, '\\n'));
                //console.log("formula is " + formula_field.formula);
                //console.log("fileValue is " + fileValue);
                if('digits' in formula_field){
                    var value = Form_formula.field_values[formula_field.code];
                    if(typeof(value) == 'number'){
                        value = value.toFixed(formula_field.digits);
                    }
                    $("[name='" + field_prefix + formula_field.code + "']").val(value);
                }else{
                    $("[name='" + field_prefix + formula_field.code + "']").val(Form_formula.field_values[formula_field.code]);
                }
            }catch(e){
                console.log("公式["+formula_field.formula+"]执行异常：" + e.message);
            }
        }
    }
    console.debug("消耗时间s2 ：" + (new Date * 1 - startTrack) + "ms");
    console.log('Form_formula.run end......');
};

Form_formula.getNextStepsFromCondition = function(step, autoFormDoc, fields){
    //定义要返回的步骤数组 
    var next_steps = new Array();

    lines = step.lines;

    Form_formula.field_values = init_formula_values(fields,autoFormDoc);
    //CoreForm.mainFormController.getPath("mainFormView.__values");

    lines.forEach(function(line){
        if(line.state == "submitted"){
            var conditionStr = line.condition.toString();
            conditionStr = conditionStr.replace(/\=/g,"==").replace(/\>==/g,">=").replace(/\<==/g,"<=").replace(/\======/g,"===").replace(/\====/g,"==");
            conditionStr = Form_formula.prependPrefixForFormula("Form_formula.field_values",conditionStr);

            try{
                if(eval(conditionStr.replace(/[\r\n]+/g, '\\n'))){
                    next_steps.push(WorkflowManager.getInstanceStep(line.to_step));
                }
            }catch(err){
                console.log("脚本["+conditionStr+"]执行异常：" + err.message);
            }

        }
    });
    return next_steps;
    
};

/**
    * 获得公式需要用到的初始值
    * 输入：fields, values, applicant
    * 输出：__values
**/

function init_formula_values(fields, autoFormDoc){
    var __values = {};
    //申请单中填的值处理
    if(fields && fields.length && autoFormDoc) {
        //debugger;
        fields.forEach(function(field){
            var type = field.type;
            if(type) {
                if(type === 'table') {
                    /*
                    * 将表格字段的值进行转换后传入__values中
                    * values中表格的值格式为
                    * [{"a":1,"b":4},{"a":2,"b":5},{"a":3,"b":6}]
                    * __values需要转化为下面格式且和主表的值一样放到第一层
                    * {"a":[1,2,3],"b":[4,5,6]}
                    **/
                    var tableFields = field.sfields,
                        tableValues = autoFormDoc[field.code],
                        formulaTableValues = [],
                        __tableValues = {};
                    //按公式的格式转换值为__tableValues
                    if(tableFields && tableFields.length && tableValues && tableValues instanceof Array) {
                        tableValues.forEach(function(tableValue){
                            formulaTableValues.push(init_formula_values(tableFields, tableValue));
                        }, this);
                        //按主表的格式转换__tableValues加到
                        tableFields.forEach(function(tablefield){
                            __tableValues[tablefield.code] = formulaTableValues.getEach(tablefield.code);
                        });
                        __values = Form_formula.mixin(__values, __tableValues);
                    }
                } else if (type == 'user'){

                    //__values[field.code] = WorkflowManager.getUser(autoFormDoc[field.code]);
                    __values[field.code] = handerUserObject(WorkflowManager.getFormulaUserObjects(autoFormDoc[field.code]));

                } else if (type == 'group'){

                    //__values[field.code] = WorkflowManager.getUser(autoFormDoc[field.code]);
                    __values[field.code] = handerOrgObject(WorkflowManager.getFormulaOrgObjects(autoFormDoc[field.code]));

                } else {
                    //此处传spaceId给选人控件的旧数据计算roles和organization
                    __values[field.code] = autoFormDoc[field.code];
                }
            }
        }, this);
    }
    //当前处理人
    __values["approver"] = WorkflowManager.getFormulaUserObject(localStorage.getItem("Meteor.userId"));
    //申请人
    __values["applicant"] = WorkflowManager.getFormulaUserObject(InstanceManager.getApplicantUserId());

    return __values;
};

function handerUserObject(u){

    if(u instanceof Array){
        var user = {};

        user.name = u.getProperty("name")
        user.organization = {};
        user.organization.name = u.getProperty("organization").getProperty("name");
        user.organization.fullname = u.getProperty("organization").getProperty("fullname");
        var userRoles = u.getProperty("roles");
        var roles = new Array();
        userRoles.forEach(function(i){
            roles = roles.concat(i);
        }); 
        roles.uniq();
        user.roles = roles;
        return user;
    }else{
        return u;
    }
}

function handerOrgObject(o){

    if(o instanceof Array){
        var org = {};

        org.name = o.getProperty("name");
        org.fullname = o.getProperty("fullname");

        return org;
    }else{
        return o;
    }
}


Array.prototype.getEach = function(code){
    var rev = [];
    for(var i = 0 ; i < this.length ; i++){
        rev.push(this[i][code]);
    }
    return rev;
};

//定义string的to_integer方法
String.prototype.to_integer = function(defaultValue)
{
    var r = parseInt(this);
    if (r||r==0) return r;
    else if(defaultValue||defaultValue==0) return defaultValue;
    else return null;
};
//定义string的to_float方法
String.prototype.to_float = function(defaultValue)
{
    var r = parseFloat(this);
    if (r||r==0) return r;
    else if(defaultValue||defaultValue==0)return defaultValue;
    else return null;
};
//定义Array的contains方法
Array.prototype.contains = function(ele)
{
    if(!ele) return false;
    var b=false;
    for(var i=0;i<this.length;i++){
        if(this[i]==ele){
            b=true;
        }
    }
    return b;
};

Array.prototype.uniq = function(){
    var a = [];
    this.forEach(function(b){ 
        if(a.indexOf(b) < 0)
            {a[a.length] = b}
    });
    return a;
};

Array.prototype.uniqById = function(){
    var a = [];
    var r = [];
    this.forEach(function(b){
        if(b){
            if("id" in b){
                if(a.indexOf(b.id) < 0){
                    a[a.length] = b.id;
                    r[r.length] = b;
                }
            }else if("_id" in b){
                if(a.indexOf(b._id) < 0){
                    a[a.length] = b._id;
                    r[r.length] = b;
                }
            }
        }
    });

    return r;
}

//子表的sum方法
function sum(sub_field_code_values){
    var ret_val=0;
    if(!sub_field_code_values || sub_field_code_values.length == 0) return ret_val;
    for(var i=0;i < sub_field_code_values.length;i++){
        if(sub_field_code_values[i]==undefined||sub_field_code_values[i]==""){
            sub_field_code_values[i]=0;
        }
        if(isNaN(sub_field_code_values[i])){
            throw new Error("sum(): 数据内容必须全为数字");
        }
        ret_val += sub_field_code_values[i].toString().to_float();
    }
    return ret_val;
};

//子表的average方法
function average(sub_field_code_values){
    if(!sub_field_code_values || sub_field_code_values.length == 0) return "";
    return sum(sub_field_code_values)/count(sub_field_code_values);
};

//计算数量
function  count(sub_field_code_values){
    if(!sub_field_code_values || sub_field_code_values.length == 0) return "";
    return sub_field_code_values.length;
};

function sortNumber(a,b){
    return  a - b;
};

//子表的max方法
function max(sub_field_code_values){
    if(!sub_field_code_values || sub_field_code_values.length == 0) return "";
    //检查数组的每个元素必须为数字
    for(var i=0;i < sub_field_code_values.length;i++){
        if(isNaN(sub_field_code_values[i])){
            throw new Error("max(): 数据内容必须全为数字");
        }else{
            sub_field_code_values[i] = sub_field_code_values[i].toString() .to_float();
        }
    }
    if(sub_field_code_values.length > 0){
        return sub_field_code_values.sort(sortNumber)[count(sub_field_code_values) - 1];
    }
};

//子表的min方法
function min(sub_field_code_values){
    if(!sub_field_code_values || sub_field_code_values.length == 0) return "";
     //检查数组的每个元素必须为数字
    for(var i=0;i < sub_field_code_values.length;i++){
        if(isNaN(sub_field_code_values[i])){
            throw new Error("min(): 数据内容必须全为数字");
        }else{
            sub_field_code_values[i] = sub_field_code_values[i] .toString().to_float();
        }
    }
    if(sub_field_code_values.length > 0){
        return sub_field_code_values.sort(sortNumber)[0];
    }
};
