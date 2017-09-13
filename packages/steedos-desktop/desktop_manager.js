if (Steedos.isNode()){

	var globalWin = nw.Window.get();

	// 刷新浏览器时，删除tray
	window.addEventListener('beforeunload', function() {
		if(window.name){
			// 在新打开的窗口中执行window.close会造成右下角托盘消失问题。
			// 所有Steedos.openWindow打开的窗口一定会带name属性
			return;
		}
		if (tray){
			tray.remove();
			tray = null;
		}
	});

	// 去除客户端右击事件
	document.body.addEventListener('contextmenu', function(ev) { 
		ev.preventDefault();
		return false;
	});
	
	// 关闭时判断
	globalWin.on("close",function(){
		if(globalWin.disableClose == false){
			if(globalWin.window && globalWin.window.name){
				globalWin.close(true);
			}
			else{
				globalWin.hide();
			}
		}
	});

	// App 再次打开是显示GlobalWin
	nw.App.on("open",function(args){
		globalWin.show();
		globalWin.focus();
	}); 

	if(process.platform == 'win32'){
		// 客户端最小化后任务栏有图标
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
				// 退出客户端前记录当前url
				if (globalWin.disableClose == false){
					if (Meteor.userId()){
						var lastUrl = FlowRouter.current().path;
						localStorage.setItem('Steedos.lastURL:' + Meteor.userId(), lastUrl);
					}
					nw.App.quit();
				}else{
					globalWin.show();
					globalWin.focus();
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
}