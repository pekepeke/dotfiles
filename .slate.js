/*global S: true, _:true*/

var LIB = {
  // http://mint.hateblo.jp/entry/2013/01/30/151918
  launchAndFocus : function(target) {
    return function (win) {
        var apps = [];
        S.eachApp(function (app) { apps.push(app.name()); });
        if (! _.find(apps, function (name) { return name === target; })) {
            win.doOperation(
                S.operation('shell', {
                    command: "/usr/bin/open -a " + target,
                    waithFoeExit: true
                })
            );
        }
        win.doOperation(S.operation('focus', { app: target }));
    };
  },
  cycleApp : function(focus_apps) {
    return function(win) {
      var app_name = win.app().name();

      if (!(app_name in focus_apps)) {return;}

        win.doOperation(
          S.operation('focus', {'app' : focus_apps[app_name]})
        );
    };
  }
};
var cas = ":cmd;ctrl";
S.bindAll({
  'g:cmd;ctrl' : S.op('grid'),
  'r:cmd;ctrl' : function() {
    S.src(".slate", true);
    S.src(".slate.js", true);
  },
});
