### Mysql数据库常用操作
1. 创建一个数据库
```mysql
create database 数据库名称;
```

2. 指定字符集创建数据库
```mysql
create database 数据库名称 default character set utf8;
```

3. 创建一个学生表, 并指定自增主键, 学生名字不能为空, 性别默认为0
```mysql
create table student(id int(10) primary key auto_increment, sname char(30) not null, sex tinyint(1) default 0, QQ varchar(255));
```

4. 创建一个用户表, 并指定ID非负, 指定字符集为utf8
```mysql
create table user(id int(10) unsigned primary key auto_increment, uname varchar(60), age tinyint(2)) default character set utf8;
```

5. 数值数据类型
| 类型     |  大小(byte)    |   描述  |
| ---- | ---- | ---- |
| tinyint    |  1  |  小整型    |
| smallint   |  2  |  大整型    |
| mediumint  |  3  |  大整型    |
|  int       |  4  |  大整型    |
|  bigint    |  8  | 超大整型   |
|  float     |  4  |  单精度浮点型    |
|  double    |  8  |  双精度浮点型    |
|  decimal   |  decimal(M,N)  |  货币,M:总的数位,N:小数点位数    |

6. 日期和时间数据类型
| 类型     |  大小(byte)    |  格式  |   描述  |
| ---- | ---- | ---- | ---- |
| date      |  3  |  YYYY-MM-DD           |   小整型    |
| time      |  3  |  HH:MM:SS             |   时间值或持续时间    |
| year      |  1  |  YYYY                 |   年份值    |
| datetime  |  8  |  YYYY-MM-DD HH:MM:SS  |   混合日期和时间值    |
| timestamp |  4  |  YYYYMMDDHHMMSS       |   unix时间戳    |

7. 字符串数据类型
| 类型     |  大小(byte)    |   描述  |
| ---- | ---- | ---- |
| char        |  0-255        |  定长字符串    |
| varchar     |  0-65535      |  变长字符串    |
| tinyblob    |  0-255        |  不超过 255 个字符的二进制字符串    |
| tinytext    |  0-255        |  短文本字符串    |
| blob        |  0-65535      |  二进制形式的长文本数据    |
| text        |  0-65535      |  长文本数据    |
| mediumblob  |  0-16777215   |  二进制形式的中等长度文本数据    |
| mediumtext  |  0-16777215   |  中等长度文本数据    |
| longblob    |  0-4294967295 |  二进制形式的极大文本数据    |
| longtext    |  0-4294967295 |  极大文本数据    |
CHAR 和 VARCHAR 类型类似，但它们保存和检索的方式不同。它们的最大长度和是否尾部空格被保留等方面也不同。在存储或检索过程中不进行大小写转换。
BINARY 和 VARBINARY 类似于 CHAR 和 VARCHAR，不同的是它们包含二进制字符串而不要非二进制字符串。也就是说，它们包含字节字符串而不是字符字符串。这说明它们没有字符集，并且排序和比较基于列值字节的数值值。
BLOB 是一个二进制大对象，可以容纳可变数量的数据。有 4 种 BLOB 类型：TINYBLOB、BLOB、MEDIUMBLOB 和 LONGBLOB。它们区别在于可容纳存储范围不同。
有 4 种 TEXT 类型：TINYTEXT、TEXT、MEDIUMTEXT 和 LONGTEXT。对应的这 4 种 BLOB 类型，可存储的最大长度不同，可根据实际情况选择。

8. 修改goods表的表字段price的数据类型
```mysql
alter table goods modify price decimal(10,2);
```

9. 更改goods表的表字段name的名称
```mysql
alter table goods change name gname varchar(100) default "wares" comment "商品名称";
```

10. 删除goods表中的数据
```mysql
delete from goods;
```

11. mysql显示版本信息
```mysql
select version();
```

12. mysql显示当前正在使用的数据库
```mysql
select database();
```

13. 指定字段查询
```mysql
select 字段名,字段名 from 表名称;
```

14. 指定条件查询, 从student表中查询名字叫李四的学生
```mysql
select * from student where sname="李四";
```

15. 模糊查询, 从student表中查询所有姓李且名字只有两个字的同学, "%"代表任意单个字符
```mysql
select * from student where sname like "李%";
```

16. 判断查询, 从student表中对查询出来的性别进行判断, 1为男, 0为女
```mysql
select if(sex, "男", "女"); sname,sex from student;
```

17. 使用别名
```mysql
select if(sex, "男", "女") as stusex,sname from student;
```

18. 使用逻辑运算符
```mysql
select sname,sex from student where sname like "李%" and sex=0;
select sname,sex from student where sname like "李%" or sex=0;
```

19. 追加字段(添加字段)
```mysql
alter table student add birthday date;
```

20. 更新表操作(更新所有的记录)
```mysql
update student set birthday = "1990/2/23";
```

21. 添加条件更新
```mysql
update student set birthday="1990/2/23" where id=1;
```

22. 限制数据输出2行数据
```mysql
select * from student limit 2;
```

23. 加上排序输出
```mysql
select * from student order by id desc;  降序排序输出
select * from student order by id asc;   升序排序输出
```

24. 取id最大的两个值
```mysql
select * from student order by id desc limit 2;
```

25. 查找年龄第二大的
```mysql
select sname,birthday from student order by birthday asc limit(1,1);  表示从这个返回序列中得到从第1位开始的1个值,即1行数据,包含起始位
```

26. 删除数据库或表
```mysql
drop database 数据库名称;
drop table 表名称;
```

27. 使用数据库
```mysql
use 数据库名称;
```

28. 查看所有数据库
```mysql
show databases;
```

29. 判断条件查询
```mysql
select * from student where birthday <= "1992/10/22";
```

30. 插入一行数据到表中
```mysql
insert into student(sname, age) values("张三", 22);
```

31. 列出表的结构
```mysql
desc 表名称;
```

32. 查看mysql数据库的信息
```mysql
status;
```

33. 查看编码
```mysql
show variables like 'character%';
```

34. 使用sql语句修改编码类型
```mysql
set character_set_database=utf8;
set character_set_server=utf8;
```

35. 查看表的字符集
```mysql
show full columns from student;
```

36. 反引号``用于字段名, 用来消除与程序保留字之间的冲突, 它是mysql的转义符, 只要不使用保留字或者中文作表名或者字段名标识, 则不需要转义.

37. 导入数据库
```mysql
use 数据库名称;
source /全路径/*.sql文件  若不指定全路径,则默认从当前shell执行目录下搜索
```

38. mysql修改密码
```mysql
set password for root@localhost=password("新密码");
```
mysql所有的用户信息表在mysql数据库下的user表中, 可在这个表中修改用户密码

39. 备份一个数据库
```mysql
mysqldump -h localhost -u 用户名 -p 数据库名称 > /tmp/bakname.sql
```