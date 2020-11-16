iamssomanager = {}

iamssomanager.iam_sso = (url) ->
    try
        if !url
            return;
        
        HTTP.get url, (err, res)->
            if(err)
                console.err "err mes: ", err
            else
                response = JSON.parse(res.content);
                if response?.serviceResponse?.authenticationSuccess
                    state = response.serviceResponse.authenticationSuccess
                    console.log "userId: ",userId
                    userId = state.user;
                    if userId
                        redirectUrl = "/api/iam/desktop_sso/?userId=" + userId;
                        window.location = redirectUrl;
    catch err
        console.error err
        throw _.extend(new Error("Failed to complete sso iam with url. " + err), {response: err})
