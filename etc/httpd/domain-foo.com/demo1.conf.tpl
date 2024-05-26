# 版权所有：Copyright (C) 2024, Martin Young <martin_young@live.cn>
#
# 前端：   http://demo1.foo.com
# 后端：   http://192.168.255.1:8080
#-------------------------------------------------------------------

Define ThisHost   demo1.foo.com
Define RemoteHost 192.168.255.1

<VirtualHost *:80>
    Use VHost ${ThisHost} 80
    Use ProxyPassRoot ${ThisHost} ${RemoteHost} 8080
</VirtualHost>

UnDefine ThisHost
UnDefine RemoteHost
