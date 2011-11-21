#!/usr/bin/env node

// http://subtech.g.hatena.ne.jp/cho45/20110708/1310121676
var JSHINT = require('./jshint.js').JSHINT;
var fs = require('fs');

var argv = process.argv;
argv.shift(); // node
argv.shift(); // $0

argv.forEach(function(filename) {
    var src = fs.readFileSync(filename, 'utf-8');
    var result = JSHINT(src, {
        browser : true,
        jquery : true,
        evil : true,
        laxbreak : true,
        passfail : false
    });

    if (!result) {
        JSHINT.errors.forEach(function(error) {
            if (!error) return;

            if (error.reason.indexOf('Stopping, unable to continue.') != -1) return;

            // 何これ？
            // if (error.reason.indexOf("Confusing use of '!'.") != -1) return;

            // for (var i...) の警告無視
            if (error.reason.indexOf("'i' is already defined.") != -1) return;
            if (error.reason.indexOf("'it' is already defined.") != -1) return;

            // 可読性のために意図的にそうしているのでうざいし、そういう最適化は実行エンジンがすべきこと
            if (error.reason.indexOf('is better written in dot notation') != -1) return;

            // 根拠がわからないので保留
            // if (error.reason.indexOf("Don't make functions within a loop") != -1) return;

            if (error.reason.indexOf('Mixed spaces and tabs') != -1) return;

            if (error.evidence) {
                error.evidence = error.evidence.replace(/\t/g, '    ');

                // 明示的に抑止されてるなら無視
                if (error.evidence.indexOf('no warnings') != -1) return;

                // やたら長い行は圧縮されたJSコードとみなす
                if (error.evidence.length > 1000) return;

                // 閉じブレース前のセミコロン警告無視 fn() {ret()}
                if (error.reason.indexOf('Missing semicolon') != -1 && error.evidence.substring(error.character).match(/^\s*\}/)) return;
        }

        console.log([filename, error.line, error.character].join(':') + "\t" + error.reason);
    });
}
});
