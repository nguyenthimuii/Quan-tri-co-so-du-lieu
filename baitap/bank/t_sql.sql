/*1.Viết đoạn code thực hiện việc chuyển đổi đầu số điện thoại di động theo quy định của bộ Thông tin 
	và truyền thông cho một khách hàng bất kì, ví dụ với: Dương Ngọc Long */
declare @sdt varchar(11), @sdtm varchar(11)
select @sdt = cust_phone from customer where cust_name = N'Dương Ngọc Long'
if len(@sdt)=11
begin
	set @sdtm = case when @sdt like '0162%' then '032'
					 when @sdt like '0163%' then '033'
					 when @sdt like '0164%' then '034'
					 when @sdt like '0165%' then '035'
					 when @sdt like '0166%' then '036'
					 when @sdt like '0167%' then '037'
					 when @sdt like '0168%' then '038'
					 when @sdt like '0169%' then '039'
					 when @sdt like '0123%' then '083'
					 when @sdt like '0124%' then '084'
					 when @sdt like '0125%' then '085'
					 when @sdt like '0127%' then '081'
					 when @sdt like '0129%' then '082'
					 when @sdt like '0120%' then '070'
					 when @sdt like '0121%' then '079'
					 when @sdt like '0122%' then '077'
					 when @sdt like '0126%' then '076'
					 when @sdt like '0128%' then '078'
				end
end
else
begin
	print N'giữ nguyên'
end
set @sdtm = @sdtm + right(@sdt, 7)
print N'Sđt cũ: ' + @sdt
print N'Sđt mới: ' + @sdtm
update customer
set cust_phone = @sdtm
where cust_name = N'Dương Ngọc Long'

