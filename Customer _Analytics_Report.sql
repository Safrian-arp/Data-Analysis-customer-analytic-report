--Memahami table
select * from orders_1 limit 5;
select * from orders_2 limit 5;
select * from customer limit 5;

--Pertumbuhan Penjualan Saat Ini
--Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)
select
sum(quantity) total_penjualan,
sum(quantity * priceEach) revenue
from orders_1
where status = 'Shipped';

select 
sum(quantity) total_penjualan,
sum(quantity * priceEach) revenue
from orders_2
where status = 'Shipped';


--Menghitung persentasi keseluruhan penjualan
select
quarter,
sum(quantity) total_penjualan,
sum(quantity * priceEach) revenue
from 
(select orderNumber,status,quantity,priceEach, '1' as quarter
 from orders_1 
 union
 select orderNumber,status,quantity,priceEach, '2' as quarter
 from orders_2
 ) tabel_a
 where status = 'Shipped'
 group by quarter;


--Apakah jumlah customers xyz.com semakin bertambah
select
quarter,
count(customerID) total_customers
from 
(select 
customerID, createDate, Quarter(createDate) quarter
from customer
 where createDate Between '2004-01-01' and '2004-06-30'
) tabel_b
group by quarter;


--Seberapa banyak customers tersebut yang sudah melakukan transaksi?
select quarter,
count(customerID) total_customers
from
(
select customerID, createDate, Quarter(createDate) as quarter
from customer
where createDate between '2004-01-01' and '2004-06-30'
) table_b
where customerID in 
(
select distinct(customerID) as total_customers
from orders_1
union
select distinct(customerID) as total_customers
from orders_2
)
group by quarter;


--Category produk apa saja yang paling banyak di-order oleh customers di Quarter-2?
select * 
from (select categoryID, 
	  count(distinct orderNumber) as total_order,
	 sum(quantity) as total_penjualan
	 from (select productCode, orderNumber, quantity, status,
		  left(productCode,3) as categoryID
		  from orders_2
		  where status = 'shipped')tabel_c
	 group by categoryID) sub 
	 order by total_order DESC;

--Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
#output = 25
select '1' as quarter,
count(distinct customerID)/25*100 as q2
from orders_1
where customerID in
(select distinct customerID from orders_2);
