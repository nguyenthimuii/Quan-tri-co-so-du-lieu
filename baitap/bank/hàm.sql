--19. Kiểm tra khách hàng đã mở tài khoản tại ngân hàng hay chưa nếu biết họ tên và số điện thoại của họ.
--input: họ tên, sđt
--output:
create function fCheckCust (@ten nvarchar(100), @sdt varchar(12))
returns bit
as
begin
	declare @count int
	set @count = (select count(*) from customer
				  where cust_name = @ten and cust_phone = @sdt)
	return case when @count > 0 then 1
				 else 0
			end
end

select dbo.fCheckCust (N'Trần Đức Quý', '0338843209')
print concat(N'Giá trị trả về là: ', dbo.fCheckCust(N'Trần Đức Quý', '0338843209'))

--1. Trả về tên chi nhánh ngân hàng nếu biết mã của nó.
create function tenchinhanh(@br_id varchar(10))
returns nvarchar(50)
as
begin
	return (select br_name from branch where br_id=@br_id)
end
print dbo.tenchinhanh('VB001')
select*from branch
--2. Trả về tên, địa chỉ và số điện thoại của khách hàng nếu biết mã khách.
--3. In ra danh sách khách hàng của một chi nhánh cụ thể nếu biết mã chi nhánh đó.
create function fdsachkh (@mcn varchar(6))
returns table
as
return select cust_name, cust_phone
		from customer
		where br_id = @mcn

select * from dbo.fdsachkh ('VT011')
drop function fdskh
/*4. Kiểm tra một khách hàng nào đó đã tồn tại trong hệ thống CSDL của ngân hàng chưa nếu biết: 
	họ tên, số điện thoại của họ. Đã tồn tại trả về 1, ngược lại trả về 0 */
create function fktratt (@ten nvarchar(50), @sdt varchar(12))
returns bit
as
begin
	declare @count int
	set @count = (select count (*) from customer
				  where cust_name = @ten and cust_phone = @sdt)
	return case when @count > 0 then 1
				else 0
			end
end

select dbo.fktratt (N'Trần Đức Quý', '0338843209')
--5. Cập nhật số tiền trong tài khoản nếu biết mã số tài khoản và số tiền mới. Thành công trả về 1, thất bại trả về 0
--6. Cập nhật địa chỉ của khách hàng nếu biết mã số của họ. Thành công trả về 1, thất bại trả về 0
--7. Trả về số tiền có trong tài khoản nếu biết mã tài khoản.
create function ftien (@matk varchar(10))
returns varchar(11)
as
begin
	return (select ac_balance from account where ac_no = @matk)
end

select dbo.ftien ('1000000001')
--8. Trả về số lượng khách hàng, tổng tiền trong các tài khoản nếu biết mã chi nhánh.
/*9. Kiểm tra một giao dịch có bất thường hay không nếu biết mã giao dịch. Giao dịch bất thường: 
	giao dịch gửi diễn ra ngoài giờ hành chính, giao dịch rút diễn ra vào thời điểm 0am  3am */
create or alter function fKtragd (@magd varchar(10))
returns nvarchar(11)
as
begin
	declare @gd time, @t_type int
	set @gd = (select t_time from transactions where t_id = @magd)
	set @t_type = (select t_type from transactions where t_id = @magd)
	return case when (@t_type = 1 and ((@gd between '11:30' and '13:30') or (@gd between '17:30' and '7:30')))
					or (@t_type = 0 and (datepart(hour,@gd) between 0 and 3)) then N'Bất thường'
				else N'Bình thường'
			end
end

select dbo.fKtragd ('0000000201')
/*10. Trả về mã giao dịch mới. Mã giao dịch tiếp theo được tính như sau: MAX(mã giao dịch đang có) + 1. 
	Hãy đảm bảo số lượng kí tự luôn đúng với quy định về mã giao dịch */
--
create or alter proc pNewID (@magd char(10) output)
as
begin
	declare @count varchar(10)
	set @count = (select (max(cast(t_id as numeric (10,0)))+1) from transactions)
	set @magd = concat(replicate('0',10-len(@count)),@count)

end
declare @magd varchar(10)
exec pNewID @a output
print @a
--
create or alter function pGd()
returns varchar(10)
as
begin
	declare @id varchar(10), @t_id varchar(10)
	set @id=(select max(t_id) from transactions)
	set @t_id=concat(replicate('0',10-len(cast(@id as int)+1)), cast(@id as int)+1)
	return @t_id
end
select dbo.fMagd()

--
create or alter function pMamoi()
returns varchar(10)
as
begin
	declare @id varchar(10), @idnew varchar(10)
	select @id = max(t_id) from transactions
	select @idnew = concat(replicate('0', 10- len(cast(@id as int)+1)), cast(@id as int)+1)
	return 
