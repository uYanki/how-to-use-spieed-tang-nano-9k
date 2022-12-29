#### Install：安装

下载[教育版][http://www.gowinsemi.com.cn/faq.aspx]（不需要 `license` ），默认安装。

把 Programmer 解压并替换掉 Gowin 原先的 Programmer 即可。

----

插上板子后会出现如下设备：

![1](README.assets/1.png)

---

#### Compile：编译

![2](README.assets/2.png)

双击 / 右键运行。

#### Programmer：烧录

![3](README.assets/3.png)

选择芯片型号 `GW1NR-9C`，选择 `SRAM Mode` (主用于调试，掉电丢失) / `embedded flash mode` (掉电不丢失) ，选择位于 `\impl\pnr` 中的 `.fs` 文件，烧录即可。 

![4](README.assets/4.png)