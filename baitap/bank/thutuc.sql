/*tuần sau chữa hàm học trigger, làm bt
nghỉ 1 tuần
ktra giữa kì, ktra tiến độ bt nhóm
lịch thi 6/12
bt nhóm 2 tuần cuối*/
--1. Chuyển đổi đầu số điện thoại di động theo quy định của bộ Thông tin và truyền thông nếu biết mã khách của họ.
create proc chuyendoiso @cust_id varchar(10)
as
begin
	declare @sđt varchar(20)=(select cust_phone from customer where cust_id=@cust_id)
	declare @sđts varchar(10)=right(@sđt,7) 
	if len(@sđt)=11
	begin
		declare @sđtd varchar(4)=left(@sđt,4)
		update customer
		set cust_phone = (case when @sđtd='0120' then concat('070',@sđts)
							   when @sđtd='0121' then concat('079',@sđts)
							   when @sđtd='0122' then concat('077',@sđts)
							   when @sđtd='0126' then concat('076',@sđts)
							   when @sđtd='0128' then concat('078',@sđts)
							   when @sđtd='0123' then concat('083',@sđts)
							   when @sđtd='0124' then concat('084',@sđts)
							   when @sđtd='0125' then concat('085',@sđts)
							   when @sđtd='0127' then concat('081',@sđts)
							   when @sđtd='0129' then concat('082',@sđts)
							   when @sđtd='0162' then concat('032',@sđts)
							   when @sđtd='0163' then concat('033',@sđts)
							   when @sđtd='0164' then concat('034',@sđts)
							   when @sđtd='0165' then concat('035',@sđts)
							   when @sđtd='0166' then concat('036',@sđts)
							   when @sđtd='0167' then concat('037',@sđts)
							   when @sđtd='0168' then concat('038',@sđts)
							   when @sđtd='0169' then concat('039',@sđts)
							   when @sđtd='0186' then concat('056',@sđts)
							   when @sđtd='0188' then concat('058',@sđts)
							   when @sđtd='0199' then concat('059',@sđts)
						end)
						where cust_id=@cust_id

	end
end

declare @makh varchar(6)
set @makh='000003'
exec chuyendoiso @makh
select * from customer where cust_id=@makh

/*2. Kiểm tra trong vòng 10 năm trở lại đây khách hàng có thực hiện giao dịch nào không, nếu biết mã khách của họ? 
	 Nếu có, hãy trừ 50.000 phí duy trì tài khoản.  */
--input: mã khách
--output: kh có
create proc Sodu @ma varchar(6)
as
begin
	declare @gd int
	set @gd = (select count(t_id)
			   from customer c join account ac on c.Cust_id=ac.cust_id
							   join transactions t on ac.Ac_no=t.ac_no
			   where c.cust_id=@ma and dateadd(year, -10, getdate())<=t_date)

	if @gd > 0
	begin
		update account set ac_balance = ac_balance - 50000
		from customer c join account ac on c.Cust_id=ac.cust_id
						join transactions t on ac.Ac_no=t.ac_no
		where c.cust_id=@ma and dateadd(year, -10, getdate())<=t_date
	end
end

declare @id varchar(6)
set @id = '000006'
exec Sodu @id
select * from account where cust_id=@id


select t_date, t_amount, c.cust_id
from customer c join account ac on c.Cust_id=ac.cust_id
				join transactions t on ac.Ac_no=t.ac_no
where dateadd(year, -10, getdate())<=t_date and c.cust_id='000006'
/*3. Kiểm tra khách thực hiện giao dịch gần đây nhất vào thứ mấy? (thứ hai, thứ ba, thứ tư,…, chủ nhật) 
và vào mùa nào (mùa xuân, mùa hạ, mùa thu, mùa đông) nếu biết mã khách.	*/
--input: mã khách
--output: thứ, mùa
create proc ktra @idkhach varchar(10), @mua varchar(15) output, @thu varchar(10) output
as
begin
	set @thu = (select top 1 t_date
				from customer c join account ac on c.Cust_id=ac.cust_id
								join transactions t on ac.Ac_no=t.ac_no
				where c.cust_id=@idkhach
				order by t_date desc)
	set @mua = (select datepart(qq, max(t_date))
				from customer c join account ac on c.Cust_id=ac.cust_id
								join transactions t on ac.Ac_no=t.ac_no
				where c.cust_id=@idkhach)

	set @thu = case when datepart(weekday, @thu) = '2' then N'thứ hai'
					when datepart(weekday, @thu) = '3' then N'thứ ba'
					when datepart(weekday, @thu) = '4' then N'thứ tư'
					when datepart(weekday, @thu) = '5' then N'thứ năm'
					when datepart(weekday, @thu) = '6' then N'thứ sáu'
					when datepart(weekday, @thu) = '7' then N'thứ bảy'
					else N'chủ nhật'
				end
	set @mua = case @mua when 1 then N'mùa xuân'
						 when 2 then N'mùa hè'
						 when 3 then N'mùa thu'
						 when 4 then N'mùa đông'
			   end
