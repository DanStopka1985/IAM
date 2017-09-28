package reports

import (
	"net/http"
	"database/sql"
	"encoding/json"
	"../structs"
)

func GetRef1SourceLpuList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "queue", "ext.report_ref1_get_source_lpu_list")
}

func GetRef1TargetLpuList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "queue", "ext.report_ref1_get_target_lpu_list")
}

func GetRef1DistrictList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "queue", "ext.report_ref1_get_district_list")
}

func GetRef1SourceSpecialityList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "queue", "ext.report_ref1_get_source_speciality_list")
}

func GetRef1TargetSpecialityList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "queue", "ext.report_ref1_get_target_speciality_list")
}

func GetRef1ReferralTypeList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "queue", "ext.report_ref1_get_referral_type_list")
}

func GetRef1SourcePositionList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "queue", "ext.report_ref1_get_source_position_list")
}

//get report data
func GetRef1(w http.ResponseWriter, r *http.Request) {
	setHeaders(w)
	ref1s := structs.Ref1s {}

	params := getParams(r);
	rows := getRows("queue","select * from ext.report_ref1(" + params + ")")
	for rows.Next() {
		var dt sql.NullString
		var dt_ord sql.NullString
		var reception_appoint_date sql.NullString
		var reception_appoint_date_ord sql.NullString

		var source_spec_name sql.NullString
		var source_pos_name sql.NullString
		var referral_type sql.NullString
		var source_lpu_name sql.NullString

		var target_spec_name sql.NullString
		var target_lpu_name sql.NullString
		var target_district_name sql.NullString

		rows.Scan(&dt, &dt_ord, &source_spec_name, &source_pos_name, &referral_type, &source_lpu_name, &reception_appoint_date, &reception_appoint_date_ord, &target_spec_name,
			&target_lpu_name, &target_district_name)
		ref1 := structs.Ref1{RecDate: dt.String, RecDateOrd: dt_ord.String, RefDate: reception_appoint_date.String, RefDateOrd: reception_appoint_date_ord.String,
			SourceSpecName: source_spec_name.String, SourcePosName: source_pos_name.String, ReferralType: referral_type.String, SourceLpuName: source_lpu_name.String,
			TargetSpecName: target_spec_name.String, TargetLpuName: target_lpu_name.String}
		ref1s = append(ref1s, ref1)
	}
	json.NewEncoder(w).Encode(ref1s)
}