[![Meteor Icon](http://icon.meteor.com/package/useraccounts:flow-routing)](https://atmospherejs.com/useraccounts/flow-routing)

# Flow Router add-on for User Accounts

User Accounts is a suite of packages for the [Meteor.js](https://www.meteor.com/) platform. It provides highly customizable user accounts UI templates for many different front-end frameworks. At the moment it includes forms for sign in, sign up, forgot password, reset password, change password, enroll account, and link or remove of many 3rd party services.

This package is an optional add-on for integration with [Flow Router][1] and either [Blaze Layout][2] or [React Layout][3].

## Blaze Configuration

Firstly, please ensure that your app depends upon the [Blaze Layout][2] package.

Then, before you configure routes for User Accounts with Flow Router, you will need to make sure you have set a few default configuration items.  


Assuming you have a main layout that looks like this:

```handlebars
<template name="myLayout">

  <div class="nav">
    {{> Template.dynamic template=nav}}
  </div>

  <div class="content">
    {{> Template.dynamic template=main}}
  </div>

  <footer>
    {{> Template.dynamic template=footer}}
  </footer>

</template>
```

You would configure this package to use it like this:

```js
AccountsTemplates.configure({
    defaultLayoutType: 'blaze', // Optional, the default is 'blaze'
    defaultTemplate: 'myCustomFullPageAtForm',
    defaultLayout: 'myLayout',
    defaultLayoutRegions: {
        nav: 'myNav',
        footer: 'myFooter'
    },
    defaultContentRegion: 'main'
});
```

If you don't have extra content regions (nav, footer, etc) you should pass an empty object to ```defaultLayoutRegions``` key of the config.

```js
AccountsTemplates.configure({
    defaultLayout: 'myLayout',
    defaultLayoutRegions: {},
    defaultContentRegion: 'main'
});
```

`useraccounts:flow-routing` uses the internal useraccounts `fullPageAtForm` is the built-in template useraccounts uses by default for its forms. You can override it on a per-route basis (see below) or replace it with `defaultTemplate:` field as above (templates specified in route config will still take precedence).  Omit `defaultTemplate` (or set to an empty string) to use the `fullPageAtForm` template built-in to your useraccounts UI package (ex [material](https://github.com/meteor-useraccounts/materialize/blob/master/lib/full_page_at_form.html)).

NOTE: The above configs must load BEFORE your AccountsTemplates routes are defined (next section).

## React Configuration

Firstly, please ensure that your app depends upon the [React Layout][3] and the [Blaze Layout][2] packages. User Accounts currents only renders Blaze templates. In order to use User Accounts with React we rely on the [Blaze To React][4] package to render the User Accounts templates.

Before you configure routes for User Accounts with Flow Router, you will need to make sure you have set a few default configuration items.  

Assuming you have a main layout that looks like following and you have `<Nav />` and `<Footer />` as your default nav/footer components:

```jsx
MainLayout = React.createClass({
  render() {
    return (
      <div>
        <header>
          {this.props.nav || <Nav />}
        </header>
        <main>
          {this.props.main}
        </main>
        <footer>
          {this.props.footer || <Footer />}
        </footer>
      </div>
    );
  }
});
```

You would then configure this package to use it like this:

```js
AccountsTemplates.configure({
  defaultLayoutType: 'blaze-to-react',
  defaultTemplate: 'fullPageAtForm',  // default
  defaultLayout: MainLayout,
  defaultLayoutRegions: {
    nav: <Nav />,
    footer: <Footer />
  },
  defaultContentRegion: 'main'
});
```

If you don't have extra content regions (nav, footer, etc) you should pass an empty object to the `defaultLayoutRegions` key of the config.

```js
AccountsTemplates.configure({
	defaultLayoutType: 'blaze-to-react',
  defaultTemplate: 'myCustomFullPageAtForm',
  defaultLayout: MainLayout,
  defaultLayoutRegions: {},
  defaultContentRegion: 'main'
});
```

`useraccounts:flow-routing` uses `fullPageAtForm` for the `defaultTemplate` option.  `fullPageAtForm` is the built-in Blaze template that all UserAccounts themed packages (Bootstrap, Materialize, etc.) use for their forms. You can override it on a per-route basis (see below) or replace it as shown above (templates specified in a route config will still take precedence).  Omit `defaultTemplate` (or set to an empty string) to use the `fullPageAtForm` template built-in to your useraccounts UI package (ex [material](https://github.com/meteor-useraccounts/materialize/blob/master/lib/full_page_at_form.html)).

Please note that this template must be a **Blaze** template. It will be rendered into your React layout using [Blaze To React][4].

NOTE: The above configs must load BEFORE your AccountsTemplates routes are defined (next section).

## Routes

There are no routes provided by default, but you can easily configure routes for sign in, sign up, forgot password, reset password, change password, enroll account using `AccountsTemplates.configureRoute`.  

The simplest way is to make the call passing in only a route code (available route codes are: signIn, signUp, changePwd, forgotPwd, resetPwd, enrollAccount).

This will set up the sign in route with a full-page form at `/sign-in`:

```js
AccountsTemplates.configureRoute('signIn');
```

You can also pass in more options to adapt it to your needs with:

```js
AccountsTemplates.configureRoute(route_code, options);
```

The following is a complete example of a custom route configuration:

##### Blaze

```js
// routes.js

AccountsTemplates.configureRoute('signIn', {
  layoutType: 'blaze',
  name: 'signin',
  path: '/login',
  template: 'myLogin',
  layoutTemplate: 'myLayout',
  layoutRegions: {
    nav: 'customNav',
    footer: 'customFooter'
  },
  contentRegion: 'main',
  redirect: '/user-profile'
});
```

##### React

```jsx
// routes.jsx

AccountsTemplates.configureRoute('signIn', {
  layoutType: 'blaze-to-react',
  name: 'signin',
  path: '/login',
  template: 'myLogin',
  layoutTemplate: CustomLayout,
  layoutRegions: {
    nav: <CustomNav />,
    footer: <CustomFooter />
  },
  contentRegion: 'main',
  redirect: '/user-profile'
});
```

All options are passed to FlowRouter.route() which then creates a new custom route (see the official Flow Router documentation [here](https://atmospherejs.com/kadira/flow-router) for more details).  

The `redirect` field permits to specify where to redirect the user after successful form submit. Actually, `redirect` can be a function so that, for example, the following:

```javascript
AccountsTemplates.configureRoute('signIn', {
    redirect: function(){
        var user = Meteor.user();
        if (user)
          Router.go('/user/' + user._id);
    }
});

Default values for all fields are as follows:

| Action          | route_code    | Route Name      | Route Path       | Template       | Redirect after Timeout |
| --------------- | ------------- | --------------- | ---------------  | -------------- |:----------------------:|
| change password | changePwd     | atChangePwd     | /change-password | fullPageAtForm |                        |
| enroll account  | enrollAccount | atEnrollAccount | /enroll-account  | fullPageAtForm |            X           |
| forgot password | forgotPwd     | atForgotPwd     | /forgot-password | fullPageAtForm |            X           |
| reset password  | resetPwd      | atResetPwd      | /reset-password  | fullPageAtForm |            X           |
| sign in         | signIn        | atSignIn        | /sign-in         | fullPageAtForm |                        |
| sign up         | signUp        | atSignUp        | /sign-up         | fullPageAtForm |                        |
| verify email    | verifyEmail   | atVerifyEmail   | /verify-email    | fullPageAtForm |            X           |
| resend verification email    | resendVerificationEmail   | atresendVerificationEmail   | /send-again    | fullPageAtForm |                        |

## Content Protection

If you want to protect a route by making sure a user is signed in, you can add the `AccountsTemplates.ensureSignedIn` check in your route's enter triggers like this:

```js
FlowRouter.route('/private', {
  triggersEnter: [AccountsTemplates.ensureSignedIn],
  action: function() {
    BlazeLayout.render(...);
    // or
    ReactLayout.render(...);
  }
});
```

If the user isn't signed in, they will be redirected to your sign in route and then redirected back to the original route after they have successfully signed in.

Or if you want to protect ALL routes in your app:

```js
FlowRouter.triggers.enter([AccountsTemplates.ensureSignedIn]);
```

[1]: https://atmospherejs.com/kadira/flow-router
[2]: https://atmospherejs.com/kadira/blaze-layout
[3]: https://atmospherejs.com/kadira/react-layout
[4]: https://atmospherejs.com/gwendall/blaze-to-react