end

declare @idkhach varchar(10), @mua varchar(15), @thu varchar(10)
set @idkhach = '000022'
exec ktra @idkhach, @mua output, @thu output
print @thu
print @mua

/*4. Đưa ra nhận xét về nhà mạng của khách hàng đang sử dụng nếu biết mã khách? (Viettel, Mobi phone, 
Vinaphone, Vietnamobile, khác)	*/
--input: mã khách
--output: nhà mạng
go
create proc nhamang @id varchar(6), @mang varchar(15) output
as
begin
	set @mang = (select cust_phone from customer where cust_id=@id)
	set @mang = case when @mang like '016[2,3,4,5,6,7,8,9]%' or @mang like '09[6,7,8]%' 
					   or @mang like '03[2,3,4,5,6,7,8,9]%' or @mang like '086%' then 'Viettel'
					 when @mang like '089%' or @mang like '09[0,3]%' or @mang like '012[0,1,2,6,8]%'
					   or @mang like '07[0,9,7,6,8]%' then 'Mobiphone'
					 when @mang like '08[1,2,3,4,5,8]%' or @mang like '09[1,4]%'
					   or @mang like '012[3,4,5,7,9]%' then 'Vinaphone'
					 when @mang like '05[6,8]%' or @mang like '092%' then 'Vietnamobile'
					 else N'Mạng khác'
				end
end
go
create proc nxnhamang @id varchar(6)
as
begin
	declare @mang varchar(15)
	set @mang = (select cust_phone from customer where cust_id=@id)
	if @mang like '016[2,3,4,5,6,7,8,9]%' or @mang like '09[6,7,8]%' 
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
	print N'Mạng khác'
	end
end
--0935777298
declare @id varchar(6), @mang varchar(15)
set @id = '000004'
exec nhamang @id, @mang output
print @mang

declare @id varchar(6)
set @id = '000004'
exec nxnhamang @id

select * from customer
/*5. Nếu biết mã khách, hãy kiểm tra số điện thoại của họ là số tiến, số lùi hay số lộn xộn. 
Định nghĩa: trừ 3 số đầu tiên, các số còn lại tăng dần gọi là số tiến, ví dụ: 098356789 là số tiến	*/

/*6. Nếu biết mã khách, hãy kiểm tra xem khách thực hiện giao dịch gần đây nhất vào buổi nào
(sáng, trưa, chiều, tối, đêm)?	*/
--input: mã khách
--output: buổi
go
create proc thoigian @makhach varchar(6), @tgian varchar(8) output
as
begin
	set @tgian = (select top 1 t_time
				  from transactions t join account ac on t.ac_no = ac.Ac_no
									  join customer c on ac.cust_id = c.Cust_id
				  where c.Cust_id = @makhach
				  order by t_time desc)
	set @tgian = case when datepart(hour, @tgian) < 6 then N'buổi đêm'
					  when datepart(hour, @tgian) < 11 then N'buổi sáng'
					  when datepart(hour, @tgian) < 13 then N'buổi trưa'
					  when datepart(hour, @tgian) < 18 then N'buổi chiều'
					  else 'tối' 
				 end
end

declare @makhach varchar(6), @tgian varchar(8)
set @makhach = '000001'
exec thoigian @makhach, @tgian output
print @tgian

select t_time
from transactions t join account ac on t.ac_no = ac.Ac_no
				  join customer c on ac.cust_id = c.Cust_id
where c.Cust_id = '000001'
order by t_time desc
/*7. Nếu biết số điện thoại của khách, hãy kiểm tra chi nhánh ngân hàng mà họ đang sử dụng thuộc miền nào? 
Gợi ý: nếu mã chi nhánh là VN  miền nam, VT  miền trung, VB  miền bắc, còn lại: bị sai mã.	*/
--input: sđt
--output: miền
create proc miencn @sdt varchar(11), @mien varchar(15) output
as
begin
	set @mien = (select distinct br_id 
				 from transactions t join account ac on t.ac_no = ac.Ac_no
									  join customer c on ac.cust_id = c.Cust_id
				 where cust_phone = @sdt)
	set @mien = case when @mien like 'VN%' then N'Miền Nam'
					 when @mien like 'VT%' then N'Miền Trung'
					 when @mien like 'VB%' then N'Miền Bắc'
				end
