-- =============================================
-- 1. 创建数据库
-- =============================================

CREATE DATABASE IF NOT EXISTS TPCH
CHARACTER SET utf8mb4;

-- 使用 TPCH 数据库
USE TPCH;


-- =============================================
-- 2. 地区表 Region
-- =============================================

CREATE TABLE Region (
    regionkey   INT PRIMARY KEY,      -- 地区编号（主键）
    name        CHAR(25),             -- 地区名称
    comment     VARCHAR(152)          -- 备注
);


-- =============================================
-- 3. 国家表 Nation
-- =============================================

CREATE TABLE Nation (
    nationkey   INT PRIMARY KEY,      -- 国家编号（主键）
    name        CHAR(25),             -- 国家名称
    regionkey   INT,                  -- 地区编号（外键）
    comment     VARCHAR(152),         -- 备注

    FOREIGN KEY (regionkey)
        REFERENCES Region(regionkey)
);


-- =============================================
-- 4. 供应商表 Supplier
-- =============================================

CREATE TABLE Supplier (
    suppkey     INT PRIMARY KEY,      -- 供应商编号（主键）
    name        CHAR(25),             -- 供应商名称
    address     VARCHAR(40),          -- 供应商地址
    nationkey   INT,                  -- 国家编号（外键）
    phone       CHAR(15),             -- 供应商电话
    acctbal     DECIMAL(10, 2),       -- 账户余额
    comment     VARCHAR(101),         -- 备注

    FOREIGN KEY (nationkey)
        REFERENCES Nation(nationkey)
);


-- =============================================
-- 5. 零件表 Part
-- =============================================

CREATE TABLE Part (
    partkey      INT PRIMARY KEY,     -- 零件编号（主键）
    name         VARCHAR(55),         -- 零件名称
    mfgr         CHAR(25),            -- 制造厂
    brand        CHAR(10),            -- 品牌
    type         VARCHAR(25),         -- 零件类型
    size         INT,                 -- 尺寸
    container    CHAR(10),            -- 包装
    retailprice  DECIMAL(10, 2),      -- 零售价格
    comment      VARCHAR(23)          -- 备注
);


-- =============================================
-- 6. 零件-供应商联系表 PartSupp
-- =============================================

CREATE TABLE PartSupp (
    partkey      INT,                 -- 零件编号
    suppkey      INT,                 -- 供应商编号
    availqty     INT,                 -- 可用数量
    supplycost   DECIMAL(10, 2),      -- 供应价格
    comment      VARCHAR(199),        -- 备注

    -- 复合主键
    PRIMARY KEY (partkey, suppkey),

    -- 外键
    FOREIGN KEY (partkey)
        REFERENCES Part(partkey),

    FOREIGN KEY (suppkey)
        REFERENCES Supplier(suppkey)
);


-- =============================================
-- 7. 顾客表 Customer
-- =============================================

CREATE TABLE Customer (
    custkey      INT PRIMARY KEY,     -- 顾客编号（主键）
    name         VARCHAR(25),         -- 姓名
    address      VARCHAR(40),         -- 地址
    nationkey    INT,                 -- 国籍编号（外键）
    phone        CHAR(15),            -- 电话
    acctbal      DECIMAL(10, 2),      -- 账户余额
    mktsegment   CHAR(10),            -- 市场分区
    comment      VARCHAR(117),        -- 备注

    FOREIGN KEY (nationkey)
        REFERENCES Nation(nationkey)
);


-- =============================================
-- 8. 订单表 Orders
-- =============================================

CREATE TABLE Orders (
    orderkey       INT PRIMARY KEY,   -- 订单编号（主键）
    custkey        INT,               -- 顾客编号（外键）
    orderstatus    CHAR(1),           -- 订单状态
    totalprice     DECIMAL(10, 2),    -- 订单总金额
    orderdate      DATE,              -- 订单日期
    orderpriority  CHAR(15),          -- 订单优先级别
    clerk          CHAR(15),          -- 记账员
    shippriority   INT,               -- 运输优先级别
    comment        VARCHAR(79),        -- 备注

    FOREIGN KEY (custkey)
        REFERENCES Customer(custkey)
);


-- =============================================
-- 9. 订单明细表 Lineitem
-- =============================================

