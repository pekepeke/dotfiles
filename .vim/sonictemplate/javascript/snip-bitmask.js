function Bitmask() {
  var args = Array.prototype.slice.call(arguments, 0);
  if (this instanceof Bitmask) {
    this.initialize.apply(this, args);
  } else {
    return new Bitmask(args);
  }
}

Bitmask.prototype.initialize = function(names) {
  this.__state = 0;
  this._bitCounter = 1;
  var constants = this.constants = {};

  names = this._arrayArg(names, arguments);
  for (var i=0, l=names.length; i<l ; i++) {
    constants[names[i]] = this._bitCounter;
    this._bitCounter *= 2;
  }
  this.clear();
};

Bitmask.prototype.clear = function() {
  this.__state = 0;
  return this;
};

Bitmask.prototype.newInstance = function() {
  var instance = new Bitmask();
  instance.constants = this.constants;
  instance._bitCounter = this._bitCounter;
  return instance;
};

Bitmask.prototype.on = function(val) {
  this._visit(this.on, this._arrayArg(val, arguments));
  return this;
};

Bitmask.prototype.off = function(val) {
  this._visit(this.off, this._arrayArg(val, arguments));
  return this;
};

Bitmask.prototype.is = function(val) {
  var mask = this._getMask(val);
  return this.__state & mask;
};

Bitmask.prototype.and = function() {
  var flag, args = this._toArray(arguments);
  for (var i=0, l=args.length; i<l; i++) {
    flag = flag && this._on(args[i]);
    if (flag) {
      return flag;
    }
  }
  return flag;
};

Bitmask.prototype.or = function() {
  var flag, args = this._toArray(arguments);
  for (var i=0, l=args.length; i<l; i++) {
    flag = flag || this._on(args[i]);
    if (flag) {
      return flag;
    }
  }
  return flag;
};

Bitmask.prototype._getMask = function(val) {
  if (typeof val === "number") {
    return val;
  }
  return this.constants[val] || 0;
};

Bitmask.prototype._on = function(val) {
  var mask = this._getMask(val);
  this.__state |= mask;
};

Bitmask.prototype._off = function(val) {
  var mask = this._getMask(val);
  this.__state &= ~mask;
};

Bitmask.prototype._visit = function(method, args) {
  for (var i=0, l=args.length; i<l; i++) {
    method.call(this, args[i]);
  }
  return this;
};

Bitmask.prototype._toArray = function(args) {
  return Array.prototype.slice.call(args, 0);
};

Bitmask.prototype._arrayArg = function(arg1, args) {
  if (!arg1 instanceof Array) {
    arg1 = this._toArray(args);
  }
  return arg1;
};

