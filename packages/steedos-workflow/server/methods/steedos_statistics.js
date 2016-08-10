JsonRoutes.add("get", "/api/steedos/statistics/", function (req, res, next) {
	
	// 日期格式化 
	dateFormat = function(date){
		var datekey = ""+date.getFullYear()+"-"+(date.getMonth()+1)+"-"+(date.getDate());
		return datekey;
	};
	// 计算前一天时间
	yesterDay = function(){
		var dNow = new Date();   //当前时间
		var dBefore = new Date(dNow.getTime() - 24*3600*1000);   //得到前一天的时间
		return dBefore;
	};
	// 统计当日数据
	dailyStaticsCount = function(collection,space){
		var statics = collection.find({"space":space["_id"],"created":{$gt: yesterDay()}});
		return statics.count();
	};
	// 查询总数
	staticsCount = function(collection,space){
		var statics = collection.find({"space":space["_id"]});
		return statics.count();
	};
	// 查询拥有者名字
	ownerName = function(collection,space){
		var owner = collection.findOne({"_id":space["owner"]});
		var name = owner.name;
		return name;
	};
	// 最近登录日期
	lastLogon = function(collection,space){
		var lastLogon = 0;
		var sUsers = db.space_users.find({"space":space["_id"]});
		if (sUsers && (sUsers.count() > 0)){
			sUsers.forEach(function(sUser){
				var user = collection.findOne({"_id":sUser["user"]});
				if(user && (lastLogon < user.last_logon)){
					lastLogon = user.last_logon;
				}
			})
		}
		return lastLogon;
	};
	// 最近修改日期
	lastModified = function(collection,space){
		var lastModified = 0;
		var obj = collection.find({"space":space["_id"]});
		obj.forEach(function(object){
			if(lastModified < object.modified){
				lastModified = object.modified;
			}
		})
		return lastModified;
	};
	// 文章附件大小
	postsAttachments = function(collection,space){
		var attSize = 0;
		var sizeSum = 0;
		var cposts = collection.find({"space":space["_id"]});
		cposts.forEach(function(post){
			var atts = cfs.posts.find({"post":post["_id"]});
			// var atts = eval(collection);
			atts.forEach(function(att){
				attSize = att.original.size;
				sizeSum += attSize;
			})	
		})
		return sizeSum;
	};
	// 当日新增附件大小
	dailyPostsAttachments = function(collection,space){
		var attSize = 0;
		var sizeSum = 0;
		var cposts = collection.find({"space":space["_id"]});
		cposts.forEach(function(post){
			var atts = cfs.posts.find({"post":post["_id"],"uploadedAt":{$gt: yesterDay()}});
			// var atts = eval(collection);
			atts.forEach(function(att){
				attSize = att.original.size;
				sizeSum += attSize;
			})	
		})
		return sizeSum;
	}
	// var postsAtt = 'posts.filerecord.find({post:post["_id"],uploadedAt:{$gt: yesterDay()}})';
	// 插入数据
	var i = 0;
	db.spaces.find({"is_paid":true}).forEach(function(space){
		i++;
		console.log(i);
		db.steedos_statistics.insert({
			// _id: ObjectId().str,
			space: space["_id"],
			space_name: space["name"],
			balance: space["balance"],
			owner_name: ownerName(db.users,space),
			created: new Date(),
			steedos:{
				users:staticsCount(db.space_users,space),
				organizations:staticsCount(db.organizations,space),
				last_logon:lastLogon(db.users,space)
			},
			workflow:{
				flows:staticsCount(db.flows,space),
				forms:staticsCount(db.forms,space),
				flow_roles:staticsCount(db.flow_roles,space),
				flow_positions:staticsCount(db.flow_positions,space),
				instances:staticsCount(db.instances,space),
				instances_last_modified:lastModified(db.instances,space),
				daily_flows:dailyStaticsCount(db.flows,space),
				daily_forms:dailyStaticsCount(db.forms,space),
				daily_instances:dailyStaticsCount(db.instances,space)
			},
			cms:{
				sites:staticsCount(db.cms_sites,space),
				posts:staticsCount(db.cms_posts,space),
				posts_last_modified:lastModified(db.cms_posts,space),
				posts_attachments_size:postsAttachments(db.cms_posts,space),
				comments:staticsCount(db.cms_comments,space),
				daily_sites:dailyStaticsCount(db.cms_sites,space),
				daily_posts:dailyStaticsCount(db.cms_posts,space),
				daily_comments:dailyStaticsCount(db.cms_comments,space),
				daily_posts_attachments_size:dailyPostsAttachments(db.cms_posts,space)
			}
		});
	})

	JsonRoutes.sendResult(res, {
    	data: {
      	ret: 0,
      	msg: "Successfully"
    	}
  	});
})