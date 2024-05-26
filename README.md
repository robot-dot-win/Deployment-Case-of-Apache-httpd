# Apache httpd WEB应用逆向代理部署模板

## 场景

- 前端使用httpd监听，后端是Tomcat/Glassfish/JBoss/nginx/httpd等许多应用服务。这些应用可能对应单独的域名，也可能对应某域名下的一个目录。
- 无高流量、高并发需求，不需要Load Balancing。
- 无关键应用，不需要High Availability。
- 所有的应用都是基于域名的访问。
- 域名和应用增减变化比较频繁。
- 有的应用要求强制https连接，有的应用要求使用多个端口号提供同一服务。
- 必须满足网站备案管理要求：对未备案资源的访问应当返回404错误码。
- 安全性和审计管理必须符合ISO/IEC 27001体系要求。
- 低成本实现。

## 策略

- 基于名字的Virtual Host。
- certbot自动维护Let's Encrypt签发的免费SSL证书。
- SNI（Server Name Indication）方式配置SSL Virtual Host。
- 保持各Virtual Host配置的极大独立性，以利增减变化的维护。
- 同样适合配置不带后端的网站。

思路和细节可参阅笔记文档。

## 模板

1、适用于RHEL 9/CentOS Stream 9/Rocky Linux 9/AlmaLinux 9。本仓库内容全部基于CentOS Stream 9。

2、安装httpd、mod_ssl。

3、执行以下步骤来确认配置模板可以正常运行：
- 将本仓库的模板配置文件目录覆盖到服务器对应的配置文件目录；
- 启动httpd服务，检查服务状态，确认启动成功；
- 修改浏览器电脑的`hosts`文件（例如Linux的`/etc/hosts`，Windows的`%SystemRoot%\System32\drivers\etc\hosts`），把服务器上httpd监听的IP地址映射到`www.foo.com`，然后在浏览器里访问`http://www.foo.com`，当出现CentOS的“HTTP SERVER TEST PAGE”页面时，说明模板可以正常运行。

4、按以下步骤定义非SSL网站：
- 检查`conf.d/zz0-common.conf`，初期通常不需要修改（后期可根据实际情况修改）。
- 根据实际情况修改`conf.d/zz1-domains.conf`，主要是定义各端口的primary virtual host。注意此时还没有SSL证书，不能配置SSL primary virtual host。
- 参照`domain-foo.com/www.conf`，把各域下各个非SSL网站以最简单的形式先定义出来。
- 重启httpd服务，确认这些网站都能够正常访问到CentOS的“HTTP SERVER TEST PAGE”页面。

5、安装certbot。

6、使用certbot，以[ACME](https://github.com/ietf-wg-acme/acme)协议的http-01认证方式为SSL网站申请证书（同名的非SSL网站必须在前面已定义好并正常运行）。

7、按以下步骤定义SSL网站：
- 修改`conf.d/zz1-domains.conf`，定义各SSL端口的primary virtual host。注意检查确认`PrimaryVHost`变量所指的网站已经申请了SSL证书。
- 重启httpd服务，检查httpd服务的状态，如果确认成功，说明`PrimaryVHost`变量所指的网站SSL证书配置成功。
- 根据实际需求，参照`domain-foo.com/*.conf.tpl`模板配置文件，重新定义各个SSL和非SSL网站的Virtual Host。
- 反复调试、修改，直至实现全部网站功能。其间可能会需要一些未加载的模块，此时可把`LoadModule`写在`conf.d/zz1-domains.conf`中。

8、网站上线后，设置shell脚本`/etc/letsencrypt/renewal-hooks/deploy/reload_httpd.sh`，以便certbot自动更新证书后自动重启httpd服务。

9、Apache httpd可以随着操作系统的发行包进行升级。每次升级应注意是否产生`.conf.rpmnew`文件，如果有，应比照老版本修改相应的配置文件。

## 许可

1. 本仓库所有内容是免费的、公开的、不限商用的，允许转载、摘录/引用，但必须遵守如下限制：
- 转载限制：必须注明原著作权人版权和原文出处，必须公开、免费发布，不允许以任何方式收费阅读（除非获得原著作权人书面授权）。
- 摘录/引用限制：必须在参考文献中列出原文出处，所形成的新作品版权归新作品著作权人所有，但其任何非纸质版本不允许以任何方式收费阅读（除非获得原著作权人书面授权）。

2. 使用本仓库的任何内容，必须遵循[《GNU通用公共许可协议》](https://www.gnu.org/licenses/)第三版的第15、16、17条之规定。
