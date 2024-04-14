select br_name, sum(t_amount), count(t_amount)
from transactions t join account ac on t.ac_no=ac.Ac_no 
					 join customer cust on ac.cust_id=cust.Cust_id
					 join branch br on cust.br_id=br.br_id
group by br_name
having count(t_amount) > 1
order by sum(t_amount) desc

select br_name, sum(t_amount), count(t_amount)
from transactions t join account ac on t.ac_no=ac.Ac_no 
					 join customer cust on ac.cust_id=cust.Cust_id
					 join branch br on cust.br_id=br.br_id
group by br_name
order by sum(t_amount) desc

select distinct br_name, count(cust.cust_id) 'Sl Khách hàng'
from customer cust join branch br on cust.Br_id=br.BR_id
				   join account ac on cust.Cust_id=ac.cust_id
				   join transactions t on ac.Ac_no=t.ac_no
where ac.Ac_no not in (select distinct ac.ac_no
							from customer cust join branch br on cust.Br_id=br.BR_id
											   join account ac on cust.Cust_id=ac.cust_id
											   join transactions t on ac.Ac_no=t.ac_no)
group by br_name
order by count(cust.cust_id) desc

select br_name, count(cust.cust_id)
from customer cust join branch br on cust.Br_id=br.BR_id
				   join account ac on cust.Cust_id=ac.cust_id
				   join transactions t on ac.Ac_no=t.ac_no
where t_id is not null
group by br_name
order by count(cust.cust_id) desc
--1. Có bao nhiêu khách hàng có ở Quảng Nam thuộc chi nhánh ngân hàng Vietcombank Đà Nẵng
SELECT COUNT (*) 'Sl khách hàng'
from customer cust join branch br on cust.br_id=br.br_id 
where cust_ad like N'%Quảng Nam%' and br_name like N'Vietcombank Đà Nẵng'

--2. Hiển thị danh sách khách hàng thuộc chi nhánh Vũng Tàu và số dư trong tài khoản của họ.
SELECT cust.cust_name, CUST.CUST_ID, SUM (ac_balance)
FROM customer cust, branch br, account ac
where cust.cust_id=ac.cust_id and cust.br_id=br.br_id and br_name like N'Vietcombank Vũng Tàu'
GROUP BY cust.cust_name, CUST.CUST_ID

select cust.cust_id, cust_name, cust_ad, sum(ac_balance)
from account ac join customer cust on cust.cust_id=ac.cust_id join branch br on cust.br_id=br.br_id
where br_name like N'Vietcombank Vũng Tàu'
GROUP BY cust.cust_id, cust_name, cust_ad

--3. Trong quý 1 năm 2012, có bao nhiêu khách hàng thực hiện giao dịch rút tiền tại Ngân hàng Vietcombank?
select count (*) 'SL khách hàng'
from transactions t join account ac on t.ac_no=ac.Ac_no join customer cust on ac.cust_id=cust.Cust_id
join branch br on cust.br_id=br.br_id
where t_type=1 and datepart(qq, t_date)=1 and br_name like N'Vietcombank%'

--4. Thống kê số lượng giao dịch, tổng tiền giao dịch trong từng tháng của năm 2014
select MONTH(t_date), count(t_amount) 'SL giao dịch', sum(t_amount) 'Tổng tiền gd'
from transactions
where year(t_date)=2014
group by month(t_date)

--5. Thống kê tổng tiền khách hàng gửi của mỗi chi nhánh, sắp xếp theo thứ tự giảm dần của tổng tiền
select cust.br_id, br_name, sum(t_amount) 'tổng tiền'
from transactions t join account ac on t.ac_no=ac.Ac_no join customer cust on ac.cust_id=cust.Cust_id
join branch br on cust.br_id=br.br_id
where t_type=0
group by cust.br_id, br_name
order by sum(t_amount) desc
/*6. Chi nhánh Sài Gòn có bao nhiêu khách hàng không thực hiện bất kỳ giao dịch nào trong vòng 3 năm trở lại đây. 
Nếu có thể, hãy hiển thị tên và số điện thoại của các khách đó để phòng marketing xử lý.*/
select Cust_name,Cust_phone
from customer cust join branch br on cust.Br_id=br.BR_id
				   join account ac on cust.Cust_id=ac.cust_id
				   left outer join transactions t on ac.Ac_no=t.ac_no
