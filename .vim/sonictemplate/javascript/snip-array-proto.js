Array.prototype.forEach = Array.prototype.forEach || function(callback,thisObject){ for(var i=0,len=this.length;i<len;i++) callback.call(thisObject,this[i],i,this) };
Array.prototype.map = Array.prototype.map || function(callback,thisObject){ for(var i=0,res=[],len=this.length;i<len;i++) res[i] = callback.call(thisObject,this[i],i,this); return res;};
Array.prototype.filter = Array.prototype.filter || function(callback,thisObject){ for(var i=0,res=[],len=this.length;i<len;i++) callback.call(thisObject,this[i],i,this) && res.push(this[i]); return res; };
Array.prototype.some = Array.prototype.some || function(callback,thisObject){ for(var i=0,len=this.length;i<len;i++) if(callback.call(thisObject,this[i],i,this)) return true; return false;};
Array.prototype.shuffle = function() {
    var i = this.length;
    while(i){
        var j = Math.floor(Math.random()*i);
        var t = this[--i];
        this[i] = this[j];
        this[j] = t;
    }
    return this;
};