/*2.Trong vòng 10 năm trở lại đây Nguyễn Lê Minh Quân có thực hiện giao dịch nào không? 
Nếu có, hãy trừ 50.000 phí duy trì tài khoản. */
declare @gd int
set @gd = (select count(t_id)
		   from customer c join account ac on c.Cust_id=ac.cust_id
						   join transactions t on ac.Ac_no=t.ac_no
		   where cust_name like N'Nguyễn Lê Minh Quân' and dateadd(year, -10, getdate()<=t_date)

if @gd > 0
begin
	print N'Số lần giao dịch: ' + cast(@gd as varchar)
	update account set ac_balance = ac_balance - 50000
	from customer c join account ac on c.Cust_id=ac.cust_id
					join transactions t on ac.Ac_no=t.ac_no
	where cust_name like N'Nguyễn Lê Minh Quân' and dateadd(year, -10, getdate())<=t_date
	print N'Đã trừ phí duy trì'
end
else
begin
	print N'Không có giao dịch'
end

select ac.ac_no, ac_balance
from customer c join account ac on c.Cust_id=ac.cust_id
				join transactions t on ac.Ac_no=t.ac_no
where cust_name like N'Nguyễn Lê Minh Quân' 

select t_date, t_amount, c.cust_id
from customer c join account ac on c.Cust_id=ac.cust_id
				join transactions t on ac.Ac_no=t.ac_no
where dateadd(year, -10, getdate())<=t_date

/*3.Trần Quang Khải thực hiện giao dịch gần đây nhất vào thứ mấy? (thứ hai, thứ ba, thứ tư,…, chủ nhật) 
	và vào mùa nào (mùa xuân, mùa hạ, mùa thu, mùa đông)? */
declare @thu varchar(10), @mua varchar(10)
set @thu = (select top 1 t_date
			from customer c join account ac on c.Cust_id=ac.cust_id
							join transactions t on ac.Ac_no=t.ac_no
			where cust_name like N'Trần Quang Khải'
			order by t_date desc)
set @mua = (select datepart(qq, max(t_date))
			from customer c join account ac on c.Cust_id=ac.cust_id
							join transactions t on ac.Ac_no=t.ac_no
			where cust_name like N'Trần Quang Khải')
print @thu

set @thu = case when datepart(weekday, @thu) = '2' then N'thứ hai'
				when datepart(weekday, @thu) = '3' then N'thứ ba'
				when datepart(weekday, @thu) = '4' then N'thứ tư'
				when datepart(weekday, @thu) = '5' then N'thứ năm'
				when datepart(weekday, @thu) = '6' then N'thứ sáu'
				when datepart(weekday, @thu) = '7' then N'thứ bảy'
				else N'chủ nhật'
			end
			/*case when datename(weekday, @thu) = 'Monday' then N'thứ hai'
				when datename(weekday, @thu) = 'Tuesday' then N'thứ ba'
				when datename(weekday, @thu) = 'Wednesday' then N'thứ tư'
				when datename(weekday, @thu) = 'Thursday' then N'thứ năm'
				when datename(weekday, @thu) = 'Friday' then N'thứ sáu'
				when datename(weekday, @thu) = 'Saturday' then N'thứ bảy'
				else N'chủ nhật'
			end*/
			
set @mua = case @mua when 1 then 'xuân'
					 when 2 then 'hè'
					 when 3 then 'thu'
					 when 4 then 'đông'
		   end

print N'Trần Quang Khải thực hiện giao dịch gần đây nhất vào ' + @thu + N' và vào mùa ' + @mua
--4.Đưa ra nhận xét về nhà mạng mà Lê Anh Huy đang sử dụng? (Viettel, Mobi phone, Vinaphone, Vietnamobile, khác)
declare @mang nvarchar (15)
select @mang = cust_phone from customer where Cust_name like N'Lê Anh Huy'
print @mang

set @mang = case when @mang like '016[2,3,4,5,6,7,8,9]%' or @mang like '09[6,7,8]%' 
				   or @mang like '03[2,3,4,5,6,7,8,9]%' or @mang like '086%' then 'Viettel'
				 when @mang like '089%' or @mang like '09[0,3]%' or @mang like '012[0,1,2,6,8]%'
				   or @mang like '07[0,9,7,6,8]%' then 'Mobiphone'
				 when @mang like '08[1,2,3,4,5,8]%' or @mang like '09[1,4]%'
				   or @mang like '012[3,4,5,7,9]%' then 'Vinaphone'
				 when @mang like '05[6,8]%' or @mang like '092%' then 'Vietnamobile'
			end

print N'Nhà mạng mà Lê Anh Huy đang sử dụng là ' + @mang

/*if @mang like '016[2,3,4,5,6,7,8,9]%' or @mang like '09[6,7,8]%' 
	or @mang like '03[2,3,4,5,6,7,8,9]%' or @mang like '086%'
begin
	print 'Viettel'
end
else if @mang like '089%' or @mang like '09[0,3]%' or @mang like '012[0,1,2,6,8]%'
		or @mang like '07[0,9,7,6,8]%' 
begin
	print 'Mobiphone'
end
else if @mang like '08[1,2,3,4,5,8]%' or @mang like '09[1,4]%'
				   or @mang like '012[3,4,5,7,9]%'
begin
	print 'Vinaphone'
end
else if @mang like '05[6,8]%' or @mang like '092%'
begin
	print 'Vietnamobile'
end
else
begin
	print N'Khác'
end */

/*5.Số điện thoại của Trần Quang Khải là số tiến, số lùi hay số lộn xộn. Định nghĩa: trừ 3 số đầu tiên, 
	các số còn lại tăng dần gọi là số tiến, ví dụ: 098356789 là số tiền */


--6.Hà Công Lực thực hiện giao dịch gần đây nhất vào buổi nào(sáng, trưa, chiều, tối, đêm)? 
declare @buoi nvarchar(10)
set @buoi = (select top 1 t_time
		     from customer c join account ac on c.cust_id=ac.cust_id
						   join transactions t on ac.ac_no=t.ac_no
		     where cust_name like N'Hà Công Lực'
		     order by t_date desc)
print @buoi
set @buoi = case when datepart(hour, @buoi) < 6 then 'đêm'
				 when datepart(hour, @buoi) < 11 then 'sáng'
				 when datepart(hour, @buoi) < 13 then 'trưa'
				 when datepart(hour, @buoi) < 18 then 'chiều'
			     else 'tối'
			end

print N'Hà Công Lực thực hiện giao dịch gần đây nhất vào buổi ' + @buoi

select t_date, t_time, t_amount
from customer c join account ac on c.cust_id=ac.cust_id
				join transactions t on ac.ac_no=t.ac_no
where cust_name like N'Hà Công Lực'
/*7.Chi nhánh ngân hàng mà Trương Duy Tường đang sử dụng thuộc miền nào? Gợi ý: nếu mã chi nhánh là VN --> miền nam, 
	VT --> miền trung, VB --> miền bắc, còn lại: bị sai mã. */
declare @mien nvarchar(20)
select @mien = br_id
from customer c join account ac on c.cust_id=ac.cust_id
				join transactions t on ac.ac_no=t.ac_no
where cust_name like N'Trương Duy Tường'

set @mien = case when @mien like 'VN%' then N'miền Nam'
				 when @mien like 'VT%' then N'miền Trung'
				 when @mien like 'VB%' then N'miền Bắc'
			end
print N'Chi nhánh ngân hàng mà Trương Duy Tường đang sử dụng thuộc ' + @mien

/*if @mien like 'VT%'
begin
	print N'miền Trung'
end
else if @mien like 'VN%'
begin
	print N'miền Nam'
end
else if @mien like 'VB%'
begin
	print N'miền Bắc'
end
else
begin
	print N'bị sai mã'
end*/

/*8.Căn cứ vào số điện thoại của Trần Phước Đạt, hãy nhận định anh này dùng dịch vụ di động của hãng nào: Viettel, 
	Mobi phone, Vina phone, hãng khác. */
declare @hang varchar(15)
select @hang = cust_phone
from customer
where cust_name like N'Trần Phước Đạt'
print @hang

set @hang = case when @hang like '086%' or @hang like '016[2,3,4,5,6,7,8,9]%' or @hang like '09[6,7,8]%'
				   or @hang like '03[2,3,4,5,6,7,8,9]%' then 'Viettel'
				 when @hang like '098%' or @hang like '09[0,3]%' or @hang like '012[0,1,2,6,8]%'
				   or @hang like '07[0,9,7,6,8]%' then 'Mobiphone'
				 when @hang like '09[1,2,3,4,5,8]%' or @hang like '09[1,4]%'
				   or @hang like '012[3,4,5,7,9]%' then 'Vinaphone'
				 else N'hãng khác'
			end
print N'Anh Trần Phước Đạt dùng dịch vụ di động của hãng ' + @hang
/*9.Hãy nhận định Lê Anh Huy ở vùng nông thôn hay thành thị. Gợi ý: nông thôn thì địa chỉ thường có chứa chữ “thôn” 
	hoặc “xóm” hoặc “đội” hoặc “xã” hoặc “huyện” */
declare @dchi nvarchar(150)
select @dchi = cust_ad
from customer
where cust_name like N'Hồ Quỳnh Hữu Phát'
print @dchi

if (@dchi like N'%thôn%' or @dchi like N'%xóm%' or @dchi like N'%đội%' or 
	@dchi like N'%xã%' or @dchi like N'%huyện%') and @dchi not like N'%thị xã%'
begin
	print N'Lê Anh Huy ở vùng nông thôn'
end
else
begin
	print N'Lê Anh Huy ở vùng thành thị'
end

/*10.Hãy kiểm tra tài khoản của Trần Văn Thiện Thanh, nếu tiền trong tài khoản của anh ta nhỏ hơn không hoặc 
	bằng không nhưng 6 tháng gần đây không có giao dịch thì hãy đóng tài khoản bằng cách cập nhật ac_type = ‘K’ */
declare @tk int, @gd int
set @tk = (select distinct ac_balance
		   from account ac join customer c on ac.cust_id=c.Cust_id
						   join transactions t on ac.Ac_no=t.ac_no
		   where cust_name like N'Trần Văn Thiện Thanh')
set @gd = (select count(t_id)
		   from account ac join customer c on ac.cust_id=c.Cust_id
						   join transactions t on ac.Ac_no=t.ac_no
		   where cust_name like N'Trần Văn Thiện Thanh' and (dateadd(month, -6, getdate())<t_date and t_id is null))
print N'số tiền trong tài khoản: ' + cast(@tk as varchar)
print N'số lần giao dịch trong 6 tháng gần đây: ' + cast(@gd as varchar)
if @tk < 0
begin
	update account
	set ac_type = 'K'
	from account ac join customer c on ac.cust_id=c.Cust_id
					join transactions t on ac.Ac_no=t.ac_no
	where cust_name like N'Trần Văn Thiện Thanh'
end
else if @tk = 0 and @gd = 0
begin
	update account
	set ac_type = 'K'
	from account ac join customer c on ac.cust_id=c.Cust_id
					join transactions t on ac.Ac_no=t.ac_no
	where cust_name like N'Trần Văn Thiện Thanh'
end
else
begin
	print N'bình thường'
end

select cust_name, ac_balance, ac_type, ac.ac_no
from account ac join customer c on ac.cust_id=c.Cust_id
				join transactions t on ac.Ac_no=t.ac_no
where cust_name like N'Trần Văn Thiện Thanh'
--11.Mã số giao dịch gần đây nhất của Huỳnh Tấn Dũng là số chẵn hay số lẻ? 
declare @mgd int
set @mgd = (select top 1 t_id
			from customer c join account ac on c.cust_id=ac.cust_id
						    join transactions t on ac.ac_no=t.ac_no
			where cust_name like N'Huỳnh Tấn Dũng'
			order by t_date desc)

if @mgd % 2=0
begin
	print N'số chẵn'
end
else
begin
	print N'số lẻ'
end

select t_date, t_id, c.cust_id
from customer c join account ac on c.cust_id=ac.cust_id
						    join transactions t on ac.ac_no=t.ac_no
			where cust_name like N'Huỳnh Tấn Dũng'
/*12.Có bao nhiêu giao dịch diễn ra trong tháng 9/2016 với tổng tiền mỗi loại là bao nhiêu (bao nhiêu tiền rút, 
	bao nhiêu tiền gửi) */
declare @gd int, @tienrut int, @tiengui int
set @gd = (select count(t_id)
		   from transactions
		   where t_date between '2016-09-01' and '2016-09-30')

set @tienrut = (select sum(t_amount)
				from transactions
				where t_type = 0 and (t_date between '2016-09-01' and '2016-09-30'))

set @tiengui = (select sum(t_amount)
				from transactions
				where t_type = 1 and ( t_date between '2016-09-01' and '2016-09-30'))

if @gd is null
	set @gd = 0
if @tienrut is null
	set @gd = 0
if @tiengui is null
	set @tiengui = 0

print N'Số giao dịch: ' + cast(@gd as varchar)
print N'tiền rút: ' + cast(@tienrut as varchar)
print N'tiền gửi: ' + cast(@tiengui as varchar)

/*13.Ở Hà Nội ngân hàng Vietcombank có bao nhiêu chi nhánh và có bao nhiêu khách hàng? Trả lời theo mẫu: “Ở Hà Nội, 
Vietcombank có … chi nhánh và có …khách hàng” */
declare @scn int, @skh int
set @scn = (select count(br_id)from Branch
			where br_name like N'Vietcombank Hà Nội%')
set @skh = (select count(cust_id)
			from customer c join branch br on c.Br_id=br.BR_id
			where br_name like N'%Hà Nội')
print N'Ở Hà Nội, Vietcombank có ' + cast(@scn as varchar) + N' chi nhánh và có ' + cast(@skh as varchar) + N' khách hàng'
--14.Tài khoản có nhiều tiền nhất là của ai, số tiền hiện có trong tài khoản đó là bao nhiêu? Tài khoản này thuộc chi nhánh nào?
-- cách 1
declare @max int
declare @cust_list table (cust_name nvarchar(100),
						  ac_balance numeric(15,0),
						  br_name nvarchar(100))
set @max=(select max(ac_balance) from account)
insert @cust_list select cust_name, ac_balance, br_name	
				  from branch br join customer c on br.BR_id=c.Br_id
								 join account ac on c.Cust_id=ac.cust_id
				  where ac_balance=@max
print N'Ds kh có nhiều tiền trong tk nhất'
select * from @cust_list
--cách 2
declare @ac_balance numeric(15,0),@cust_name nvarchar(100),@br_name nvarchar(100)
select top 1 @ac_balance = ac_balance, @cust_name=cust_name, @br_name=br_name
from branch br join customer c on br.BR_id=c.Br_id
			   join account ac on c.Cust_id=ac.cust_id
order by ac_balance desc

print @ac_balance
print @cust_name
print @br_name
--cách 3
declare @max int,@cust_name nvarchar(100),@br_name nvarchar(100)
set @max = (select max(ac_balance) from account)

select @cust_name=cust_name, @br_name=br_name
from branch br join customer c on br.BR_id=c.Br_id
			   join account ac on c.Cust_id=ac.cust_id
where ac_balance=@max
print concat(N'Tài khoản có nhiều tiền nhất là của ',@cust_name, N', số tiền là ',@max,N'. Tk thuộc chi nhánh ',@br_name)

--15.Có bao nhiêu khách hàng ở Đà Nẵng?
declare @slkh int
set @slkh=(select count(cust_id) 
		   from customer
		   where cust_ad like N'%Đà Nẵng%')
print N'Có ' + cast(@slkh as varchar) + N' khách hàng ở ĐN'
--16.Có bao nhiêu khách hàng ở Quảng Nam nhưng mở tài khoản Sài Gòn
declare @slkh int
set @slkh = (select count(cust_id)
			 from customer c join branch br on c.Br_id = br.BR_id
			 where cust_ad like N'%Quảng Nam%' and br_name like N'%Sài Gòn')
print N'Có ' + cast(@slkh as varchar) + N' khách hàng ở QNam nhưng mở tk ở SG'

--17.Ai là người thực hiện giao dịch có mã số 0000000387, thuộc chi nhánh nào? Giao dịch này thuộc loại nào?
declare @tenkh nvarchar(50), @tencn nvarchar(50), @loai varchar(3)
select @tenkh=cust_name, @tencn=br_name, @loai=t_type
from customer c join branch br on c.Br_id=br.BR_id
				join account ac on c.Cust_id=ac.cust_id
				join transactions t on ac.Ac_no=t.ac_no
where t_id like '0000000387'
print @tenkh + N' là người thực hiện giao dịch có mã số 0000000387' + N', thuộc chi nhánh ' + @tencn + N'. Giao dịch này thuộc loại ' + @loai
/*18.Hiển thị danh sách khách hàng gồm: họ và tên, số điện thoại, số lượng tài khoản đang có và nhận xét. 
	Nếu < 1 tài khoản  “Bất thường”, còn lại “Bình thường” */
declare @ten nvarchar(50), @sdt varchar(12), @sltk int
select @ten=cust_name, @sdt=cust_phone, @sltk=count(ac_no)
from customer c join account ac on c.Cust_id=ac.cust_id
group by cust_name, cust_phone
if @sltk < 1
begin
	print N'họ và tên: ' + @ten + N', số điện thoại: ' + @sdt + N', số lượng tài khoản đang có: ' + cast(@sltk as varchar)
	print N'Bất thường'
end
else
begin
	print N'Bình thường'
end

select cust_name 'họ và tên',
	   cust_phone  'sđt',
	   count(ac_no) 'số lượng tài khoản',
	   case
			when count(ac_no) > 1 then N'Bình thường'
			else N'Bất thường'
	   end 'nhận xét'
from customer c join account ac on c.Cust_id=ac.cust_id
group by cust_name, cust_phone

--19.Viết đoạn code nhận xét tiền trong tài khoản của ông Hà Công Lực. <100.000: ít, < 5.000.000 -> trung bình, còn lại: nhiều
declare @tien int
set @tien = (select sum(ac_balance) 
			 from account ac join customer c on ac.cust_id=c.Cust_id
			 where cust_name like N'Hà Công Lực')
print @tien
if @tien < 100000
begin
	print N'Ít'
end
else if @tien >= 100000 and @tien < 50000000
begin
	print N'Trung bình'
end
else
begin
	print N'Nhiều'
end

select ac_no, ac_balance
from account ac join customer c on ac.cust_id=c.Cust_id
where cust_name like N'Hà Công Lực'
/*20.Hiển thị danh sách các giao dịch của chi nhánh Huế với các thông tin: mã giao dịch, thời gian giao dịch, số tiền giao dịch,
	loại giao dịch (rút/gửi), số tài khoản. Ví dụ:
	Mã giao dịch	Thời gian GD	Số tiền GD	Loại GD	Số tài khoản
	00133455	2017-11-30 09:00	3000000	    Rút	 0      4847374948		*/
select t_id 'Mã giao dịch', 
	   t_time 'Thời gian GD', 
	   t_amount 'Số tiền GD',
	   case
			when t_type = 0 then N'Rút'
			when t_type = 1 then N'Gửi'
	   end 'Loại',
	   ac.ac_no 'Số tài khoản'
from account ac join transactions t on ac.ac_no = t.ac_no
				join customer c on ac.cust_id = c.Cust_id
				join branch br on c.Br_id = br.BR_id
where br_name like N'%Huế'

declare @dsgd table (MaGD nvarchar(100) not null,
					ThoiGianGD DATETIME not null,
					SoTienGD int not null,
					loaiGD nvarchar(100) not null,
					STK nvarchar(20) not null)
insert into @dsgd(MaGD,ThoiGianGD,SoTienGD, loaiGD, STK)
select t_id as 'Mã giao dịch', 
	concat(t_date,' ',left(t_time,5)) as 'Thời gian GD', 
	t_amount as 'Số tiền GD', 
	case when t_type=1 then N'Gửi' 
	else N'Rút' end 'Loại GD' , 
	A.ac_no as'Số tài khoản'
FROM CUSTOMER C
JOIN BRANCH B ON B.BR_id=C.Br_id
JOIN ACCOUNT A ON A.cust_id=c.cust_id
JOIN TRANSACTIONS T ON T.ac_no=A.Ac_no
where BR_name like N'%Huế'
SELECT MaGD 'Mã giao dịch',FORMAT(ThoiGianGD, 'dd-MM-yyyy hh:mm') 'Thời gian GD', SoTienGD 'Số tiền GD', loaiGD 'Loại GD', STK 'Số tài khoản'
FROM @dsgd

--21.Kiểm tra xem khách hàng Nguyễn Đức Duy có ở Quang Nam hay không?
declare @dchi nvarchar(100)
set @dchi = (select cust_ad
	   from customer
	   where cust_name like N'Nguyễn Đức Duy')
if @dchi like N'%Quảng Nam'
begin
	print N'Phải'
end
else
begin
	print N'Không'
end
/*22.Điều tra số tiền trong tài khoản ông Lê Quang Phong có hợp lệ hay không? 
	(Hợp lệ: tổng tiền gửi – tổng tiền rút = số tiền hiện có trong tài khoản). Nếu hợp lệ, đưa ra thông báo “Hợp lệ”, 
	ngược lại hãy cập nhật lại tài khoản sao cho số tiền trong tài khoản khớp với tổng số tiền đã giao dịch 
	(ac_balance = sum(tổng tiền gửi) – sum(tổng tiền rút) */
go
declare @tiengui int, @tienrut int, @tongtien int, @ac_balance int
set @ac_balance = (select ac_balance from customer c join account ac on c.Cust_id=ac.cust_id
												join transactions t on ac.Ac_no=t.ac_no
								where cust_name like N'Lê Quang Phong')

set @tiengui = (select sum(t_amount)
				from customer c join account ac on c.Cust_id=ac.cust_id
								join transactions t on ac.Ac_no=t.ac_no
				where t_type = 1 and cust_name like N'Lê Quang Phong')
	print @tiengui

set @tienrut = (select sum(t_amount)
				from customer c join account ac on c.Cust_id=ac.cust_id
								join transactions t on ac.Ac_no=t.ac_no
				where t_type = 0 and cust_name like N'Lê Quang Phong')
	print @tienrut

if @ac_balance is null		--đề phòng cho th kh có dl
	set @ac_balance=0		-- null khi thực hiện phép tính sẽ trả về null
if @tiengui is null
	set @tiengui=0
if @tienrut is null
	set @tienrut=0

if (@tongtien = @tiengui - @tienrut)
begin
	print N'Hợp lệ'
end
else
begin
	print N'Không hợp lệ'
	update account set ac_balance = @tiengui - @tienrut
	from customer c join account ac on c.Cust_id=ac.cust_id
	where cust_name like N'Lê Quang Phong'
	print N'Đã update'
end

select t_id, t_amount, ac.ac_no, ac_balance
from customer c join account ac on c.Cust_id=ac.cust_id
				join transactions t on ac.Ac_no=t.ac_no
where cust_name like N'Lê Quang Phong'
/*23.Chi nhánh Đà Nẵng có giao dịch gửi tiền nào diễn ra vào ngày chủ nhật hay không? 
	Nếu có, hãy hiển thị số lần giao dịch, nếu không, hãy đưa ra thông báo “không có” */
declare @slgd int
select @slgd = count(t_id)
			 from transactions t join account ac on t.ac_no=ac.Ac_no
								 join customer c on ac.cust_id=c.Cust_id
								 join branch br on c.Br_id=br.BR_id
			 where datename(weekday,t_date) = 'Sunday' and br_name like N'%Đà Nẵng' and t_type = 1

if @slgd > 0
begin
	print N'Số lần giao dịch: ' + cast(@slgd as varchar)
end
else
begin
	print 'Không có'
end

--
select t_date, DATENAME(weekday,t_date) 'thứ', t_type
from transactions t join account ac on t.ac_no=ac.Ac_no
								 join customer c on ac.cust_id=c.Cust_id
								 join branch br on c.Br_id=br.BR_id
where DATENAME(weekday,t_date) = 'Sunday' and br_name like N'%Đà Nẵng'

/*24.Kiểm tra xem khu vực miền bắc có nhiều phòng giao dịch hơn khu vực miền trung ko? Miền bắc có 
	mã bắt đầu bằng VB, miền trung có mã bắt đầu bằng VT */
declare @bac int, @trung int
set @bac = (select count(br_id) 
			from branch
			where br_id like 'VB%')
set @trung = (select count(br_id) 
			from branch
			where br_id like 'VT%')

print N'Số phòng giao dịch ở miền Bắc: ' + cast(@bac as varchar)
print N'Số phòng giao dịch ở miền Trung: ' + cast(@trung as varchar)

if @bac > @trung
begin
	print N'Khu vực miền Bắc nhiều phòng giao dịch hơn'
end
else
begin
	print N'Khu vực miền Trung nhiều phòng giao dịch hơn'
end

--25.In ra dãy số lẻ từ 1 – n, với n là giá trị tự chọn
declare @sole int = 1, @n int = 1000
while @sole < @n
begin
	print @sole
	set @sole = @sole + 2
end

--26.In ra dãy số chẵn từ 0 – n, với n là giá trị tự chọn
declare @sole int = 0, @n int = 1000
while @sole <= @n
begin
	print @sole
	set @sole = @sole + 2
end

--27.In ra 100 số đầu tiền trong dãy số Fibonaci
declare @n int = 100 -- Số phần tử trong dãy Fibonacci
declare @a int = 0
declare @b int = 1
declare @count int = 0

while @count < @n
begin
    print @a
    declare @sum int = @a + @b
    set @a = @b
    set @b = @sum
    set @count = @count + 1
end
go
/*28.In ra tam giác sao: 
a)	tam giác vuông
*
**
***
****
*****    */
declare @sao varchar(10), @count int = 1
set @sao = '*'
while @count <= 5
begin
	print @sao
	set @sao = replicate('*', len(@sao)+1)
	set @count = @count + 1
end
go

declare @sao int = 1
while @sao <= 5
begin
	print replicate('*', @sao)
	set @sao = @sao + 1
end
go


declare @sao int = 1, @space int = 7
while @sao <= 8
begin
	print replicate(' ', @space) + replicate('*', @sao)
	set @space = @space - 1
	set @sao = @sao + 1
end
go
/*b)	tam giác cân

    *
   ***
  *****
 *******
*********      */
2x2-1=3  n(tổng số dòng)-i(số dòng đang đứng)  2i-1

declare @n int = 5, @i int = 1
while @i <= @n
begin
	print replicate (' ', @n-@i) + replicate('*', 2*@i -1)
	set @i = @i + 1
end
go



declare @sao int, @space int
set @sao=1 
set @space=10
while @sao<=@space
 begin
print replicate(' ',(@space-@sao)/2) + replicate('*',@sao) 
set @sao=@sao+2
end

--c)	In bảng cửu chương
-- dọc
declare @x int, @n int, @m int 
set @n=2
while @n <10 
begin
	set @m=1
	while @m <=10
	begin
		set @x=@n*@m 
		print concat(@n,'x',@m, '=', @x)
		set @m=@m+1
	end
