# 版权所有：Copyright (C) 2024, Martin Young <martin_young@live.cn>
#
# 前端1：   http://demo3.foo.com      其中/download/要求301跳转HTTPS
# 前端2：   https://demo3.foo.com     其中/download/要求：
#                                     1、仅限邮件系统SMTP认证的用户访问；
#                                     2、浏览、下载本服务器 /mnt/nfs/ 目录下的文件；
#                                     3、限速10MB/s。
# 后端：    http://192.168.255.5
#-----------------------------------------------------------------------------

Define ThisHost    demo3.foo.com
Define RemoteHost  192.168.255.5

<VirtualHost *:80>
    Use VHost ${ThisHost} 80
    Use http2https_uri ^/download/
    Use ProxyPassRoot ${ThisHost} ${RemoteHost} 80
</VirtualHost>

# 注意：
# 1、需要在 conf.d/zz1-domains.conf 里面加载PAM认证和限速相关模块。
# 2、关于PAM认证的配置，此处不做详细说明，可参见：
#    https://github.com/robot-dot-win/Deployment-Case-of-OpenVPN

<VirtualHost *:443>
    Use SSLVHost ${ThisHost} 443

    <Directory "/mnt/nfs">
        Options Indexes
        IndexOptions FancyIndexing FoldersFirst NameWidth=* Charset=UTF-8

        SetOutputFilter RATE_LIMIT
        SetEnv rate-limit 10000
        SetEnv rate-initial-burst 12000

        AuthType Basic
        AuthName "User Authentication"
        AuthBasicProvider PAM
        AuthPAMService http_download.pam
        Require valid-user
    </Directory>

    Alias /download/ "/mnt/nfs/"

    <LocationMatch "^/download/">
        DirectoryIndex disabled
        Options +Indexes
    </LocationMatch>

    ProxyPass /download/ !
    Use ProxyPassRoot ${ThisHost} ${RemoteHost} 80
</VirtualHost>

UnDefine ThisHost
UnDefine RemoteHost
