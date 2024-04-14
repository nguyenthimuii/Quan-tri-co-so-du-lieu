/* 1. Khi thêm mới dữ liệu trong bảng transactions hãy thực hiện các công việc sau:
	a. Kiểm tra trạng thái tài khoản của giao dịch hiện hành. Nếu trạng thái tài khoản ac_type = 9 
	   thì đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy thao tác đã thực hiện. Ngược lại:  
		i.	Nếu là giao dịch gửi: số dư = số dư + tiền gửi. 
		ii.	Nếu là giao dịch rút: số dư = số dư – tiền rút. Nếu số dư sau khi thực hiện giao dịch < 50.000 
			thì đưa ra thông báo ‘không đủ tiền’ và hủy thao tác đã thực hiện.	*/
create or alter trigger fthem
on transactions
for insert
as
begin
	declare @ac_type int, @t_type bit, @t_amount int, @ac_balance int

	select @ac_type = ac_type from account where ac_no in (select ac_no from inserted)
	select @ac_balance = ac_balance from account where ac_no in (select ac_no from inserted)
	select @t_type = t_type from inserted
	select @t_amount = t_amount from inserted

	if @ac_type = 9
	begin
		print N'tài khoản đã bị xóa'
		rollback
	end
	else
	begin
		if @t_type = 1
		begin
			update account
			set ac_balance = ac_balance + @t_amount
			where ac_no in (select ac_no from inserted)
		end
		else
		begin
			if @ac_balance - @t_amount < 50000
			begin
				print N'Không đủ tiền'
				rollback
			end
			else
			begin
				update account
				set ac_balance = ac_balance - @t_amount
				where ac_no in (select ac_no from inserted)
			end
		end
	end
end

insert into transactions values ('1012', 0, 3,'2023-10-03', '00:00', '1000000001') --ac_type = 9
insert into transactions values ('10001', 1, 2, '2023-11-10', '17:00', '1000000002') --gửi
insert into transactions values ('100001', 0, 2, '2023-11-10', '17:15', '1000000002')  --rút
insert into transactions values ('10003', 0, 44720001, '2023-11-10', '17:00', '1000000003') --kh đủ tiền 44770000
select * from account
select * from transactions

alter table transactions
disable trigger fthem
/* 2. Sau khi xóa dữ liệu trong transactions hãy tính lại số dư:
	a. Nếu là giao dịch rút: Số dư = số dư cũ + t_amount
	b. Nếu là giao dịch gửi: Số dư = số dư cũ – t_amount	*/
go
create or alter trigger fXoac2
on transactions
after delete
as
begin
	declare @ac_balance int, @t_type bit, @t_amount int
	select @ac_balance = ac_balance from account where ac_no in (select ac_no from deleted)
	select @t_type = t_type from deleted
	select @t_amount = t_amount from deleted

	if @t_type = 0
	begin
		update account
		set ac_balance = @ac_balance + @t_amount
		where ac_no in (select ac_no from deleted)
	end
	else
	begin
		update account
		set ac_balance = @ac_balance - @t_amount
		where ac_no in (select ac_no from deleted)
	end
end

delete transactions where t_id='10002'
select * from transactions
select * from account

alter table transactions
disable trigger fXoac2
-- 3. Khi cập nhật hoặc sửa dữ liệu tên khách hàng, hãy đảm bảo tên khách không nhỏ hơn 5 kí tự.
go
create or alter trigger fCapnhatc3
on customer
for update
as
begin
	declare @name varchar(50)
	select @name = cust_name from inserted

	if len(@name) < 5
	begin
		print N'Tên khách hàng không hợp lệ'
		rollback
	end
end

update customer 
set cust_name = N'Lực'
where cust_id = '000001'
select * from customer

alter table customer
disable trigger fCapnhatc3
/* 4. Khi xóa dữ liệu trong bảng account, hãy thực hiện thao tác cập nhật trạng thái tài khoản là 9 
	(không dùng nữa) thay vì xóa.	*/
go
create or alter trigger fAcc4
on account
instead of delete
as
begin
	update account
	set ac_type = 9
	where ac_no in (select ac_no from deleted)
end

delete account where ac_no = '1000000001'
select * from account

