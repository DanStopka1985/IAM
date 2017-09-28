-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_ref1_get_source_lpu_list(
 IN reg_dt1 character varying DEFAULT ''::character varying, 
 IN reg_dt2 character varying DEFAULT ''::character varying,
 IN ref_dt1 character varying DEFAULT ''::character varying, 
 IN ref_dt2 character varying DEFAULT ''::character varying,
 IN src_spec character varying DEFAULT ''::character varying,
 IN trg_spec character varying DEFAULT ''::character varying,
 IN ref_type character varying DEFAULT ''::character varying, 
 IN src_lpu character varying DEFAULT ''::character varying,
 IN trg_lpu character varying DEFAULT ''::character varying,
 IN src_pos character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select reg_dt1, reg_dt2, ref_dt1, ref_dt2, src_spec, trg_spec, ref_type, src_lpu, trg_lpu, src_pos, district),
filter as (
 select distinct rsc.code
 from referral r
 join referral_info ri on ri.id = r.referral_info_id
 join referral_source rs on r.source_id = rs.id
 join referral_source_doctors rsd on rsd._id = rs.id
 join doctor sd on sd.id = rsd.doctors_id
 join referral_target rt on r.target_id = rt.id
 join referral_target_doctors rtd on rtd._id = rt.id

 join coding rsc on rsc.id = rs.lpu_id

),

t as (
 select distinct on (l.id) l.id, l.name, l.district_name, 1 ord from ext.lpu l where l.id in (select code from filter) union all
 select '', 'Не выбрано', '', 0
)

select t.id, t.name from t order by ord, name
;
 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;


-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_ref1_get_target_lpu_list(
 IN reg_dt1 character varying DEFAULT ''::character varying, 
 IN reg_dt2 character varying DEFAULT ''::character varying,
 IN ref_dt1 character varying DEFAULT ''::character varying, 
 IN ref_dt2 character varying DEFAULT ''::character varying,
 IN src_spec character varying DEFAULT ''::character varying,
 IN trg_spec character varying DEFAULT ''::character varying,
 IN ref_type character varying DEFAULT ''::character varying, 
 IN src_lpu character varying DEFAULT ''::character varying,
 IN trg_lpu character varying DEFAULT ''::character varying,
 IN src_pos character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select reg_dt1, reg_dt2, ref_dt1, ref_dt2, src_spec, trg_spec, ref_type, src_lpu, trg_lpu, src_pos, district),
filter as (
 select distinct rsc.code
 from referral r
 join referral_info ri on ri.id = r.referral_info_id
 join referral_source rs on r.source_id = rs.id
 join referral_source_doctors rsd on rsd._id = rs.id
 join doctor sd on sd.id = rsd.doctors_id
 join referral_target rt on r.target_id = rt.id
 join referral_target_doctors rtd on rtd._id = rt.id

 join coding rsc on rsc.id = rt.lpu_id

),

t as (
 select distinct on (l.id) l.id, l.name, l.district_name, 1 ord from ext.lpu l where l.id in (select code from filter) union all
 select '', 'Не выбрано', '', 0
)

select t.id, t.name from t order by ord, name
;
 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;


-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_ref1_get_district_list(
 IN reg_dt1 character varying DEFAULT ''::character varying, 
 IN reg_dt2 character varying DEFAULT ''::character varying,
 IN ref_dt1 character varying DEFAULT ''::character varying, 
 IN ref_dt2 character varying DEFAULT ''::character varying,
 IN src_spec character varying DEFAULT ''::character varying,
 IN trg_spec character varying DEFAULT ''::character varying,
 IN ref_type character varying DEFAULT ''::character varying, 
 IN src_lpu character varying DEFAULT ''::character varying,
 IN trg_lpu character varying DEFAULT ''::character varying,
 IN src_pos character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select reg_dt1, reg_dt2, ref_dt1, ref_dt2, src_spec, trg_spec, ref_type, src_lpu, trg_lpu, src_pos, district),
filter as (
 select distinct rsc.code
 from referral r
 join referral_info ri on ri.id = r.referral_info_id
 join referral_source rs on r.source_id = rs.id
 join referral_source_doctors rsd on rsd._id = rs.id
 join doctor sd on sd.id = rsd.doctors_id
 join referral_target rt on r.target_id = rt.id
 join referral_target_doctors rtd on rtd._id = rt.id
 join coding rsc on rsc.id = rt.lpu_id
),

t as (
 select distinct on (l.district_name) l.district_name id, l.district_name as name, 1 ord from ext.lpu l where l.id in (select code from filter) union all
 select '', 'Не выбрано', 0
)

