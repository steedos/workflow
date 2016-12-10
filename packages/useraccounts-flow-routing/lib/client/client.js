/* global
  AccountsTemplates: false,
  BlazeLayout: false,
  grecaptcha: false,
  FlowRouter: false,
  $: false
*/
'use strict';


// Previous path used for redirect after form submit
AccountsTemplates._prevPath = null;

// Possibly keeps reference to the handle for the timed out redirect
// set on some routes
AccountsTemplates.timedOutRedirect = null;


AccountsTemplates.clearState = function() {
  _.each(this._fields, function(field) {
    field.clearStatus();
  });
  var form = this.state.form;
  form.set('error', null);
  form.set('result', null);
  form.set('message', null);

  AccountsTemplates.setDisabled(false);

  // Possibly clears timed out redirects
  if (AccountsTemplates.timedOutRedirect !== null) {
    Meteor.clearTimeout(AccountsTemplates.timedOutRedirect);
    AccountsTemplates.timedOutRedirect = null;
  }
};

AccountsTemplates.getparamToken = function() {
  return FlowRouter.getParam('paramToken');
};

// Getter for previous route's path
AccountsTemplates.getPrevPath = function() {
  return this._prevPath;
};

// Setter for previous route's path
AccountsTemplates.setPrevPath = function(newPath) {
  check(newPath, String);
  this._prevPath = newPath;
};

AccountsTemplates.ensureSignedIn = function(context, redirect) {
  if (!Meteor.userId()) {
    // if we're not already on an AT route
    if (!_.contains(AccountsTemplates.knownRoutes, context.route.name)) {

      AccountsTemplates.setState(AccountsTemplates.options.defaultState, function() {
        var err = AccountsTemplates.texts.errors.mustBeLoggedIn;
        AccountsTemplates.state.form.set("error", [err]);
      });

      // redirect settings
      AccountsTemplates.avoidRedirect = true;
      AccountsTemplates.avoidClearError = true;
      AccountsTemplates.redirectToPrevPath = true;

      // redirect to defined sign-in route and then redirect back
      // to original route after successful sign in
      var signInRouteName = AccountsTemplates.getRouteName('signIn');
      if (signInRouteName) {
        redirect(signInRouteName);
      }
      else {
        throw Error('[ensureSignedIn] no signIn route configured!');
      }
    }
  }
};

// Stores previous path on path change...
FlowRouter.triggers.exit([
  function(context) {
    var routeName = context.route.name;
    var knownRoute = _.contains(AccountsTemplates.knownRoutes, routeName);
    if (!knownRoute) {
      AccountsTemplates.setPrevPath(context.path);
    }
  }
]);

AccountsTemplates.linkClick = function(route) {
  if (AccountsTemplates.disabled()) {
    return;
  }
  var path = AccountsTemplates.getRoutePath(route);
  if (path === '#' || AccountsTemplates.avoidRedirect || path === FlowRouter.current().path) {
    AccountsTemplates.setState(route);
  } else {
    Meteor.defer(function() {
      FlowRouter.go(path);
    });
  }

  if (AccountsTemplates.options.focusFirstInput) {
    var firstVisibleInput = _.find(this.getFields(), function(f) {
      return _.contains(f.visible, route);
    });
    if (firstVisibleInput) {
      $('input#at-field-' + firstVisibleInput._id).focus();
    }
  }
};

AccountsTemplates.logout = function() {
  var onLogoutHook = AccountsTemplates.options.onLogoutHook;
  var homeRoutePath = AccountsTemplates.options.homeRoutePath;
  Meteor.logout(function() {
    if (onLogoutHook) {
      onLogoutHook();
    } else if (homeRoutePath) {
      FlowRouter.redirect(homeRoutePath);
    }
  });
};

AccountsTemplates.postSubmitRedirect = function(route) {
  if (AccountsTemplates.avoidRedirect) {
    AccountsTemplates.avoidRedirect = false;
    if (AccountsTemplates.redirectToPrevPath) {
      FlowRouter.redirect(AccountsTemplates.getPrevPath());
    }
  } else {
    var nextPath = AccountsTemplates.routes[route] && AccountsTemplates.routes[route].redirect;
    if (nextPath) {
      if (_.isFunction(nextPath)) {
        nextPath();
      } else {
        FlowRouter.go(nextPath);
      }
    } else {
      var previousPath = AccountsTemplates.getPrevPath();
      if (previousPath && FlowRouter.current().path !== previousPath) {
        FlowRouter.go(previousPath);
      } else {
        var homeRoutePath = AccountsTemplates.options.homeRoutePath;
        if (homeRoutePath) {
          FlowRouter.go(homeRoutePath);
        }
      }
    }
  }
};

AccountsTemplates.submitCallback = function(error, state, onSuccess) {

  var onSubmitHook = AccountsTemplates.options.onSubmitHook;
  if (onSubmitHook) {
    onSubmitHook(error, state);
  }

  if (error) {
    if (_.isObject(error.details)) {
      if (error.error === 'validation-error') {
        // This error is a ValidationError from the mdg:validation-error package.
        // It has a well-defined error format

        // Record errors that don't correspond to fields in the form
        var errorsWithoutField = [];

        _.each(error.details, function(fieldError) {
          var field = AccountsTemplates.getField(fieldError.name);

          if (field) {
            // XXX in the future, this should have a way to do i18n
            field.setError(fieldError.type);
          } else {
            errorsWithoutField.push(fieldError.type);
          }
        });

        if (errorsWithoutField) {
          AccountsTemplates.state.form.set('error', errorsWithoutField);
        }
      } else {
        // If error.details is an object, we may try to set fields errors from it
        _.each(error.details, function(error, fieldId) {
          AccountsTemplates.getField(fieldId).setError(error);
        });
      }
    } else {
      var err = 'error.accounts.Unknown error';
      if (error.reason) {
        err = error.reason;
      }
      if (err.substring(0, 15) !== 'error.accounts.') {
        err = 'error.accounts.' + err;
      }
      AccountsTemplates.state.form.set('error', [err]);
    }
    AccountsTemplates.setDisabled(false);
    // Possibly resets reCaptcha form
    if (state === 'signUp' && AccountsTemplates.options.showReCaptcha) {
      grecaptcha.reset();
    }
  } else {
    if (onSuccess) {
      onSuccess();
    }

    if (_.contains(['enrollAccount', 'forgotPwd', 'resetPwd', 'verifyEmail'], state)) {
      var redirectTimeout = AccountsTemplates.options.redirectTimeout;
      if (redirectTimeout > 0) {
        AccountsTemplates.timedOutRedirect = Meteor.setTimeout(function() {
          AccountsTemplates.timedOutRedirect = null;
          AccountsTemplates.setDisabled(false);
          AccountsTemplates.postSubmitRedirect(state);
        }, redirectTimeout);
      }
    } else if (state) {
      AccountsTemplates.setDisabled(false);
      AccountsTemplates.postSubmitRedirect(state);
    }
  }
};

// Initialization
if (FlowRouter && FlowRouter.initialize) {
  // In order for ensureSignIn triggers to work,
  // AccountsTemplates must be initialized before FlowRouter
  // (this is now true since useraccounts:core is being executed first...)
  var oldInitialize = FlowRouter.initialize;
  FlowRouter.initialize = function() {
    AccountsTemplates._init();
    oldInitialize.apply(this, arguments);
  };
}
