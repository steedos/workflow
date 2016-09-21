Array.prototype.filterProperty = function(h, l){
    var g = [];
    this.forEach(function(t){
        var m = t? t[h]:null;
        var d = false;
        if(m instanceof Array){
            d = m.includes(l);
        }else{
            d = (l === undefined)? false:m==l;
        }
        if(d){
            g.push(t);
        }
    });
    return g;
};

Array.prototype.getProperty = function(k){
    var v = new Array();
    this.forEach(function(t){
        var m = t? t[k]:null;
        v.push(m);
    });
    return v;
}

Array.prototype.getEach = function(code){
    var rev = [];
    for(var i = 0 ; i < this.length ; i++){
        rev.push(this[i][code]);
    }
    return rev;
};

Array.prototype.uniq = function(){
    var a = [];
    this.forEach(function(b){ 
        if(a.indexOf(b) < 0)
            {a[a.length] = b}
    });
    return a;
};

Form_formula = {};


Form_formula.mixin = function(dest, src){
    for(var key in src){
        dest[key] = src[key];
    }
    return dest;
};


Form_formula.handerUserObject = function(u){

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

Form_formula.handerOrgObject = function(o){

    if(o instanceof Array){
        var org = {};

        org.name = o.getProperty("name");
        org.fullname = o.getProperty("fullname");

        return org;
    }else{
        return o;
    }
}



/**
    * 获得公式需要用到的初始值
    * 输入：fields, values, applicant
    * 输出：__values
**/
Form_formula.init_formula_values = function(fields, autoFormDoc, approver, applicant, spaceId){
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
                            formulaTableValues.push(Form_formula.init_formula_values(tableFields, tableValue));
                        }, this);
                        //按主表的格式转换__tableValues加到
                        tableFields.forEach(function(tablefield){
                            __tableValues[tablefield.code] = formulaTableValues.getEach(tablefield.code);
                        });
                        __values = Form_formula.mixin(__values, __tableValues);
                    }
                } else if (type == 'user'){
                    __values[field.code] = Form_formula.handerUserObject(WorkflowManager.getFormulaUserObjects(spaceId, autoFormDoc[field.code]));

                } else if (type == 'group'){
                    __values[field.code] = Form_formula.handerOrgObject(WorkflowManager.getFormulaOrgObjects(autoFormDoc[field.code]));

                } else {
                    //此处传spaceId给选人控件的旧数据计算roles和organization
                    __values[field.code] = autoFormDoc[field.code];
                }
            }
        }, this);
    }
    //当前处理人
    __values["approver"] = WorkflowManager.getFormulaUserObject(approver);
    //申请人
    __values["applicant"] = WorkflowManager.getFormulaUserObject(applicant);

    return __values;
};

