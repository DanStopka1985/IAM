package reports

import (
	"net/http"
	"fmt"
	"database/sql"
	ss "../settings"
	"../structs"
	"encoding/json"
)

var s = ss.GetSettings()
var iemkPsqlInfo = fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", s.DbIemkHost, s.DbIemkPort, s.DbIemkUser, s.DbIemkPassword, s.DbIemkName)
var iemkDb, errIemkCon = sql.Open("postgres", iemkPsqlInfo)
var appointPsqlInfo = fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", s.DbAppointHost, s.DbAppointPort, s.DbAppointUser, s.DbAppointPassword, s.DbAppointName)
var appointDb, errAppointCon = sql.Open("postgres", appointPsqlInfo)
var queuePsqlInfo = fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", s.DbQueueHost, s.DbQueuePort, s.DbQueueUser, s.DbQueuePassword, s.DbQueueName)
var queueDb, errQueueCon = sql.Open("postgres", queuePsqlInfo)


func setHeaders(w http.ResponseWriter) http.ResponseWriter  {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	return w
}

func getParams(r *http.Request) string {
	pKeys := [10]string{"lpu", "dt1", "dt2", "rdt1", "rdt2" , "vdt1", "vdt2", "ct", "district", "spec"}
	params := ""
	for i := 0; i < len(pKeys); i++ {
		if r.FormValue(pKeys[i]) != "" {
			if len(params) > 0 {params += ","}
			params += pKeys[i] + " := '" + r.FormValue(pKeys[i]) + "'"
		}
	}

	return params;
}

func GetSimpleClassifier(w http.ResponseWriter, r *http.Request, db string, proc string) {
	setHeaders(w)
	sItems := structs.SItems {}
	params := getParams(r);
	rows := getRows(db, "select * from " + proc + "(" + params + ")")
	for rows.Next() {
		var id sql.NullString
		var name sql.NullString
		rows.Scan(&id, &name)
		sItem := structs.SItem{Id: id.String, Name: name.String}
		sItems = append(sItems, sItem)
	}
	json.NewEncoder(w).Encode(sItems)
}


func getRows(dbName string, query string) (*sql.Rows) {
	var err error
	if (dbName == "iemk"){
		err = errIemkCon
		P(err)
		P(iemkDb.Ping())
		P(err)
		rows, err := iemkDb.Query(query)
		P(err)
		return rows
	} else if (dbName == "appoint"){
		err = errAppointCon
		P(err)
		P(appointDb.Ping())
		P(err)
		rows, err := appointDb.Query(query)
		P(err)
		return rows
	} else if (dbName == "queue"){
		err = errQueueCon
		P(err)
		P(queueDb.Ping())
		P(err)
		rows, err := queueDb.Query(query)
		P(err)
		return rows
	}
	return nil
}

func P(err error){
	if err != nil {
		panic(err)
	}
}