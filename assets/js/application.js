var ENDPOINT = 'http://api.eu-1-aws.10xlabs.net/v1';
var TOKEN = '';
var SECRET = '';

/* Modules */

var calculateHash = function(token, secret, method, url, date, data) {
  var hmac = CryptoJS.algo.HMAC.create(CryptoJS.algo.SHA256, secret);
  hmac.update(method);
  hmac.update(url);
  hmac.update(date);
  hmac.update(token);

  if(data) {
    if(typeof(data) === 'string') {
      hmac.update(data);
    } else {      
      hmac.update(JSON.stringify(data));
    }
  }

  var hash = hmac.finalize().toString(CryptoJS.enc.Base64);
  return hash;
};

angular.module('labs', ['customResource']).
  factory('Lab', function($customResource) {
    var Lab = $customResource(ENDPOINT + '/machines/:machineId', { machineId: '@name'}, {
      query: { method:'GET', isArray:true },
      get: { method:'GET' },
      remove: { method:'DELETE' },
      create: { method:'POST' },
    });
    return Lab;
});


/* Controllers */

function LabsController($scope, Lab) {
  $scope.token = TOKEN;
  $scope.secret = SECRET;

  $scope.refresh = function() {
    var date = new Date().toUTCString();
    $scope.labs = Lab.query({}, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'GET', '/machines', date) });
  };

  $scope.deleteMachine = function(name) {
    var date = new Date().toUTCString();
    Lab.remove({ machineId: name }, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'DELETE', '/machines/' + name, date) }, function() {
      console.log('Deleted Successfully.');
      $scope.refresh();
    },
    function() {
      console.log('Error!');
    });
  };

  $scope.createMachine = function() {
    var date = new Date().toUTCString();
    var data = { "template": "ubuntu-precise64", "key": "default", "size": "512", "pool": "default" };
    Lab.create({}, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'POST', '/machines', date, data) }, data, function() {
      console.log('Success.');
      $scope.refresh();
    },
    function() {
      console.log('Error!');
    });
  };

  $scope.refresh();
}

//LabsController.$inject = ['$scope', 'Lab'];

