create database TPC_H character set utf8mb4;

create table Region (
	regionkey int primary key,
	name varchar(50),
	comment varchar(70)

);

create table Nation (
	nationkey int primary key,
	name varchar(50),
	regionkey int,
	comment varchar(70),
	
	foreign key (regionkey) references Region(regionkey)
	
);

create table Part (
	partkey int primary key,
	name varchar(50),
	mfgr varchar(50),
	brand varchar(40),
	type varchar(40),
	size int,
	container varchar(50),
	retailprice int,
	comment varchar(70)

);


create table Supplier (
	suppkey int primary key,
	name varchar(50),
	address varchar(50),
	nationkey int,
	phone varchar(50),
	acctbal int,
	comment varchar(50),
	
	foreign key (nationkey) references Nation(nationkey)


);

create table PartSupp (
	partkey int,
	suppkey int,
	availqty int,
	supplycost int,
	comment varchar(50),
	
	primary key(partkey, suppkey),
	foreign key (partkey) references Part(partkey),
	foreign key (suppkey) references Supplier(suppkey)


);

create table Customer (
	custkey int primary key,
	name varchar(50),
	address varchar(50),
	nationkey int,
	phone varchar(50),
	acctbal int,
	mktsegment varchar(50),
	comment varchar(50),
	
	foreign key (nationkey) references Nation(nationkey)


);


create table Orders (
	orderkey int primary key,
	custkey int,
	orderstatus char,
	totalprice float,
	orderdate date,
	orderpriority varchar(50),
	clerk varchar(50),
	shippriority int,
	comment varchar(50),
	
	foreign key (custkey) references Customer(custkey)

);


create table lineitem (
    orderkey int not null,
    partkey int not null,
    suppkey int not null,
    linenumber int not null,
    quantity int,
    extendedprice decimal(15, 2),
    discount decimal(4, 2),
    tax decimal(4, 2),
    returnflag char(1),
    linestatus char(1),
    shipdate date,
    commitdate date,
    receiptdate date,
    shipinstruct varchar(50),
    shipmode varchar(50),
    comment varchar(50),

    constraint pk_lineitem primary key (orderkey, linenumber),
    constraint fk_lineitem_orders foreign key (orderkey) references orders(orderkey),
    constraint fk_lineitem_partsupp foreign key (partkey, suppkey) references partsupp(partkey, suppkey)
);


alter table part
add constraint ck_part_price check (retailprice > 0);

alter table partsupp
add constraint ck_partsupp_availqty check (availqty >= 0);



show create table part;
show create table partsupp;


insert into region (regionkey, name, comment)
values
    (1, 'ASIA', '亚洲'),
    (2, 'EUROPE', '欧洲'),
    (3, 'AFRICA', '非洲');

insert into nation (nationkey, name, regionkey, comment)
values
    (1, 'CHINA', 1, '中国'),
    (2, 'JAPAN', 1, '日本'),
    (3, 'GERMANY', 2, '德国'),
    (4, 'EGYPT', 3, '埃及');

select nation.name as nation_name, region.name as region_name
from nation
join region on nation.regionkey = region.regionkey
order by nation.nationkey;


insert into supplier (suppkey, name, address, nationkey, phone, acctbal, comment)
values
    (1, '华南电子', '广州', 1, '020-10000001', 8000.00, '电子元件供应商'),
    (2, '华东机械', '上海', 1, '021-10000002', 6500.00, '机械零件供应商'),
    (3, '东京精工', '东京', 2, '03-10000003', 7200.00, '精密零件供应商'),
    (4, '柏林工业', '柏林', 3, '030-10000004', 9000.00, '工业零件供应商');

insert into part (partkey, name, mfgr, brand, type, size, container, retailprice, comment)
values
    (1, '温度传感器', '华南电子', '南星', '电子元件', 2, '盒装', 35.00, '用于温度检测'),
    (2, '滚珠轴承', '东京精工', '精工', '机械零件', 5, '盒装', 80.00, '用于转轴支撑'),
    (3, '六角螺栓', '华东机械', '东力', '紧固件', 8, '袋装', 2.50, '用于零件固定');

select suppkey, name, nationkey from supplier order by suppkey;
select partkey, name, retailprice from part order by partkey;

insert into partsupp (partkey, suppkey, availqty, supplycost, comment)
values
    (1, 1, 300, 20.00, '华南电子供应温度传感器'),
    (1, 2, 250, 22.00, '华东机械供应温度传感器'),
    (2, 3, 50,  55.00, '东京精工供应滚珠轴承'),
    (3, 4, 15,   1.50, '柏林工业供应六角螺栓'),
    (3, 2, 8,    1.40, '华东机械供应六角螺栓');

select * from partsupp
order by partkey, suppkey;

