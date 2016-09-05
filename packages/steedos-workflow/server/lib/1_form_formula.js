

Array.prototype.filterProperty = function(h, l){
    var g = [];
    this.forEach(function(t){
        var m = t? t[h]:null;
        var d = false;
        if(m instanceof Array){
            d = m.includes(l);
        }else{
            d = (l === undefined)? false:m==l;
        }
        if(d){
            g.push(t);
        }
    });
    return g;
};