select t.id, t.name from t order by ord, name
;
 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;

--------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION ext.report_ref1_get_source_speciality_list(
 IN reg_dt1 character varying DEFAULT ''::character varying, 
 IN reg_dt2 character varying DEFAULT ''::character varying,
 IN ref_dt1 character varying DEFAULT ''::character varying, 
 IN ref_dt2 character varying DEFAULT ''::character varying,
 IN src_spec character varying DEFAULT ''::character varying,
 IN trg_spec character varying DEFAULT ''::character varying,
 IN ref_type character varying DEFAULT ''::character varying, 
 IN src_lpu character varying DEFAULT ''::character varying,
 IN trg_lpu character varying DEFAULT ''::character varying,
 IN src_pos character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select reg_dt1, reg_dt2, ref_dt1, ref_dt2, src_spec, trg_spec, ref_type, src_lpu, trg_lpu, src_pos, district),
filter as (
 select distinct c.code
 from referral r
 join referral_source rs on r.source_id = rs.id
 join referral_source_doctors rsd on rsd._id = rs.id
 join doctor sd on sd.id = rsd.doctors_id
 join coding c on c.id = sd.speciality_id
 join referral_target rt on r.target_id = rt.id
 join referral_target_doctors rtd on rtd._id = rt.id
),

t as (
 select distinct on (s.id) s.id, s.name as name, 1 ord from ext.speciality s where s.id in (select code from filter) union all
 select '', 'Не выбрано', 0
)

select t.id, t.name from t order by t.ord, t.name
;
 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;


--------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_ref1_get_target_speciality_list(
 IN reg_dt1 character varying DEFAULT ''::character varying, 
 IN reg_dt2 character varying DEFAULT ''::character varying,
 IN ref_dt1 character varying DEFAULT ''::character varying, 
 IN ref_dt2 character varying DEFAULT ''::character varying,
 IN src_spec character varying DEFAULT ''::character varying,
 IN trg_spec character varying DEFAULT ''::character varying,
 IN ref_type character varying DEFAULT ''::character varying, 
 IN src_lpu character varying DEFAULT ''::character varying,
 IN trg_lpu character varying DEFAULT ''::character varying,
 IN src_pos character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select reg_dt1, reg_dt2, ref_dt1, ref_dt2, src_spec, trg_spec, ref_type, src_lpu, trg_lpu, src_pos, district),
filter as (
 select distinct c.code
 from referral r
 join referral_source rs on r.source_id = rs.id
 join referral_source_doctors rsd on rsd._id = rs.id
 join doctor sd on sd.id = rsd.doctors_id

 join referral_target rt on r.target_id = rt.id
 join referral_target_doctors rtd on rtd._id = rt.id
 join doctor td on td.id = rtd.doctors_id
 join coding c on c.id = td.speciality_id
),

t as (
 select distinct on (s.id) s.id, s.name as name, 1 ord from ext.speciality s where s.id in (select code from filter) union all
 select '', 'Не выбрано', 0
)

select t.id, t.name from t order by t.ord, t.name
;
 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;

------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_ref1_get_referral_type_list(
 IN reg_dt1 character varying DEFAULT ''::character varying, 
 IN reg_dt2 character varying DEFAULT ''::character varying,
 IN ref_dt1 character varying DEFAULT ''::character varying, 
 IN ref_dt2 character varying DEFAULT ''::character varying,
 IN src_spec character varying DEFAULT ''::character varying,
 IN trg_spec character varying DEFAULT ''::character varying,
 IN ref_type character varying DEFAULT ''::character varying, 
 IN src_lpu character varying DEFAULT ''::character varying,
 IN trg_lpu character varying DEFAULT ''::character varying,
 IN src_pos character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select reg_dt1, reg_dt2, ref_dt1, ref_dt2, src_spec, trg_spec, ref_type, src_lpu, trg_lpu, src_pos, district),
 
filter as (
 select distinct crt.code
 from referral r
 join referral_info ri on ri.id = r.referral_info_id
 join coding crt on crt.id = ri.referral_type_id
 join referral_source rs on r.source_id = rs.id
 join referral_source_doctors rsd on rsd._id = rs.id
 join doctor sd on sd.id = rsd.doctors_id
 join referral_target rt on r.target_id = rt.id
 join referral_target_doctors rtd on rtd._id = rt.id
),

t as (
 select distinct on (rt.id) rt.id, rt.name, 1 ord from ext.referral_type rt where rt.id in (select code from filter) union all
 select '', 'Не выбрано', 0
)

