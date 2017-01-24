var Template = {
  // re: /{{(!)?\s*([^{}<> \t]+)?\s*}}/g,
  re: /<%(!)?\s*([^<%> \t]+)?\s*%>/g,
  // re: /\(\((!)?\s*([^\(\)<> \t]+)?\s*\)\)/g,
  render: function(tpl, vars) {
    var self = this;
    vars = vars || {};
    return tpl.replace(this.re, function(s, raw, key) {
      var v = vars[key] || "";
      return raw ? v : self.escape(v);
    });
  },
  escape: function(s) {
    if (typeof s !== 'string') {
      return s;
    }
    return s.replace(/[&'`"<>]/g, function(match) {
      return {
        '&': '&amp;',
        "'": '&#x27;',
        '`': '&#x60;',
        '"': '&quot;',
        '<': '&lt;',
        '>': '&gt;',
      }[match]
    });
  }
};