CREATE TABLE Lineitem (
    orderkey       INT,               -- 订单编号
    partkey        INT,               -- 零件编号
    suppkey        INT,               -- 供应商编号
    linenumber     INT,               -- 订单明细编号

    quantity       DECIMAL(10, 2),    -- 数量
    extendedprice  DECIMAL(10, 2),    -- 订单明细价格
    discount       DECIMAL(10, 2),    -- 折扣
    tax            DECIMAL(10, 2),    -- 税率

    returnflag     CHAR(1),           -- 退货标记
    linestatus     CHAR(1),           -- 订单明细状态

    shipdate       DATE,              -- 装运日期
    commitdate     DATE,              -- 委托日期
    receiptdate    DATE,              -- 签收日期

    shipinstruct   CHAR(25),          -- 装运说明
    shipmode       CHAR(10),          -- 装运方式
    comment        VARCHAR(44),        -- 备注

    -- 复合主键
    PRIMARY KEY (orderkey, linenumber),

    -- 外键
    FOREIGN KEY (orderkey)
        REFERENCES Orders(orderkey),

    FOREIGN KEY (partkey, suppkey)
        REFERENCES PartSupp(partkey, suppkey)
);







USE TPCH;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Lineitem;
TRUNCATE TABLE Orders;
TRUNCATE TABLE PartSupp;
TRUNCATE TABLE Customer;
TRUNCATE TABLE Part;
TRUNCATE TABLE Supplier;
TRUNCATE TABLE Nation;
TRUNCATE TABLE Region;

SET FOREIGN_KEY_CHECKS = 1;





-- =============================================
-- 使用 TPCH 数据库
-- =============================================

USE TPCH;


-- =============================================
-- 1. 插入地区数据 Region
-- =============================================

INSERT INTO Region (regionkey, name, comment) VALUES
(0, 'AFRICA', 'Africa region'),
(1, 'AMERICA', 'America region'),
(2, 'ASIA', 'Asia region'),
(3, 'EUROPE', 'Europe region'),
(4, 'MIDDLE EAST', 'Middle East region');


-- =============================================
-- 2. 插入国家数据 Nation
-- =============================================

INSERT INTO Nation (nationkey, name, regionkey, comment) VALUES
(1, 'ALGERIA', 0, 'Located in Africa'),
(2, 'BRAZIL', 1, 'Located in America'),
(3, 'CHINA', 2, 'Located in Asia'),
(4, 'JAPAN', 2, 'Located in Asia'),
(5, 'GERMANY', 3, 'Located in Europe');


-- =============================================
-- 3. 插入供应商数据 Supplier
-- =============================================

INSERT INTO Supplier
(suppkey, name, address, nationkey, phone, acctbal, comment)
VALUES
(101, '金仓集团', '北京市海淀区', 3,
 '138-0011-0011', 50000.00, '知名国产数据库厂商'),

(102, '华为', '深圳市龙岗区', 3,
 '139-0012-0012', 80000.00, '通信与IT设备供应商'),

(103, 'SONY', '东京都港区', 4,
 '135-0013-0013', 65000.00, '电子产品制造商');


-- =============================================
-- 4. 插入顾客数据 Customer
-- =============================================

INSERT INTO Customer
(custkey, name, address, nationkey, phone, acctbal, mktsegment, comment)
VALUES
(201, '苏举库', '上海市浦东新区', 3,
 '186-1111-2222', 12000.00, 'BUILDING', '重要客户'),

(202, '张三', '广州市天河区', 3,
 '186-3333-4444', 8500.00, 'AUTOMOBILE', '普通客户'),

(203, 'John Smith', 'New York', 2,
 '188-5555-6666', 25000.00, 'HOUSEHOLD', 'Overseas customer');




-- =============================================
-- 5. 插入零件数据 Part
-- =============================================

INSERT INTO Part
(partkey, name, mfgr, brand, type, size, container, retailprice, comment)
VALUES
(1, '螺丝钉A', 'MFGR#1', 'BRAND#11',
 'SMALL', 1, 'SM BOX', 0.50, 'Standard screw'),

(2, '芯片B', 'MFGR#2', 'BRAND#22',
 'MEDIUM', 5, 'MD PKG', 150.00, 'High-performance chip'),

(3, '外壳C', 'MFGR#1', 'BRAND#11',
 'LARGE', 50, 'LG CASE', 80.00, 'Plastic case');


-- =============================================
-- 6. 插入零件供应商联系数据 PartSupp
-- =============================================

INSERT INTO PartSupp
(partkey, suppkey, availqty, supplycost, comment)
VALUES
(1, 101, 10000, 0.20, '金仓集团供应螺丝钉A'),

(2, 101, 500, 180.50, '金仓集团供应芯片B'),