where BR_name like N'% sài gòn' and (t_date< dateadd(year,-3,getdate()) or t_id is null)
UNION 
select 'SL khách', count(distinct cust.cust_id)
from customer cust join branch br on cust.Br_id=br.BR_id
				   join account ac on cust.Cust_id=ac.cust_id
			       left outer join transactions t on ac.Ac_no=t.ac_no
where Br.BR_name like N'% sài gòn' and (t_date< dateadd(year,-3,getdate()) or t_id is null)

/*7. Thống kê thông tin giao dịch theo mùa, nội dung thống kê gồm: số lượng giao dịch, lượng tiền giao dịch trung bình, 
tổng tiền giao dịch, lượng tiền giao dịch nhiều nhất, lượng tiền giao dịch ít nhất.*/
select datepart (qq, t_date) 'quý',count(t_amount) SL, avg(t_amount) TB, sum(t_amount) T, max(t_amount), min(t_amount)
from transactions
group by datepart (qq, t_date)

--8. Tìm số tiền giao dịch nhiều nhất trong năm 2016 của chi nhánh Huế. Nếu có thể, hãy đưa ra tên của khách hàng thực hiện giao dịch đó.
select cust_name, br_name, t_amount, t_date
from transactions t join account ac on t.ac_no=ac.Ac_no
					join customer cust on ac.cust_id=cust.Cust_id
					join branch br on cust.Br_id=br.BR_id
where year(t_date)=2016 and br_name like N'%huế'
and t_amount=(select max(t_amount)
				   from transactions t join account ac on t.ac_no=ac.Ac_no
									   join customer cust on ac.cust_id=cust.Cust_id
									   join branch br on cust.Br_id=br.BR_id
				   where year(t_date)=2016 and br_name like N'%huế')

select top 1 cust_name, br_name, max(t_amount)'Tổng tiền'
from transactions t join account ac on t.ac_no=ac.Ac_no
					join customer cust on ac.cust_id=cust.Cust_id
					join branch br on cust.Br_id=br.BR_id
where year(t_date)=2016 and br_name like N'%huế'
group by cust_name, br_name

--9. Tìm khách hàng có lượng tiền gửi nhiều nhất vào ngân hàng trong năm 2017 (nhằm mục đích tri ân khách hàng)
select cust.cust_id, cust_name, t_amount, t_date
from transactions t join account ac on t.ac_no=ac.Ac_no
					join customer cust on ac.cust_id=cust.Cust_id
					join branch br on cust.Br_id=br.BR_id
where year(t_date)=2017 and t_type=1
order by t_amount desc

--10. Tìm những khách hàng có cùng chi nhánh với ông Phan Nguyên Anh
select cust.cust_id, cust_name, br.br_id
from customer cust join branch br on cust.Br_id=br.BR_id
where br.br_id=(select br_id
				from customer
				where cust_name=N'Phan Nguyên Anh')
and cust_name<>N'Phan Nguyên Anh'

--11. Liệt kê những giao dịch thực hiện cùng giờ với giao dịch của ông Lê Nguyễn Hoàng Văn ngày 2016-12-02
select cust_name, t_id, t_amount, t_date, t_time
from transactions t join account ac on t.ac_no=ac.Ac_no
					join customer cust on ac.cust_id=cust.Cust_id
where t_date='2016-12-02'
and t_time = (select datepart(hour,t_time)
			  from transactions t join account ac on t.ac_no=ac.Ac_no
								  join customer cust on ac.cust_id=cust.Cust_id
			  where t_date = '2016-12-02' and cust_name = N'Lê Nguyễn Hoàng Văn')
and cust_name<>N'Lê Nguyễn Hoàng Văn'

--12. Hiển thị danh sách khách hàng ở cùng thành phố với Trần Văn Thiện Thanh
select cust_name, (right (cust_ad, patindex('%[-,]%',reverse(cust_ad))-1))
from customer
where (right (cust_ad, patindex('%[-,]%',reverse(cust_ad))-1))=(select (right (cust_ad, patindex('%[-,]%',reverse(cust_ad))-1))
																from customer
																where cust_name = N'Trần Văn Thiện Thanh')
and cust_name<>N'Trần Văn Thiện Thanh'
--13. Tìm những giao dịch diễn ra cùng ngày với giao dịch có mã số 0000000217
select t_id, t_amount, t_date
from transactions
where day(t_date)=(select day(t_date)
			  from transactions
			  where t_id='0000000217')
			  and t_id<>'0000000217'
--14. Tìm những giao dịch cùng loại với giao dịch có mã số 0000000387
select t_id, t_type, t_amount
from transactions
where t_type=(select t_type
			  from transactions
			  where t_id='0000000387')
			  and t_id<>'0000000387'
