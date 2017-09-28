'use strict';

app.controller('ref1CTRL', ['$scope', '$window', '$http', 'i18nService', 'exportUiGridService', '$rootScope',  function($scope, $window, $http, i18nService, exportUiGridService) {
    let classiffiers = ['src_spec', 'src_pos', 'ref_type', 'src_lpu', 'trg_spec', 'trg_lpu', 'district'];
    let dates = ['reg_dt1', 'reg_dt2', 'ref_dt1', 'ref_dt2'];
    $scope.langs = i18nService.getAllLangs();
    $scope.lang = 'ru';

    //declare functions
    let getParam = function (key) {
        let v = $scope[`${key}`];
        return (v !== undefined && v !== null && v.id !== '') ? `&${key}=` + v.id : '';
    };

    let getDateParam = function (key) {
        let v = $scope[`${key}`];
        return (v !== undefined) ? `&${key}=` + dtToStr(v) : '';
    };

    const generateParams = function () {
        let rp = '?';
        for (let i = 0; i < classiffiers.length; i++)
            rp += getParam(classiffiers[i]);
        for (let i = 0; i < dates.length; i++)
            rp += getDateParam(dates[i]);
        return rp;
    };

    $scope.refreshClassifier = function (key) {
        $http({
            method: 'GET',
            url: encodeURI(baseCtrlURL + `/ref1/${key}` + generateParams())
        }).then(function successCallback(response) {
            let index = 0;
            if ( $scope[`${key}`]) {
                let savedId = $scope[`${key}`].id;
                index = response.data.reduce((findedIndex, el, ind) => {
                    return (el.id === savedId) ? ind : findedIndex;
                }, 0);
            }
            $scope[`${key}_array`] = response.data;
            $scope[`${key}`] =  $scope[`${key}_array`][index];
        }, function errorCallback(response) {
        });
    };

    $scope.refreshClassifiers = function (except_key) {
        for (let i = 0; i < classiffiers.length; i++)
            if (except_key !== classiffiers[i])
                $scope.refreshClassifier(classiffiers[i]);
    };

    //refresh report
    $scope.refreshReport = function(){
        $http({
            method: 'GET',
            url: encodeURI(baseCtrlURL + '/ref1' + generateParams())
        }).then(function successCallback(response) {
            $scope.myData = response.data;
        }, function errorCallback(response) {
        });
    };

    //init params
    $scope.rdt1 = new Date(2015, 6, 1);
    $scope.rdt2 = new Date();
    $scope.refreshClassifiers();
    $scope.myData = [];
    $scope.gridOptions = {
        data: 'myData',
        enableGridMenu: true,
        columnDefs: [
            {field: 'dt', displayName: 'Дата регистрации направления', sortingAlgorithm: function (a, b, rowA, rowB, direction) {
                return +rowA.entity.dt_ord - +rowB.entity.dt_ord;
            }},
            {field: 'source_spec_name', displayName: 'Специальность направляющего'},
            {field: 'source_pos_name', displayName: 'Должность направляющего'},
            {field: 'referral_type', displayName: 'Тип направления'},
            {field: 'source_lpu_name', displayName: 'Направляющая МО'},
            {field: 'reception_appoint_date', displayName: 'Дата направления', sortingAlgorithm: function (a, b, rowA, rowB, direction) {
                return +rowA.entity.reception_appoint_date_ord - +rowB.entity.reception_appoint_date_ord;
            }},
            {field: 'target_spec_name', displayName: 'Специальность принимающего'},
            {field: 'target_lpu_name', displayName: 'Принимающая МО'},
            {field: 'target_district_name', displayName: 'Район принимающей МО'}
        ],
        enablePaging: true,
        paginationPageSizes: [10, 25, 50, 75],
        paginationPageSize: 10,
        exporterMenuCsv: false,
        exporterMenuPdf: false,
        onRegisterApi: function(gridApi){
            $scope.gridApi = gridApi;
        },
        gridMenuCustomItems: [{
            title: 'Выгрузить в EXCEL',
            action: function ($event) {
                console.log(exportUiGridService);
                exportUiGridService.exportToExcel('sheet 1', $scope.gridApi, 'all', 'all', 'ref1');
            },
            order: 110
        }
        ]
    };
    $scope.refreshReport();

    $scope.open = function(a) {
        $window.location.href = a;
    };
}]);

