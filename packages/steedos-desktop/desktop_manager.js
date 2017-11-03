if (Steedos.isNode()){

	var globalWin = nw.Window.get();

	globalWin.maximize();

	var zoneArray = ["cn", "us", "beta"];
	var currentZone = window.location.host.split(".", 1);
	
	// 只在cn、us和beta域下存入cookie
	if (_.indexOf(zoneArray, currentZone[0]) > -1){
		// 首次登录客户端会在cookie中记录当前域名
		var zone = document.cookie.replace(/(?:(?:^|.*;\s*)X-Zone\s*\=\s*([^;]*).*$)|^.*$/, "$1");
		var expires = new Date();
		if (zone == ""){
			if (Steedos.userId() && !Meteor.loggingIn()){
				// 有效期为10年
				expires.setTime(expires.getTime() + 365 * 24 * 3600000 * 10);
				document.cookie = "X-Zone=" + window.location.origin + "; path=/; domain=.steedos.com; expires=" + expires.toGMTString();
			}
		}else{
			// 再次登录后判断是否与cookie中所存域名一致，不一致时提示跳转
			if (zone != window.location.origin){
				swal({
					title: t("steedos_desktop_zone_info"),
					type: "warning",
					showCancelButton: true,
					confirmButtonText: t("steedos_desktop_confirm"),
					cancelButtonText: t("steedos_desktop_cancel"),
					closeOnCancel: true
				}, function() {
					window.location = zone;
				})
			}
		}
	}

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

	var gui = nw.require("nw.gui");
	var cutMenu = new gui.MenuItem({
		label: "nw_menu_cut",
		click: function() {
			document.execCommand("cut");
		}
	});
	var copyMenu = new gui.MenuItem({
		label: "nw_menu_copy",
		click: function() {
			document.execCommand("copy");
		}
	});
	var pasteMenu = new gui.MenuItem({
		label: "nw_menu_paste",
		click: function() {
			document.execCommand("paste");
		}
	});
	var selectallMenu = new gui.MenuItem({
		label: "nw_menu_selectall",
		click: function() {
			document.execCommand("selectall");
		}
	});
	var reloadMenu = new gui.MenuItem({
		label: "nw_menu_reload",
		click: function() {
			window.location.reload(true);
		}
	});
	var gInputMenu = new gui.Menu;
	gInputMenu.append(cutMenu);
	gInputMenu.append(copyMenu);
	gInputMenu.append(pasteMenu);
	gInputMenu.append(selectallMenu);
	var gCopyMenu = new gui.Menu;
	gCopyMenu.append(copyMenu);
	var gMenu = new gui.Menu;
	gMenu.append(reloadMenu);

	$(function(){
		[cutMenu,copyMenu,pasteMenu,selectallMenu,reloadMenu].forEach(function(n){
			n.label = t(n.label);
		});
	});

	// 去除客户端右击事件
	document.body.addEventListener('contextmenu', function(ev) { 
		ev.preventDefault();
		var selectedText = window.getSelection().toString();
		if (!ev.target.disabled && (ev.target instanceof HTMLInputElement 
			|| ev.target instanceof HTMLTextAreaElement 
			|| ev.target.isContentEditable)) {
			cutMenu.enabled = true;
			copyMenu.enabled = true;
			pasteMenu.enabled = true;
			selectallMenu.enabled = true;
			if(!selectedText){
				cutMenu.enabled = false;
				copyMenu.enabled = false;
			}
			if(!gui.Clipboard.get().get()){
				pasteMenu.enabled = false;
			}
			if(!ev.target.value){
				selectallMenu.enabled = false;
			}
			gInputMenu.popup(ev.x, ev.y);
		}
		else if(selectedText){
			copyMenu.enabled = true;
			gCopyMenu.popup(ev.x, ev.y);
		}
		else{
			gMenu.popup(ev.x, ev.y);
		}
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
		globalWin.maximize();
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
				globalWin.maximize();
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
					globalWin.maximize();
					globalWin.focus();
				}
			}
		}));

		tray.menu = menu;

		//click事件
		tray.on('click',function(){
			globalWin.show();
			globalWin.maximize();
			globalWin.focus();
		});
	}
}