--15. Những chi nhánh nào thực hiện nhiều giao dịch gửi tiền trong tháng 12/2015 hơn chi nhánh Đà Nẵng
select br_name, count(t_amount)
from transactions t join account ac on t.ac_no=ac.Ac_no
					join customer cust on ac.cust_id=cust.Cust_id
					join branch br on cust.Br_id=br.BR_id
where t_date like '2015-12%' and t_type=1
group by br_name
having count(t_amount)>(select count(t_amount)
					    from transactions t join account ac on t.ac_no=ac.Ac_no
										    join customer cust on ac.cust_id=cust.Cust_id
										    join branch br on cust.Br_id=br.BR_id
					    where t_date like '2015-12%' and t_type=1 and br_name like N'%đà nẵng')

--16. Hãy liệt kê những tài khoản trong vòng 6 tháng trở lại đây không phát sinh giao dịch
select distinct cust.cust_id, cust_name
from customer cust join branch br on cust.Br_id=br.BR_id
				   join account ac on cust.Cust_id=ac.cust_id
				   join transactions t on ac.Ac_no=t.ac_no
where ac.Ac_no not in (select distinct ac.ac_no
					   from customer cust join branch br on cust.Br_id=br.BR_id
										  join account ac on cust.Cust_id=ac.cust_id
										  join transactions t on ac.Ac_no=t.ac_no
					   where dateadd(month,-6,getdate())<t_date)

--17. Ông Phạm Duy Khánh thuộc chi nhánh nào? Từ 01/2017 đến nay ông Khánh đã thực hiện bao nhiêu giao dịch gửi tiền vào ngân hàng
-- với tổng số tiền là bao nhiêu.
select br_name,
		(select count(t_id)
		from customer cust join branch br on cust.Br_id=br.BR_id
						   join account ac on cust.Cust_id=ac.cust_id
						   join transactions t on ac.Ac_no=t.ac_no
		where cust_name = N'Phạm Duy Khánh' 
		and t_date>='2017-01-01') SLGD,
		(select sum(t_amount)
		from customer cust join branch br on cust.Br_id=br.BR_id
						   join account ac on cust.Cust_id=ac.cust_id
						   join transactions t on ac.Ac_no=t.ac_no
		where cust_name = N'Phạm Duy Khánh' 
		and t_date>='2017-01-01') TTGD
from customer cust join branch br on cust.Br_id=br.BR_id
				   join account ac on cust.Cust_id=ac.cust_id
				   join transactions t on ac.Ac_no=t.ac_no
where cust_name = N'Phạm Duy Khánh' and t_type=1
group by cust_name, br_name

select distinct a.Cust_id, a.Cust_name,a.BR_name, sl, tong
from (select c.Cust_id, c.Cust_name, b.BR_name
	from transactions t left join account a on a.Ac_no=t.ac_no
						left join customer c on c.Cust_id=a.cust_id
						left join Branch b on b.BR_id=c.Br_id
where Cust_name=N'Phạm Duy Khánh') a left join 
									(select c.Cust_id, Cust_name, BR_name, count(t_type) as sl, sum(t_amount) as tong
									 from transactions t join account a on a.Ac_no=t.ac_no
														 join customer c on c.Cust_id=a.cust_id
														 join Branch b on b.BR_id=c.Br_id
                                     where Cust_name=N'Phạm Duy Khánh' and t_date>='2017-01-01' and t_type=1
									 group by c.Cust_id, Cust_name, BR_name) b on a.Cust_id=b.Cust_id
--18. Thống kê giao dịch theo từng năm, nội dung thống kê gồm: số lượng giao dịch, lượng tiền giao dịch trung bình
select year(t_date) 'Năm', count(*) 'SL GD', avg(t_amount) 'Tiền tb'
from transactions
group by year(t_date)

--19. Thống kê số lượng giao dịch theo ngày và đêm trong năm 2017 ở chi nhánh Hà Nội, Sài Gòn
select case
		   when (t_time between '6:00' and '18:00') then 'Ngày'
		   else 'Đêm'
	   end
	   ,count(t_id)
from transactions t join account ac on t.ac_no=ac.Ac_no
					join customer cust on ac.cust_id=cust.Cust_id
					join branch br on cust.Br_id=br.BR_id
where br_name like N'%Hà nội' or br_name like N'%sài gòn' and year(t_date)=2017
group by case
		   when (t_time between '6:00' and '18:00') then 'Ngày'
		   else 'Đêm'
		 end

