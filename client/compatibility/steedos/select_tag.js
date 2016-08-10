
/*
* 添加Array的remove函数
*/
Array.prototype.remove = function(from, to) {
	if(from < 0 ){
		return ;
	}   
    var rest = this.slice((to || from) + 1 || this.length);   
    this.length = from < 0 ? this.length + from : from;   
    return this.push.apply(this, rest);   
};

/*
* 添加Array的过滤器
* return 符合条件的对象Array
*/
Array.prototype.filterProperty = function(h, l){
	var g = [];
	this.forEach(function(t){
		var m = t ? t[h]:null;
		var d = false;
		if(m instanceof Array){
			d = m.includes(l);
		}else{
			if(m instanceof Object){
				if("id" in m){
					m = m["id"];
				}else if("_id" in m){
					m = m["_id"];
				}

			}
            if(l instanceof Array){
                d = (l === undefined) ? false : l.includes(m);
            }else{
                d = (l === undefined) ? false : m==l;
            }
		}

		if(d){
			g.push(t);
		}
	});
	return g;
}

/*
* 添加Array的过滤器
* return 符合条件的第一个对象
*/
Array.prototype.findPropertyByPK = function(h, l){
	var r = null;
	this.forEach(function(t){
		var m = t ? t[h]:null;
		var d = false;
		if(m instanceof Array){
			d = m.includes(l);
		}else{
			d = (l === undefined) ? false : m==l;
		}

		if(d){
			r = t;
		}
	});
	return r;
}

$(function(){

	if(!$("#selectTagModal").html()){
		$("body").append('<div class="modal fade selectTagModal" id="selectTagModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">  <div class="modal-dialog" role="document"><div class="modal-content">  <div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button><h4 class="modal-title" id="selectTagModalTitle">'+TAPi18n.__("select_tag_select_user")+'</h4>  </div>  <div id="selectTagModal-content" class="modal-body"></div><div class="modal-footer"><div class="row"><div class="col-md-8"><ui id="valueLabel_ui" class="valueLabel"><div id="valueLabel"></div></ui></div><div class="col-md-4"><div id="selectTagButton" class="selectTagButton"><button type="button" class="btn btn-default selectTagCancel" data-dismiss="modal">'+TAPi18n.__("select_tag_cancel")+'</button><button type="button" class="btn btn-primary selectTagOK" title="'+TAPi18n.__("select_tag_confirm")+'">'+TAPi18n.__("select_tag_confirm")+'</button>  </div></div</div></div> </div></div></div>');
	}

	if(!$("#selectTagTemplate").html()){
		$("body").append('<script id="selectTagTemplate" type="text/x-handlebars-template">{{#if showOrg}}<div class="box-header with-border">    <ol class="breadcrumb" style="float:left">    {{breadcrumb org}}    </ol></div>{{/if}}<div class="selectTagModal-body" id="selectTagModal-body">{{#if showOrg}}<div class="box box-solid"><div class="box-body no-padding"><ul class="nav nav-pills nav-stacked">{{#orgList org.children tagType showUser}}{{name}}{{/orgList}}</ul></div></div>{{/if}}{{#if showUser}}{{#if org.users}}<div class="box box-solid"><div class="box-body no-padding"><table id="selectTag-users" class="table table-bordered table-striped selectTag-users" width="100%" style="text-align:left"><thead style="display:none"><tr>  <th data-priority="1">'+TAPi18n.__("select_tag_username")+'</th></tr></thead><tbody>{{#userList org.users tagType}}{{name}}{{/userList}}</tbody></table></div></div>{{/if}}{{/if}}</div></script>');
	}
});