alter table account
disable trigger fAcc4
/* 5. Khi thêm mới dữ liệu trong bảng transactions hãy thực hiện các công việc sau:
	a.	Kiểm tra trạng thái tài khoản của giao dịch hiện hành. Nếu trạng thái tài khoản ac_type = 9 
		thì đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy thao tác đã thực hiện. Ngược lại:  
		i.	Nếu là giao dịch gửi: số dư = số dư + tiền gửi. 
		ii.	Nếu là giao dịch rút: số dư = số dư – tiền rút. Nếu số dư sau khi thực hiện giao 
			dịch < 50.000 thì đưa ra thông báo ‘không đủ tiền’ và hủy thao tác đã thực hiện.	*/
go
create or alter trigger fThemdl
on transactions
for insert
as
begin
	declare @ac_type int, @t_amount int, @ac_balance int, @t_type bit
	select @ac_type = ac_type from account ac join inserted i on ac.ac_no = i.ac_no
	select @ac_balance = ac_balance from account ac join inserted i on ac.ac_no = i.ac_no
	select @t_type = t_type from inserted
	select @t_amount = t_amount from inserted

	if @ac_type = 9
	begin
		print N'Tài khoản đã bị xóa'
		rollback
	end
	else
	begin
		if @t_type = 1
		begin
			update account
			set ac_balance = ac_balance + @t_amount
			where ac_no in (select ac_no from inserted)
		end
		else
		begin
			update account
			set ac_balance = ac_balance - @t_amount
			where ac_no in (select ac_no from inserted)

			if @ac_balance - @t_amount < 50000
			begin
				print N'Không đủ tiền'
				rollback
			end
		end
	end
end

insert into transactions values ('10002', 0, 2, '2023-11-10', '17:00', '1000000002')
select * from account
select * from transactions
-- 6. Khi sửa dữ liệu trong bảng transactions hãy tính lại số dư: Số dư = số dư cũ + (t_amount mới – t_amount cũ)
go
create or alter trigger fSuaTrc6
on transactions
for update
as
begin
	declare @t_amount int, @t_amountc int
	select @t_amount = t_amount from inserted
	select @t_amountc = t_amount from deleted

	update account
	set ac_balance = ac_balance + (@t_amount - @t_amountc)
	where ac_no in (select ac_no from inserted)
end

update transactions
set t_amount = '2000000' 
where t_id = '0000000201'
select * from transactions
select * from account	227374002 cũ	1752000 t cũ  227622002 = 227374002+(2000000-1752000)

alter table transactions
enable trigger fSuaTrc6
/*7. Sau khi xóa dữ liệu trong transactions hãy tính lại số dư:
	a. Nếu là giao dịch rút: Số dư = số dư cũ + t_amount
	b. Nếu là giao dịch gửi: Số dư = số dư cũ – t_amount	*/
go
create or alter trigger fXoaTrc7
on transactions
after delete
as
begin
	declare @ac_balance int, @t_type bit, @t_amount int
	select @ac_balance = ac_balance from account where ac_no in (select ac_no from deleted)
	select @t_type = t_type from deleted
	select @t_amount = t_amount from deleted

	if @t_type = 0
	begin
		update account
		set ac_balance = @ac_balance + @t_amount
		where ac_no in (select ac_no from deleted)
	end
	else
	begin 
		update account
		set ac_balance = @ac_balance - @t_amount
		where ac_no in (select ac_no from deleted)
	end
end
-- 8. Khi cập nhật hoặc sửa dữ liệu tên khách hàng, hãy đảm bảo tên khách không nhỏ hơn 5 kí tự. 
create or alter trigger fcn
on customer
for update
as 
begin
	declare @ten nvarchar(50) 
	select @ten = cust_name from inserted
	if len(@ten) <5
	begin
		print N'Tên khách hàng không hợp lệ'
		rollback
	end
end

update customer
set cust_name = N'lực'
where cust_id = '000001'
select * from customer
/* 9. Khi tác động đến bảng account (thêm, sửa, xóa), hãy kiểm tra loại tài khoản. Nếu ac_type = 9 
	(đã bị xóa) thì đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy các thao tác vừa thực hiện.	*/
go
create or alter trigger fTacdongc9
on account
for insert, update, delete
as
begin
	if (select ac_type from inserted) = 9
	begin
		print N'Tài khoản đã bị xóa'
		rollback
	end
	else if (select ac_type from deleted) = 9
	begin
		print N'Tài khoản đã bị xóaa'
		rollback
	end
	else
	begin
		print N'Tài khoản vẫn tồn tại'
	end