--20. Hiển thị danh sách khách hàng chưa thực hiện giao dịch nào trong năm 2017?
select distinct cust.cust_id, cust_name
from customer cust join branch br on cust.Br_id=br.BR_id
				   join account ac on cust.Cust_id=ac.cust_id
				   join transactions t on ac.Ac_no=t.ac_no
where cust_name not in (select distinct cust_name
					   from customer cust join branch br on cust.Br_id=br.BR_id 
										  join account ac on cust.Cust_id=ac.cust_id
										  join transactions t on ac.Ac_no=t.ac_no
					   where year(t_date)=2017)

--21. Hiển thị những giao dịch trong mùa xuân của các chi nhánh miền trung. Gợi ý: giả sử một năm có 4 mùa,
--    mỗi mùa kéo dài 3 tháng; chi nhánh miền trung có mã chi nhánh bắt đầu bằng VT.
select br.BR_id, br_name, t_id, t_amount, t_date
from branch br join customer cust on br.br_id=cust.br_id
			   join account ac on cust.Cust_id=ac.cust_id
			   join transactions t on ac.Ac_no=t.ac_no
where br.BR_id like 'VT%' and datepart(qq, t_date)=1

--22. Hiển thị họ tên và các giao dịch của khách hàng sử dụng số điện thoại có 3 số đầu là 093 và 2 số cuối là 02.
select cust_name, cust_phone, t_amount
from customer cust join account ac on cust.Cust_id=ac.cust_id
				   join transactions t on ac.Ac_no=t.ac_no
where cust_phone like '093%02'

--23. Hãy liệt kê 2 chi nhánh làm việc kém hiệu quả nhất trong toàn hệ thống (số lượng giao dịch gửi tiền ít nhất) trong quý 3 năm 2017
select top 2 br.br_id, br_name, t_amount
from branch br join customer cust on br.BR_id=cust.Br_id
			   join account ac on cust.Cust_id=ac.cust_id
			   join transactions t on ac.Ac_no=t.ac_no
where t_type=1 and datepart(qq, t_date)=3 and year(t_date)=2017
order by t_amount

--24. Hãy liệt kê 2 chi nhánh có bận mải nhất hệ thống (thực hiện nhiều giao dịch gửi tiền nhất) trong năm 2017.
select top 2 br.br_id, br_name, count(t_amount)
from branch br join customer cust on br.BR_id=cust.Br_id
			   join account ac on cust.Cust_id=ac.cust_id
			   join transactions t on ac.Ac_no=t.ac_no
where t_type=1 and year(t_date)=2017
group by br.br_id, br_name
order by count(t_amount) desc

--25. Tìm giao dịch gửi tiền nhiều nhất trong mùa đông. Nếu có thể, hãy đưa ra tên của người thực hiện giao dịch và chi nhánh.
select top 1 cust_name, br.BR_id, t_amount, t_date
from transactions t join account ac on t.ac_no=ac.Ac_no
					join customer cust on ac.cust_id=cust.Cust_id
					join branch br on cust.Br_id=br.BR_id
where datepart(qq, t_date)=4 and t_type=1
order by t_amount desc

--26. Để bổ sung nhân sự cho các chi nhánh, cần có kết quả phân tích về cường độ làm việc của họ. 
--    Hãy liệt kê những chi nhánh phải làm việc qua trưa và loại giao dịch là gửi tiền.
select br.BR_id, br_name
from branch br join customer cust on br.BR_id=cust.Br_id
			   join account ac on cust.Cust_id=ac.cust_id
			   join transactions t on ac.Ac_no=t.ac_no
where (t_time between '11:00' and '13:30') and t_type=1
group by br.BR_id, br_name

--27. Hãy liệt kê các giao dịch bất thường. Gợi ý: là các giao dịch gửi tiền những được thực hiện 
--    ngoài khung giờ làm việc và cho phép overtime (từ sau 16h đến trước 7h)
select t_id, t_amount, t_time
from transactions
where t_type=1 and (t_time not between '7:00' and '11:30') and (t_time not between '13:00' and '17:00')


--28. Hãy điều tra những giao dịch bất thường trong năm 2017. Giao dịch bất thường là giao dịch diễn ra
--    trong khoảng thời gian từ 12h đêm tới 3 giờ sáng.
select t_id, t_amount, t_time
from transactions
where year(t_date)=2017 and (t_time between '00:00' and '3:00')

