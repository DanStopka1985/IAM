-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_appoint_get_lpu_list(
 IN rdt1 character varying DEFAULT ''::character varying, 
 IN rdt2 character varying DEFAULT ''::character varying,
 IN vdt1 character varying DEFAULT ''::character varying, 
 IN vdt2 character varying DEFAULT ''::character varying,
 IN spec integer DEFAULT 0::integer,
 IN lpu character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select rdt1, rdt2, vdt1, vdt2, district, spec, lpu),
filter as (select distinct n.id_lpu::text from notification n
join appointment a on a.id = n.appointment_id 
  cross join prm 
  join ext.lpu lpu on lpu.id = n.id_lpu::text
  left join notice_appointment na on na.id = a.id 
where n.id_lpu is not null and 
 (prm.rdt1 = '' or na.record_date_time::date >= prm.rdt1::date) and
 (prm.rdt2 = '' or na.record_date_time::date <= prm.rdt2::date) and
 (prm.vdt1 = '' or a.visit_start::date >= prm.vdt1::date) and
 (prm.vdt2 = '' or a.visit_start::date <= prm.vdt2::date) and
 (prm.spec = 0 or prm.spec = n.spesiality_id) and
 (prm.district = '' or prm.district = lpu.district_name)
),

t as (
 select l.id, l.name, 1 ord from ext.lpu l where l.id::text in (select id_lpu::text from filter) union all
 select '', 'не выбрано', 0
)

select t.id, t.name from t order by ord, name;
 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_appoint_get_district_list(
 IN rdt1 character varying DEFAULT ''::character varying, 
 IN rdt2 character varying DEFAULT ''::character varying,
 IN vdt1 character varying DEFAULT ''::character varying, 
 IN vdt2 character varying DEFAULT ''::character varying,
 IN spec integer DEFAULT 0::integer, 
 IN lpu character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select rdt1, rdt2, vdt1, vdt2, district, spec, lpu),
filter as (select distinct n.id_lpu::text from notification n
join appointment a on a.id = n.appointment_id 
  cross join prm 
  left join notice_appointment na on na.id = a.id 
where n.id_lpu is not null and 
 (prm.rdt1 = '' or na.record_date_time::date >= prm.rdt1::date) and
 (prm.rdt2 = '' or na.record_date_time::date <= prm.rdt2::date) and
 (prm.vdt1 = '' or a.visit_start::date >= prm.vdt1::date) and
 (prm.vdt2 = '' or a.visit_start::date <= prm.vdt2::date) and
 (prm.spec = 0 or prm.spec = n.spesiality_id) and
 (prm.lpu = '' or prm.lpu = n.id_lpu::text)
),

t as (
 select distinct (district_name) district_name, 1 ord, district_name id from ext.lpu where ext.lpu.id::text in (select id_lpu::text from filter) union all
 select 'Не выбрано', 0, ''
)

select t.id, district_name from t order by ord, district_name;

 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;

------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION ext.report_znp1(
 IN rdt1 character varying DEFAULT ''::character varying, 
 IN rdt2 character varying DEFAULT ''::character varying,
 IN vdt1 character varying DEFAULT ''::character varying, 
 IN vdt2 character varying DEFAULT ''::character varying,
 IN spec integer DEFAULT 0::integer, 
 IN lpu character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
  RETURNS TABLE(rec_date character varying, rec_date_ord character varying, visit_date character varying, visit_date_ord character varying, lpu_name character varying, spec_name character varying, district_name character varying) AS
$BODY$
begin
return query 
with prm as (select rdt1, rdt2, vdt1, vdt2, district, spec, lpu)

select 
 to_char(na.record_date_time, 'dd.mm.yyyy')::character varying rec_date, 
 to_char(na.record_date_time, 'yyyymmdd')::character varying rec_date_ord, 
 to_char(a.visit_start, 'dd.mm.yyyy')::character varying visit_date, 
 to_char(a.visit_start, 'yyyymmdd')::character varying visit_date_ord, 
 lpu.name lpu, 
 s.name_spesiality spec, 
 lpu.district_name dstr_name
from appointment a
cross join prm
join notification n on a.id = n.appointment_id
left join spesiality s on s.id = n.spesiality_id
left join notice_appointment na on na.id = a.id
join ext.lpu lpu on lpu.id = n.id_lpu::text
where 
 (prm.rdt1 = '' or na.record_date_time::date >= prm.rdt1::date) and
 (prm.rdt2 = '' or na.record_date_time::date <= prm.rdt2::date) and
 (prm.vdt1 = '' or a.visit_start::date >= prm.vdt1::date) and
 (prm.vdt2 = '' or a.visit_start::date <= prm.vdt2::date) and 
 (prm.district = '' or prm.district = lpu.district_name) and
 (prm.lpu = '' or prm.lpu = n.id_lpu::text) and
 (prm.spec = 0 or prm.spec = n.spesiality_id) order by lpu.name;
 /*EXCEPTION
                WHEN others THEN*/
                
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;


--  select * from ext.report_znp1()




------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION ext.report_appoint_get_speciality_list(
 IN rdt1 character varying DEFAULT ''::character varying, 
 IN rdt2 character varying DEFAULT ''::character varying,
 IN vdt1 character varying DEFAULT ''::character varying, 
 IN vdt2 character varying DEFAULT ''::character varying,
 IN spec integer DEFAULT 0::integer, 
 IN lpu character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query 
with 
prm as (select rdt1, rdt2, vdt1, vdt2, district, spec, lpu),
filter as (
 select 
  distinct spesiality_id 
  from notification n 
  join appointment a on a.id = n.appointment_id 
  cross join prm 
  left join notice_appointment na on na.id = a.id 
where n.id_lpu is not null and 
 (prm.rdt1 = '' or na.record_date_time::date >= prm.rdt1::date) and
 (prm.rdt2 = '' or na.record_date_time::date <= prm.rdt2::date) and
 (prm.vdt1 = '' or a.visit_start::date >= prm.vdt1::date) and
 (prm.vdt2 = '' or a.visit_start::date <= prm.vdt2::date) and
 (prm.lpu = '' or prm.lpu = n.id_lpu::text)
),
t as (
 select s.id::character varying, s.name_spesiality "name", 1 ord from spesiality s where s.id in (select spesiality_id from filter) union all
 select '', 'не выбрано', 0
)

select t.id::character varying, t.name from t order by ord, name;

 /*EXCEPTION
                WHEN others THEN */
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;

 --select * from ext.report_appoint_get_speciality_list()
 --select * from ext.report_appoint_get_lpu_list()