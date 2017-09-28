'use strict';
const dtToStr = function (dt) {
    if (dt !== undefined && dt !== null)
        return dt.getFullYear() + '-' + ('0' + (dt.getMonth() + 1)).slice(-2) + '-' + ('0' + dt.getDate()).slice(-2);
    else return '';
};

const baseCtrlURL = 'http://127.0.0.1:8083';

app.controller('reportCTRL', ['$scope', '$window', '$http', '$rootScope', function($scope, $window) {
    $scope.open = function(a) {
        $window.location.href = a;
    };
}]);