--29. Có bao nhiêu người ở Đắc Lắc sở hữu nhiều hơn một tài khoản?
select cust_name, count(*)
from account ac join customer cust on ac.cust_id=cust.Cust_id
where cust_ad like N'%đăk lăk%'
group by cust_name
having count(*)>1

--30. Nếu mỗi giao dịch rút tiền ngân hàng thu phí 3.000 đồng, hãy tính xem tổng tiền phí
--    thu được từ thu phí dịch vụ từ năm 2012 đến năm 2017 là bao nhiêu?
select count(*)*3000 'tổng phí thu'
from transactions
where t_type=0 and (year(t_date) between 2012 and 2017)

--31. Hiển thị thông tin các khách hàng họ Trần theo các cột sau:
--    Mã KH   Họ   Tên   Số dư tài khoản
--select cust_id 'Mã KH', 
select cust_name, left (cust_name, patindex('% %',cust_name)) 'Họ', 
		right (cust_name, patindex('% %',reverse(cust_name))-1) 'Tên', ac_balance 
from customer cust join account ac on cust.cust_id=ac.cust_id
where cust_name like N'Trần%'

--32. Cuối mỗi năm, nhiều khách hàng có xu hướng rút tiền khỏi ngân hàng để chuyển sang ngân hàng khác hoặc chuyển sang
--    hình thức tiết kiệm khác. Hãy lọc những khách hàng có xu hướng rút tiền khỏi ngân hàng bằng hiển thị những người
--    rút gần hết tiền trong tài khoản (tổng tiền rút trong tháng 12/2017 nhiều hơn 100 triệu và số dư trong tài khoản còn lại <= 100.000)
select cust_name, ac_balance, sum(t_amount)
from customer cust join account ac on cust.cust_id=ac.cust_id
				   join transactions t on ac.ac_no=t.ac_no
where t_date like '2017-12%' and t_type=0 and ac_balance<=100000
group by cust_name, ac_balance
having sum(t_amount)>100000000

/*33. Thời gian vừa qua, hệ thống CSDL của ngân hàng bị hacker tấn công (giả sử tí cho vui J), tổng tiền trong tài khoản
    bị thay đổi bất thường. Hãy liệt kê những tài khoản bất thường đó. Gợi ý: tài khoản bất thường là tài khoản có 
    tổng tiền gửi – tổng tiền rút <> số tiền trong tài khoản bỏ */

/*34. Do hệ thống mạng bị nghẽn và hệ thống xử lý chưa tốt phần điều khiển đa người dùng nên một số tài khoản bị invalid. 
    Hãy liệt kê những tài khoản đó. Gợi ý: tài khoản bị invalid là những tài khoản có số tiền âm. Nếu có thể hãy liệt kê
    giao dịch gây ra sự cố tài khoản âm. Giao dịch đó được thực hiện ở chi nhánh nào? (mục đích để quy kết trách nhiệm J)*/

/*35. (Giả sử) Gần đây, một số khách hàng ở chi nhánh Đà Nẵng kiện rằng: tổng tiền trong tài khoản không khớp với số tiền
    họ thực hiện giao dịch. Hãy điều tra sự việc này bằng cách hiển thị danh sách khách hàng ở Đà Nẵng bao gồm các thông 
	tin sau: mã khách hàng, họ tên khách hàng, tổng tiền đang có trong tài khoản, tổng tiền đã gửi, tổng tiền đã rút, 
	kết luận (nếu tổng tiền gửi – tổng tiền rút = số tiền trong tài khoản là OK, trường hợp còn lại là có sai)*/

/*36. Ngân hàng cần biết những chi nhánh nào có nhiều giao dịch rút tiền vào buổi chiều để chuẩn bị chuyển tiền tới. 
Hãy liệt kê danh sách các chi nhánh và lượng tiền rút trung bình theo ngày (chỉ xét những giao dịch diễn ra trong buổi chiều),
sắp xếp giảm dần theo lượng tiền giao dịch.*/
select t_date, br_name, avg(t_amount)
from transactions t join account ac on t.ac_no=ac.Ac_no 
					join customer cust on ac.cust_id=cust.Cust_id
					join branch br on cust.br_id=br.br_id
where t_type=0 and (t_time between '13:00' and '17:00')
group by t_date, br_name
order by avg(t_amount) desc

select day(t_date), br_name, avg(t_amount)
from transactions t join account ac on t.ac_no=ac.Ac_no 
					join customer cust on ac.cust_id=cust.Cust_id
					join branch br on cust.br_id=br.br_id
where t_type=0 and (t_time between '13:00' and '17:00')
group by day(t_date), br_name
order by avg(t_amount) desc