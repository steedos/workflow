
if (Steedos.isNode()){
	
	// 客户端最小化后任务栏有图标
	var globalWin = nw.Window.get();
	var desktopTitle = process.cwd().split("\\")[2];
	var tray = new nw.Tray({ 
		title: desktopTitle,
		icon: 'images/icon.png'
	});

	tray.tooltip = desktopTitle;

	//添加菜单
	var menu = new nw.Menu();
	menu.append(new nw.MenuItem({
		label: '打开',
		click: function(){
			globalWin.show();
			globalWin.focus();
		}
	}));
	menu.append(new nw.MenuItem({
		label: '退出',
		click: function(){
			// 关闭客户端前记录当前url
			if (Meteor.userId()){
				var lastUrl = FlowRouter.current().path;
				localStorage.setItem('Steedos.lastURL:' + Meteor.userId(), lastUrl);
				globalWin.close(true);
			}
		}
	}));

	tray.menu = menu;

	//click事件
	tray.on('click',function(){
		globalWin.show();
		globalWin.focus();
	});
}
