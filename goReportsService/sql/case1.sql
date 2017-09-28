create table if not exists ext.test_loader(id integer);

CREATE OR REPLACE FUNCTION ext.report_iemk_get_district_list(
 IN dt1 character varying DEFAULT ''::character varying,
 IN dt2 character varying DEFAULT ''::character varying,
 IN ct character varying DEFAULT ''::character varying,
 IN lpu character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query
  (select '', 'не выбрано') union all
  (select distinct l.district_name, l.district_name from ext.lpu l
  where exists (
   select 1 from case_base cb
   where cb.id_lpu = l.id and
   (dt1 = '' or cb.open_date >= dt1::date) and
   (dt2 = '' or cb.open_date <= dt2::date) and
   (ct = '' or ct = '1' and exists (select 1 from case_amb ca where ca.id = cb.id) or ct = '2' and exists (select 1 from case_stat cs where cs.id = cb.id))

  ) and
  (lpu = '' or lpu = l.id)

  order by l.district_name) ;
 EXCEPTION
                WHEN others THEN
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;

-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_iemk_get_lpu_list(
 IN dt1 character varying DEFAULT ''::character varying,
 IN dt2 character varying DEFAULT ''::character varying,
 IN ct character varying DEFAULT ''::character varying,
 IN lpu character varying DEFAULT ''::character varying,
 IN district character varying DEFAULT ''::character varying
)
RETURNS TABLE(id character varying, name character varying) AS
$BODY$
begin
 return query
  (select '', 'не выбрано') union all
  (select l.id, l.name from ext.lpu l
  where (district = '' or district != '' and l.district_name = district) and
  exists (
   select 1 from case_base cb
   where cb.id_lpu = l.id and
   (dt1 = '' or cb.open_date >= dt1::date) and
   (dt2 = '' or cb.open_date <= dt2::date) and
   (ct = '' or ct = '1' and exists (select 1 from case_amb ca where ca.id = cb.id) or ct = '2' and exists (select 1 from case_stat cs where cs.id = cb.id))
  ) order by l.name) ;
 EXCEPTION
                WHEN others THEN
end;

$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------
CREATE OR REPLACE FUNCTION ext.report_iemk(
    IN dt1 character varying DEFAULT ''::character varying,
    IN dt2 character varying DEFAULT ''::character varying,
    IN ct character varying DEFAULT ''::character varying,
    IN lpu character varying DEFAULT ''::character varying,
    IN district character varying DEFAULT ''::character varying)
  RETURNS TABLE(odt character varying, open_date character varying, case_type character varying, name character varying, district_name character varying) AS
$BODY$
begin
return query
 with prm as (select dt1, dt2, ct, lpu, district)

select
 to_char(cb.open_date, 'yyyymmdd')::character varying(8) odt,
 to_char(cb.open_date, 'dd.mm.yyyy')::character varying(10) open_date,
 case
  when ca.id is not null then 'Амбулаторный'
  when cs.id is not null then 'Стационарный'
 end::character varying(12) case_type,
 lpu.name::character varying(255),
 lpu.district_name::character varying(255)

from case_base cb
cross join prm
left join case_amb ca on ca.id = cb.id
left join case_stat cs on cs.id = cb.id
left join ext.lpu lpu on lpu.id = cb.id_lpu
where
 (prm.dt1 = '' or cb.open_date >= prm.dt1::date) and
 (prm.dt2 = '' or cb.open_date <= prm.dt2::date) and
 (prm.ct = '' or prm.ct = '2' and cs.id is not null or prm.ct = '1' and ca.id is not null) and
 (prm.lpu = '' or prm.lpu = cb.id_lpu) and
 (prm.district = '' or prm.district = lpu.district_name);
 EXCEPTION
                WHEN others THEN raise notice '123';

end;

$BODY$
  LANGUAGE plpgsql VOLATILE;