end

declare @sdt varchar(11), @mien varchar(15)
set @sdt = '01645500071'
exec miencn @sdt, @mien output
print @mien

select c.cust_id, br_id, cust_phone, ac.ac_no
from transactions t join account ac on t.ac_no = ac.Ac_no
					join customer c on ac.cust_id = c.Cust_id
where cust_phone = '01645500071'
/*8. Căn cứ vào số điện thoại của khách, hãy nhận định vị khách này dùng dịch vụ di động của hãng nào: 
Viettel, Mobi phone, Vina phone, hãng khác.	  */
--input: sđt
--output: hãng
create proc dvdd @sdt varchar(11), @hang varchar(15) output
as
begin
	set @hang = (select cust_phone from customer where cust_phone = @sdt)
	set @hang = case when @hang like '016[2,3,4,5,6,7,8,9]%' or @hang like '09[6,7,8]%' 
					   or @hang like '03[2,3,4,5,6,7,8,9]%' or @hang like '086%' then 'Viettel'
					 when @hang like '089%' or @hang like '09[0,3]%' or @hang like '012[0,1,2,6,8]%'
					   or @hang like '07[0,9,7,6,8]%' then 'Mobiphone'
					 when @hang like '08[1,2,3,4,5,8]%' or @hang like '09[1,4]%'
					   or @hang like '012[3,4,5,7,9]%' then 'Vinaphone'
					 when @hang like '05[6,8]%' or @hang like '092%' then 'Vietnamobile'
					 else N'Hãng khác'
				end
end

declare @sdt varchar(11), @hang varchar(15)
set @sdt = '01646636030'
exec dvdd @sdt, @hang output
print @hang
select * from customer
/*9. Hãy nhận định khách hàng ở vùng nông thôn hay thành thị nếu biết mã khách hàng của họ. Gợi ý: nông thôn
thì địa chỉ thường có chứa chữ “thôn” hoặc “xóm” hoặc “đội” hoặc “xã” hoặc “huyện”	*/
--input: mã khách
--output: địa chỉ
create proc kvuc @makh varchar(6), @dchi varchar(10) output
as
begin
	set @dchi = (select cust_ad from customer where cust_id = @makh)
	set @dchi = case when (@dchi like N'%thôn%' or @dchi like N'%xóm%' or @dchi like N'%đội%' or 
						   @dchi like N'%xã%' or @dchi like N'%huyện%') and @dchi not like N'%thị xã%' then N'Nông thôn'
					 else N'Thành thị'
				end
end

create proc khuvuc @makh varchar(6), @dchi varchar(10) output
as
begin
	declare @cust_ad varchar (50) = (select cust_ad from customer where cust_id = @makh)
	set @dchi = case when (@cust_ad like N'%thôn%' or @cust_ad like N'%xóm%' or @cust_ad like N'%đội%' or 
						   @cust_ad like N'%xã%' or @cust_ad like N'%huyện%') and @cust_ad not like N'%thị xã%' then N'Nông thôn'
					 else N'Thành thị'
				end
end
--K79/4 THANH THỦY, HẢI CH U, ĐÀ NẴNG 000010
--THÔN THANH QUÝT 1, ĐIỆN THẮNG TRUNG, ĐIỆN BÀN, QUẢNG NAM  000011
declare @makh varchar(6), @dchi varchar(10)
set @makh = '000013'
exec kvuc @makh, @dchi output
print @dchi

drop proc kvuc
select * from customer
/*10. Hãy kiểm tra tài khoản của khách nếu biết số điện thoại của họ. Nếu tiền trong tài khoản của họ nhỏ hơn	
không hoặc bằng không nhưng 6 tháng gần đây không có giao dịch thì hãy đóng tài khoản bằng cách cập nhật ac_type = ‘K’	*/
--input: sđt
--output: 
create proc ktratk @sdt varchar(11)
as
begin
	declare @sodu int, @gd int
	set @sodu = (select ac_balance
				 from account ac join customer c on ac.cust_id = c.Cust_id
				 where cust_phone = @sdt)
	set @gd = (select count(t_id)
			   from account ac join customer c on ac.cust_id = c.Cust_id
							   join transactions t on ac.Ac_no = t.ac_no
			   where cust_phone = @sdt and dateadd(month, -6, getdate())<t_date or t_id is null)
	if @sodu < 0
	begin
		update account
		set ac_type = 'K'
		from customer c join account ac on c.Cust_id = ac.cust_id
		where cust_phone = @sdt
	end
	else if @sodu = 0 and @gd =0
	begin
		update account
		set ac_type = 'K'
		from customer c join account ac on c.Cust_id = ac.cust_id
		where cust_phone = @sdt
	end
	else
	begin
		print N'Bình thường'
	end
