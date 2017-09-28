'use strict';
let app = angular.module("app", ['ngSanitize', 'ngAnimate', 'ui.bootstrap', 'ui.grid', 'ngRoute', 'ui.grid.pagination', 'ngTouch', 'ui.grid.exporter']);

app.config(['$routeProvider',
    function($routeProvider) {
        $routeProvider.
        when('/case1', {
            templateUrl: 'partials/case1.html',
            title: 'Использование ИЭМК',
            controller: 'case1CTRL'
        }).
        when('/znp1', {
            templateUrl: 'partials/znp1.html',
            title:'Доступность первичной медицинской помощи',
            controller: 'znp1CTRL'
        }).
        when('/ref1', {
            templateUrl: 'partials/ref1.html',
            title:'Доступность первичной медицинской помощи',
            controller: 'ref1CTRL'

        })
    }]);

app.factory('exportUiGridService', exportUiGridService);

exportUiGridService.inject = ['uiGridExporterService'];
function exportUiGridService(uiGridExporterService) {
    let service = {
        exportToExcel: exportToExcel
    };

    return service;

    function Workbook() {
        if (!(this instanceof Workbook)) return new Workbook();
        this.SheetNames = [];
        this.Sheets = {};
    }


    function exportToExcel(sheetName, gridApi, rowTypes, colTypes, filename) {
        let columns = gridApi.grid.options.showHeader ? uiGridExporterService.getColumnHeaders(gridApi.grid, colTypes) : [];
        let data = uiGridExporterService.getData(gridApi.grid, rowTypes, colTypes);
        let fileName = gridApi.grid.options.exporterExcelFilename ? gridApi.grid.options.exporterExcelFilename : filename;
        fileName += '.xlsx';
        let wb = new Workbook(),
            ws = sheetFromArrayUiGrid(data, columns);
        wb.SheetNames.push(sheetName);
        wb.Sheets[sheetName] = ws;
        let wbout = XLSX.write(wb, {
            bookType: 'xlsx',
            bookSST: true,
            type: 'binary'
        });
        saveAs(new Blob([s2ab(wbout)], {
            type: 'application/octet-stream'
        }), fileName);
    }

    function sheetFromArrayUiGrid(data, columns) {
        let ws = {};
        let range = {
            s: {
                c: 10000000,
                r: 10000000
            },
            e: {
                c: 0,
                r: 0
            }
        };
        let C = 0;
        columns.forEach(function (c) {
            let v = c.displayName || c.value || columns[i].name;
            addCell(range, v, 0, C, ws);
            C++;
        }, this);
        let R = 1;
        data.forEach(function (ds) {
            C = 0;
            ds.forEach(function (d) {
                let v = d.value;
                addCell(range, v, R, C, ws);
                C++;
            });
            R++;
        }, this);
        if (range.s.c < 10000000) ws['!ref'] = XLSX.utils.encode_range(range);
        return ws;
    }
    /**
     *
     * @param {*} data
     * @param {*} columns
     */

    function datenum(v, date1904) {
        if (date1904) v += 1462;
        let epoch = Date.parse(v);
        return (epoch - new Date(Date.UTC(1899, 11, 30))) / (24 * 60 * 60 * 1000);
    }

    function s2ab(s) {
        let buf = new ArrayBuffer(s.length);
        let view = new Uint8Array(buf);
        for (let i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
        return buf;
    }

    function addCell(range, value, row, col, ws) {
        if (range.s.r > row) range.s.r = row;
        if (range.s.c > col) range.s.c = col;
        if (range.e.r < row) range.e.r = row;
        if (range.e.c < col) range.e.c = col;
        let cell = {
            v: value
        };
        if (cell.v == null) cell.v = '-';
        let cell_ref = XLSX.utils.encode_cell({
            c: col,
            r: row
        });

        if (typeof cell.v === 'number') cell.t = 'n';
        else if (typeof cell.v === 'boolean') cell.t = 'b';
        else if (cell.v instanceof Date) {
            cell.t = 'n';
            cell.z = XLSX.SSF._table[14];
            cell.v = datenum(cell.v);
        } else cell.t = 's';

        ws[cell_ref] = cell;
    }
}