end
/*11. Thêm một bản ghi vào bảng TRANSACTIONS nếu biết các thông tin ngày giao dịch, thời gian giao dịch, 
	số tài khoản, loại giao dịch, số tiền giao dịch. Công việc cần làm bao gồm:
a. Kiểm tra ngày và thời gian giao dịch có hợp lệ không. Nếu không, ngừng xử lý
b. Kiểm tra số tài khoản có tồn tại trong bảng ACCOUNT không? Nếu không, ngừng xử lý
c. Kiểm tra loại giao dịch có phù hợp không? Nếu không, ngừng xử lý
d. Kiểm tra số tiền có hợp lệ không (lớn hơn 0)? Nếu không, ngừng xử lý
e. Tính mã giao dịch mới
f. Thêm mới bản ghi vào bảng TRANSACTIONS
g. Cập nhật bảng ACCOUNT bằng cách cộng hoặc trừ số tiền vừa thực hiện giao dịch tùy theo loại giao dịch	*/
--input: ngày, thời gian, số tài khoản, loại, số tiền
--output: 
--SUA
create or alter proc pThemTrans @ngay date,
								@tg time,
								@stk varchar(10),
								@loai char(1),
								@tien money, 
								@ret bit out
as
begin
	--a
	if @ngay is null or @tg is null or @ngay > getdate()
	begin
		set @ret = 0
		return
	end
	--b: để 1 tốc độ thực hiện nhanh nhất
	if not exists (select 1 from account where ac_no = @stk)
	begin
		set @ret = 0
		return
	end
	--c
	if @loai not in ('1','0')
	begin
		set @ret = 0
		return
	end
	--d
	if @tien <= 0
	begin
		set @ret = 0
		return
	end
	--e
	declare @mamoi varchar(10) = dbo.fMagd()
	--f
	begin transaction
		insert into transactions values (@mamoi, @loai, @tien, @ngay, @tg, @stk)
		if @@ROWCOUNT <= 0
		begin
			rollback transaction
			set @ret = 0 
			return
		end
		--g
		update account
		set ac_balance = case @loai when 1 then ac_balance + @tien
									when 0 then ac_balance - @tien end
		if @@ROWCOUNT <= 0
		begin
			rollback transaction
			set @ret = 0 
			return
		end
	commit transaction
	set @ret = 1
end

--test
go
declare @ngay date = '2023-11-13', 
		@tg time = '13:30',
		@stk varchar(10) = '1000000003', --88182020 44770000
		@loai char(1) = '1',
		@tien money = 1 ,
		@ret bit 
exec pThemTrans @ngay, @tg, @stk, @loai, @tien, @ret out
print @ret

select * from account
select * from transactions

--Sai
create or alter proc pGiaodich @ngay date, @time time, @stk varchar(10), @loaigd varchar(2), @tien int
as
begin
	declare @acno varchar(10), @count varchar(10), @magd varchar(10)
	set @acno = (select count(ac_no) from account where ac_no = @stk)
	if @time is not null or @ngay is not null or @ngay <= getdate()
	begin
		if @acno > 0
		begin
			if @loaigd = 1 or @loaigd = 0
			begin
				if @tien > 0
				begin
					set @count = (select (max(cast(t_id as numeric (10,0)))+1) from transactions)
					set @magd = concat(replicate('0',10-len(@count)),@count)
					insert into transactions (t_id, t_type, t_amount, t_date, t_time, ac_no)
					values (@magd, @loaigd, @tien, @ngay, @time, @stk)

					update account
					set ac_balance = case when @loaigd = 1 then ac_balance + @tien
										  else ac_balance - @tien 
									 end
					where ac_no = @stk
					print N'Thêm thành công'
				end
				else
					print N'Số tiền không hợp lệ'
			end
			else print N'Loại gd không hợp lệ'
		end
		else print N'STK không tồn tại'
	end
	else print N'Ngày không hợp lệ'
end

declare @ngay date, @time time, @stk varchar(10), @loaigd varchar(2), @tien int
exec fGiaodich'2023-10-20' ,null ,'1000000001' ,1,8000
select * from transactions
/*12. Thêm mới một tài khoản nếu biết: mã khách hàng, loại tài khoản, số tiền trong tài khoản. Bao gồm những công việc sau:
a. Kiểm tra mã khách hàng đã tồn tại trong bảng CUSTOMER chưa? Nếu chưa, ngừng xử lý
b. Kiểm tra loại tài khoản có hợp lệ không? Nếu không, ngừng xử lý
c. Kiểm tra số tiền có hợp lệ không? Nếu NULL thì để mặc định là 50000, nhỏ hơn 0 thì ngừng xử lý.
d. Tính số tài khoản mới. Số tài khoản mới bằng MAX(các số tài khoản cũ) + 1
e. Thêm mới bản ghi vào bảng ACCOUNT với dữ liệu đã có.	*/
--input: mã khách hàng, loại tài khoản, số tiền
--output: ret
create or alter proc pTk @makh varchar(6), 
						 @loai varchar(1), 
						 @sotien int, 
						 @ret bit output
