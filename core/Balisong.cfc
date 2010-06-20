<cfcomponent output="true">
<cfscript>
 
 
 public numeric function  count(string predicate, any collection){
    return _count(predicate,collection,0);
 }
 
 public any function _count(string predicate, any collection, numeric accumulator){
   collection = ensureArray( collection );
   for(item in collection){
   if( isArray(item) ) accumulator = _count(predicate, item, accumulator);
    else if(refindnocase(predicate,item)) ++accumulator;
   }
   return accumulator;
 }
 
 
 public any function filter(string predicate, any collection){
   if( isArray(collection) ) return _filterArray(predicate,collection, [] ); 
   if( isStruct(collection) ) return _filterStruct(predicate,collection, {} );  
   return collection; //Hmmm ... just echo? perhaps an exception would be better.
 }
 
 //slightly different implementation for arrays
 public any function _filterArray(string predicate, array collection, array accumulator){
   for(item in collection){
   if( isCollection(item) ) arrayAppend(accumulator, filter(predicate, item, accumulator) );
    else if(refindnocase(predicate, item)) arrayAppend(accumulator, item);
   }
   return accumulator;
 }
 
 //slightly different implementation for structs
 public any function _filterStruct(string predicate, struct collection, struct accumulator){
   for(item in collection){
   if( isCollection(collection[item]) ) structInsert(accumulator, item, filter(predicate, collection[item], accumulator) );
    else if (refindnocase(predicate, collection[item])) structInsert(accumulator, item, collection[item]);   
   }
   return accumulator;
 }
 
 
 //returns true if all elements in the collection that
 //match the predicate
 public boolean function all(string predicate, any collection){
   collection = ensureArray( collection );
   for(item in collection){
   if( isArray(item) && any(predicate,item) ) return true;
    else if (!refindnocase(predicate,item)>0) return false;
   }
   return true;
 }
 
 
 //returns true if any element is found in the collection that
 //matches the predicate
 public boolean function any(string predicate, any collection){
   collection = ensureArray( collection );
   for(item in collection){
   if( isArray(item) && any(predicate,item) ) return true;
    else if (refindnocase(predicate,item)>0) return true;
   }
   return false;
 }
 
 
 //returns true if an element exists in the collection
 public boolean function exists(any target, any collection){
   collection = ensureArray( collection );
   return arrayfindnocase( collection, target ); 
 }
 
 
 public boolean function isList(any l){
   return (isSimplevalue(l) && listLen(l));
 }
 
 public any function ensureArray(any l){
   if(isList(l)) return listToArray( duplicate(l));  
   return duplicate(l);
 }
 
 public any function clone(any o){
   return duplicate(o);
 }
 
 public function foldRight(array a, string op, numeric start){
   var accumulator =  start;
   //same as reducing but uses a custom accumulator
   return  reduce(a,op,accumulator,'right');
 }
 
 
 
 public function foldLeft(array a, string op, numeric start){
   var accumulator =  start;
     //same as reducing but uses a custom accumulator
   return  reduce(a,op,accumulator,'left');
 }
 
 
 
 public function reduceRight(array a, string op){
  var accumulator =  (op == '+')? 0 : 1;
   return  _reduceRight(a,op,accumulator);
 }
 
 
 public function _reduceRight(array a, string op, numeric accumulator){
   var i = 1;
   for(i=a.size(); i > 0; i--){
    if( isArray(a[i]) ) accumulator = _reduceRight(a[i], op, accumulator);
    else accumulator = evaluate(accumulator & op & a[i]); 
   }
  return accumulator;
 }
 
 
 
 public function reduce(array a, string op='+', numeric accumulator="0", string direction="left" ){
  return  (direction=='left')?_reduceLeft(a,op,accumulator):_reduceRight(a,op,accumulator);
 }
    
    
 public function reduceLeft(array a, string op='+' ){
  var accumulator =  (op == '+')? 0 : 1;
  return  _reduceLeft(a, op, accumulator );
 }
 
 
 private function _reduceLeft(array a, string op, numeric accumulator){
   var i = 1;
   for(i=1; i <= arrayLen(a); i++){
    if( isArray(a[i]) ) accumulator = _reduceLeft(a[i], op, accumulator);
    //else if( isStruct(a[i]) ) continue;
    else if (isNumeric(a[i])) accumulator = evaluate(accumulator & op & a[i]); 
   }
   return accumulator;
 }
 
 
 public function flatten(array a){
  return _flatten(a, []);
 }
 
 
 public function _flatten(array a, array accumulator){
  var item = chr(0);
  for(item in a){
   if( isArray(item) ) accumulator = _flatten( item, accumulator );
   else arrayAppend( accumulator, item);
  }
  return accumulator;
 }
 
 
 //concatonates N collections together. all args should be same type
 public function concat(){
   var c = ( isArray(arguments[1]) ) ? [] : {};
   var i = '';
   var j = '';
   for(i in arguments) 
    for (j in arguments[i]) 
     (isArray(c)) ? arrayAppend(c, j) : structInsert(c,j,arguments[i][j]); 
   return c;
 }
 
 
 // increments each numeric value in the array. if the value is not numeric, it just returns
 // the value.
 public function inc(any a){
   return apply(_inc,a); //would be nice to have a lambda or closure here
 }//
 
 
 public function _inc(any val){
  if( isNumeric(val) ) return ++val;
  return val;
 }//


 // executes the given function on each element of the list and returns a new list
 // this is semantically equivallent to map, but the syntax and name may be more intuitive
 // to English speakers ... apply a function to and array... vs. map array to function 
 public function apply(any func, any a){
  if (isStruct(a)) return _applyStruct(func, a);
  else return _applyListOrArray(func, a);
 }//

 
 private function isCollection(any coll){
   return ( isStruct(coll) || isArray(coll) );
 }
 
 
 private function _applyStruct(any func, any col){
   var item = chr(0);
   var _s = {};
   var _a = [];
   for(item in col){
   if( isStruct(col[item]) ) structInsert(_s, item, apply(func, col[item]) ); 
   else if( isArray(col[item]) ) { arrayAppend(_a, apply(func, col[item]) ); structInsert(_s,item,_a); }
    else structInsert( _s, item, func(col[item]) ); 
   }
  return _s;
 }//
 
 
 
 private function _applyListOrArray(any func, any a){
   var item = chr(0);
   var _a = [];
   var _s = {};
   a = ensureArray(a);
   for(item in a){
   if( isArray(item)) arrayAppend(_a, apply(func, item) ); 
   else if( isStruct(item) ) {structInsert(_s, 'item', apply(func, item) ); arrayAppend(_a, _s); }
    else arrayAppend( _a, func(item) ); 
   }
  return _a;
 }//
 
 
 
 // executes the given function on each element of the list
 public function foreach(a, func){
   var item = chr(0);
   for(item in a){
    if( isArray(item) ) apply(func, item) ; 
    else func(item); 
   }
 }//


</cfscript>
</cfcomponent>