end

drop proc ktratk
declare @sdt varchar(11)
set @sdt = '0905556510'
exec ktratk @sdt
select * from customer c join account ac on c.Cust_id = ac.cust_id where cust_phone = @sdt
--11. Kiểm tra mã số giao dịch gần đây nhất của khách là số chẵn hay số lẻ nếu biết mã khách.
--input: mã khách
--output: 
create proc ktmgd @id varchar(6)
as
begin
	declare @gd int = (select top 1 t_id
					   from transactions t join account ac on t.ac_no = ac.Ac_no
										   join customer c on ac.cust_id = c.Cust_id
					   where c.cust_id = @id
					   order by t_date desc)
	if @gd % 2=0
	begin
		print N'số chẵn'
	end
	else
	begin
		print N'số lẻ'
	end
end

declare @id varchar(6)
set @id = '000023'
exec ktmgd @id

/*12. Trả về số lượng giao dịch diễn ra trong khoảng thời gian nhất định (tháng, năm), tổng tiền mỗi loại 
giao dịch là bao nhiêu (bao nhiêu tiền rút, bao nhiêu tiền gửi)	*/  sai
--input: tháng, năm
--output: slgd, tt rút, tt gửi
alter proc tongtien @thang varchar(5), @nam varchar(5), @slgd int output, @ttrut int output, @ttgui int output
as
begin
	set @slgd = (select count(t_id) 
				 from transactions 
				 where @thang = datepart(month, t_date) and @nam = datepart(year, t_date))
	set @ttrut = (select sum(t_amount)
				  from transactions
				  where @thang = datepart(month, t_date) and @nam = datepart(year, t_date) and t_type = 0)
	set @ttgui = (select sum(t_amount)
				  from transactions
				  where @thang = datepart(month, t_date) and @nam = datepart(year, t_date) and t_type = 1)
	if @slgd is null
	set @slgd = 0
	if @ttrut is null
	set @ttrut = 0
	if @ttgui is null
	set @ttgui = 0
end

declare @thang varchar, @nam varchar, @slgd int, @ttrut int, @ttgui int
set @thang = '08'
set @nam = '2016'
exec tongtien @thang, @nam, @slgd output, @ttrut output, @ttgui output
print @slgd
print @ttrut
print @ttgui
--13. Trả về số lượng chi nhánh ở một địa phương nhất định.  sai
--input: địa phương
--output: sl chi nhánh
create proc slcn @diaphuong nvarchar(50), @slcn int output
as
begin
	set @slcn = (select count(br_id) from Branch where br_name = @diaphuong)
end

declare @diaphuong nvarchar(50), @slcn int
set @diaphuong like N'%Hà Nội%'
exec slcn @diaphuong, @slcn output
print @slcn

/*14. Trả về tên khách hàng có nhiều tiền nhất là trong tài khoản, số tiền hiện có trong tài khoản đó 
là bao nhiêu? Tài khoản này thuộc chi nhánh nào?	*/
--15. Trả về số lượng khách của một chi nhánh nhất định.
--16. Tìm tên, số điện thoại, chi nhánh của khách thực hiện giao dịch, nếu biết mã giao dịch.
/*17. Hiển thị danh sách khách hàng gồm: họ và tên, số điện thoại, số lượng tài khoản đang có và nhận xét. 
Nếu < 1 tài khoản --> “Bất thường”, còn lại “Bình thường”	*/
/*18. Nhận xét tiền trong tài khoản của khách nếu biết số điện thoại. <100.000: ít, 
< 5.000.000: trung bình, còn lại: nhiều	  */
--input: sđt
--output: nhận xét

alter proc nxtien @sdt varchar(11), @nxet nvarchar(16) output
as
begin
	declare @tien int
	set @tien = (select sum(ac_balance)
				 from customer c join account ac on c.Cust_id = ac.cust_id
				 where @sdt = cust_phone)
	if @tien < 100000
	begin
		print N'Ít tiền'
	end
	else if @tien < 5000000 and @tien >100000
	begin
		print N'Trung bình'
	end
	else
	begin
		print N'Nhiều tiền'
	end
end

