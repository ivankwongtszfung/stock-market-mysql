--Question1
delimiter /
create trigger t1
  after insert
  on stock
  for each row
  begin
   insert into stock_log(symbol,indexNo,value ,lot ,  price ,  amountOfTrade , currentTimestamp)
     value (new.symbol,new.indexNo,new.value ,new.lot ,  new.price ,  new.amountOfTrade , new.currentTimestamp)
      ;
  end;/

delimiter ;

delimiter /
create trigger t3
  after update
  on stock
  FOR EACH ROW
  begin
   insert into stock_log(symbol,indexNo,value ,lot ,  price ,amountOfTrade,currentTimestamp)
    values(new.symbol,new.indexNo,new.value ,new.lot ,  new.price ,new.amountOfTrade,new.currentTimestamp);
  end;/

delimiter ;

insert into corporation(name,teleNo,address,NIC) values('HSBC Holdings plc',27488333,'paid concourse,MTR university Station,ShaTin,New Territories','blue chips stocks');

--customer,broker,admin
SELECT * FROM stock
WHERE
  exists(select * from customer where name=@username) or exists(select * from broker where name=@username) or
  exists(select * from adminstrator where name=@username)
;
-- guest
select * from stock_log
where hour(currentTimestamp)=(hour(now())) and MINUTE(currentTimestamp)=0;

--question2
--check stock by symbol/ non-guest
set @symbol='HSBC';
set @index=5;
select * from stock
where symbol=@symbol or indexNo=@index;
--check stock by symbol/ guest
set @symbol='HSBC';
set @index=5;
select * from stock_log
where (symbol=@symbol or indexNo=@index) and (hour(currentTimestamp)=(hour(now())) and MINUTE(currentTimestamp)=0);

--question3
--top five most active
select symbol,max(amountOfTrade) from stock_log
where day(currentTimestamp)=day(now())
group by symbol
limit 5;

--opening closing price
select t11.symbol ,t11.closingprice as openingPrice,t22.closingprice from(
(select t2.symbol,t1.price as closingprice from
((select * from stock_log) t1
join
(select distinct symbol,min(currentTimestamp) as currentTimestamp from stock_log where day(currentTimestamp)=day(now())
group by symbol) t2
on t1.currentTimestamp=t2.currentTimestamp and t1.symbol=t2.symbol )
group by t2.symbol) t11
inner join
(select t4.symbol,t3.price as closingprice from
((select * from stock_log) t3
join
(select distinct symbol,max(currentTimestamp) as currentTimestamp from stock_log where day(currentTimestamp)=day(now())
group by symbol) t4
on t3.currentTimestamp=t4.currentTimestamp and t3.symbol=t4.symbol )
group by t4.symbol) t22
on t11.symbol=t22.symbol);


--this is the price range of stock
select t1.symbol,t1.minimun,t2.maximun from
(
  (select symbol,min(price) as minimun from stock_log
  where day(currentTimestamp)=day(now())
  group by symbol
  ) t1
  JOIN
  (select symbol,max(price) as maximun from stock_log
  where day(currentTimestamp)=day(now())
  group by symbol
) t2
  on t1.symbol=t2.symbol
);

--question4
--insert customer
insert into customer(name,teleNo,password,addresses,birthday,NIC) values ('sunny',28971234,'sunsun','chinese U,lee wo sin','1995-01-13','sunny birthday'),('ivan',12345678,'sunsun','happy valley,local street','1996-08-25','317 very sucks'),('van',12345678,'vanvan','happy valley,local street','1996-08-25','317 very sucks');

--insert broker
insert into broker(name,teleNo,password,address,birthday,NIC) values ('jijs',24567111,'jijs1122','paradism US','1996-01-01','i am a smart broker'),('apple',12345687,'jijs11sadf22','paradism US','1996-01-01','i am a smart broker'),('pen',3215451,'jijssss1122','paradism US','1996-01-01','i am a smart broker');

--customer assign broker
set @username='van';
set @broker='apple';
insert into customerBroker(customerId,licenseNo)
(select  customerId,licenseNo
from customer c,broker b
where c.name=@username and b.name=@broker);

--find the top 3 broker
select  t2.name,t1.numberOfCustomer from
((select licenseNo,count(licenseNo) as numberOfCustomer
from customerBroker
group by licenseNo
order by licenseNo DESC) t1
left join
(select * from broker) t2
on t1.licenseNo=t2.licenseNo
)order by t1.numberOfCustomer DESC;

--List the customers who own at least a share of all stocks in the market.
set @cash=100;
delimiter /
create trigger customerProfo
  after insert
  on customer
  for each row
  begin
   insert into profolio(profolioId,cash)
     values (new.customerId,@cash);
  end;/
delimiter ;

--customer buy stock which afford
set @NoOfShare=10;
set @stockName='ABC ltd';
set @username='ivan';
set @price:=(select price from stock where symbol=@stockName);
set @price:=@price*@NoOfShare;
set @cash:=(select cash from profolio
where profolioId=(select customerId from customer where customer.name=@username));
set @index:=(select indexNo from stock where stock.symbol=@stockName);
insert into share(shareId,shares,regNo)
(select 1,@price,@index from profolio where @cash>@amountOfTrade);


set @NoOfStock:=(select count(*) from stock);
select profolioId as customerIdWhoHaveAllStock from
(select distinct profolioId,count(*) as no from customerStock
group by profolioId) a
where no=@NoOfStock;

--only admin can do every update,block customer
set @username:='admin';
set @password:='admin';

delimiter /
create trigger adminright
  before insert
  on stock
  for each row
  begin
  DECLARE msg VARCHAR(255);
  IF (exist(select * from adminstrator where name=@username and password=@password;)) THEN
      set msg = "Only admin can update";
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
  END IF;

  end;/

delimiter ;


delimiter /
create trigger adminright
  before update
  on stock
  for each row
  begin
  DECLARE msg VARCHAR(255);
  IF (exist(select * from adminstrator where name=@username and password=@password;)) THEN
      set msg = "Only admin can update";
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
  END IF;

  end;/

delimiter ;

delimiter /
create trigger adminright
  before update
  on customer
  for each row
  begin
  DECLARE msg VARCHAR(255);
  IF (exist(select * from adminstrator where name=@username and password=@password;)) THEN
      set msg = "Only admin can update";
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
  END IF;

  end;/

delimiter ;
