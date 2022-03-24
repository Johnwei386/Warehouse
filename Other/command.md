# git操作
git branch                              查看本地分支, 加'-r'显示远程分支
git checkout -b 02-sit origin/02-sit    并新建一个本地分支,切换到该分支，映射远程分支，拉取远程分支到本地
git checkout 01-dev                     切换分支
git remote set-url origin http://51.128.5.218/g_hrms/HRMS.git    更改远程分支
git merge 01-dev                        合并指定分支到当前分支
git branch -d dev                       删除dev分支
git stash                               备份当前工作区的内容到Git栈中
git stash pop                           从Git栈中读取最近一次保存的内容
git stash list                          显示Git栈内的所有备份
git stash clear                         清空Git栈
git reset --hard                        放弃本地修改
git reset --hard HEAD^                  回退到上一个版本
git reset --hard f8dce4b(版本号)         切换到指定版本
git reflog                              查看版本号
git reset --hard commit_id              回滚到某个提交
git log --stat                          查看提交日志详情摘要
git config --local user.name 'name'                                 设置用户名(作用域为仓库)
git config --local user.email 'jiangwei@oa.bbg'                     设置邮箱
git config -l                                                       列出所有配置
git remote add origin https://github.com/anonyusers/****.git        添加远程仓库
git config --global --unset credential.helper                       清除已缓存的Token
git config --global core.autocrlf false                             Windows系统, 取消git自动转换换行符为CRLF

# git清除本地缓存后,更新.gitignore文件才能生效
git rm -r --cached .

# 回滚本地分支
git reset --hard commit-id :回滚到commit-id，讲commit-id之后提交的commit都去除
git reset --hard HEAD~3：将最近3次的提交回滚


# 回滚远程分支
1、git checkout the_branch
2、git pull
3、git branch the_branch_backup //备份一下这个分支当前的情况
4、git reset --hard the_commit_id //把the_branch本地回滚到the_commit_id
5、git push origin :the_branch //删除远程 the_branch
6、git push origin the_branch //用回滚后的本地分支重新建立远程分支
7、git push origin :the_branch_backup //如果前面都成功了，删除这个备份分支


# 一些实用bash命令
fuser -k /dev/pts/6   关闭远程连接端口
dpkg -l |awk '{print $2}' |grep -i '^nc'  查找nc开头的已安装程序包
rsync -av '-e ssh -p 29008' --exclude='data/*' root@104.224.139.137:/root/ChineseNER ./  复制远程服务器的目录到本地主机并排除data目录

# tar备份系统
tar -cvpzf /media/moose/share/20190130_debian9.6_amd64_home_opt.tar.gz --exclude=/bin --exclude=/etc --exclude=initrd.img.old --exclude=/lost+found --exclude=/run --exclude=/sys --exclude=/var --exclude=/boot --exclude=/lib --exclude=/media --exclude=/proc --exclude=/sbin --exclude=/tmp --exclude=vmlinuz --exclude=/dev --exclude=initrd.img --exclude=/lib64 --exclude=/mnt --exclude=/root --exclude=/srv --exclude=/usr --exclude=vmlinuz.old /

# tar还原系统
tar -xvpzf /media/disk/backup.tgz -C /

# 构建软链接  ln -s 源文件 链接名称
ln -s /home/john/Programs/redis-6.0.10/bin/redis-server redis-server

