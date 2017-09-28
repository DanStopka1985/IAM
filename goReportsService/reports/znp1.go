package reports

import (
	"net/http"
	"database/sql"
	"encoding/json"
	"../structs"
)

//get report data
func GetZNP1(w http.ResponseWriter, r *http.Request) {
	setHeaders(w)
	appointZnp1s := structs.AppointZnp1s {}

	params := getParams(r);
	rows := getRows("appoint","select * from ext.report_znp1(" + params + ")")
	for rows.Next() {
		var rec_date sql.NullString
		var rec_date_ord sql.NullString
		var visit_date sql.NullString
		var visit_date_ord sql.NullString
		var lpu sql.NullString
		var spec_name sql.NullString
		var district_name sql.NullString
		rows.Scan(&rec_date, &rec_date_ord, &visit_date, &visit_date_ord, &lpu, &spec_name, &district_name)
		appointZnp1 := structs.AppointZnp1{RecDate: rec_date.String, RecDateOrd: rec_date_ord.String, VisitDate: visit_date.String, VisitDateOrd: visit_date_ord.String, LpuName: lpu.String, SpecName: spec_name.String, DistrictName: district_name.String}
		appointZnp1s = append(appointZnp1s, appointZnp1)
	}
	json.NewEncoder(w).Encode(appointZnp1s)
}


func GetAppointLpuList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "appoint", "ext.report_appoint_get_lpu_list")
}

func GetAppointDistrictList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "appoint", "ext.report_appoint_get_district_list");
}

func GetAppointSpecialityList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "appoint", "ext.report_appoint_get_speciality_list");
}
