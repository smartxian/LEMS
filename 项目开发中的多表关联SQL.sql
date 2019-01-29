# <!-- 项目开发中的多表关联SQL -->
# <!-- 缩进表示不常用SQL -->
#
# <!-- 设备相关SQL -->
#
# 	<!-- s_equipment s_equ_purchase 关联查询  -->
	select eid, id, ename, type, addtime, status, remark, equipment.pcid,uid,pctime,price
	from s_equipment equipment join s_equ_purchase purchase on(equipment.pcid=purchase.pcid)
	where eid = 'd16bbc38a9a94f6a8ca1f82797463cfa';

# 	<!-- s_equ_purchase s_equipment 关联查询  -->
	select purchase.pcid,uid,pctime,price,eid,id, ename, type, addtime, status, remark
	from s_equipment equipment join s_equ_purchase purchase on(equipment.pcid=purchase.pcid)
	where purchase.pcid = '79e142a75ba3492ca528c390863f3b93';

# <!-- 权限相关SQL -->

# 	<!-- user user_role 关联查询  -->
	select user.uid, uname, ture_name, passwd, salt, office_address, office_phone, email, masterid, createtime,token, rid
	from s_user user join user_role urole on(user.uid=urole.uid)
	where user.uid = '16e3a3765d2a40b4917eb2cce7d372d4';

# <!-- user user_role role 关联查询 -->
SELECT uname, ture_name, office_address, office_phone, email, masterid, createtime,rname, remark
from s_user user join user_role urole on(user.uid=urole.uid) join s_role role on(urole.rid=role.rid) 
where user.uid = '16e3a3765d2a40b4917eb2cce7d372d4';

# 	<!-- user_role role 关联查询  -->
	select uid, urole.rid, rname, remark
	from user_role urole join s_role role on(urole.rid=role.rid)
	where urole.rid = '405230015';

# 	<!-- user_role user 关联查询  -->
	select urole.uid, rid, uname, ture_name, passwd, salt, office_address, office_phone, email, masterid, createtime,token
	from user_role urole join s_user user on(urole.uid=user.uid)
	where urole.rid = '405230015';

# 	<!-- role user_role 关联查询  -->
	select role.rid, rname, remark,uid
	from s_role role join user_role urole on(role.rid=urole.rid)
	where role.rid = '405230015';

# <! -- role user_role user 关联查询 -->
select rname, remark,uname, ture_name, office_address, office_phone, email, masterid, createtime
from s_role role join user_role urole on(urole.rid=role.rid) join s_user user on (user.uid=urole.uid)
where role.rid = '405230015';

# <!-- 用户列表 -->
select user.uid,uname, ture_name, office_address, office_phone, email, masterid, createtime,status,rname, remark 
from s_user user left join user_role urole on(user.uid=urole.uid) left join s_role role on(urole.rid=role.rid) 
where user.status='0' AND user.ture_name LIKE '%a%';

# <!-- 用户列表 分页 -->
select user.uid,uname, ture_name, office_address, office_phone, email, masterid, createtime,status,rname, remark 
from s_user user left join user_role urole on(user.uid=urole.uid) left join s_role role on(urole.rid=role.rid) 
where user.status='0' AND user.ture_name LIKE '%a%' LIMIT 0,5;

select user.uid,uname, ture_name, office_address, office_phone, email, masterid, createtime,status,rname, remark
from s_user user left join user_role urole on(user.uid=urole.uid) left join s_role role on(urole.rid=role.rid)
where user.status='0' AND user.ture_name ORDER BY rname LIKE '%a%' LIMIT 0,5;

# <!-- 大查询功能 -->

select lab.id , lab.lname , lab.lsize , lab.equcount , lab.status , lab.type,epurc.price,equ.id , equ.ename , equ.type , equ.status ,equ.type ,user.uname 
from s_laboratory lab join equ_lab elab on(lab.lid=elab.lid) 
join s_equipment equ on(elab.eid=equ.eid)  
join s_equ_purchase epurc on(equ.pcid=epurc.pcid) 
join s_user user on(epurc.uid=user.uid)
where lab.lid = '0b1533555c0748b4a8e985f7b9e52897' order by epurc.price asc LIMIT 0,5;

