--初始化 nacos 数据库
CREATE DATABASE IF NOT EXISTS nacos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
--初始化nacos表
SOURCE /docker-entrypoint-initdb.d/sqls/nacos-mysql-schema.sql;
--初始化自己的nacos配置
use nacos;
SOURCE /docker-entrypoint-initdb.d/sqls/nacos-zjmfz-data.sql;

--初始化业务数据 数据库名称用下划线“_”分割，中划线有问题“-”，不会创建对应库
CREATE DATABASE IF NOT EXISTS zjmfz_mini_rig CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
use zjmfz_mini_rig;
SOURCE /docker-entrypoint-initdb.d/sqls/zjmfz_mini_rig.sql;

FLUSH PRIVILEGES;
SELECT 'MySQL 数据库初始化完成!' AS message;