(3, 102, 2000, 60.00, '华为供应外壳C'),

(1, 103, 5000, 0.25, 'SONY供应螺丝钉A');


-- =============================================
-- 7. 插入订单数据 Orders
-- =============================================

INSERT INTO Orders
(orderkey, custkey, orderstatus, totalprice, orderdate,
 orderpriority, clerk, shippriority, comment)
VALUES
(1001, 201, 'F', 1680.50,
 CURDATE() - INTERVAL 3 DAY,
 '1-URGENT', 'Clerk#01', 0, '苏举库的订单1'),

(1002, 202, 'O', 800.00,
 CURDATE() - INTERVAL 10 DAY,
 '3-MEDIUM', 'Clerk#02', 1, '张三的订单'),

(1003, 201, 'F', 500.00,
 CURDATE() - INTERVAL 20 DAY,
 '5-LOW', 'Clerk#01', 1, '苏举库的订单2');


-- =============================================
-- 8. 插入订单明细数据 Lineitem
-- =============================================

INSERT INTO Lineitem
(orderkey, partkey, suppkey, linenumber,
 quantity, extendedprice, discount, tax,
 returnflag, linestatus,
 shipdate, commitdate, receiptdate,
 shipinstruct, shipmode, comment)
VALUES

(1001, 2, 101, 1,
 10, 1500.00, 0.05, 0.08,
 'N', 'F',
 CURDATE(), CURDATE(), CURDATE(),
 'TAKE BACK RETURN', 'AIR', '明细1'),

(1001, 1, 101, 2,
 500, 250.00, 0.05, 0.08,
 'N', 'F',
 CURDATE(), CURDATE(), CURDATE(),
 'TAKE BACK RETURN', 'AIR', '明细2'),

(1002, 3, 102, 1,
 10, 800.00, 0.0, 0.08,
 'A', 'F',
 CURDATE(), CURDATE(), CURDATE(),
 'DELIVER IN PERSON', 'TRUCK', '明细3'),

(1003, 1, 103, 1,
 1000, 250.00, 0.0, 0.0,
 'R', 'F',
 CURDATE(), CURDATE(), CURDATE(),
 'NONE', 'MAIL', '明细4');


select name, address, phone from Supplier;

select custkey, sum(totalprice)
from Orders
group by custkey;

select C.custkey, C.name
from Customer C, Orders O
where C.custkey = O.custkey
group by C.custkey, C.name
having avg(O.totalprice) > 1000;


select name, retailprice
from Part;

select name, phone
from Customer
where acctbal > 10000;

select orderdate, orderkey
from Orders
order by orderdate DESC;

select Nation.name, count(*)
from Nation, Supplier
where Nation.nationkey = Supplier.nationkey
group by Nation.name;


select Nation.name
from Nation, Region
where Region.name = 'Asia' and Region.regionkey = Nation.regionkey;

select Part.name, Part.brand
from Part, PartSupp, Supplier
where Supplier.name = '华为' and Supplier.suppkey = PartSupp.suppkey and PartSupp.partkey = Part.partkey;


select Customer.*, orderkey
from Customer
left join Orders on Orders.custkey = Customer.custkey
where orderkey is null;


-- =============================================
-- 使用 TPCH 数据库
-- =============================================

USE TPCH;


-- =============================================
-- 1. 新增客户 “李四”
-- =============================================

INSERT INTO Customer
(custkey, name, address, nationkey, phone, acctbal, mktsegment, comment)
VALUES
(204, '李四', '北京市朝阳区', 3,
 '138-5555-6666', 20000.00, 'FURNITURE', '新客户');


-- =============================================
-- 2. 新增供应商 “海大”
-- =============================================

INSERT INTO Supplier
(suppkey, name, address, nationkey, phone, acctbal, comment)
VALUES
(104, '海大', '大连市甘井子区', 3,
 '133-7777-8888', 95000.00, '船舶设备供应商');




-- =============================================
-- 3. 新增零件 “船舶模拟驾驶舱”
-- =============================================

INSERT INTO Part
(partkey, name, mfgr, brand, type, size, container, retailprice, comment)
VALUES
(4, '船舶模拟驾驶舱', '海大', 'BRAND#33',
 'LARGE', 200, 'LG CRATE', 50000.00, '高端模拟设备');


-- =============================================
-- 4. 建立新零件与供应商联系
-- =============================================