(function (define) {
	define(['jquery'], function ($) {
		return (function(){
			var $options ;
			var selectTag = {
				show : show,
				hide : hide,
				reload : reloadTag,
        checked : checked,
        values :[],
        valuesObject : getValuesObject
			}
			return selectTag;


      function init(){

        $(".selectTagOK").html($(".selectTagOK").prop("title") + " ( "+selectTag.values.length+" ) ")

        $("#valueLabel_ui").hide();

        if($options.showUser){
          $("#selectTagModalTitle").html(TAPi18n.__("select_tag_select_user"));
        }else{
          $("#selectTagModalTitle").html(TAPi18n.__("select_tag_select_organization"));
        }

        $(".selectTagOK").html(TAPi18n.__("select_tag_confirm"));
        $(".selectTagOK").prop("title",TAPi18n.__("select_tag_confirm"));
        $(".selectTagCancel").html(TAPi18n.__("select_tag_cancel"));
      }

      function getValuesObject(){

        var vo = new Array();
        var v = SelectTag.values;
        if(v){

            for(var i = 0 ; i < v.length; i ++){
               if($options.showUser){
                    vo.push($options.data.users.findPropertyByPK("id", v[i]));
                }else{
                    vo.push($options.data.orgs.findPropertyByPK("id", v[i]));
                } 
            }
        }
        return vo;
      }

      function checked(parentTag){
        var tag = $("input",parentTag)[0];
        if(tag.type == 'radio'){
            selectTag.values = [tag.value];
            $(".selectTagOK").click();
        }else{
            if(tag.checked){
                if(selectTag.values.indexOf(tag.value) < 0){
                  selectTag.values.push(tag.value);
                }
            }else{
                selectTag.values.remove(selectTag.values.indexOf(tag.value));
            }

            changeValueLabel();
            
            $(".selectTagOK").html($(".selectTagOK").prop("title") + " ( "+selectTag.values.length+" ) ")
        }
      }

      function changeValueLabel(){
        if(selectTag.values.length > 0){
          var html = '';
          selectTag.valuesObject().forEach(function(v){
            html = html + '\r\n<li data-value='+v.id+'>' + v.name + '</li>'
            //html = html + '\r\n<span><li data-value='+v.id+'>' + v.name + '</li><li class="remove"><i class="fa fa-times" aria-hidden="true"></i></li></span>'
          });
          $("#valueLabel").html(html);

          Sortable.create($("#valueLabel")[0], {
            group:"words",
            animation:150,
            onRemove:function(event){console.log("onRemove...")},
            onEnd: function(event){
              var values = [];
              $("#valueLabel li").each(function(){
                var li = this;
                values.push(li.dataset.value);
              });
              selectTag.values = values;
            }
          })

          $("#valueLabel_ui").show();
        }else{
          $("#valueLabel_ui").hide();
        }
      }

			/*
			* options : {} 
			* 	data: {orgs:[],users:[]}
			* 	multiple : false 单选，true 多选
			* 	showOrg : 是否显示部门
			* 	showUser : 是否显示用户。true : 用户可选择user 。 false ： 用户可选择 orgs。
			*	orgId : 第一层orgId
            *   org:
			* callback : 点击确认按钮的回调函数
			*/
			function show(options,callback){
        options.values = [];

        if(options.defaultValues && options.defaultValues.length > 0){
            selectTag.values = options.defaultValues;
            options.defaultValues = [];
        }else{
            selectTag.values = [];
        }
				//检查参数
				checkOptions(options);
				
				initOptions(options);
				
				reloadTag($options.orgId);

        $(".selectTagOK").attr('onclick',callback + ";SelectTag.hide();");
        
        init();

        if(!options.multiple){
          $(".selectTagOK").hide();
        }else{
          $(".selectTagOK").show();
          changeValueLabel();
        }

        $("#selectTagModal-content").css("max-height", ($(window).height()-180) + "px")
				$("#selectTagModal").modal('show');
			};
			
			function hide(){
				$("#selectTagModal").modal('hide');
			};

			function checkOptions(options){
				if(!options || !options.data)
					throw new Error(TAPi8n.__("select_tag_lack_of_parameters") + ",eg:show({orgs:[{id:'',name:'',parent:''}],users:[{id:'',name:'',orgs:[]}]})");
				
				return true;
			};
			
			function initOptions(options){
				if(!options.multiple){
					options.multiple = false;
                    options.tagType = 'radio';
				}else{
                    options.tagType = 'checkbox';
                }
				
				if(options.showOrg != false){
					options.showOrg = true;
				}
				
				if(options.showUser != false){
					options.showUser = true;
				}

        if(!options.orgId){
            options.orgId = '';
        }

        if(options.showOrg && options.data.users){
            options.data.users.forEach(function(u){
                if(organizations in u){
                    return ;
                }
                if(u.organization instanceof Object){
                    
                }else{
                    u.organization = options.data.orgs.findPropertyByPK("id", u.organization);
                }

                u.organizations = u.organization.parents.concat(u.organization.id);
            });
        }
				
				$options = $.extend({},options);
			};

			function reloadTag(orgId){
				var options = constructorOptions(orgId);
				var sourceTemplate = $("#selectTagTemplate").html();
				var template = Handlebars.compile(sourceTemplate);
				$('#selectTagModal-content').html(template(options));
          //$(".selectTag-profile").initial({charCount:1});
          setDefaultValues(options);
          //TODO 判断当前的用户数量，大于10就显示分页，否则不显示分页
          
          $("#selectTag-users").DataTable({
              paging:true,
              lengthChange:false,
              searching:false,
              ordering:false,
              info:false,
              autoWidth:true,
              language:{
                  oPaginate:{
                      sFirst: TAPi18n.__('select_tag_first'),
                      sPrevious: TAPi18n.__('select_tag_previous'),
                      sNext:TAPi18n.__('select_tag_next'),
                      sLast:TAPi18n.__('select_tag_last')
                  }
              },
              pagingType: "numbers"
          });
          
			};

      function setDefaultValues(options){
          var dfs= selectTag.values;
          dfs.forEach(function(v){
              $("#" + v).attr("checked",true);
          });
      }

			function constructorOptions(orgId){
        var org = {};
				if($options.showOrg){
                    
          org = $options.data.orgs.findPropertyByPK("id", orgId);

          if(org){
              org.parentOrg = getOrgParent(org.parent);
          }else{
              org = {};
          }

					org.children = getOrgChildren(orgId);
				}
				org.users = getUsers(orgId);

        $options.org = org;

				return $options;
			};

      function getOrgParent(parentOrgId){
          var org ;

          if(parentOrgId == '' || parentOrgId == 0 || !parentOrgId){
              return ;
          }else{
              org = $options.data.orgs.findPropertyByPK("id", parentOrgId);
          }

          if(org.parent != '' && org.parent != 0){
              org.parentOrg = getOrgParent(org.parent);
          }

          return org;
      };
			
			/*
			* return 传入orgId的直属组织
			*/
			function getOrgChildren (orgId){
				var orgChildren = new Array();
				if($options.data.orgs){
					if($options.showUser){
						$options.data.orgs.forEach(function(org){
							if(org){
								if(org.parent == orgId || (orgId == '' && !('parent' in org))){
									org.users = getUsers(org.id);
									orgChildren.push(org);
								}
							}
						});
					}else{
            if(orgId == ''){
              orgChildren = $options.data.orgs.filterProperty('is_company', true);
            }else{
              orgChildren = $options.data.orgs.filterProperty('parent', orgId);
            }
						
					}
				}
				return orgChildren;
			};

			/*
			* return 传入返回org下的所有用户
			*/
			function getUsers(orgId){
				var orgUsers = new Array();

				if(!$options.data.orgs || $options.data.orgs.length < 1){
					return $options.data.users;
				}

				if($options.data.users){
					orgUsers = $options.data.users.filterProperty('organizations',orgId);
				}
				return orgUsers;
			}
			
		})();
	});
}(function (deps, factory) {
	 window.SelectTag = factory(window.jQuery);
}));


