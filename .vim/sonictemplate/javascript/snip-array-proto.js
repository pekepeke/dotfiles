Array.prototype.forEach = Array.prototype.forEach || function(callback,thisObject){ for(var i=0,len=this.length;i<len;i++) callback.call(thisObject,this[i],i,this) };
Array.prototype.map = Array.prototype.map || function(callback,thisObject){ for(var i=0,res=[],len=this.length;i<len;i++) res[i] = callback.call(thisObject,this[i],i,this); return res;};
Array.prototype.filter = Array.prototype.filter || function(callback,thisObject){ for(var i=0,res=[],len=this.length;i<len;i++) callback.call(thisObject,this[i],i,this) && res.push(this[i]); return res; };
Array.prototype.some = Array.prototype.some || function(callback,thisObject){ for(var i=0,len=this.length;i<len;i++) if(callback.call(thisObject,this[i],i,this)) return true; return false;};
Array.prototype.reduce = Array.prototype.reduce || function(callback) { var i, l = this.length, cur; if ((l <= 0 || l === null) && arguments.length <= 1) { throw new Error("invalid arguments", arguments); } if (arguments.length <= 1) { cur = this[0]; i = 1; } else { cur = arguments[1]; } for (var i= i || 0; i < l; i++) { cur = callback.call(this, cur, this[i], i, this); } return cur; };
Array.prototype.shuffle = function() { var r = Array.apply(null, this), i, l, j, tmp; for (i=0, l=r.length; i<l ;i++) { j = Math.floor(Math.random() * l); if (j==i) continue; tmp = r[j]; r[j] = r[i]; r[i] = tmp; } }