INSERT INTO PartSupp
(partkey, suppkey, availqty, supplycost, comment)
VALUES
(4, 104, 10, 42000.00, '海大供应船舶模拟驾驶舱');








-- =============================================
-- 5.1 为“苏举库”增加一笔高额订单
-- 并订购“船舶模拟驾驶舱”
-- =============================================

INSERT INTO Orders
(orderkey, custkey, orderstatus, totalprice, orderdate,
 orderpriority, clerk, shippriority, comment)
VALUES
(1004, 201, 'F', 51000.00,
 CURDATE() - INTERVAL 1 DAY,
 '1-URGENT', 'Clerk#03', 0, '苏举库的大额订单');


INSERT INTO Lineitem
(orderkey, partkey, suppkey, linenumber,
 quantity, extendedprice, discount, tax,
 returnflag, linestatus,
 shipdate, commitdate, receiptdate,
 shipinstruct, shipmode, comment)
VALUES
(1004, 4, 104, 1,
 1, 50000.00, 0, 0.08,
 'N', 'F',
 CURDATE(), CURDATE(), CURDATE(),
 'FRAGILE', 'TRUCK', '驾驶舱明细');


-- =============================================
-- 5.2 为“张三”创建新订单
-- 订购零件1和零件2
-- =============================================

INSERT INTO Orders
(orderkey, custkey, orderstatus, totalprice, orderdate,
 orderpriority, clerk, shippriority, comment)
VALUES
(1005, 202, 'O', 200.00,
 CURDATE() - INTERVAL 5 DAY,
 '3-MEDIUM', 'Clerk#02', 1, '张三的新订单');


INSERT INTO Lineitem
(orderkey, partkey, suppkey, linenumber,
 quantity, extendedprice, discount, tax,
 returnflag, linestatus,
 shipdate, commitdate, receiptdate,
 shipinstruct, shipmode, comment)
VALUES

(1005, 1, 101, 1,
 100, 50.00, 0, 0,
 'N', 'O',
 CURDATE(), CURDATE(), CURDATE(),
 'NONE', 'MAIL', '螺丝钉A'),

(1005, 2, 101, 2,
 1, 150.00, 0, 0,
 'N', 'O',
 CURDATE(), CURDATE(), CURDATE(),
 'NONE', 'MAIL', '芯片B');


-- =============================================
-- 5.3 为“李四”创建订单
-- 订购零件1、2、3
-- =============================================

INSERT INTO Orders
(orderkey, custkey, orderstatus, totalprice, orderdate,
 orderpriority, clerk, shippriority, comment)
VALUES
(1006, 204, 'O', 350.00,
 CURDATE() - INTERVAL 2 DAY,
 '2-HIGH', 'Clerk#03', 0, '李四的订单');


INSERT INTO Lineitem
(orderkey, partkey, suppkey, linenumber,
 quantity, extendedprice, discount, tax,
 returnflag, linestatus,
 shipdate, commitdate, receiptdate,
 shipinstruct, shipmode, comment)
VALUES

(1006, 1, 101, 1,
 100, 50.00, 0, 0,
 'N', 'O',
 CURDATE(), CURDATE(), CURDATE(),
 'NONE', 'AIR', '螺丝钉A'),

(1006, 2, 101, 2,
 1, 150.00, 0, 0,
 'N', 'O',
 CURDATE(), CURDATE(), CURDATE(),
 'NONE', 'AIR', '芯片B'),

(1006, 3, 102, 3,
 2, 160.00, 0, 0,
 'N', 'O',
 CURDATE(), CURDATE(), CURDATE(),
 'NONE', 'AIR', '外壳C');




select Customer.*
from Customer, Supplier, Lineitem, Orders
where Supplier.name = '海大' and Supplier.suppkey = Lineitem.suppkey AND 
Lineitem.orderkey = Orders.orderkey and Orders.custkey = Customer.custkey;

SELECT custkey, name
FROM Customer
WHERE custkey IN (
SELECT O.custkey
FROM Orders O, Lineitem L, PartSupp PS, Part P /* 四表连接 */
WHERE O.orderkey = L.orderkey
AND L.partkey = PS.partkey
AND L.suppkey = PS.suppkey
AND PS.partkey = P.partkey
AND P.mfgr =
'海大' AND P.name =
'船舶模拟驾驶舱'
);

select Customer.custkey, Customer.name
from Customer
where not exists(
	select * from Orders, Lineitem, Part
	where Part.name = '船舶模拟驾驶舱'
		and Part.partkey = Lineitem.partkey
		and Lineitem.orderkey = Orders.orderkey
		and Orders.custkey = Customer.custkey
		
);


