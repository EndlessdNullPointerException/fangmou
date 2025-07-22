## 笔记-list 页面

### TODO

- [x] 增加悬浮按钮，修改路由结构，通过悬浮按钮跳转到新增
- [x] 完成排序功能
- [x] 完成搜索功能
- [x] 完成批量选择并进行处理的功能
- [x] 完成从本地获取笔记列表功能
- [ ] 完成从云端获取笔记列表功能
- [ ] 本地和云端记录相冲突的处理（可以参考 git merge conflict  处理方案）
- [ ] 标签管理，新增标签，根据标签重排序



---



## 笔记-详情页面

### TODO

- [x] 可以在浏览、新增和编辑之间切换
- [x] 可以切换富文本模式和 markdown 模式
- [ ] 为文章添加或删除标签



### 数据结构

###### 笔记基本信息表（note_basic_message）

一条笔记对应一条基本信息

| 名称         | 标识符         | 数据类型  | 索引     | NOT NULL | DEFAULT | 注释                                 |
| ------------ | -------------- | --------- | -------- | -------- | ------- | ------------------------------------ |
| 基本信息UUID | id             | String    | 主键索引 | NOT NULL |         | -                                    |
| 逻辑删除标记 | deletion_flag  | BOOLEAN   |          | NOT NULL | FALSE   | -                                    |
| 创建时间     | created_at     | TIMESTAMP |          | NOT NULL |         | -                                    |
| 最后修改时间 | last_update_at | TIMESTAMP |          | NOT NULL |         | -                                    |
| 删除时间     | deleted_at     | TIMESTAMP |          | NOT NULL |         | -                                    |
| 标题         | title          | String    |          | NOT NULL |         | -                                    |
| 摘要         | excerpt        | String    |          | NOT NULL |         | 截取正文前100个字符                  |
| 类型         | noteType       | INTEGER   |          | NOT NULL |         | 0表示使用markdown语法，1表示普通类型 |

- 由于该应用可以脱离云端独立运行所以 UUID、创建时间、最后修改时间由应用决定

###### SQLLite

```sqlite

CREATE TABLE note_basic_message (
  id String PRIMARY KEY,
  deletion_flag BOOLEAN NOT NULL DEFAULT FALSE,
  created_At TIMESTAMP NOT NULL,
  lastUpdateAt TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP NOT NULL,
  title TEXT NOT NULL,
  excerpt TEXT NOT NULL,
  noteType INTEGER NOT NULL
)
```

###### MySQL

```mysql
CREATE TABLE note_basic_message (
  id String PRIMARY KEY,
  created_at TIMESTAMP NOT NULL,
  last_update_at TIMESTAMP NOT NULL,
  title varchar(50) NOT NULL,
  excerpt varchar(50) NOT NULL
)
```



### 笔记正文表(note_main)

一条笔记对应一条正文

| 名称     | 标识符 | 数据类型 | 索引               | NOT NULL         | DEFAULT          | 注释               |
| -------- | ------ | -------- | -------------------- | -------------------- | -------------------- | -------------------- |
| 正文UUID | id     | String   | 主键索引 | NOT NULL |  | 与笔记基本信息的ID相同 |
| 逻辑删除标记 | deletion_flag  | BOOLEAN  |          | NOT NULL | FALSE                               | -                                    |
| 创建时间     | created_at     | DateTime |          | NOT NULL |                                     | -                                    |
| 最后修改时间 | last_update_at | DateTime |          | NOT NULL |                                     | -                                    |
| 删除时间     | deleted_at     | DateTime |          | NOT NULL |        | -       |
| 正文     | main | TEXT     |                     | NOT NULL |                     | -                    |

###### SQLLite

```sqlite
CREATE TABLE note_main (
  id String PRIMARY KEY,
  deletion_flag BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL,
  lastUpdateAt TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP NOT NULL,
  main TEXT NOT NULL
)
```



### 笔记标签表(note_label)

| 名称     | 标识符 | 数据类型 | 注释 |
| -------- | ------ | -------- | ---- |
| 标签UUID | id     | String   | -    |

| 标签名   | label       | String   | -                                                |
| 标签说明 | description | String   | -                                                |
| 标签等级 | level       | int      | 分为置顶（0）、重要（1）、普通（2）、待删除（3） |



### 笔记标签映射表(note_label_map)

一条笔记可以对应多个标签

| 名称         | 标识符   | 数据类型 | 说明                 |
| ------------ | -------- | -------- | -------------------- |
| 基本信息UUID | id       | String   | -                    |
| 基本信息ID   | note_id  | String   | 与笔记基本信息ID相同 |
| 标签id       | label_id | String   | 与标签ID相同         |



---





## 设置页



---