print ''
set @n=@n+1
end

declare @i int = 2
declare @j int = 1


--ngang
declare @so1 int=1, @so2 int=2, @dong varchar(200)
while @so1<=10
begin
	set @so2=2
	set @dong=''
	while @so2<=9
	begin					-- dùng char(2) để căn chỉnh
	     set @dong = @dong + cast(@so2 as char(2)) +'x'
						   + cast(@so1 as char(2)) +'='
						   + cast (@so1*@so2 as char(2))+ '   '   
		 set @so2=@so2 +1
	end
	print (@dong)
	set @so1=@so1+1
end


--d)	Viết đoạn code đọc số. Ví dụ: 1.234.567 --> Một triệu hai trăm ba mươi tư ngàn năm trăm sáu mươi bảy đồng. 
--	(Giả sử số lớn nhất là hàng trăm tỉ)
DECLARE @number INT = 1234567
DECLARE @result NVARCHAR(MAX) = ''

-- Xác định hàng triệu
DECLARE @hangtrieu INT = @number / 1000000
IF @hangtrieu > 0
BEGIN
    SET @result = @result + CAST(@hangtrieu AS NVARCHAR) + ' triệu '
    SET @number = @number - @hangtrieu * 1000000
END

-- Xác định hàng nghìn
DECLARE @hangngan INT = @number / 1000
IF @hangngan > 0
BEGIN
    SET @result = @result + CAST(@hangngan AS NVARCHAR) + ' ngàn '
    SET @number = @number - @hangngan * 1000
