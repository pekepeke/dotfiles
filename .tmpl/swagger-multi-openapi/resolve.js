#!/usr/bin/env node

'use strict';

var jsonRefs = require('json-refs');
var resolve = jsonRefs.resolveRefs;
var YAML = require('js-yaml');
var fs = require('fs');
var path = require('path')

var program = require('commander');

program
  .version('2.0.0')
  .option('-o --output-format [output]',
          'output format. Choices are "json" and "yaml" (Default is json)',
          'json')
  .option('-O --output [output file]',
          'output filename.',
          null)
  .option('-w --watch', 'watch file changes.', false)
  .usage('[options] <yaml file ...>')
  .parse(process.argv);

if (program.outputFormat !== 'json' && program.outputFormat !== 'yaml') {
  console.error(program.help());
  process.exit(1);
}

var file = program.args[0];

if (!fs.existsSync(file)) {
  console.error('File does not exist. ('+file+')');
  process.exit(1);
}

function renderSwaggerMulti(file, outputFile) {
  var root = YAML.safeLoad(fs.readFileSync(file).toString());
  var options = {
    filter        : ['relative', 'remote'],
    loaderOptions : {
      processContent : function (res, callback) {
        callback(null, YAML.safeLoad(res.text));
      }
    }
  };
  resolve(root, options).then(function (results) {
    var text;
    if (program.outputFormat === 'yaml') {
      text = YAML.safeDump(results.resolved);
    } else if (program.outputFormat === 'json') {
      text = JSON.stringify(results.resolved, null, 2);
    }
    jsonRefs.clearCache();
    if (outputFile) {
      fs.writeFileSync(outputFile, text)
      console.log((new Date()) + " - update: " + outputFile)
    } else {
      console.log(text)
    }
  });
}

if (program.watch) {
  var targetDir = path.dirname(file)
  fs.watch(targetDir, { recursive: true }, function(type, filename) {
    var ext = path.extname(filename);
    if (program.output == filename || (ext != ".yaml" && ext != ".yml")) {
      return
    }
    // console.log(type, filename, program.output)
    renderSwaggerMulti(file, program.output)
  })
} else {
  renderSwaggerMulti(file, program.output)
}

