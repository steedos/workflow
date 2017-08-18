# Options
AccountsTemplates.configure
  defaultLayout: 'loginLayout',
  defaultLayoutRegions: 
    nav: 'loginNav',
  defaultContentRegion: 'main',

  showForgotPasswordLink: true,
  overrideLoginErrors: true,
  enablePasswordChange: true,

  sendVerificationEmail: true,
  # enforceEmailVerification: true,
  # confirmPassword: true,
  # continuousValidation: false,
  # displayFormLabels: true,
  # forbidClientAccountCreation: true,
  # formValidationFeedback: true,
  homeRoutePath: '/',
  # showAddRemoveServices: false,
  # showPlaceholders: true,

  negativeValidation: true,
  positiveValidation: true,
  negativeFeedback: false,
  positiveFeedback: true,
  showLabels: false,

  # Privacy Policy and Terms of Use
  # privacyUrl: 'privacy',
  # termsUrl: 'terms-of-use',

  preSignUpHook: (password, options) ->
    options.profile.locale = Steedos.getLocale();




AccountsTemplates.configureRoute 'changePwd',
  path: '/steedos/change-password'
AccountsTemplates.configureRoute 'forgotPwd',
  path: '/steedos/forgot-password'
  redirect: '/steedos/forgot-password-token'
AccountsTemplates.configureRoute 'resetPwd',
  path: '/steedos/reset-password'
AccountsTemplates.configureRoute 'signIn',
  path: '/steedos/sign-in'
AccountsTemplates.configureRoute 'signUp',
  path: '/steedos/sign-up'
AccountsTemplates.configureRoute 'verifyEmail',
  path: '/steedos/verify-email'
AccountsTemplates.configureRoute 'enrollAccount',
  path: '/steedos/enroll-account'

# add fields within sign-up form
pwdField = AccountsTemplates.removeField('password');
AccountsTemplates.removeField('email');
AccountsTemplates.addFields([
  {
    _id: 'name',
    type: 'text'
  },
  {
    _id: "username",
    type: "text",
    displayName: "username",
    required: true,
    minLength: 5,
  },
  {
    _id: 'email',
    type: 'email',
    required: false
    displayName: "email",
    re: /.+@(.+){2,}\.(.+){2,}/,
    errStr: 'Invalid email',
    placeholder: {
      forgotPwd:"email_input_placeholder"
    }
  },
  {
    _id: 'username_and_email',
    type: 'text',
    required: true,
    displayName: "Login",
  },
  pwdField,
  {
    _id: 'company',
    type: 'text'
  },
  {
    _id: 'mobile',
    type: 'text'
  }
]);


if Meteor.isServer and Accounts.emailTemplates
  Accounts.emailTemplates.siteName = "Steedos";
  Accounts.emailTemplates.from = Meteor.settings.email?.from;


if Meteor.settings?.public?.accounts?.disableAccountRegistration
  AccountsTemplates.options.forbidClientAccountCreation = true
