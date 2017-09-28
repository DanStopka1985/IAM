package reports

import (
	"net/http"
	"database/sql"
	"encoding/json"
	"../structs"
)

//get report data
func GetIEMK(w http.ResponseWriter, r *http.Request) {
	setHeaders(w)
	iemkCases := structs.IemkCases {}

	params := getParams(r);
	rows := getRows("iemk","select * from ext.report_iemk(" + params + ")")
	for rows.Next() {
		var odt sql.NullString
		var open_date sql.NullString
		var case_type sql.NullString
		var name sql.NullString
		var district_name sql.NullString
		rows.Scan(&odt, &open_date, &case_type, &name, &district_name)
		iemkCase := structs.IemkCase{Odt: odt.String, OpenDate: open_date.String, CaseType: case_type.String, LpuName: name.String, DistrictName: district_name.String}
		iemkCases = append(iemkCases, iemkCase)
	}
	json.NewEncoder(w).Encode(iemkCases)
}

func GetIemkLpuList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "iemk", "ext.report_iemk_get_lpu_list")
}

func GetIemkDistrictList(w http.ResponseWriter, r *http.Request) {
	GetSimpleClassifier(w, r, "iemk", "ext.report_iemk_get_district_list")
}

func GetCaseType(w http.ResponseWriter, r *http.Request) {
	setHeaders(w)
	sItems := structs.SItems {}
	sItems = append(sItems, structs.SItem{Id: "", Name: "Не выбрано"})
	sItems = append(sItems, structs.SItem{Id: "1", Name: "Амбулаторный"})
	sItems = append(sItems, structs.SItem{Id: "2", Name: "Стационарный"})
	json.NewEncoder(w).Encode(sItems)
}