use TPCH;
select Customer.name
from Customer
where Customer.name <> '张三' and not exists(
	select *
	from(
		select distinct Lineitem.partkey
		from Lineitem, Orders, Customer
		where Customer.name = '张三'
		and Customer.custkey = Orders.custkey
		and Orders.orderkey = Lineitem.orderkey
	
	) as P
	where not exists(
		select *
		from Lineitem, Orders
		where Customer.custkey = Orders.custkey
		and Orders.orderkey = Lineitem.orderkey
		and Lineitem.partkey = P.partkey
	
	)
);


select Customer.*
from Customer, (
	select custkey
	from Orders
	group by custkey
	having avg(totalprice) > 10000 ) as B,
	Nation 
where Customer.custkey = B.custkey 
and Customer.nationkey = Nation.nationkey
and Nation.name = '中国';

use TPCH;
SELECT Part.*
FROM Part
WHERE Part.partkey IN (
    SELECT DISTINCT Lineitem.partkey
    FROM Customer, Orders, Lineitem
    WHERE Customer.name = '张三'
      AND Customer.custkey = Orders.custkey
      AND Orders.orderkey = Lineitem.orderkey
)
AND Part.partkey IN (
    SELECT DISTINCT Lineitem.partkey
    FROM Customer, Orders, Lineitem
    WHERE Customer.name = '李四'
      AND Customer.custkey = Orders.custkey
      AND Orders.orderkey = Lineitem.orderkey
);

select Part.*
from (
	SELECT DISTINCT Lineitem.partkey
    FROM Customer, Orders, Lineitem
    WHERE Customer.name = '张三'
      AND Customer.custkey = Orders.custkey
      AND Orders.orderkey = Lineitem.orderkey
      union
     SELECT DISTINCT Lineitem.partkey
    FROM Customer, Orders, Lineitem
    WHERE Customer.name = '李四'
      AND Customer.custkey = Orders.custkey
      AND Orders.orderkey = Lineitem.orderkey
) as P, Part
where Part.partkey = P.partkey;


select distinct Part.*
from Nation, Region, Part, Supplier, PartSupp
where Region.name = 'ASIA'
and Region.regionkey = Nation.regionkey
and Nation.nationkey = Supplier.nationkey
and Supplier.suppkey = PartSupp.suppkey
and PartSupp.partkey = Part.partkey;

select Customer.*
from Customer
where exists(
	select Orders.custkey
	from Orders
	where Orders.custkey = Customer.custkey
);


select distinct Customer.name, B.order_count
from Customer, (
	select custkey, COUNT(*) as order_count
	from Orders
	group by custkey
	having count(*) > 1
) as B
where Customer.custkey = B.custkey;


select Part.*
from Part
where Part.retailprice > any(
	
	select PartSupp.supplycost
	from PartSupp, Supplier
	where Supplier.name = 'SONY'
	and PartSupp.suppkey = Supplier.suppkey

);

select distinct Region.name,   B.customer_count
from (

	select distinct Region.regionkey, COUNT(Customer.custkey) as customer_count
	from Region, Nation, Customer
	where Region.regionkey = Nation.regionkey
	and Nation.nationkey = Customer.nationkey
	group by regionkey

) as B, Region
where Region.regionkey = B.regionkey;



-- =================
-- 第五周实验内容
-- 实验3.4
use TPCH;
insert into Supplier(suppkey, name, address, nationkey, phone, acctbal, comment)
VALUES (105,
'大疆创新'
,
'深圳市南山区'
, 3,
'136-9999-8888'
, 98000.00,
'无人机制造商');

create table ChineseCustomer like Customer;

insert into ChineseCustomer
select Customer.*
from Customer, Nation
where Customer.nationkey = Nation.nationkey
	and Nation.name = 'CHINA';

update PartSupp
set supplycost = supplycost * 1.1
where suppkey = 101;


-- 3.4
insert into Nation(nationkey, name, regionkey, comment)
values(6, 'NEWZEALAND', 5, 'Located in Oceania');

update Lineitem
set quantity = quantity - 50
where suppkey = 102;

use TPCH;
delete from Region
where regionkey = 2;


-- 实验内容3.5
create view V_Part_Supplier as
SELECT 
	Part.name as Part_name,
	Part.retailprice,
	Supplier.name as Supplier_name,
	PartSupp.supplycost
