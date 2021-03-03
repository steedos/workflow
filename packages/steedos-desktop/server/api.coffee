Cookies = Npm.require("cookies")
# parser = Npm.require('xml2json')

JsonRoutes.add "get", "/api/iam/desktop_sso", (req, res, next) ->
    user_id = req?.query?.userId;

    cookies = new Cookies( req, res );
    userId = cookies.get("X-User-Id")
    authToken = cookies.get("X-Auth-Token")
    
    if !user_id
        res.writeHead 302, {'Location': '/'}
        return res.end ''

    user = db.space_users.findOne({ $or: [ {email: user_id}, { username: user_id}]},{fields:{user:1}});
    
    if !user
        return res.end ''
    
    # 如果本地已经有cookies
    if userId and authToken
        # 比较本地数据和当前用户是否一致
        if user.user!=userId
            # 不一致，清除信息
            Setup.clearAuthCookies(req, res)
            hashedToken = Accounts._hashLoginToken(authToken)
            Accounts.destroyToken(userId, hashedToken)
        else
            console.log "userId and authToken-----"
            res.writeHead 302, {'Location': '/'}
            return res.end ''
    
    # 验证成功，登录
    authToken = Accounts._generateStampedLoginToken()
    hashedToken = Accounts._hashStampedToken authToken
    Accounts._insertHashedLoginToken user.user,hashedToken
    Setup.setAuthCookies req,res,user.user,authToken.token
    console.log "/api/iam/desktop_sso-------"
    res.writeHead 302, {'Location': '/'}
    return res.end ''