declare @sdt varchar(11), @nxet nvarchar(16)
set @sdt = '0783388103'
exec nxtien @sdt, @nxet out


--19. Kiểm tra khách hàng đã mở tài khoản tại ngân hàng hay chưa nếu biết họ tên và số điện thoại của họ.
--input: họ tên, sđt
--output:
create or alter proc ktrtk @ten nvarchar(50), @sdt varchar(11), @ret bit out
as
begin
	declare @tk int
	set @tk = (select count(*)
			   from customer
			   where cust_name = @ten and cust_phone = @sdt)
	if @tk > 0
	begin
		set @ret = 1 
	end
	else
	begin
		set @ret = 0
	end
end

select * from customer

declare @ten nvarchar(50), @sdt varchar(11)
declare @a bit
set @ten = N'Trần Đức Quý'
set @sdt = '0338843209'
exec ktrtk @ten, @sdt, @a out
print @a

select ac_no from account ac join customer c on ac.cust_id = c.cust_id where cust_name = N'Trần Đức Quý'
/*20. Điều tra số tiền trong tài khoản của khách có hợp lệ hay không nếu biết mã khách? 
(Hợp lệ: tổng tiền gửi – tổng tiền rút = số tiền hiện có trong tài khoản). Nếu hợp lệ, đưa ra thông báo “Hợp lệ”, 
ngược lại hãy cập nhật lại tài khoản sao cho số tiền trong tài khoản khớp với tổng số tiền đã giao dịch 
(ac_balance = sum(tổng tiền gửi) – sum(tổng tiền rút)	*/
create proc dieutra @Cust_id varchar(10)
as
begin
	declare @TTiengui int, @TTienrut int, @ac_balance int
	set @ac_balance = (select ac_balance
					   from account ac join customer c on ac.cust_id = c.Cust_id
					   where c.cust_id = @Cust_id)
	set @TTiengui = (select sum(t_amount) 
					 from transactions t join account ac on t.ac_no = ac.ac_no
										 join customer c on ac.cust_id = c.Cust_id
					 where t_type = 1 and c.cust_id = @Cust_id)
	set @TTienrut = (select sum(t_amount)
					 from transactions t join account ac on t.ac_no = ac.ac_no
					 					 join customer c on ac.cust_id = c.Cust_id
					 where t_type = 0 and c.cust_id = @Cust_id)

	if @ac_balance is null	
	set @ac_balance=0		
	if @TTiengui is null
		set @TTiengui=0
	if @TTienrut is null
		set @TTienrut=0

	if (@ac_balance = @TTiengui - @TTienrut)
	begin
		print N'Hợp lệ'
	end
	else
	begin
		print N'Không hợp lệ'
		update account set ac_balance = @TTiengui - @TTienrut
		from customer c join account ac on c.Cust_id=ac.cust_id
		where c.cust_id = @Cust_id
		print N'Đã update'
	end
end

declare @Cust_id varchar(10)
set @Cust_id = '000003'
exec dieutra @cust_id
select ac_balance from customer c join account ac on c.Cust_id=ac.cust_id
		where c.cust_id = @Cust_id 

/*21. Kiểm tra chi nhánh có giao dịch gửi tiền nào diễn ra vào ngày chủ nhật hay không nếu biết mã chi nhánh? 
Nếu có, trả về lần giao dịch.	*/
--22. In ra dãy số lẻ từ 1 – n, với n là giá trị tự chọn
--23. In ra dãy số chẵn từ 0 – n, với n là giá trị tự chọn
--24. In ra 100 số đầu tiền trong dãy số Fibonaci
--25. In ra tam giác sao: 
/*a) tam giác vuông
*
**
***
****
*****		*/
/*b) tam giác cân

       *
     ***
   *****
 *******
********		*/


--c) In bảng cửu chương
/*d) Viết đoạn code đọc số. Ví dụ: 1.234.567  Một triệu hai trăm ba mươi tư ngàn năm trăm sáu mươi bảy đồng. 
(Giả sử số lớn nhất là hàng trăm tỉ)	*/
--e) Kiểm tra số điện thoại của khách là số tiến hay số lùi nếu biết mã khách. 
/*Gợi ý:
Với những số điện thoại có 10 số, thì trừ 3 số đầu tiên, nếu số sau lớn hơn hoặc bằng số trước thì là số tiến, 
ngược lại là số lùi. Ví dụ: 0981.244.789 (tiến), 0912.776.541 (lùi), 0912.563.897 (lộn xộn)
Với những số điện thoại có 11 số thì trừ 4 số đầu tiên. */

