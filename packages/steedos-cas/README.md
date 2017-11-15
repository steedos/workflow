Steedos CAS 单点登录
==========

## CAS 介绍

CAS 是 Yale 大学发起的一个开源项目，旨在为 Web 应用系统提供一种可靠的单点登录方法，CAS 在 2004 年 12 月正式成为 JA-SIG 的一个项目。

- **CAS Server**
 为需要独立部署的 Web 应用。本系统的服务器端指的是暂时部署在21服务器上的steedos:cas项目。
- **CAS Client**
    支持非常多的客户端,(这里指单点登录系统中的各个 Web 应用)，包括 Java, .Net, PHP, Perl, Apache, uPortal, Ruby 等。本系统的客户端指的就是包括审批王系统在内的其他相关系统。

## CAS 认证过程
- **1.登录**
访问cas的登录界面，并传入参数service的值。
  - cas登录地址：
  `https://192.168.0.29:8446/cas/login`
  `http://192.168.0.29:8086/cas/login`
  - service参数地址：
  `Meteor.absoluteUrl('api/cas/sso/')`
- **2.CAS认证**
  - 跳转至cas登录界面。
  - 输入用户名密码后，点击登录按钮，将登录表单传递到cas后端
  - cas取username和password参数，进行验证并授权。
  - 如果用户名密码错误，则提示用户信息认证失败。
  - 验证通过，生成一个ticket，并跳转至service地址，即steedos的验证接口。
- **3.Steedos验证**
  - 浏览器跳转至api/cas/sso接口进行单点登录的验证。
  - steedos的验证接口提取生成的ticket以及service参数，并传递给cas服务器的验证接口。
  - cas根据ticket和service进行验证。
  - 验证通过后，cas会返回username，根据username获取当前用户的信息，并在steedos平台模拟登录，存储setAuthCookies等值，并跳转至主界面。