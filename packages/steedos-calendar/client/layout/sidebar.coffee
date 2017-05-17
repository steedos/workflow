import Calendar from '../core'

calendarsDep = new Tracker.Dependency;
calendarsRange = null
calendarsLoading = false


Template.calendarSidebar.helpers 
	calendars: ()->
		userId= Meteor.userId();
		# console.log(userId);
		return Calendars.find()
	isCalendarOwner: ()->
		return this.ownerId == Meteor.userId()

Template.calendarSidebar.onRendered ->
	# 读取并刷新

Template.calendarSidebar.events 
	'click a.calendar-add': (event)->
		$('.btn.calendar-add').click();

	'click i.calendar-edit': (event)->
		# console.log(Meteor.userId()+"   "+this.ownerId);
		if Meteor.userId()!=this.ownerId
			swal("无权限","该账号无权限操作此日历","warning");
			return;
		Session.set("cmDoc", this);
		$('.btn.calendar-edit').click();

	'click i.calendar-show': (event)->
		Session.set("cmDoc", this);
		$('.btn.calendar-show').click();
		

	'click i.calendar-delete': (event)->
		if Meteor.userId()!=this.ownerId
			swal("无权限","该账号无权限操作此日历","warning");
			return;
		console.log(this);
		calendar_id=this._id;
		swal({
		  title: "删除日历",
		  text: "你确定删除此日历吗？与此日历相关联的事件也都将被删除。",
		  type: "warning",
		  showCancelButton: true,
		  cancelButtonText:"取消",
		  confirmButtonColor: "#DD6B55",
		  confirmButtonText: "确定",
		  closeOnConfirm: false,
		  html: false
		},
		# 删除表中的记录
		()->
			# this._id取值无法删除，删除失败,this未定义
			Calendars.remove {_id:calendar_id}, (error)->
				console.log(error);
				if error
					swal("删除失败",error.message,"error");
				else
					swal("删除成功","日历已被删除！","success");
		);