END

-- Xác định hàng trăm
DECLARE @hangtram INT = @number / 100
IF @hangtram > 0
BEGIN
    SET @result = @result + CAST(@hangtram AS NVARCHAR) + ' trăm '
    SET @number = @number - @hangtram * 100
END

-- Xác định hàng chục
DECLARE @hangchuc INT = @number / 10
IF @hangchuc > 0
BEGIN
    DECLARE @chuoihangchuc NVARCHAR(20)
    SET @chuoihangchuc = CASE
                            WHEN @hangchuc = 1 THEN 'mười'
                            WHEN @hangchuc = 2 THEN 'hai mươi'
                            WHEN @hangchuc = 3 THEN 'ba mươi'
                            WHEN @hangchuc = 4 THEN 'bốn mươi'
                            WHEN @hangchuc = 5 THEN 'năm mươi'
                            WHEN @hangchuc = 6 THEN 'sáu mươi'
                            WHEN @hangchuc = 7 THEN 'bảy mươi'
                            WHEN @hangchuc = 8 THEN 'tám mươi'
                            WHEN @hangchuc = 9 THEN 'chín mươi'
                        END
    SET @result = @result + @chuoihangchuc + ' '
    SET @number = @number - @hangchuc * 10
END

-- Xác định hàng đơn vị
IF @number > 0
BEGIN
    DECLARE @chuoidonvi NVARCHAR(20)
    SET @chuoidonvi = CASE
                        WHEN @number = 1 THEN 'một'
                        WHEN @number = 2 THEN 'hai'
                        WHEN @number = 3 THEN 'ba'
                        WHEN @number = 4 THEN 'bốn'
                        WHEN @number = 5 THEN 'năm'
                        WHEN @number = 6 THEN 'sáu'
                        WHEN @number = 7 THEN 'bảy'
                        WHEN @number = 8 THEN 'tám'
                        WHEN @number = 9 THEN 'chín'
                    END
    SET @result = @result + @chuoidonvi
