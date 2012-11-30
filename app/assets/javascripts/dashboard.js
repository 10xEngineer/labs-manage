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
    var Lab = $customResource(ENDPOINT + '/machines/:machineId', {}, {
      query: { method:'GET', isArray:true },
      get: { method:'GET' },
      remove: { method:'DELETE' },
      create: { method:'POST' },
    });
    return Lab;
  }]).factory('Template', ['$customResource' , function($customResource) {
    var Template = $customResource(ENDPOINT + '/templates', {}, {
      query: { method:'GET', isArray:true }
    });
    return Template;
  }]).factory('Snapshot', ['$customResource' , function($customResource) {
    var Snapshot = $customResource(ENDPOINT + '/machines/:machineId/snapshots/:snapshotId/:persist', { machineId: '@name' }, {
      query: { method:'GET', isArray:true },
      remove: { method:'DELETE' },
      create: { method:'POST' },
      restore: { method: 'PUT' },
      persist: { method: 'POST', params: { persist: 'persist' } }
    });
    return Snapshot;
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
  }]).directive('createMachine', function() {
    return function(scope, element, attrs) {
      element.bind('click', function(e) {
        $('form#createForm').get(0).reset();
      });
    };
  }).directive('getSnapshot', ['$compile', function($compile) {
    return function(scope, element, attrs) {
      element.bind('click', function() {
        scope.loadSnapshots(attrs.getSnapshot);
        $('#snapshots').modal();
      });
    };
}]);


/* Controllers */

function LabsController($scope, Lab, Template, Snapshot) {
  $scope.Math = window.Math;
  $scope.token = $('#token').val() || TOKEN;
  $scope.secret = $('#secret').val() || SECRET;
  $scope.labInfo = {};

  var loadingComplete = function() {
    $scope.alertMessage = false;
  };

  var error = function(response) {
    var message = response && response.data ? response.data.message : undefined;

    $scope.alertClass = 'alert-error show';
    $scope.alertMessage = message || "An unknown error occurrd";
  };

  // Templates
  $scope.loadTemplates = function() {
    var date = new Date().toUTCString();
    
    $scope.templates = Template.query({}, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'GET', '/templates', date) }, loadingComplete, error);
  };

  // Machines
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
    var form = $('form#createForm').get(0);
    var name = form.name.value;
    var template = form.template.value;
    var data = { "key": "default", "size": "512", "pool": "default" };

    if(name) {
      data.name = name;
    }
    if(template) {
      data.template = template;
    }

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

  // Snapshots
  $scope.loadSnapshots = function(machine) {
    $scope.snapshots = false;
    $scope.alertClass = 'alert-info show';
    $scope.alertMessage = 'Processing...'

    var date = new Date().toUTCString();
    $scope.snapshotInfo = { machine: machine };
    $scope.snapshots = Snapshot.query({ machineId: machine }, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'GET', '/machines/' + machine + '/snapshots', date) }, loadingComplete, error);
  }

  $scope.createSnapshot = function(machine) {
    $scope.alertClass = 'alert-info show';
    $scope.alertMessage = 'Processing...'

    var date = new Date().toUTCString();
    $scope.snapshotInfo = { machine: machine };
    var data = {};
    Snapshot.create({ machineId: machine }, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'POST', '/machines/' + machine + '/snapshots', date, data) }, data, function() {

      $scope.loadSnapshots(machine);
      loadingComplete();
    }, error);

  }

  $scope.restoreSnapshot = function(machine, snapshot) {
    $scope.alertClass = 'alert-info show';
    $scope.alertMessage = 'Processing...'

    var date = new Date().toUTCString();
    $scope.snapshotInfo = { machine: machine };
    var data = { name: snapshot };
    Snapshot.restore({ machineId: machine }, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'PUT', '/machines/' + machine + '/snapshots', date, data) }, data, function() {
      $('#snapshots').modal('hide');
      loadingComplete();
      $scope.alertMessage = 'Successfully restored snapshot ' + snapshot + '.';
    }, error);
  }

  $scope.deleteSnapshot = function(machine, snapshot) {
    $scope.alertClass = 'alert-info show';
    $scope.alertMessage = 'Processing...'

    var date = new Date().toUTCString();
    $scope.snapshotInfo = { machine: machine };
    Snapshot.remove({ machineId: machine, snapshotId: snapshot }, { 'X-Labs-Date': date, 'X-Labs-Token': $scope.token, 'X-Labs-Signature': calculateHash($scope.token, $scope.secret, 'DELETE', '/machines/' + machine + '/snapshots/' + snapshot, date) }, function() {
      $scope.loadSnapshots(machine);
      loadingComplete();
    }, error);
  }

  $scope.refresh();
  $scope.loadTemplates();
}

LabsController.$inject = ['$scope', 'Lab', 'Template', 'Snapshot'];

