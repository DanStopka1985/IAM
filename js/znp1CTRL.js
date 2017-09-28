'use strict';

app.controller('znp1CTRL', ['$scope', '$window', '$http', 'i18nService', 'exportUiGridService', '$rootScope',  function($scope, $window, $http, i18nService, exportUiGridService) {
    let classiffiers = ['lpu', 'district', 'spec'];
    let dates = ['rdt1', 'rdt2', 'vdt1', 'vdt2'];
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
            url: encodeURI(baseCtrlURL + `/znp1/${key}` + generateParams())
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
            url: encodeURI(baseCtrlURL + '/znp1' + generateParams())
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
        columnDefs: [
            {field: 'rec_date', displayName: 'Дата создания записи', sortingAlgorithm: function (a, b, rowA, rowB, direction) {
                return +rowA.entity.rec_date_ord - +rowB.entity.rec_date_ord;
            }},
            {field: 'visit_date', displayName: 'Дата приема', sortingAlgorithm: function (a, b, rowA, rowB, direction) {
                return +rowA.entity.visit_date_ord - +rowB.entity.visit_date_ord;
            }},
            {field: 'lpu', displayName: 'ЛПУ'},
            {field: 'spec_name', displayName: 'Специальность'},
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
                exportUiGridService.exportToExcel('sheet 1', $scope.gridApi, 'all', 'all', 'znp1');
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

