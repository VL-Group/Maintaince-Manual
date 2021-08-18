# Visual Studio Code 远程调试

## 要求
* 带有 SSH-client 的系统（Windows 10 1809 以上或 Windows Server 2019 系统可以启用原生的 OpenSSH，见 Q&A 部分）；
* Visual Studio Code 1.35.0 以上；[安装](https://code.visualstudio.com/)
* 远程系统须为 Linux-based x86_64；
* 以下内容假定在 Windows 10 1809 以上进行，其他环境类似。

## 工作方式
* 本地计算机安装 Visual Studio Code；
* 远程服务器自动配置 Code Server；
* 通过 SSH 连接到远程服务器进行开发、调试。

## 生成 SSH 密钥文件
远程开发推荐使用 SSH 密钥进行认证，在本地计算机上打开 Terminal (PowerShell):
```posh
ssh-keygen -t rsa -b 4096
```
这里生成 SSH 密钥文件（passphrase 可以留空），

![](https://i.loli.net/2019/06/10/5cfe00cb8023676767.png)

再将这个密钥添加到服务器上：
* `macOS` 或 `Linux`:
```posh
ssh-copy-id username@host-ip
```
* `Windows`:
```posh
SET REMOTEHOST=username@host-ip

scp %USERPROFILE%\.ssh\id_rsa.pub %REMOTEHOST%:~/tmp.pub
ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && rm -f ~/tmp.pub"
```
即，将生成的公钥内容添加到 `~/.ssh/authorized_keys` 文件中，也可以手动操作

## 配置 Visual Studio Code
* 安装 [Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
### 修改 ssh_config
按下 `f1` 打开命令窗口，输入 `SSH`，找到 `Remote-SSH: Open Configuration File...`，并选择一个需要修改的配置文件。

![](https://i.loli.net/2019/06/10/5cfdfc35536e852460.jpg)

```bash
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
Host your-host-alias
     HostName host-fqdn-or-ip
     Port ssh-port
     IdentityFile C:\path\to\your\exported\private\keyfile
     User your-user-name
```

## 连接并使用
按下 `f1` 打开命令窗口，找到 `Remote-SSH: Connect to Host...`，选择刚才配置的服务器。初始化工作是自动完成的。

当窗口左下角出现 "SSH: xxx" 的时候，就已经成功连接上了服务器。

![](https://i.loli.net/2019/06/10/5cfdfc941d68c91056.jpg)

点击打开文件夹，可以直接打开位于服务器上的远程文件夹，也可以打开本地文件夹。可以在 "Remote-SSH" 栏目中配置端口转发。

![](https://i.loli.net/2019/06/10/5cfdfcb6c0b0d15041.jpg)

在远程服务器上安装 Python 扩展后，可以启用调试（调试的配置自行解决）：

![](https://i.loli.net/2019/06/10/5cfdfcce8382426219.jpg)

## Q&A

**Q: 在 Windows 上使用哪一个 SSH 客户端？**

A: 推荐的还是使用 Windows 原生的 OpenSSH (使用 Windows 10)。如果条件不允许，请使用 Git for Windows，
并选择 **Use Git and optional Unix tools from the Command Prompt**，然后将 `C:\Program Files\Git\usr\bin` 添加到 `PATH`。

**PuTTY 是不兼容的**

https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client

**Q: 如何保持本地文件和服务器文件的同步？**

A: 1: 可以使用 `SSHFS` 来方便地把远程目录映射到本地的网络文件夹上（Windows 上使用 [Chocolatey](https://chocolatey.org/) 安装）。2: 使用 `rsync` 程序可以保持文件的同步（Windows 上使用 WSL）。

**Q: 有一台机器只能通过跳板机访问，如何连接？**

A: 只需在 SSH 配置文件中首先加入跳板，然后按下面的格式再添加需要的机器：

```bash
Host Any-Jumper-Name
     ...
     ...

Host Your-Target-Machine
     HostName <IP address of target>
     User Username
     IdentityFile C:\path\to\your\exported\private\keyfile
     ProxyCommand ssh -q -W %h:%p Any-Jumper-Name
```

**Q: 我不想使用密钥来登录 SSH。**

A: 请在 Remote SSH 的设置中启用 `"remote.SSH.showLoginTerminal": true`，并在打开的控制台里输入密码。
