SteedosDataManager = {};

SteedosDataManager.organizationRemote = new AjaxCollection("organizations");
SteedosDataManager.spaceUserRemote = new AjaxCollection("space_users");
SteedosDataManager.flowRoleRemote = new AjaxCollection("flow_roles");


// 获取space_users
SteedosDataManager.getSpaceUsers = function (spaceId, userIds) {
  var q = {};
  q.spaceId = spaceId;
  var data = 
  {
    'userIds' : userIds
  }
  var spaceUsers;
  
  $.ajax({
    url: Meteor.absoluteUrl('api/workflow/getSpaceUsers') + '?' + $.param(q),
    type: 'POST',
    async: false,
    data: data,
    dataType: 'json',
    success: function(responseText, status) {
      if (responseText.errors) {
        toastr.error(responseText.errors);
        return;
      }

      spaceUsers = responseText.spaceUsers;
    },
    error: function(xhr, msg, ex) {
      toastr.error(msg);
    }
  });

  return spaceUsers;
}

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