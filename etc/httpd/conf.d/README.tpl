版权所有：Copyright (C) 2024, Martin Young <martin_young@live.cn>
-----------------------------------------------------------------

这个目录保存的是两部分内容：

1、 对Apache httpd+mod_ssl安装后的同名缺省配置文件的修改，不包含
未修改的配置文件。使用时，需直接覆盖到刚刚安装完毕的同名目录下。
源文件来源：CentOS Stream 9, Apache httpd 2.4.57

2、 两个自定义模板文件：
    zz0-common.conf   httpd通用全局配置文件。必要时需修改文件名使
                      之排在该目录所有.conf文件的倒数第1位
    zz1-domains.conf  httpd主网站配置文件必要时需修改文件名使
                      之排在该目录所有.conf文件的倒数第1位

--
2024-05-24