select t.id, t.name from t order by ord, name
;
 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;


------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_ref1_get_source_position_list(
 IN reg_dt1 character varying DEFAULT ''::character varying, 
 IN reg_dt2 character varying DEFAULT ''::character varying,
 IN ref_dt1 character varying DEFAULT ''::character varying, 
 IN ref_dt2 character varying DEFAULT ''::character varying,
 IN src_spec character varying DEFAULT ''::character varying,
 IN trg_spec character varying DEFAULT ''::character varying,
 IN ref_type character varying DEFAULT ''::character varying, 
 IN src_lpu character varying DEFAULT ''::character varying,
 IN trg_lpu character varying DEFAULT ''::character varying,
 IN src_pos character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select reg_dt1, reg_dt2, ref_dt1, ref_dt2, src_spec, trg_spec, ref_type, src_lpu, trg_lpu, src_pos, district),

filter as (
 select distinct scp.code
 from referral r
 join referral_source rs on r.source_id = rs.id
 join referral_source_doctors rsd on rsd._id = rs.id
 join doctor sd on sd.id = rsd.doctors_id
 join coding scp on scp.id = sd.position_id 
 join referral_target rt on r.target_id = rt.id
 join referral_target_doctors rtd on rtd._id = rt.id
),

t as (
 select distinct on(p.id) p.id, p.name, 1 ord from ext.position p where p.id in (select code from filter) union all
 select '', 'Не выбрано', 0
)

select t.id, t.name from t order by ord, name
;
 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;  


------------------------------------------------------------------------------------------------------------
/*
with prm(reg_dt1, reg_dt2, src_spec, src_pos, ref_type, src_lpu, ref_dt1, ref_dt2, trg_spec, trg_lpu, district) as (select ''::character varying,''::character varying,''::character varying,''::character varying,
''::character varying,''::character varying,''::character varying,''::character varying,''::character varying,''::character varying,''::character varying)

select 
 to_char(ri.date, 'dd.mm.yyyy') dt, --дата рег напр
 to_char(ri.date, 'yyyymmdd') dt_ord,
 ss.name source_spec_name, --спец напр
						ss.id source_spec_id,
 sp.name source_pos_name, --должн напр
						sp.id source_pos_id,
 rtype.name referral_type, --тип напр
						rtype.id referral_type_id,
 lpu.name source_lpu_name, --напр лпу
						lpu.id source_lpu_id,
 to_char(rt.reception_appoint_date, 'dd.mm.yyyy') reception_appoint_date, --дата напр
 to_char(rt.reception_appoint_date, 'yyyymmdd') reception_appoint_date_ord,
 ts.name target_spec_name, --спец прин
						ts.id target_spec_id,
 tar_lpu.name target_lpu_name, --прин МО
						tar_lpu.id target_mo_id,
 tar_lpu.district_name target_district_name --район прин
 
from referral r
cross join prm
join referral_info ri on ri.id = r.referral_info_id
join referral_source rs on r.source_id = rs.id
join referral_source_doctors rsd on rsd._id = rs.id
join doctor sd on sd.id = rsd.doctors_id
join coding rsc on rsc.id = rs.lpu_id
join ext.lpu lpu on lpu.id = rsc.code
join coding scs on scs.id = sd.speciality_id
join ext.speciality ss on ss.id = scs.code
join coding scp on scp.id = sd.position_id
join ext.position sp on sp.id = scp.code
join coding crt on crt.id = ri.referral_type_id
join ext.referral_type rtype on rtype.id = crt.code

join referral_target rt on r.target_id = rt.id
left join referral_target_doctors rtd on rtd._id = rt.id
left join doctor td on td.id = rtd.doctors_id
join coding rtc on rtc.id = rt.lpu_id
join ext.lpu tar_lpu on tar_lpu.id = rtc.code

join coding tcs on tcs.id = td.speciality_id
join ext.speciality ts on ts.id = tcs.code

where
  (prm.reg_dt1 = '' or ri.date::date >= reg_dt1::date) and
  (prm.reg_dt2 = '' or ri.date::date <= reg_dt2::date) and
  (prm.src_spec = '' or prm.src_spec = ss.id) and 
  (prm.src_pos = '' or prm.src_pos = sp.id) and
  (prm.ref_type = '' or prm.ref_type = rtype.id) and
  (prm.src_lpu = '' or prm.src_lpu = lpu.id) and
  (prm.ref_dt1 = '' or rt.reception_appoint_date::date >= prm.ref_dt1::date) and
  (ref_dt2 = '' or rt.reception_appoint_date::date <= prm.ref_dt2::date) and
  (prm.trg_spec = '' or prm.trg_spec = ts.id) and
  (prm.trg_lpu = '' or prm.trg_lpu = tar_lpu.id) and
  (prm.district = '' or prm.district = tar_lpu.district_name)
  */

