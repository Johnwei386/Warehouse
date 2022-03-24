#### 1. 一些git操作命令
```bash
git branch                                                     # 查看本地分支, 加'-r'显示远程分支
git checkout -b 02-sit origin/02-sit    # 并新建一个本地分支;切换到该分支;映射远程分支;拉取远程分支到本地.
git checkout 01-dev                                 # 切换分支
git merge 01-dev                        # 合并指定分支到当前分支
git branch -d dev                       # 删除dev分支
git stash                                        # 备份当前工作区的内容到Git栈中
git stash pop                               # 从Git栈中读取最近一次保存的内容
git stash list                                 # 显示Git栈内的所有备份
git stash clear                             # 清空Git栈
git reset --hard                           # 放弃本地修改
git reset --hard HEAD^            # 回退到上一个版本
git reset --hard f8dce4b(版本号)         # 切换到指定版本
git reflog                                                       # 查看版本号
git reset --hard commit_id                   # 回滚到某个提交
git log --stat                                                # 查看提交日志详情摘要
git config --local user.name 'name'                                 # 设置用户名(作用域为仓库)
git config --local user.email 'jiangwei@oa.bbg'         # 设置邮箱
git config -l                                                                                 # 列出所有配置
git remote add origin https://github.com/anonyusers/abcd.git        # 添加远程仓库url
git remote set-url origin http://192.168.0.218/abcd/abcd.git             # 更改远程仓库url
git config --global --unset credential.helper                                              # 清除已缓存的Token
git config --global core.autocrlf false         # Windows系统, 取消git自动转换换行符为CRLF
```

#### 2. git清除本地缓存后,更新.gitignore文件才能生效
```bash
git rm -r --cached .
```

#### 3. 回滚本地分支
```bash
git reset --hard commit-id :回滚到commit-id，讲commit-id之后提交的commit都去除
git reset --hard HEAD~3：将最近3次的提交回滚
```


#### 4. 回滚远程分支
```bash
git checkout the_branch
git pull
git branch the_branch_backup               # 备份一下这个分支当前的情况
git reset --hard the_commit_id               # 把the_branch本地回滚到the_commit_id
git push origin :the_branch                      # 删除远程 the_branch
git push origin the_branch                       # 用回滚后的本地分支重新建立远程分支
git push origin :the_branch_backup    # 如果前面都成功了，删除这个备份分支
```

#### 5. 一些实用bash命令
```bash
# 关闭远程连接端口
fuser -k /dev/pts/6   
# 查找nc开头的已安装程序包
dpkg -l |awk '{print $2}' |grep -i '^nc'  
# 复制远程服务器的目录到本地主机并排除data目录
rsync -av '-e ssh -p 29008' --exclude='data/*' root@104.224.139.137:/root/ChineseNER ./  
```

#### 6. tar备份和还原系统
**6.1备份系统**

```bash
tar -cvpzf /media/moose/share/20190130_debian9.6_amd64_home_opt.tar.gz --exclude=/bin --exclude=/etc --exclude=initrd.img.old --exclude=/lost+found --exclude=/run --exclude=/sys --exclude=/var --exclude=/boot --exclude=/lib --exclude=/media --exclude=/proc --exclude=/sbin --exclude=/tmp --exclude=vmlinuz --exclude=/dev --exclude=initrd.img --exclude=/lib64 --exclude=/mnt --exclude=/root --exclude=/srv --exclude=/usr --exclude=vmlinuz.old /
```
**6.2还原系统**

```bash
tar -xvpzf /media/disk/backup.tgz -C /
```

#### 7. 构建软链接  ln -s 源文件 链接名称
```bash
ln -s /home/john/Programs/redis-6.0.10/bin/redis-server redis-server
```

#### 8. github切换远程仓库链接

github在2021年8月已经更改了仓库的认证方式，所有之前用账号密码认证的仓库需要变更为使用ssh或者两步认证的方式，这里采用ssh的key认证的方式，即需要将自己linux系统的ssh公钥上传到github，然后将现有本地仓库的远程仓库链接修改为ssh认证的仓库。

修改远程仓库命令如下：

```bash
git remote set-url origin git@github.com:Johnwei386/Warehouse.git
```

#### 9. 指定范围合并分支

合并Branch-A中的一些文件到Branch-B中

```bash
# 1. 切换分支到Branch-B
git  checkout  Branch-B

# 2. 创建一个临时分支
git  checkout  -b  Branch-B-tmp

# 3. 确认当前分支是否是临时分支
git  branch

# 4. 合并Branch-A分支到临时分支,此时会自动处理冲突
git  merge  01-dev

# 5. 处理当前分支存在冲突的项
git  add  .

# 6. 提交到本地仓库
git  commit  -m  'merge  Branch-A  to  Branch-B-tmp'

# 7. 切换到Branch-B仓库
git  branch  Branch-B

# 8. 指定文件合并到Branch-B分支, 需要指定文件名,使用通配符无效
git  checkout  Branch-B-tmp  .gitignore
git  checkout  Branch-B-tmp  abc.java

# 9. 提交本地仓库,然后合并到远程仓库
git  commit  -m  'merge some files'
git  push  origin  Branch-B

# 可以将需要合并的文件放在文件mergeFile.list, 然后执行merge.sh来合并文件

```