Handlebars.registerHelper('orgList', function(items, tagType, showUser, options) {
  var out = "";
  if(!items) 
  	return;

  if(showUser){
      for(var i=0, l=items.length; i<l; i++) {
        out = out + "<li><a href=\"javascript:SelectTag.reload(\'"+items[i].id+"\')\">" +"<i class='fa fa-sitemap' aria-hidden='true' style='padding-right:4px'></i>"+ options.fn(items[i]);
        if(items[i].users){
        	out = out + "<span class='pull-right'>" + items[i].users.length + "<span class='glyphicon glyphicon-menu-right' style='font-size:13px;padding-left:5px;color:#ccc'></span></span>";
        }

        out = out + "</a></li>";
      }
  }else{
        items.forEach(function(item){
            out = out + "<li ><a class='org'><label style='height:100%;cursor:pointer;width:70%' onClick='SelectTag.checked(this)'><input type='"+tagType+"' name='selectTag-org' id='"+item.id+"' value='"+item.id+"'";

            if(tagType == "radio"){
              out = out + " style='display:none' ";
            }else{
              out = out + " style ='margin-top:0;vertical-align:middle;'";
            }
            out = out + "><i class='fa fa-sitemap' aria-hidden='true' style='padding-left:4px'></i><span style='vertical-align:middle;padding-left:4px'>" + options.fn(item) + "</span></label>";
            
            if(item.children && item.children.length > 0){
                out = out + "<span class='pull-right' style='cursor:pointer;width:30%;text-align:right' onClick=\"javascript:SelectTag.reload(\'"+item.id+"\')\"><i class='fa fa-angle-right' aria-hidden='true'></i></span>";
            }

            out = out + "</a>";

            out = out + "</li>";
        });
  }
	
  return new Handlebars.SafeString(out);
});

Handlebars.registerHelper('userList', function(items, tagType, options) {
  var out = "";
  if(!items) 
  	return;
  for(var i=0, l=items.length; i<l; i++) {
    out = out + "<tr ><td ><a class='user' ><label style='height:100%;width:100%;cursor:pointer;margin-bottom:2px;margin-top:2px;' onClick='SelectTag.checked(this)'><input type='"+tagType+"' name='selectTag-user' id='"+items[i].id+"' value='"+items[i].id+"'";
    if(tagType == "radio"){
      out = out + " style='display:none' ";
    }else{
      out = out + " style ='margin-top:0;vertical-align:middle'";
    }
    out = out +"><span style='vertical-align:middle;padding-left:4px'><img src='" + Meteor.absoluteUrl("/avatar/"+items[i].user+"?w=30&h=30&fs=14") +"' class='selectTag-profile img-circle'>" + options.fn(items[i]) + "</span></label></a></td></tr>";
  }
	
  return new Handlebars.SafeString(out);
});

Handlebars.registerHelper('breadcrumb', function(data) {
  var out = "";
  if(!data) 
  	return;
  function getLi(org){
  	if (!org || !org.name || org.name =='')
  		return "";
  	var o = '<li><a href="javascript:SelectTag.reload(\''+org.id+'\')">'+org.name+"</a></li>"
  	if(org.parentOrg){
  		o = getLi(org.parentOrg) + o;
  	}
  	return o;
  }
	
  out = getLi(data.parentOrg);
  out = '<li><a href="javascript:SelectTag.reload(\'\')"><i class="fa fa-home"></i></a></li>' + out;
  if(data.id && data.id !=0 && data.id !=''){
  	out = out + '<li class="active"><a href="javascript:void(0)">'+data.name+'</a></li>';//SelectTag.reload(\''+data.id+'\')
  }
  return new Handlebars.SafeString(out);
});