/*
create table ext.speciality1 as
select distinct on (id) * from ext.speciality;

drop table ext.speciality;

create table ext.speciality as select * from ext.speciality1;*/

--select * from ext.speciality







CREATE OR REPLACE FUNCTION ext.report_ref1(
 IN reg_dt1 character varying DEFAULT ''::character varying, 
 IN reg_dt2 character varying DEFAULT ''::character varying,
 IN ref_dt1 character varying DEFAULT ''::character varying, 
 IN ref_dt2 character varying DEFAULT ''::character varying,
 IN src_spec character varying DEFAULT ''::character varying,
 IN trg_spec character varying DEFAULT ''::character varying,
 IN ref_type character varying DEFAULT ''::character varying, 
 IN src_lpu character varying DEFAULT ''::character varying,
 IN trg_lpu character varying DEFAULT ''::character varying,
 IN src_pos character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(dt character varying, dt_ord character varying, source_spec_name character varying, source_pos_name character varying, referral_type character varying, 
 source_lpu_name character varying, reception_appoint_date character varying, reception_appoint_date_ord character varying,
 target_spec_name character varying, target_lpu_name character varying, target_district_name character varying
 ) AS
$BODY$
begin
 return query 
with 
prm as (select reg_dt1, reg_dt2, ref_dt1, ref_dt2, src_spec, trg_spec, ref_type, src_lpu, trg_lpu, src_pos, district)

select 
 to_char(ri.date, 'dd.mm.yyyy')::character varying dt, --дата рег напр
 to_char(ri.date, 'yyyymmdd')::character varying dt_ord,
 ss.name::character varying source_spec_name, --спец напр
 sp.name::character varying source_pos_name, --должн напр
 rtype.name::character varying referral_type, --тип напр
 lpu.name::character varying source_lpu_name, --напр лпу
 to_char(rt.reception_appoint_date, 'dd.mm.yyyy')::character varying reception_appoint_date, --дата напр
 to_char(rt.reception_appoint_date, 'yyyymmdd')::character varying reception_appoint_date_ord,
 ts.name::character varying target_spec_name, --спец прин
 tar_lpu.name::character varying target_lpu_name, --прин МО
 tar_lpu.district_name::character varying target_district_name --район прин
 
from referral r
cross join prm
join referral_info ri on ri.id = r.referral_info_id
join referral_source rs on r.source_id = rs.id
join referral_source_doctors rsd on rsd._id = rs.id
join doctor sd on sd.id = rsd.doctors_id
join coding rsc on rsc.id = rs.lpu_id
join ext.lpu lpu on lpu.id = rsc.code
join coding scs on scs.id = sd.speciality_id
join ext.speciality ss on ss.id = scs.code
join coding scp on scp.id = sd.position_id
join ext.position sp on sp.id = scp.code
join coding crt on crt.id = ri.referral_type_id
join ext.referral_type rtype on rtype.id = crt.code

join referral_target rt on r.target_id = rt.id
left join referral_target_doctors rtd on rtd._id = rt.id
left join doctor td on td.id = rtd.doctors_id
join coding rtc on rtc.id = rt.lpu_id
join ext.lpu tar_lpu on tar_lpu.id = rtc.code

join coding tcs on tcs.id = td.speciality_id
join ext.speciality ts on ts.id = tcs.code

where
  (prm.reg_dt1 = '' or ri.date::date >= prm.reg_dt1::date) and
  (prm.reg_dt2 = '' or ri.date::date <= prm.reg_dt2::date) and
  (prm.src_spec = '' or prm.src_spec = ss.id) and 
  (prm.src_pos = '' or prm.src_pos = sp.id) and
  (prm.ref_type = '' or prm.ref_type = rtype.id) and
  (prm.src_lpu = '' or prm.src_lpu = lpu.id) and
  (prm.ref_dt1 = '' or rt.reception_appoint_date::date >= prm.ref_dt1::date) and
  (prm.ref_dt2 = '' or rt.reception_appoint_date::date <= prm.ref_dt2::date) and
  (prm.trg_spec = '' or prm.trg_spec = ts.id) and
  (prm.trg_lpu = '' or prm.trg_lpu = tar_lpu.id) and
  (prm.district = '' or prm.district = tar_lpu.district_name)
;
 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;  


select * from ext.report_ref1()