select lab.lid, lab.id, lab.lname, lab.lsize, lab.status, lab.type, lab.equcount,user.uname
from s_laboratory lab join s_user user on(lab.uid=user.uid)
where lab.lid = '0b1533555c0748b4a8e985f7b9e52897';

# <!--实验室查询功能主SQL-->
select lab.lid,lab.id , lab.lname , lab.lsize , lab.equcount , lab.status , lab.type , lab.remark , 
epurc.price , elab.lid el_lid , elab.eid el_eid ,
equ.id e_id , equ.ename , equ.type e_type , equ.status e_status , equ.remark e_remark ,
epurc.uid ep_uid , user.uid u_uid , 
user.uname u_uname 
from s_laboratory lab left join equ_lab elab on(lab.lid=elab.lid) 
left join s_equipment equ on(elab.eid=equ.eid)  
left join s_equ_purchase epurc on(equ.pcid=epurc.pcid)
left join s_user user on(epurc.uid=user.uid) 
where lab.status !='1' AND lab.lname LIKE '%6%' ORDER BY lab.lname asc LIMIT 0,2;
# <!--实验室查询功能从SQL-->
select COUNT(*)
from s_laboratory lab left join equ_lab elab on(lab.lid=elab.lid) 
left join s_equipment equ on(elab.eid=equ.eid)  
left join s_equ_purchase epurc on(equ.pcid=epurc.pcid)
left join s_user user on(epurc.uid=user.uid) 
where lab.status !='1' AND lab.lname LIKE '%6%';
# <!--MyBatis-->
select lab.lid,lab.id , lab.lname , lab.lsize , lab.equcount , lab.status , lab.type , lab.remark , 
epurc.price ,  elab.lid el_lid , elab.eid el_eid ,  
equ.id e_id , equ.ename , equ.type e_type , equ.status e_status , equ.remark e_remark , 
epurc.uid ep_uid , 
user.uid u_uid , user.uname u_uname 
from s_laboratory lab left join equ_lab elab on(lab.lid=elab.lid) 
left join s_equipment equ on(elab.eid=equ.eid)  
left join s_equ_purchase epurc on(equ.pcid=epurc.pcid) 
left join s_user user on(epurc.uid=user.uid) 
where lab.status !='1' AND lab.lname LIKE concat(concat('%',?),'%')
ORDER BY lab.lname asc  LIMIT ?,?;

# <!-- 实验室设备级联查询 -->
select a.* from( 
    select lab.lid, lab.id, lab.lname, lab.lsize, lab.equcount, lab.status, lab.type, lab.remark, epurc.price, 
    equ.eid,equ.id e_id, equ.ename, equ.type e_type, equ.status e_status, equ.remark e_remark, user.uname u_uname 
    from s_laboratory lab 
    LEFT JOIN equ_lab elab on(lab.lid=elab.lid) 
    LEFT JOIN s_equipment equ on(elab.eid=equ.eid) 
    left join s_equ_purchase epurc on(equ.pcid=epurc.pcid) 
    left join s_user user on(epurc.uid=user.uid) 
    where lab.status !='1' 
    UNION 
    select lab.lid, lab.id, lab.lname, lab.lsize, lab.equcount, lab.status, lab.type, lab.remark, epurc.price, 
    equ.eid,equ.id e_id, equ.ename, equ.type e_type, equ.status e_status, equ.remark e_remark, user.uname u_uname 
    from s_equipment equ 
    LEFT JOIN equ_lab elab on (elab.eid=equ.eid) 
    LEFT JOIN s_laboratory lab on (lab.lid=elab.lid) 
    left join s_equ_purchase epurc on(equ.pcid=epurc.pcid) 
    left join s_user user on(epurc.uid=user.uid) 
    where equ.status !='1' 
) a 
WHERE 
a.id LIKE concat(concat('%',''),'%') 
AND a.lname LIKE concat(concat('%',''),'%') 
AND a.type LIKE concat(concat('%',''),'%') 
AND a.e_id LIKE concat(concat('%',''),'%') 
AND a.ename LIKE concat(concat('%',''),'%') 
AND a.e_type LIKE concat(concat('%',''),'%') 
ORDER BY a.lname asc 
LIMIT ?,?