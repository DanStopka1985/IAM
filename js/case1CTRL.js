'use strict';

app.controller('case1CTRL', ['$scope', '$window', '$http', 'i18nService', 'exportUiGridService', '$rootScope',  function($scope, $window, $http, i18nService, exportUiGridService) {
    let classiffiers = ['caseType', 'lpu', 'district'];
    let dates = ['dt1', 'dt2'];
    $scope.langs = i18nService.getAllLangs();
    $scope.lang = 'ru';

    let dateSort = function (a, b, rowA, rowB, direction) {
        return +rowA.entity.odt - +rowB.entity.odt;
    };

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
            url: encodeURI(baseCtrlURL + `/case1/${key}` + generateParams())
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
            url: encodeURI(baseCtrlURL + '/case1' + generateParams())
        }).then(function successCallback(response) {
            $scope.myData = response.data;
        }, function errorCallback(response) {
        });
    };

    //init params
    $scope.dt1 = new Date(2017, 6, 1);
    $scope.dt2 = new Date();
    $scope.refreshClassifiers();
    $scope.myData = [{open_date:'', case_type:'', name: '', district_name: ''}];
    $scope.gridOptions = {
        data: 'myData',
        columnDefs: [
            {field: 'open_date', displayName: 'Дата открытия случая', sortingAlgorithm: dateSort},
            {field: 'case_type', displayName: 'Тип случая'},
            {field: 'name', displayName: 'ЛПУ'},
            {field: 'district_name', displayName: 'Район'}
        ],
        enablePaging: true,
        paginationPageSizes: [10, 25, 50, 75],
        paginationPageSize: 10,
        enableGridMenu: true,
        exporterMenuCsv: false,
        exporterMenuPdf: false,
        onRegisterApi: function(gridApi){
            $scope.gridApi = gridApi;
        },
        gridMenuCustomItems: [{
            title: 'Выгрузить в EXCEL',
            action: function ($event) {
                console.log(exportUiGridService);
                exportUiGridService.exportToExcel('sheet 1', $scope.gridApi, 'all', 'all', 'case1');
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

