Array.prototype.sortByName = function(){
    if(!this){return;}
    this.sort(function(p1,p2){
        return p1.name.localeCompare(p2.name);
    });
};