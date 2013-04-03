/*global db: true,rs: true*/
var Global = {
  primaryOptimeDate : function() {
    var members = rs.status().members
      , member;
    for(var i=0, l = members.length; i < l; i++) {
      member = members[i];
      if(member.stateStr == 'PRIMARY') {
        return member.optimeDate;
      }
    }
  }
  , optimeDate : function() {
    var members = rs.status().members
      , member;
    for(var i=0, l = members.length; i < l; i++) {
      member = members[i];
      if(member.self) {
        return member.optimeDate;
      }
    }
  }
  , replicationLog : function() {
    var members = rs.status().members;
    if (!members) {
      return null;
    }
    return ((this.primaryOptimeDate() - this.optimeDate()) / 1000);
  }
  , $A : function(args) {
    return Array.prototype.slice.call(args);
  }
  , sprintf : function() {
    var args = this.$A(arguments)
      , fmt = args.shift() || "";
    return fmt.replace(/%s/g, function(s) {
      return args.shift();
    });
  }
  , summary : function() {
    var uptime = db.serverStatus().uptime;
    var setName = (db.serverStatus().repl ||{}).setName;
    var primary = (db.serverStatus().repl ||{}).primary;
    var replag = this.replicationLog();
    var curConnections = db.serverStatus().connections.current;
    var resMem = db.serverStatus().mem.resident;
    var userAsserts = db.serverStatus().asserts.user;
    var warningAsserts = db.serverStatus().asserts.warning;
    var totalQueues = db.serverStatus().globalLock.currentQueue.total;
    var lockRatio = db.serverStatus().globalLock.ratio;
    var readQueues = db.serverStatus().globalLock.currentQueue.readers;

    var uptimeHours = Math.floor(uptime / (60 * 60));
    var uptimeMinutes = Math.floor((uptime - (uptimeHours * 60 * 60)) / 60);
    print([
          this.sprintf('System information as of %s', db.serverStatus().localTime),
          '',
          '** Replication **',
          this.sprintf("Primary: %s\tReplag: %s(s)", primary, replag),
          '',
          '** Uptime **',
          this.sprintf("uptime: %s (s)\thuman: %sh and %sm",
                       uptime, uptimeHours, uptimeMinutes),
          '',
          '** Connections **',
          this.sprintf("Current: %s\tQueued: %s\t% read:%s\tLock Ratio: %s",
                       curConnections, totalQueues, readQueues/(totalQueues + 1), lockRatio),
          '',
          '** Asserts **',
          this.sprintf("User: %s\tWarning: %s" , userAsserts, warningAsserts),
    ].join("\n"));
  }
  , bind : function(name) {
    var self = this
      , fn = this[name];
    return function() {
      return fn.apply(self, self.$A(arguments));
    };
  }
};

prompt = (function() {
  var states = [
      "STARTUP", "PRIMARY", "SECONDARY", "RECOVERING", "FATAL",
      "STARTUP2", "UNKNOWN", "ARBITER", "DOWN", "ROLLBACK"
    ]
    , host = db.serverStatus().host.split('.')[0];

  return function() {
    var result = db.isMaster()
      , state;
    if (result.ismaster) {
      state = 'P';
    } else if (result.secondary) {
      state = 'S';
    } else {
      result = db.adminCommand({replSetGetstate : 1});
      state = states[result.myState];
    }
    return host + ':' + state + ' ' + db + '> ';
  };
})();

Global.summary();
// exports
var summary = Global.bind("summary");
