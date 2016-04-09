/**
 * Created by Rakibul Hasan on 4/8/2016.
 */

var mainApp = angular.module('myApp', ['ngResource', 'ngRoute','ui.tinymce']);

mainApp.controller('DrugListCtrl', function ($scope, DrugsFactory, ValueUpdated) {
    function initialize() {
        $scope.drugs = [];
    }

    initialize();

    $scope.drugs = DrugsFactory.drugs().query();
    $scope.$on('DrugListUpdated', function () {
        $scope.drugs = DrugsFactory.drugs().query();
    });
});


mainApp.controller('EditDrugCtrl', function ($scope, $routeParams, DrugsFactory, ValueUpdated,$httpParamSerializer) {
    function initialize() {

    }
    initialize();
    var drugId=$routeParams.drugsId;
    $scope.form = DrugsFactory.drugs().get({drugsId: drugId});

    $scope.editDrugInfo=function(){
        DrugsFactory.drugs().update({drugsId: drugId},$httpParamSerializer($scope.form),function(){
            ValueUpdated.drugsListUpdated();
        });
    };
});


mainApp.controller('AddDrugCtrl', function ($scope, $routeParams, DrugsFactory, ValueUpdated, $httpParamSerializer) {
    function initialize() {

    }

    initialize();
    $scope.addNewDrug = function () {
        DrugsFactory.drugs().save($httpParamSerializer($scope.form), function (output) {
            console.log(output);
            ValueUpdated.drugsListUpdated();
            $scope.form={};
        })
    }
});

mainApp.controller('ViewDrugCtrl',function($scope, $routeParams, DrugsFactory,$sce){
    var drugId=$routeParams.drugsId;
    $scope.drug=DrugsFactory.drugs().get({drugsId: drugId});

    $scope.trustHtml=function(html){
        return $sce.trustAsHtml(html);
    }
})


mainApp.factory('DrugsFactory', function ($resource) {
    var factory = {};
    factory.drugs = function () {
        return $resource('/api/drugs/:drugsId', {id: '@_id'}, {
            update: {
                method: 'PUT', // this method issues a PUT request,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            },
            save: {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            }
        });
    };
    return factory;
});

mainApp.factory('ValueUpdated', function ($rootScope) {
    var service = {};
    service.drugsListUpdated = function () {
        $rootScope.$broadcast("DrugListUpdated");
    };
    return service;
});

mainApp.config(['$routeProvider',
    function ($routeProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/index/add_drug/',
                controller: 'AddDrugCtrl'
            })
            .when('/edit-drug/:drugsId', {
                templateUrl: '/index/edit_drug/',
                controller: 'EditDrugCtrl'
            })
            .when('/view-drug/:drugsId', {
                templateUrl: '/index/view_drug/',
                controller: 'ViewDrugCtrl'
            })
            .otherwise({
                redirectTo: '/'
            });
    }]);