from Part, PartSupp, Supplier
where Part.partkey = PartSupp.partkey
	and PartSupp.suppkey = Supplier.suppkey;

create view V_Customer_States as
select 
	Customer.name,
	Customer.custkey,
	COUNT(Orders.orderkey),
	avg(Orders.totalprice)
from Customer, Orders
where Customer.custkey = Orders.custkey
group by Orders.custkey;


create view V_Huawei_Supplies as
select
	partkey,
	suppkey,
	supplycost,
	comment
from PartSupp
where suppkey = 101
with check option;


-- 3.5
create view V_Customer_Asia as
select
	C.*
from Customer C, Nation, Region
where C.nationkey = Nation.nationkey
	and Nation.regionkey = Region.regionkey
	and Region.name = 'ASIA';

select *
from V_Part_Supplier
where supplycost > retailprice;

drop view V_Part_Supplier, V_Huawei_supplies, V_Customer_States, V_Customer_Asia;


-- 3.6实验内容
explain
select *
from Customer
where nationkey = 3;

EXPLAIN FORMAT=TRADITIONAL
SELECT *
FROM Customer
WHERE nationkey = 3;


create index idx_customer_phone on Customer(phone);

explain format = traditional
select *
from Customer
where phone = '186-1111-2222';


-- 3.5
create unique index idx_part_name on Part(name);

insert into Part(name)
values('外壳C');

drop index idx_customer_phone on Customer;
drop index idx_part_name on Part;


-- 第七周
show grants;

-- 1. 创建经理用户
CREATE USER 'david'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'tom'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'kathy'@'localhost' IDENTIFIED BY '123456';


-- 2. 授予经理创建用户和管理角色的权限
-- WITH GRANT OPTION 允许转授相应权限
GRANT CREATE USER, ROLE_ADMIN ON *.*
TO 'david'@'localhost'
WITH GRANT OPTION;

GRANT CREATE USER, ROLE_ADMIN ON *.*
TO 'tom'@'localhost'
WITH GRANT OPTION;

GRANT CREATE USER, ROLE_ADMIN ON *.*
TO 'kathy'@'localhost'
WITH GRANT OPTION;


-- 3. 创建职员用户
CREATE USER 'jeffery'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'jane'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'mike'@'localhost' IDENTIFIED BY '123456';


-- 4. USAGE 不授予实际的数据操作权限
GRANT USAGE ON *.*
TO 'david'@'localhost',
   'tom'@'localhost',
   'kathy'@'localhost',
   'jeffery'@'localhost',
   'jane'@'localhost',
   'mike'@'localhost';


-- 5. 授予三位经理 tpch 数据库范围内的全部权限
GRANT ALL PRIVILEGES ON `tpch`.*
TO 'david'@'localhost',
   'tom'@'localhost',
   'kathy'@'localhost';


-- 6. 刷新权限（原文保留，但上述语句执行后不需要额外刷新）
FLUSH PRIVILEGES;








-- 创建六个角色
CREATE ROLE 'purchase_employee', 'purchase_manager',
            'sale_employee', 'sale_manager',
            'customer_employee', 'customer_manager';


-- ① 采购部职员：查询、插入采购相关表
GRANT SELECT, INSERT ON tpch.Part TO 'purchase_employee';
GRANT SELECT, INSERT ON tpch.Supplier TO 'purchase_employee';
GRANT SELECT, INSERT ON tpch.PartSupp TO 'purchase_employee';

-- 采购部经理：本部门表的全部权限，以及部分其他表的查询权限
GRANT ALL ON tpch.Part TO 'purchase_manager';
GRANT ALL ON tpch.Supplier TO 'purchase_manager';
GRANT ALL ON tpch.PartSupp TO 'purchase_manager';

GRANT SELECT ON tpch.Orders TO 'purchase_manager';
GRANT SELECT ON tpch.Lineitem TO 'purchase_manager';
GRANT SELECT ON tpch.Customer TO 'purchase_manager';


-- ② 销售部职员
GRANT SELECT, INSERT ON tpch.Orders TO 'sale_employee';
GRANT SELECT, INSERT ON tpch.Lineitem TO 'sale_employee';

-- 销售部经理
GRANT ALL ON tpch.Orders TO 'sale_manager';
GRANT ALL ON tpch.Lineitem TO 'sale_manager';

GRANT SELECT ON tpch.Part TO 'sale_manager';
GRANT SELECT ON tpch.Customer TO 'sale_manager';


