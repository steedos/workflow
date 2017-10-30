var screenSizes = {
  xs: 480,
  sm: 768,
  md: 992,
  lg: 1200
};

Template.AdminLTE.onCreated(function () {
  var self = this;
  var skin = 'blue';
  var fixed = true;
  var sidebarMini = false;

  if (this.data) {
    skin = this.data.skin || skin;
    //fixed = this.data.fixed || fixed;
    sidebarMini = this.data.sidebarMini || sidebarMini;
  }

  fixed && $('body').addClass('fixed');
  sidebarMini && $('body').addClass('sidebar-mini');
  // self.removeClasses = function () {
  //   fixed && $('body').removeClass('fixed');
  //   sidebarMini && $('body').removeClass('sidebar-mini');
  // }

});

Template.AdminLTE.onRendered(function () {
  Steedos.fixSideBarScroll()
});

Template.AdminLTE.onDestroyed(function () {
  // this.removeClasses();
  // this.style.remove();
  // this.skin.remove();
});

Template.AdminLTE.helpers({
  isReady: function () {
    return Template.instance().isReady.get();
  },

  loadingTemplate: function () {
    return this.loadingTemplate || 'AdminLTE_loading';
  },

  skin: function () {
    return this.skin || 'blue';
  }
});

Template.AdminLTE.events({
  'click [data-toggle=offcanvas]': function (e, t) {
    e.preventDefault();

    //Enable sidebar push menu
    if ($(window).width() > (screenSizes.sm - 1)) {
      $("body").toggleClass('sidebar-collapse');
    }
    //Handle sidebar push menu for small screens
    else {
      if ($("body").hasClass('sidebar-open')) {
        $("body").removeClass('sidebar-open');
        $("body").removeClass('sidebar-collapse')
      } else {
        $("body").addClass('sidebar-open');
      }
    }

    if (Steedos && Steedos.fixSideBarScroll) 
      Steedos.fixSideBarScroll()
  },

  'click .main-sidebar': function (e, t) {
    if (Steedos && Steedos.isMobile()){
      //手机上可能菜单展开了，需要额外收起来
      $("body").removeClass("sidebar-open")
    }
  },

  'click .content-wrapper': function (e, t) {

    if (e.target && e.target.getAttribute)
      if (e.target.getAttribute("data-toggle") == "offcanvas")
        return
    if (e.target && e.target.parentElement && e.target.parentElement.getAttribute)
      if (e.target.parentElement.getAttribute("data-toggle") == "offcanvas")
        return
    //Enable hide menu when clicking on the content-wrapper on small screens
    if ($(window).width() <= (screenSizes.sm - 1) && $("body").hasClass("sidebar-open")) {
      $("body").removeClass('sidebar-open');
    }
  },

  'click .sidebar li a': function (e, t) {
    //Get the clicked link and the next element
    var $this = $(e.currentTarget);
    var checkElement = $this.next();

    //Check if the next element is a menu and is visible
    if ((checkElement.is('.treeview-menu')) && (checkElement.is(':visible'))) {
      //Close the menu
      checkElement.slideUp('normal', function () {
        checkElement.removeClass('menu-open');
      });
      checkElement.parent("li").removeClass("active");
    }
    //If the menu is not visible
    else if ((checkElement.is('.treeview-menu')) && (!checkElement.is(':visible'))) {
      //Get the parent menu
      var parent = $this.parents('ul').first();
      //Close all open menus within the parent
      var ul = parent.find('ul:visible').slideUp('normal');
      //Remove the menu-open class from the parent
      ul.removeClass('menu-open');
      //Get the parent li
      var parent_li = $this.parent("li");

      //Open the target menu and add the menu-open class
      checkElement.slideDown('normal', function () {
        //Add the class active to the parent li
        checkElement.addClass('menu-open');
        parent.find('li.active').removeClass('active');
        parent_li.addClass('active');
      });
    }
    else if ($(window).width() < (screenSizes.sm - 1)) {

      $("body").removeClass('sidebar-open');
      $("body").removeClass('sidebar-collapse')
    }
    //if this isn't a link, prevent the page from being redirected
    if (checkElement.is('.treeview-menu')) {
      e.preventDefault();
    }
  }
});
