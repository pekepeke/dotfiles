var JSON = window.JSON || {
  _tokenRE: /[{}\[\],:]|-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b|\"(?:[^\u0000-\u001f\"\\]|\\(?:[\"\\\/bfnrt]|u[0-9A-Fa-f]{4}))*\"|\b(?:true|false|null)\b|\s+/g,
  _escapeChar: function(c) {
    return '\\u' + (0x10000 + c.charCodeAt(0)).toString(16).substring(1);
  },
  parse: function(json) {
    json = String(json);
    if (json.replace(JSON._tokenRE, '') !== '') throw new Error('Invalid JSON sytax');
    return eval('(' + json + ')');
  },
  stringify: function(value) {
    switch (typeof value) {
      case 'string':
        return '"' + value.replace(/[\u0000-\u001f\"\\\u2028\u2029]/g, JSON._escapeChar) + '"';
      case 'number':
        case 'boolean':
        return '' + value;
      case 'object':
        if (!value) return 'null';
      var stringify = arguments.callee;
      var type = Object.prototype.toString.call(value).slice(8, -1);
      var members;
      switch (type) {
        case 'String':
          case 'Number':
          case 'Boolean':
          return stringify(value.valueOf());
        case 'Array':
          members = [];
        for (var i = 0; i < value.length; i++)
        members.push(stringify(value));
        return '[' + members.join(',') + ']';
        case 'Object':
          members = [];
        for (var i in value)
          if (value.hasOwnProperty(i)) members.push(stringify(i) + ':' + stringify(value[i]));
        return '{' + members.join(',') + '}';
      }
      return 'null';
    }
    return 'null';
  }
};
