# 版权所有：Copyright (C) 2024, Martin Young <martin_young@live.cn>
#
# 前端：   http://demo4.foo.com         要求301跳转HTTPS
#          https://demo4.foo.com        要求：1、/images/和/static/直接访问本机根目录下的内容；
#                                             2、/webadmin/和/private/禁止通过前端访问
# 后端：   http://192.168.255.8:8080
#-------------------------------------------------------------------

Define ThisHost   demo4.foo.com
Define RemoteHost 192.168.255.8

<VirtualHost *:80>
    Use VHost ${ThisHost} 80
    Use http2https
</VirtualHost>

<VirtualHost *:443>
    Use SSLVHost ${ThisHost} 443

    RewriteRule ^/(webadmin|private)/   - [forbidden]

    ProxyPass /images/ !
    ProxyPass /static/ !
    Use ProxyPassRoot ${ThisHost} ${RemoteHost} 8080
</VirtualHost>

UnDefine ThisHost
UnDefine RemoteHost
