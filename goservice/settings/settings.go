package settings

import (
	"os"
	"encoding/json"
	"log"
)

type settings struct {
	Port int
    DbIemkHost string
    DbIemkPort int
    DbIemkUser string
    DbIemkPassword string
    DbIemkName string

	DbAppointHost string
	DbAppointPort int
	DbAppointUser string
	DbAppointPassword string
	DbAppointName string

	DbQueueHost string
	DbQueuePort int
	DbQueueUser string
	DbQueuePassword string
	DbQueueName string
}

func GetSettings() settings{
	var settings settings
	jsonFile, err := os.Open("settings.json")
	if err != nil {
		log.Fatal(err.Error())
	}
	jsonParser := json.NewDecoder(jsonFile)
	err = jsonParser.Decode(&settings)
	if err != nil {
		log.Fatal(err.Error())
	}
	return settings
}