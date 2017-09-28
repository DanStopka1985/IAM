package main

import (
	"log"
	"net/http"
	"github.com/gorilla/mux"
	"strconv"
	_ "github.com/lib/pq"
	ss "../settings"
	rep "../reports"
	l "../loader"
)

func main() {
	l.Loader()

	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/case1", rep.GetIEMK)
	router.HandleFunc("/case1/lpu", rep.GetIemkLpuList)
	router.HandleFunc("/case1/caseType", rep.GetCaseType)
	router.HandleFunc("/case1/district", rep.GetIemkDistrictList)

	router.HandleFunc("/znp1/lpu", rep.GetAppointLpuList)
	router.HandleFunc("/znp1/district", rep.GetAppointDistrictList)
	router.HandleFunc("/znp1/spec", rep.GetAppointSpecialityList)
	router.HandleFunc("/znp1", rep.GetZNP1)

	router.HandleFunc("/ref1/src_lpu", rep.GetRef1SourceLpuList)
	router.HandleFunc("/ref1/trg_lpu", rep.GetRef1TargetLpuList)
	router.HandleFunc("/ref1/district", rep.GetRef1DistrictList)
	router.HandleFunc("/ref1/src_spec", rep.GetRef1SourceSpecialityList)
	router.HandleFunc("/ref1/trg_spec", rep.GetRef1TargetSpecialityList)

	router.HandleFunc("/ref1/ref_type", rep.GetRef1ReferralTypeList)
	router.HandleFunc("/ref1/src_pos", rep.GetRef1SourcePositionList)
	router.HandleFunc("/ref1", rep.GetRef1)

	log.Fatal(http.ListenAndServe(":" + strconv.Itoa(ss.GetSettings().Port), router))
}