as
begin
	--a
	if not exists (select 1 from customer where cust_id = @makh)
	begin
		set @ret = 0
		return
	end
	--b
	if @loai not in ('0', '1')
	begin
		set @ret = 0
		return
	end
	--c
	if @sotien < 0
	begin
		set @ret = 0
		return
	end
	else if @sotien is null
	begin
		set @sotien = 50000
	end
	--d
	declare @stk varchar(10), @stkm varchar(10)
	set @stk = (select max(ac_no) from account)
	set @stkm = cast(@stk as int)+1
	--e
	insert into account values (@stkm, @sotien, @loai, @makh)
	if @@rowcount <=0
	begin
		set @ret = 0
		return
	end
	set @ret = 1
end

declare @makh varchar(6) = '000001',
		@loai varchar(1) = '1',
		@sotien int = 1, 
		@ret bit 
exec pTk @makh, @loai, @sotien, @ret output
print @ret
select * from account
--
create or alter proc pTaikhoan(@makh varchar(6), @loai varchar(1), @sotien int)
as
begin
	declare @count int, @stkmax varchar(10), @stkmoi varchar(10)
	set @count = (select count(*) from customer where cust_id = @makh)
	if @count > 0
	begin
		if @loai = 0 or @loai = 1
		begin
			if @sotien is null
			begin
				set @sotien = 50000
				set @stkmax = (select max(ac_no) from account)
				set @stkmoi = right('1000000000' + cast(cast(right(@stkmax, 10) as int) + 1 as varchar), 10)

				insert into account(ac_no, ac_balance, ac_type, cust_id)
				values(@stkmoi, @sotien, @loai, @makh)
			end
			else print N'Số tiền không hợp lệ'
		end
		else print N'Mã giao dịch không hợp lệ'
	end
	else print N'Mã khách hàng chưa tồn tại'
end
declare @makh varchar(6), @loai bit, @sotien varchar(20)
exec pTaikhoan '000001', 2, NULL

select * from account
/*13. Kiểm tra thông tin khách hàng đã tồn tại trong hệ thống hay chưa nếu biết họ tên và số điện thoại. 
	Tồn tại trả về 1, không tồn tại trả về 0	*/
/*14. Tính mã giao dịch mới. Mã giao dịch tiếp theo được tính như sau: MAX(mã giao dịch đang có) + 1. 
	Hãy đảm bảo số lượng kí tự luôn đúng với quy định về mã giao dịch	*/
--15. Tính mã tài khoản mới. (định nghĩa tương tự như câu trên)
create or alter function fMaTK()
returns varchar(10)
as
begin
	declare @mtkmax varchar(10), @mtkmoi varchar(10)
	set @mtkmax = (select max(ac_no) from account)
	set @mtkmoi = right ('1000000000' + cast((cast(right(@mtkmax, 10) as int) + 1)as varchar), 10)
	return @mtkmoi
end

select dbo.fMaTK()
--16. Trả về tên chi nhánh ngân hàng nếu biết mã của nó.
--17. Trả về tên của khách hàng nếu biết mã khách.
create or alter function fTenKH (@id varchar(6))
returns nvarchar(40)
as
begin
	return (select cust_name from customer where cust_id = @id)
end

select dbo.fTenKH('000001')
--18. Trả về số tiền có trong tài khoản nếu biết mã tài khoản.
create or alter function fSotien (@mtk varchar(10))
returns int
as
begin
	return (select ac_balance from account where ac_no = @mtk)
end

select dbo.fSotien('1000000001')
--19. Trả về số lượng khách hàng nếu biết mã chi nhánh.
create or alter function fSlkh (@mcn varchar(5))
returns int
as
begin
	declare @sl int
	set @sl = (select count(*) from customer where br_id = @mcn)
	return @sl
end

select dbo.fSlkh('VT011')
--20. Kiểm tra một giao dịch có bất thường hay không nếu biết mã giao dịch.
--Giao dịch bất thường: giao dịch gửi diễn ra ngoài giờ hành chính, giao dịch rút diễn ra vào thời điểm 0am  3am
create or alter function fktgd(@id varchar(10))
returns nvarchar(30)
as
begin
	declare @time time, @type bit
	set @time = (select t_time from transactions where t_id = @id)
	set @type = (select t_type from transactions where t_id = @id)
	return case when (@type=1 and ((@time between '07:00' and '11:30') or (@time between '13:30' and '17:00'))) or
						 (@type=0 and (@time not between '00:00' and '03:00')) then N'Bình thường'
				else N'Bất thường' end
end

select dbo.fktgd('0000000203')
select*from transactions
--21.	Sinh mã khách hàng tự động. Module này có chức năng tạo và trả về mã khách hàng mới bằng cách lấy MAX(mã khách hàng cũ) + 1.
--22