-- ③ 客户管理部职员
GRANT SELECT, INSERT ON tpch.Customer TO 'customer_employee';
GRANT SELECT, INSERT ON tpch.Nation TO 'customer_employee';
GRANT SELECT, INSERT ON tpch.Region TO 'customer_employee';

-- 客户管理部经理
GRANT ALL ON tpch.Customer TO 'customer_manager';
GRANT ALL ON tpch.Nation TO 'customer_manager';
GRANT ALL ON tpch.Region TO 'customer_manager';

GRANT SELECT ON tpch.Orders TO 'customer_manager';

-- 为经理分配角色
-- WITH ADMIN OPTION：允许将相应角色授予其他用户
GRANT 'purchase_manager'
TO 'david'@'localhost' WITH ADMIN OPTION;

GRANT 'sale_manager'
TO 'tom'@'localhost' WITH ADMIN OPTION;

GRANT 'customer_manager'
TO 'kathy'@'localhost' WITH ADMIN OPTION;


-- 为职员分配角色
GRANT 'purchase_employee' TO 'jeffery'@'localhost';
GRANT 'sale_employee' TO 'jane'@'localhost';
GRANT 'customer_employee' TO 'mike'@'localhost';


-- 登录时默认激活已授予的所有角色
SET DEFAULT ROLE ALL TO
    'david'@'localhost',
    'tom'@'localhost',
    'kathy'@'localhost',
    'jeffery'@'localhost',
    'jane'@'localhost',
    'mike'@'localhost';


SHOW GRANTS FOR 'david'@'localhost';
SHOW GRANTS FOR 'mike'@'localhost';

-- 查看采购经理角色本身有哪些权限
SHOW GRANTS FOR 'purchase_manager';


use TPCH;
SELECT USER(), CURRENT_USER();

REVOKE 'customer_employee'
FROM 'mike'@'localhost';


grant 'customer_employee'
to 'mike'@'localhost' with admin option;


create user 'audit_user'@'localhost' identified by '123456';
create role 'auditor';

grant select on TPCH.*
to 'auditor';

grant 'auditor' to 'audit_user'@'localhost';





-- =========================
-- 第九周

DELIMITER $$

create trigger TPI_Lineitem_Price_INSERT
after insert on Lineitem
for each row
begin
	declare L_valuediff real;
	SET L_valuediff = NEW.extendedprice * (1 - NEW.discount) * (1 + NEW.tax);
	
	update Orders
	set totalprice = L_valuediff + totalprice
	where orderkey = new.orderkey;
end$$
DELIMITER ;

drop trigger if exists TPI_Lineitem_Price_INSERT;



DROP TRIGGER IF EXISTS TRI_Lineitem_Price_INSERT;
DROP TRIGGER IF EXISTS TRI_Lineitem_Price_UPDATE;
DROP TRIGGER IF EXISTS TRI_Lineitem_Price_DELETE;

DROP TRIGGER IF EXISTS TRI_Lineitem_Quantity_INSERT;
DROP TRIGGER IF EXISTS TRI_Lineitem_Quantity_UPDATE;
DROP TRIGGER IF EXISTS TRI_Lineitem_Quantity_DELETE;










DELIMITER $$

-- 1. 插入订单明细后：增加订单总价
CREATE TRIGGER TRI_Lineitem_Price_INSERT
AFTER INSERT ON Lineitem
FOR EACH ROW
BEGIN
    DECLARE L_valuediff REAL;

    SET L_valuediff =
        NEW.extendedprice * (1 - NEW.discount) * (1 + NEW.tax);

    UPDATE Orders
    SET totalprice = totalprice + L_valuediff
    WHERE orderkey = NEW.orderkey;
END$$


-- 2. 修改订单明细后：按价格差额调整订单总价
CREATE TRIGGER TRI_Lineitem_Price_UPDATE
AFTER UPDATE ON Lineitem
FOR EACH ROW
BEGIN
    DECLARE L_valuediff REAL;
    DECLARE L_new_value REAL;
    DECLARE L_old_value REAL;

    SET L_new_value =
        NEW.extendedprice * (1 - NEW.discount) * (1 + NEW.tax);

    SET L_old_value =
        OLD.extendedprice * (1 - OLD.discount) * (1 + OLD.tax);

    SET L_valuediff = L_new_value - L_old_value;

    IF L_valuediff <> 0 THEN
        UPDATE Orders
        SET totalprice = totalprice + L_valuediff
        WHERE orderkey = NEW.orderkey;
    END IF;
END$$


