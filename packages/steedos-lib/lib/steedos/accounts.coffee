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
AccountsTemplates.addFields([
  {
    _id: 'name',
    type: 'text'
  },
  {
    _id: 'company',
    type: 'text'
  },
  {
    _id: 'mobile',
    type: 'text'
  }
]);


if Meteor.isServer
  Accounts.emailTemplates.siteName = "Steedos";
  Accounts.emailTemplates.from = Meteor.settings.email.from;