END

SELECT @result AS DocSo
-- Kết quả: Một triệu hai trăm ba mươi bốn ngàn năm trăm sáu mươi bảy

DECLARE @number INT = 1234567
DECLARE @result NVARCHAR(MAX) = ''

-- Xác định hàng triệu
IF @number >= 1000000
BEGIN
    SET @result = @result + CAST(@number / 1000000 AS NVARCHAR) + ' triệu '
    SET @number = @number % 1000000
END

-- Xác định hàng nghìn
IF @number >= 1000
BEGIN
    SET @result = @result + CAST(@number / 1000 AS NVARCHAR) + ' ngàn '
    SET @number = @number % 1000
END

-- Xác định hàng trăm
IF @number >= 100
BEGIN
    SET @result = @result + CAST(@number / 100 AS NVARCHAR) + ' trăm '
    SET @number = @number % 100
END

-- Xác định hàng chục
IF @number >= 20
BEGIN
    DECLARE @hangchuc NVARCHAR(20)
    SET @hangchuc = CASE
                        WHEN @number >= 90 THEN 'chín'
                        WHEN @number >= 80 THEN 'tám'
                        WHEN @number >= 70 THEN 'bảy'
                        WHEN @number >= 60 THEN 'sáu'
                        WHEN @number >= 50 THEN 'năm'
                        WHEN @number >= 40 THEN 'bốn'
                        WHEN @number >= 30 THEN 'ba'
                        WHEN @number >= 20 THEN 'hai'
                    END
    SET @result = @result + @hangchuc + ' mươi '
    SET @number = @number % 10