-- 3. 删除订单明细后：减少订单总价
CREATE TRIGGER TRI_Lineitem_Price_DELETE
AFTER DELETE ON Lineitem
FOR EACH ROW
BEGIN
    DECLARE L_valuediff REAL;

    SET L_valuediff =
        OLD.extendedprice * (1 - OLD.discount) * (1 + OLD.tax);

    UPDATE Orders
    SET totalprice = totalprice - L_valuediff
    WHERE orderkey = OLD.orderkey;
END$$


-- 4. 插入订单明细前：检查并扣减库存
CREATE TRIGGER TRI_Lineitem_Quantity_INSERT
BEFORE INSERT ON Lineitem
FOR EACH ROW
BEGIN
    DECLARE L_availqty INTEGER;

    SELECT availqty INTO L_availqty
    FROM PartSupp
    WHERE partkey = NEW.partkey
      AND suppkey = NEW.suppkey;

    IF (L_availqty - NEW.quantity) < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Available quantity is NOT ENOUGH';
    ELSE
        UPDATE PartSupp
        SET availqty = availqty - NEW.quantity
        WHERE partkey = NEW.partkey
          AND suppkey = NEW.suppkey;
    END IF;
END$$


-- 5. 修改订单明细前：检查并调整库存
CREATE TRIGGER TRI_Lineitem_Quantity_UPDATE
BEFORE UPDATE ON Lineitem
FOR EACH ROW
BEGIN
    DECLARE L_valuediff REAL;
    DECLARE L_availqty INTEGER;

    IF NEW.quantity <> OLD.quantity THEN
        SET L_valuediff = NEW.quantity - OLD.quantity;

        SELECT availqty INTO L_availqty
        FROM PartSupp
        WHERE partkey = NEW.partkey
          AND suppkey = NEW.suppkey;

        IF (L_availqty - L_valuediff) < 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Available quantity is NOT ENOUGH';
        ELSE
            UPDATE PartSupp
            SET availqty = availqty - L_valuediff
            WHERE partkey = NEW.partkey
              AND suppkey = NEW.suppkey;
        END IF;
    END IF;
END$$


-- 6. 删除订单明细前：归还库存
CREATE TRIGGER TRI_Lineitem_Quantity_DELETE
BEFORE DELETE ON Lineitem
FOR EACH ROW
BEGIN
    UPDATE PartSupp
    SET availqty = availqty + OLD.quantity
    WHERE partkey = OLD.partkey
      AND suppkey = OLD.suppkey;
END$$

DELIMITER ;


select totalprice
from Orders
where Orderkey = 1001;

update Lineitem
set tax = 0.09
where orderkey = 1001
	and linenumber = 1;

select totalprice
from Orders
where Orderkey = 1001;

update Lineitem
set tax = 0.08
where orderkey = 1001
	and linenumber = 1;


-- 实验任务
-- 设计并创建一个新表 Orders_Log(log_id INT AUTO_INCREMENT PRIMARY KEY,orderkey INT, old_price REAL, new_price REAL, change_time TIMESTAMP DEFAULT
-- CURRENT_TIMESTAMP)。然后创建一个 AFTER UPDATE 触发器，当 Orders 表的 totalprice 发
-- 生变化时，自动向 Orders_Log 表中插入一条日志记录。

create table Orders_Log(
	log_id int AUTO_INCREMENT primary key;
	orderkey int;
	old_price real;
	new_price real;
	change_time timestamp default current_timestamp;

);


delimiter &&

create trigger TRI_Orders_totalprice
after update on Orders
for each row
begin

	declare old_price real;
	declare new_price real;
	declare orderkey int;

	set old_price = old.totalprice;
	set new_price = new.totalprice;
	set orderkey = new.orderkey;
	
	if new.totalprice <> old.totalprice then

	insert into Orders_Log(orderkey, old_price, new_price)
	values(
		orderkey,
		old_price,
		new_price
	);
	
	end if;
end &&

delimiter ;



-- 防止删除触发器: 创建一个 BEFORE DELETE 触发器，在 Customer 表上。如果该顾客在 Orders
-- 表中仍有订单，则阻止删除该顾客，并报错 "无法删除尚有订单的顾客"


delimiter &&

create trigger TRI_Customer
before delete on Customer
for each row
begin
	
	if exists (
		select 1
		from Orders
		where Orders.custkey = old.custkey
		
	) then
		signal sqlstate '45000'
			set message_text = '无法删除尚有订单的顾客';
	end if;
	
end&&

delimiter ;
















