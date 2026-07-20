# ISPD 2005

官方入口：https://www.ispd.cc/contests/05/contest.htm

期望设计：adaptec1–4、bigblue1–4。下载内容放入 `payload/`，主 Git 不跟踪。

当前已验证：

- adaptec1：官方归档已下载并解压。
- adaptec2：官方归档已下载，SHA-256 为 `E5A7BC0E343A97F3D9D3A1C871636A4B51DA7F64EE71D2F04E7DB295655A09A2`；tar 路径安全，六个内部 gzip 文件均通过完整性测试。
- adaptec4：官方归档已下载，SHA-256 为 `CA894BCF93ACE5998DD393A6B6D5F240D3C695159CDC62AB055B8EDF70EF46AB`；tar 路径安全，六个内部 gzip 文件均通过完整性测试。

用于最小 Xplace/ISPD2005 复现实验的三个设计（adaptec1、adaptec2、adaptec4）已经齐备；这不代表 ISPD 2005 全部设计均已下载。
