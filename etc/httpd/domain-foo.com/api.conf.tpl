# 版权所有：Copyright (C) 2024, Martin Young <martin_young@live.cn>
#
# 前端0：   http://api.foo.com             禁止访问(404)
#
# 前端1：   https://api.foo.com            要求SSL协议最低版本TLS 1.3
# 后端1：   http://192.168.255.3:8080
#
# 前端2：   https://api.foo.com:8443/old/  一些早期应用，要求SSL协议支持TLS 1.0
# 后端2：   http://192.168.255.4:9000/
#-----------------------------------------------------------------------------

Define ThisHost    api.foo.com
Define RemoteHost  192.168.255.3
Define RemoteHost2 192.168.255.4

<VirtualHost *:80>
    Use VHost ${ThisHost} 80
    RewriteRule (.*) - [forbidden]
</VirtualHost>

<VirtualHost *:443>
    Use SSLVHost ${ThisHost} 443
    SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1 -TLSv1.2
    Use ProxyPassRoot ${ThisHost} ${RemoteHost} 8080
</VirtualHost>

<VirtualHost *:8443>
    Use SSLVHost ${ThisHost} 8443

    SSLProtocol TLSv1
    Use ProxyPassPath ${ThisHost} ${RemoteHost2} 9000 /old/ /

    RewriteRule (.*) - [forbidden]
</VirtualHost>

UnDefine ThisHost
UnDefine RemoteHost
UnDefine RemoteHost2