insert into customer (custkey, name, address, nationkey, phone, acctbal, mktsegment, comment)
values
    (1, '张三', '广州', 1, '13800000001', 8000.00, '零售', '电子产品采购'),
    (2, '李四', '上海', 1, '13800000002', 4000.00, '零售', '机械零件采购'),
    (3, '佐藤', '东京', 2, '03-20000003', 7000.00, '制造', '精密零件采购'),
    (4, '铃木', '大阪', 2, '06-20000004', 3000.00, '制造', '工业零件采购'),
    (5, '韦伯', '柏林', 3, '030-20000005', 5000.00, '零售', '紧固件采购');


select customer.name, nation.name as nation_name, customer.acctbal
from customer
join nation on customer.nationkey = nation.nationkey
order by customer.custkey;

insert into orders (orderkey, custkey, orderstatus, totalprice, orderdate, orderpriority, clerk, shippriority, comment)
values
    (1001, 1, 'o',  70.00, '2026-11-01', '普通', '小陈', 0, '张三第一次下单'),
    (1002, 1, 'o',  80.00, '2026-11-03', '普通', '小陈', 0, '张三第二次下单'),
    (1003, 2, 'o',  25.00, '2026-11-04', '普通', '小林', 0, '李四采购螺栓'),
    (1004, 3, 'o', 115.00, '2026-11-05', '加急', '小林', 0, '佐藤采购两种零件'),
    (1005, 4, 'o', 160.00, '2026-11-06', '普通', '小陈', 0, '铃木采购轴承');


select customer.name, count(orders.orderkey) as order_count
from customer
left join orders on customer.custkey = orders.custkey
group by customer.custkey, customer.name
order by customer.custkey;

insert into lineitem (
    orderkey, linenumber, partkey, suppkey, quantity, extendedprice,
    discount, tax, returnflag, linestatus, shipdate, commitdate,
    receiptdate, shipinstruct, shipmode, comment
)
values
    (1001, 1, 1, 1,  2,  70.00, 0, 0, 'n', 'o', '2026-11-03', '2026-11-04', '2026-11-05', '送货上门', '快递', '两个温度传感器'),
    (1002, 1, 2, 3,  1,  80.00, 0, 0, 'n', 'o', '2026-11-05', '2026-11-06', '2026-11-07', '送货上门', '快递', '一个滚珠轴承'),
    (1003, 1, 3, 2, 10,  25.00, 0, 0, 'n', 'o', '2026-11-06', '2026-11-07', '2026-11-08', '送货上门', '快递', '十个六角螺栓'),
    (1004, 1, 1, 2,  1,  35.00, 0, 0, 'n', 'o', '2026-11-07', '2026-11-08', '2026-11-09', '送货上门', '快递', '一个温度传感器'),
    (1004, 2, 2, 3,  1,  80.00, 0, 0, 'n', 'o', '2026-11-07', '2026-11-08', '2026-11-09', '送货上门', '快递', '一个滚珠轴承'),
    (1005, 1, 2, 3,  2, 160.00, 0, 0, 'n', 'o', '2026-11-08', '2026-11-09', '2026-11-10', '送货上门', '快递', '两个滚珠轴承');


-- 任务三
insert into Region (regionkey) values (3);

insert into Nation (regionkey) values (4);


delete from Region WHERE regionkey = 3;

insert INTO Part (partkey, retailprice) values (4,-30);

insert into PartSupp (partkey, suppkey, availqty) values (1,3,-30);


-- 任务四
show create table nation;
alter table nation
    drop foreign key nation_ibfk_1,
    add constraint fk_nation_region_cascade
        foreign key (regionkey) references region(regionkey)
        on delete cascade;


-- 任务五
select Nation.name, count(distinct Supplier.suppkey), count(distinct partsupp.partkey),
	sum(PartSupp.availqty), avg(PartSupp.supplycost)
from Nation
join Supplier on Nation.nationkey = Supplier.nationkey 
join PartSupp on PartSupp.suppkey = Supplier.suppkey 
group by Nation.name, Nation.nationkey
having sum(PartSupp.availqty) > 500;


-- task6
select Customer.name, Nation.name, Customer.acctbal
from Customer, Nation
where Customer.acctbal > (
	select avg(c.acctbal)
	from Customer c
	where c.nationkey = Customer.nationkey

)
	and Customer.nationkey = Nation.nationkey;


select *
from Customer c
where not exists (
	
	select 1
	from Orders o
	where o.custkey = c.custkey

);


-- task7

create table StockAlert_Log (
	alert_id int auto_increment,
	partkey int,
	suppkey int,
	alert_time timestamp default current_timestamp,
	
	constraint pk_stockalert_log primary key (alert_id)

);

delimiter &&

create trigger trg_partsupp_lowstock
after update on PartSupp
for each row
if new.availqty < 10 and old.availqty >= 10 then
	insert into StockAlert_Log (partkey, suppkey)
	values(new.partkey, new.suppkey);
end if&&
delimiter ;

show create trigger trg_partsupp_lowstock;

update PartSupp
set availqty = 5
where partkey = 1 and suppkey = 2;

select * from StockAlert_Log;

update partsupp
set availqty = 12
where partkey = 3 and suppkey = 4;







