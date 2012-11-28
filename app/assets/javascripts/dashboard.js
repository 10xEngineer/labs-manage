var ENDPOINT = 'https://api.eu-1-aws.10xlabs.net/v1';
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

var attachPopover = function() {
  $('.machineInfo').popover({
    content: getContent()
  });
}


angular.module('labs', ['customResource']).
  factory('Lab', ['$customResource' , function($customResource) {
    var Lab = $customResource(ENDPOINT + '/machines/:machineId', { machineId: '@name'}, {
      query: { method:'GET', isArray:true },
      get: { method:'GET' },
      remove: { method:'DELETE' },
      create: { method:'POST' },
    });
    return Lab;
  }]).directive('machineInfo', ['$compile', function($compile) {
    return function(scope, element, attrs) {

      attrs.$observe('machineInfo', function(value) {
        scope.fetchMachineInfo(value);

        scope.$watch('labInfo', function(labInfo, oldVal, scope, index) {
          if(!labInfo) return;

          var lab = labInfo[value];

          if(lab && lab.name) {
            var portMapping = '';
            for(var proxy in lab.port_mapping) {
              portMapping += proxy + '(' + lab.port_mapping[proxy] + ')';
            }
            labInfo[value].portMapping = portMapping;

            var temp = $compile('<table class="table table-bordered table-striped">\
              <tr>\
                <td>Template:</td>\
                <td>{{labInfo["' + value + '"].template}}</td>\
              </tr>\
              <tr>\
                <td>IPv4:</td>\
                <td>{{labInfo["' + value + '"].ipv4_address}}</td>\
              </tr>\
              <tr>\
                <td>SSH client:</td>\
                <td>ssh -A {{labInfo["' + value + '"].ssh_proxy.proxy_user}}@{{labInfo["' + value + '"].ssh_proxy.gateway.host}}</td>\
              </tr>\
              <tr>\
                <td>Endpoint:</td>\
                <td>{{labInfo["' + value + '"].token}}.{{labInfo["' + value + '"].microcloud}}</td>\
              </tr>\
              <tr>\
                <td>Key Fingerprint:</td>\
                <td>{{labInfo["' + value + '"].ssh_proxy.fingerprint}}</td>\
              </tr>\
              <tr>\
                <td>Port Mapping:</td>\
                <td>{{labInfo["' + value + '"].portMapping}}</td>\
              </tr>\
              <tr>\
                <td>Created:</td>\
                <td>{{labInfo["' + value + '"].created_at}}</td>\
              </tr>\
              <tr>\
                <td>Last Updated:</td>\
                <td>{{labInfo["' + value + '"].updated_at}}</td>\
              </tr>\
            </table>')(scope.$parent);
            element.clickover({
              title: attrs.machineInfo,
              html: true,
              content: temp
            });

          };
        }, true);
      });
    };
}]);


/* Controllers */

function LabsController($scope, Lab) {
  $scope.token = $('#token').val() || TOKEN;
  $scope.secret = $('#secret').val() || SECRET;
  test = $scope.labInfo = {};

  var loadingComplete = function() {
    $scope.alertMessage = false;
  };

  var error = function(response) {
    var message = response && response.data ? response.data.message : undefined;

    $scope.alertClass = 'alert-error show';
    $scope.alertMessage = message || "An unknown error occurrd";
  };

  $scope.refresh = function() {
    $scope.alertClass = 'alert-info show';
    $scope.alertMessage = 'Loading your lab machines...'
    var date = new Date().toUTCString();
    
    $scope.labs = Lab.query({}, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'GET', '/machines', date) }, loadingComplete, error);
  };

  $scope.fetchMachineInfo = function(name) {
    var date = new Date().toUTCString();
    $scope.labInfo[name] = Lab.get({ machineId: name }, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'GET', '/machines/' + name, date) }, function(data) {
      $scope.labInfo[name] = JSON.parse(JSON.stringify(data));
      loadingComplete();
    }, error);
  };

  $scope.setLabForDeletion = function(name) {
    $scope.labDelete = name;
  }
  
  $scope.deleteMachine = function(name) {
    $scope.alertClass = 'alert-info show';
    $scope.alertMessage = 'Processing...'

    var date = new Date().toUTCString();
    Lab.remove({ machineId: name }, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'DELETE', '/machines/' + name, date) }, function() {
      console.log('Deleted Successfully.');
      $scope.refresh();
      loadingComplete();
    },
    function() {
      console.log('Error!');
      error.apply(this, arguments);
    });
  };

  $scope.createMachine = function() {
    $scope.alertClass = 'alert-info show';
    $scope.alertMessage = 'Processing...'

    var date = new Date().toUTCString();
    var data = { "template": "ubuntu-precise64", "key": "default", "size": "512", "pool": "default" };
    Lab.create({}, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'POST', '/machines', date, data) }, data, function() {
      console.log('Success.');
      $scope.refresh();
      loadingComplete();
    },
    function() {
      console.log('Error!');
      error.apply(this, arguments);
    });
  };

  $scope.refresh();
}

LabsController.$inject = ['$scope', 'Lab'];