END

-- Xác định hàng đơn vị
IF @number > 0
BEGIN
    DECLARE @hangdonvi NVARCHAR(20)
    SET @hangdonvi = CASE
                        WHEN @number = 1 THEN 'một'
                        WHEN @number = 2 THEN 'hai'
                        WHEN @number = 3 THEN 'ba'
                        WHEN @number = 4 THEN 'bốn'
                        WHEN @number = 5 THEN 'năm'
                        WHEN @number = 6 THEN 'sáu'
                        WHEN @number = 7 THEN 'bảy'
                        WHEN @number = 8 THEN 'tám'
                        WHEN @number = 9 THEN 'chín'
                    END
    SET @result = @result + @hangdonvi
END

SELECT @result AS DocSo

CREATE FUNCTION dbo.DocSo (@number INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @result NVARCHAR(MAX) = ''
    
    -- Xác định hàng chục tỷ
    IF @number >= 1000000000
    BEGIN
        SET @result = @result + dbo.DocSo(@number / 1000000000) + ' tỷ '
        SET @number = @number % 1000000000
    END
    
    -- Xác định hàng trăm triệu
    IF @number >= 100000000
    BEGIN
        SET @result = @result + dbo.DocSo(@number / 100000000) + ' trăm '
        SET @number = @number % 100000000
    END
    
    -- Xác định hàng chục triệu
    IF @number >= 10000000
    BEGIN
        SET @result = @result + dbo.DocSo(@number / 10000000) + ' chục '
        SET @number = @number % 10000000
    END
    
    -- Xác định hàng triệu
    IF @number >= 1000000
    BEGIN
        SET @result = @result + dbo.DocSo(@number / 1000000) + ' triệu '
        SET @number = @number % 1000000
    END
    
    -- Xác định hàng trăm nghìn
    IF @number >= 100000
    BEGIN
        SET @result = @result + dbo.DocSo(@number / 100000) + ' trăm '
        SET @number = @number % 100000
    END
    
    -- Xác định hàng chục nghìn
    IF @number >= 10000
    BEGIN
        SET @result = @result + dbo.DocSo(@number / 10000) + ' chục '
        SET @number = @number % 10000
    END
    
    -- Xác định hàng nghìn
    IF @number >= 1000
    BEGIN
        SET @result = @result + dbo.DocSo(@number / 1000) + ' ngàn '
        SET @number = @number % 1000
    END
    
    -- Xác định hàng trăm
    IF @number >= 100
    BEGIN
        SET @result = @result + dbo.DocSo(@number / 100) + ' trăm '
        SET @number = @number % 100
    END
    
    -- Xác định hàng chục
    IF @number >= 10
    BEGIN
        DECLARE @hangchuc NVARCHAR(20)
        SET @hangchuc = CASE
                            WHEN @number >= 20 THEN dbo.DocSo(@number / 10) + ' mươi '
                            WHEN @number = 15 THEN 'mười lăm '
                            ELSE 'mười '
                        END
        SET @result = @result + @hangchuc
        SET @number = @number % 10
    END
    
    -- Xác định hàng đơn vị
    IF @number > 0
    BEGIN
        SET @result = @result + dbo.DocSo(@number)
    END
    
    RETURN @result
END

DECLARE @number INT = 1234567
SELECT dbo.DocSo(@number) AS DocSo
-- Kết quả: Một triệu hai trăm ba mươi tư ngàn năm trăm sáu mươi bảy
-- Kết quả: Một triệu hai trăm ba mươi tư ngàn năm trăm sáu mươi bảy
--e)	Kiểm tra số điện thoại của Lê Quang Phong là số tiến hay số lùi. 
/*Gợi ý:
Với những số điện thoại có 10 số, thì trừ 3 số đầu tiên, nếu số sau lớn hơn hoặc bằng số trước thì là số tiến, 
ngược lại là số lùi. Ví dụ: 0981.244.789 (tiến), 0912.776.541 (lùi), 0912.563.897 (lộn xộn)
Với những số điện thoại có 11 số thì trừ 4 số đầu tiên. */



--Quiz 5: ông Dương Ngọc Long thực hiện giao dịch đầu tiên tại VCB và ngày trong hay cuối tuần. Ông rút hay gửi tiền, số lượng bao nhiêu>
declare @ngay nvarchar(50), @loai nvarchar(5), @tongtien int
select top 1 @ngay = t_date, @loai = t_type, @tongtien = sum(t_amount)
from customer c join account ac on c.Cust_id = ac.cust_id
				join branch br on c.Br_id = br.BR_id
				join transactions t on ac.Ac_no = t.ac_no
where cust_name = N'Dương Ngọc Long'
group by t_date, t_type
order by t_date desc
set @ngay = case when datepart(weekday, @ngay) = 2 then N'đầu tuần'
				 when datepart(weekday, @ngay) between 3 and 7 then N'trong tuần'
				 when datepart(weekday, @ngay) = 1 then N'cuối tuần'
		    end
set @loai = case when @loai = 1 then 'gửi'
				 when @loai = 0 then 'rút'
			end
print N'Ông Dương Ngọc Long thực hiện giao dịch đầu tiên vào ngày ' + @ngay + N'. Ông thực hiện ' + 
		@loai + N' tiền với số lượng tiền là ' + cast(@tongtien as varchar)