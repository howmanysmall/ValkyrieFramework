-- DO IT SOME TIME
newproxy = do 
    oldproxy = newproxy
    (mt) ->
        npr = oldproxy true
        nmt = getmetatable npr
        if mt
            for e,m in pairs mt
                nmt[e] = m
        return npr, nmt
    
