var request = require('request');

/**
 * 日志封装，方便后期日志多样化处理
 **/
function log() {
    args = Array.prototype.slice.call(arguments);
}


Dingtalk.API = function(config) {
    var defaults = {
        domain: 'https://oapi.dingtalk.com',
        corp_id: 'CorpID',
        corp_secret: 'Corp_Secret',

        redirect_uri: 'REDIRECT_URI'
    };
    this.config = _.merge(defaults, config);
    this.token = null;
    this.tokenCreateTime = null;
    this.tokenExpireTime = 7200 * 1000;
}

/**
 * 获取token
 * @param {function} callback 回调
 * @returns {null} 
 **/
 Dingtalk.API.prototype.getToken = function(callback) {
    //log('获取token')
    var corp_id = this.config.corp_id;
    var corp_secret = this.config.corp_secret;
    request({
        method: 'GET',
        url: this.config.domain + '/gettoken',
        json: true,
        qs: {
            corpid: corp_id,
            corp_secret: corp_secret    
        }
    }, function(err, response, body) {
        if (err) {
            //log('出错了', err);
            return callback(err);
        }
        //log('返回数据', body);
        var json = body;
        var errcode = json.errcode;
        if (errcode !== 0) {
            //log(json);
        }
        this.token = json.access_token;
        this.tokenCreateTime = Date.now();

        callback(err, json);
    })
}

/**
 * 统一请求接口
 * @param {string} path 请求路径，bui自动拼接成完整的url
 * @param {object} params 请求参数集合
 * @param {function} callback  回调，请求成功与否都会触发回调，成功回调会回传数据
 * @returns {null} 
 **/
 Dingtalk.API.prototype.doRequest = function(path, params, callback) {
    var _this = this;
    var action = function(t) {
        var url = _this.config.domain + '/' + path;
        if (t) {
            url += '?access_token=' + t;
        }
        var method = 'GET';
        if (params.method === 'POST') {
            delete params.method;
            method = 'POST';
        }
        var obj = {
            method: method,
            url: url,
            json: true
        };

        if (method === 'POST') {
            obj.body = params;
        } else {
            obj.qs = params;
        }
        //log('请求参数：', obj)
        request(obj, function(err, response, body) {
            if (err) {
                //log('出错了', err);
                return callback(err);
            }
            //log('返回数据', body);
            var json = body;
            var errcode = json.errcode;
            if (errcode !== 0) {
                //log(json);
            }
            callback(err, json);
        })
    };
    //如果有判断三种情况：1token没过期； 2不检查token； 3token过期或者没有设置token等情况
    if ((this.token && this.tokenCreateTime && (Date.now() - this.tokenCreateTime < this.tokenExpireTime))) {
        action(this.token);
    } else {
        //log('token过期或者未设置')
        this.getToken(function(err, json) {
            if (err) {
                return callback(err);
            }
            action(json.access_token);
        });
    }
}


var corpApis = [
    {
        path: 'department/list',
        alias: '',
        method: 'GET'
    },{
        path: 'department/create',
        method: 'POST'
    },{
        path: 'department/update',
        method: 'POST'
    },{
        path: 'department/delete',
        method: 'GET'
    },{
        path: 'user/get',
        method: 'GET'
    },{
        path: 'user/create',
        method: 'POST'
    },{
        path: 'user/update',
        method: 'POST'
    },{
        path: 'user/delete',
        method: 'GET'
    },{
        path: 'user/batchdelete',
        method: 'POST'
    },{
        path: 'user/simplelist',
        method: 'GET'
    },{
        path: 'user/list',
        method: 'GET'
    },{
        path: 'call_back/register_call_back',
        method: 'POST'
    },{
        path: 'call_back/get_call_back',
        method: 'GET'
    },{
        path: 'call_back/update_call_back',
        method: 'POST'
    },{
        path: 'call_back/delete_call_back',
        method: 'GET'
    },{
        path: 'call_back/get_call_back_failed_result',
        alias: '',
        method: 'GET'
    },{
        path: 'message/send_to_conversation',
        method: 'POST'
    },{
        path: 'message/send',
        method: 'POST'
    },{
        path: 'media/upload',
        method: 'POST'
    },{
        path: 'media/get',
        method: 'GET'
    },{
        path: 'data/record',
        method: 'POST'
    },{
        path: 'get_jsapi_ticket',
        method: 'GET'
    },{
        path: 'user/getuserinfo',
        method: 'GET'
    }
]

/**
 * 批量生成接口
 **/
corpApis.forEach(function(item) {
    var p = item.path;
    var method = item.method;
    var alias = item.alias;
    var functionName = alias || p.replace("/", "_");
    Dingtalk.API.prototype[functionName] = function(params, callback) {
        if (_.isFunction(params)) {
            callback = params;
            params = {};
        }
        var params = params || {};
        var callback = callback || function() {};
        if (method === 'POST') {
            params.method = 'POST';
        }
        this.doRequest(p, params, function(err, json) {
            if (err) {
                //log('获取数据失败');
            }
            callback(err, json);
        });
    }
});
