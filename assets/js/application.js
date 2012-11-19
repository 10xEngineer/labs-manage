
/* Modules */

angular.module('labs', ['ngResource']).
  factory('Lab', function($resource) {
    var Lab = $resource('http://labs.apiary.io/v1/machines/:machineId', { machineId: '@name'}, {
      query: { method:'GET', headers: { 'X-Labs-Token': '6d6574972c198f76455d4eeb61ec', 'X-Labs-Signature': '324c8faefd63b882f4a7e486daaeb21f5be0c01e77ddc651' }, isArray:true },
      get: { method:'GET', headers: { 'X-Labs-Token': '6d6574972c198f76455d4eeb61ec', 'X-Labs-Signature': '324c8faefd63b882f4a7e486daaeb21f5be0c01e77ddc651' } },
      remove: { method:'DELETE', headers: { 'X-Labs-Token': '6d6574972c198f76455d4eeb61ec', 'X-Labs-Signature': '324c8faefd63b882f4a7e486daaeb21f5be0c01e77ddc651' } },
      create: { method:'POST', headers: { 'X-Labs-Token': '6d6574972c198f76455d4eeb61ec', 'X-Labs-Signature': '324c8faefd63b882f4a7e486daaeb21f5be0c01e77ddc651' } },
    });
    return Lab;
});


/* Controllers */

function LabsController($scope, Lab) {
  $scope.labs = Lab.query();

  $scope.refresh = function() {
    return $scope.labs = Lab.query();
  };

  $scope.deleteMachine = function(name) {
    Lab.remove({ machineId: name }, function() {
      console.log('Deleted Successfully.');
      $scope.refresh();
    },
    function() {
      console.log('Error!');
    });
  };

  $scope.createMachine = function() {
    Lab.create({ "template": "ubuntu-precise64", "key": "default" }, function() {
      console.log('Success.');
      $scope.refresh();
    },
    function() {
      console.log('Error!');
    });
  };
}

//LabsController.$inject = ['$scope', 'Lab'];

