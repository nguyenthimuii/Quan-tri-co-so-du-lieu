--9. Liệt kê những khách hàng không thuộc các chi nhánh miền bắc
select br_id, cust_name, cust_ad
from customer
where br_id not like 'VB%'

select br_id, cust_name, cust_ad
from customer
except
select br_id, cust_name, cust_ad
from customer
where br_id like 'VB%'

select br_id, cust_name, cust_ad
from customer
where br_id not in
					(select br_id
					from customer
					where br_id like 'VB%')
--10. Liệt kê những tài khoản nhiều hơn 100 triệu trong tài khoản
select ac_no, ac_balance
from account
where ac_balance > 100000000
--11. Liệt kê những giao dịch gửi tiền diễn ra ngoài giờ hành chính
select t_id, t_type, t_amount, t_time
from transactions
where t_type=0 and (t_time not between '7:00' and '11:30') and (t_time not between '13:00' and '17:00')

select t_id,t_time, t_type
from transactions
except
select t_id, t_time, t_type
from transactions
where ((t_time between '7:00' and '11:30') or (t_time between '13:00' and '17:00') or t_type=1)

select t_id,t_time
from transactions
where t_type=0 and (DATEPART(HOUR, t_time) < 8 OR DATEPART(HOUR, t_time) >= 17);


select t_id, t_time
from transactions
where t_time not between DATEPART(HOUR, t_time) >= 8 and DATEPART(HOUR, t_time) = 17 and t_type = 0

--12. Liệt kê những giao dịch rút tiền diễn ra vào khoảng từ 0-3h sáng
select t_id,t_time
from transactions
where t_type=1 and t_time between '0:00' and '3:00' 
--13. Tìm những khách hàng có địa chỉ ở Ngũ Hành Sơn – Đà nẵng
select cust_id, cust_name, cust_ad
from customer
where cust_ad like N'%Ngũ Hành Sơn Đà Nẵng'
--14. Liệt kê những chi nhánh chưa có địa chỉ
select BR_name, BR_ad
from branch
where BR_ad like N''
--15. Liệt kê những giao dịch rút tiền bất thường (nhỏ hơn 50.000)
select t_id,t_amount
from transactions
where t_type=1 and t_amount < 500000
--16. Liệt kê các giao dịch gửi tiền diễn ra trong năm 2017.
select t_id,t_amount,t_date
from transactions
where t_type=0 and year(t_date)= 2017
--17. Liệt kê những giao dịch bất thường (tiền trong tài khoản âm)
select t_id, ac.ac_no, t_amount
from account ac, transactions t
where ac.ac_no=t.ac_no and ac_balance < 0
--18. Hiển thị tên khách hàng và tên tỉnh/thành phố mà họ sống
select cust_name,(right(cust_ad,charindex(',',reverse(cust_ad))-2))
from customer
where charindex(',',reverse(cust_ad))>0
--19. Hiển thị danh sách khách hàng có họ tên không bắt đầu bằng chữ N, T
select cust_id, cust_name
from customer
where cust_name not like N'[N, T]%'
--20. Hiển thị danh sách khách hàng có kí tự thứ 3 từ cuối lên là chữ a, u, i
select cust_id, cust_name
from customer
where cust_name like N'%[a, á, à, ả, ã, ạ, u, ú, ủ, ù, ũ, ụ, i, í, ỉ, ì, ị, ĩ]__'
--21. Hiển thị khách hàng có tên đệm là Thị hoặc Văn
select cust_id, cust_name
from customer
where (cust_name like N'%Thị%' or cust_name like N'%Văn%') and cust_name not like N'%Văn'
--22. Hiển thị khách hàng có địa chỉ sống ở vùng nông thôn. Với quy ước: nông thôn là vùng mà địa chỉ chứa: thôn, xã, xóm
select cust_id, cust_name, cust_ad
from customer
where (cust_ad like N'%thôn%' or cust_ad like N'%xã%' or cust_ad like N'%xóm%') and cust_ad not like N'%thị xã%'
--23. Hiển thị danh sách khách hàng có kí tự thứ hai của TÊN là chữ u hoặc ũ hoặc a. Chú ý: TÊN là từ cuối cùng của cột cust_name
select cust_id, cust_name, (right(cust_name,charindex(' ',reverse(cust_name))-1))
from customer
where right(cust_name,charindex(' ',reverse(cust_name))-1) LIKE N'_[u,ũ,a,á,à,ã,ả,ạ]%'

select cust_id, cust_name, branch.br_id
from customer join branch on customer .br_id=branch.br_id
where branch.br_id=(select branch.br_id from customer join branch on customer .br_id=branch.br_id
					where cust_name=N'phạm duy khánh')
and cust_name<>N'phạm duy khánh'