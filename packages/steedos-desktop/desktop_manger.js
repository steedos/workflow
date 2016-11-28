
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
		type: 'checkbox', 
		label: '打开',
		click: function(){
			globalWin.show();
			globalWin.focus();
		}
	}));
	menu.append(new nw.MenuItem({ 
		type: 'checkbox', 
		label: '退出',
		click: function(){
			nw.App.quit();
		}
	}));

	tray.menu = menu;

	//click事件
	tray.on('click',function(){
		globalWin.show();
		globalWin.focus();
	});
}
