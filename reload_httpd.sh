#!/bin/bash
#
# /etc/letsencrypt/renewal-hooks/deploy/reload_httpd.sh
#
# 版权所有：Copyright (C) 2024, Martin Young <martin_young@live.cn>
#--------------------------------------------------------------------

systemctl reload httpd
