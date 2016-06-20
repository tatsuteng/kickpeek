KickPeek for OpenWrt
===

#### 简介

OpenWRT 下根据信号强度自动踢掉蹭网者的小工具。

#### 选择网卡

在配置文件中进行设置：`/etc/config/kickpeek`

```
config kickpeek
	option interface 'wlan0'
	...
```

默认为 'wlan0'

#### 认证

------

> 注意：这里的“认证”是指“连接 AP 后不会马上被提下线“，而不是 802.11i 中的定义。

##### 1. 白名单

加入白名单的设备任何时候都可以正常得连接 WiFi 热点。

比如要将 MAC 地址为 12:34:56:78:9a:bc 的设备加入白名单，编辑配置文件，加入以下一行:

```
config kickpeek
	...
	list macs '12:34:56:78:9a:bc'
```

重启 kickpeek 即可：`/etc/init.d/kickpeek restart`

##### 2. 定时近距离认证

开启设备 WiFi 的同时将设备尽可能地靠近路由器，即可完成认证，但是这种认证有时间限制，默认为
 1 小时，超时后需要重新将设备靠近路由器再认证。

```
config kickpeek
	...
	option threshold '-20'
	option timeout '3600'
	...
```

threshold 和 timeout 参数规定了：
+ 完成认证所需的信号强度(dBm)，默认 -20 dBm
+ 此次认证有效期(秒)，默认 3600s


#### 安全注意事项

本工具只在防蹭网，不能保证 WiFi 的安全性。

##### 开放 WiFi 不设密码

不要轻易这样做。开放的 WiFi 不加密数据，攻击者不需要连结热点就能截获明文数据。

##### WEP

WEP 的安全性基本等同于不设密码不加密

##### WPA/WPA2-PSK

不要随意散布 WiFi 密码。攻击者知道 WiFi 密码后能轻易根据 WiFi 密码获得设备与 AP 之间的加密
密钥，从而截获明文数据。

**所以这个软件有什么卵用？ --用来对付那些使用”WiFi 万能钥匙“的小白蹭网者。**

#### TODO

+ 做一个 LuCI 界面
+ 重启进程时保持已认证设备，无需从新认证
+ 完善异常处理

#### 许可

KickPeek 的代码使用 GPLv3 发布。
