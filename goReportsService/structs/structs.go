package structs

type SItem struct {
	Id string `json:"id"`
	Name string `json:"name"`
}
type SItems []SItem

type IemkCase struct {
	Odt string `json:"odt"`
	OpenDate string `json:"open_date"`
	CaseType string `json:"case_type"`
	LpuName string `json:"name"`
	DistrictName string `json:"district_name"`
}
type IemkCases []IemkCase

type AppointZnp1 struct {
	RecDate string `json:"rec_date"`
	RecDateOrd string `json:"rec_date_ord"`
	VisitDate string `json:"visit_date"`
	VisitDateOrd string `json:"visit_date_ord"`
	LpuName string `json:"lpu"`
	SpecName string `json:"spec_name"`
	DistrictName string `json:"district_name"`
}

type AppointZnp1s []AppointZnp1

type Ref1 struct {
	RecDate string `json:"dt"`
	RecDateOrd string `json:"dt_ord"`
	RefDate string `json:"reception_appoint_date"`
	RefDateOrd string `json:"reception_appoint_date_ord"`

	SourceSpecName string `json:"source_spec_name"`
	SourcePosName string `json:"source_pos_name"`
	ReferralType string `json:"referral_type"`
	SourceLpuName string `json:"source_lpu_name"`

	TargetSpecName string `json:"target_spec_name"`
	TargetLpuName string `json:"target_lpu_name"`
	TargetDistrictName string `json:"target_district_name"`
}

type Ref1s []Ref1