end
--ttnt t10 cbi cv cuối t12 triển khai tt
--ttnn t3 và t10, t3 năm sau cbi cv
select * from account
insert into account values('100000015', 1, 9, '000001')
update account
set ac_balance = 1
where ac_no = '1000000001'
delete account where ac_no = '1000000001'

alter table account
disable trigger fTacdongc9
/* 10. Khi thêm mới dữ liệu vào bảng customer, kiểm tra nếu họ tên và số điện thoại đã tồn tại 
	trong bảng thì đưa ra thông báo ‘đã tồn tại khách hàng’ và hủy toàn bộ thao tác.	*/
go
create or alter trigger fTontaic10
on customer
for insert
as
begin
	if exists (select 1 from customer c join inserted ins on c.cust_name = ins.Cust_name and c.cust_phone = ins.Cust_phone)
	begin
		print N'đã tồn tại khách hàng'
		rollback
	end
end

insert into customer values('00039', N'Thị', '0377393568', N'72 Ngũ Hành Sơn', 'VN013')
select * from customer
select * from Branch

create or alter trigger fcau10
on customer
for insert
as
begin
	declare @name nvarchar(30), @sdt varchar(11)
	set @name = (select cust_name from inserted)
	set @sdt = (select cust_phone from inserted)

	if (select count(*) from customer where cust_name = @name and cust_phone = @sdt) > 1
	begin
		print N'Đã tồn tại'
		rollback
	end
end

insert into customer values('00040', N'Nguyễn Thị Mùi', '0377393568', N'72 Ngũ Hành Sơn', 'VN013')
select * from customer
alter table customer
disable trigger cau10
/* 11. Khi thêm mới dữ liệu vào bảng account, hãy kiểm tra mã khách hàng. Nếu mã khách hàng chưa 
	tồn tại trong bảng customer thì đưa ra thông báo ‘khách hàng chưa tồn tại, hãy tạo mới khách hàng trước’ 
	và hủy toàn bộ thao tác.	*/
	go
create or alter trigger fcau11
on account
for insert
as
begin
	declare @makh varchar(6) = (select cust_id from inserted)
	if (select count(*) from customer where cust_id = @makh) < 1
	begin
		print N'khách hàng chưa tồn tại, hãy tạo mới khách hàng trước'
	end
end

insert into account values('1000000063', 12345678, 1, '000015')
insert into account values('1000000064', 12345678, 1, '000092')

create or alter trigger fThemAcc11
on account
instead of insert
as
begin
	declare @makh varchar(6) = (select cust_id from inserted)
	if (select count(*) from customer where cust_id = @makh) <= 0
	begin
		print N'Khách hàng chưa tồn tại, hãy tạo mới khách hàng trước'
		rollback
	end
	else
	begin
		declare @stk nvarchar(10) = (select ac_no from inserted)
		declare @tien numeric(15,0) = (select ac_balance from inserted)
		declare @loai char(1) = (select ac_type from inserted)
		insert into account values (@stk, @tien, @loai, @makh)
		if @@rowcount > 0
		begin
			print N'Thêm mới thành công'
		end
	end
end

insert into account values('1000000062', 12345678, 1, '000015')
select * from account
select * from customer

alter table account
DISable trigger fThemAcc11
/* 12. Khi tác động đến bảng account (thêm, sửa, xóa), hãy kiểm tra loại tài khoản. Nếu ac_type = 9 
	(đã bị xóa) thì đưa ra thông báo ‘tài khoản đã bị xóa’ và hủy các thao tác vừa thực hiện.	*/
/* 13. Khi thêm mới dữ liệu vào bảng customer, kiểm tra nếu họ tên và số điện thoại đã tồn tại trong bảng
	thì đưa ra thông báo ‘đã tồn tại khách hàng’ và hủy toàn bộ thao tác.	*/
/* 14. Khi thêm mới dữ liệu vào bảng account, hãy kiểm tra mã khách hàng. Nếu mã khách hàng chưa tồn tại trong 
	bảng customer thì đưa ra thông báo ‘khách hàng chưa tồn tại, hãy tạo mới khách hàng trước’ và hủy toàn bộ thao tác.	*/

