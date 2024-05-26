# 版权所有：Copyright (C) 2024, Martin Young <martin_young@live.cn>
#
# 前端：   http://demo2.foo.com    要求301跳转HTTPS
#          https://demo2.foo.com
# 后端：   http://192.168.255.2:8080
#-------------------------------------------------------------------

Define ThisHost   demo2.foo.com
Define RemoteHost 192.168.255.2

<VirtualHost *:80>
    Use VHost ${ThisHost} 80
    Use http2https
</VirtualHost>

<VirtualHost *:443>
    Use SSLVHost ${ThisHost} 443
    Use ProxyPassRoot ${ThisHost} ${RemoteHost} 8080
</VirtualHost>

UnDefine ThisHost
UnDefine RemoteHost
