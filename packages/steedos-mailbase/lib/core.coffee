Mail = {}


Meteor.startup ->
    if Meteor.isClient
        Accounts.onLogout ()->
            # 每次登出系统时设置_auth为空，否则切换用户时_auth值可以是上一次登录的账户
            AccountManager._auth = null