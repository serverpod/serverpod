(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q)){b[q]=a[q]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(Object.getPrototypeOf(r)&&Object.getPrototypeOf(r).p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++){inherit(b[s],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s){A.jI(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a){a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.et(b)
return new s(c,this)}:function(){if(s===null)s=A.et(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.et(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
ey(a,b,c,d){return{i:a,p:b,e:c,x:d}},
ev(a){var s,r,q,p,o,n=a[v.dispatchPropertyName]
if(n==null)if($.ew==null){A.jv()
n=a[v.dispatchPropertyName]}if(n!=null){s=n.p
if(!1===s)return n.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return n.i
if(n.e===r)throw A.b(A.eZ("Return interceptor for "+A.i(s(a,n))))}q=a.constructor
if(q==null)p=null
else{o=$.d8
if(o==null)o=$.d8=v.getIsolateTag("_$dart_js")
p=q[o]}if(p!=null)return p
p=A.jA(a)
if(p!=null)return p
if(typeof a=="function")return B.A
s=Object.getPrototypeOf(a)
if(s==null)return B.n
if(s===Object.prototype)return B.n
if(typeof q=="function"){o=$.d8
if(o==null)o=$.d8=v.getIsolateTag("_$dart_js")
Object.defineProperty(q,o,{value:B.i,enumerable:false,writable:true,configurable:true})
return B.i}return B.i},
hv(a,b){if(a<0||a>4294967295)throw A.b(A.E(a,0,4294967295,"length",null))
return J.hx(new Array(a),b)},
hw(a,b){if(a<0)throw A.b(A.U("Length must be a non-negative integer: "+a,null))
return A.k(new Array(a),b.j("o<0>"))},
hx(a,b){var s=A.k(a,b.j("o<0>"))
s.$flags=1
return s},
hy(a,b){return J.h7(a,b)},
ag(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.aL.prototype
return J.bA.prototype}if(typeof a=="string")return J.a8.prototype
if(a==null)return J.aM.prototype
if(typeof a=="boolean")return J.bz.prototype
if(Array.isArray(a))return J.o.prototype
if(typeof a!="object"){if(typeof a=="function")return J.X.prototype
if(typeof a=="symbol")return J.aQ.prototype
if(typeof a=="bigint")return J.aO.prototype
return a}if(a instanceof A.j)return a
return J.ev(a)},
cf(a){if(typeof a=="string")return J.a8.prototype
if(a==null)return a
if(Array.isArray(a))return J.o.prototype
if(typeof a!="object"){if(typeof a=="function")return J.X.prototype
if(typeof a=="symbol")return J.aQ.prototype
if(typeof a=="bigint")return J.aO.prototype
return a}if(a instanceof A.j)return a
return J.ev(a)},
eu(a){if(a==null)return a
if(Array.isArray(a))return J.o.prototype
if(typeof a!="object"){if(typeof a=="function")return J.X.prototype
if(typeof a=="symbol")return J.aQ.prototype
if(typeof a=="bigint")return J.aO.prototype
return a}if(a instanceof A.j)return a
return J.ev(a)},
jo(a){if(typeof a=="number")return J.aN.prototype
if(typeof a=="string")return J.a8.prototype
if(a==null)return a
if(!(a instanceof A.j))return J.ap.prototype
return a},
F(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.ag(a).E(a,b)},
h5(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.jy(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.cf(a).k(a,b)},
h6(a,b){return J.eu(a).W(a,b)},
h7(a,b){return J.jo(a).aG(a,b)},
h8(a,b){return J.cf(a).N(a,b)},
eC(a,b){return J.eu(a).D(a,b)},
T(a){return J.ag(a).gp(a)},
aD(a){return J.eu(a).gv(a)},
cg(a){return J.cf(a).gl(a)},
h9(a){return J.ag(a).gq(a)},
ak(a){return J.ag(a).h(a)},
by:function by(){},
bz:function bz(){},
aM:function aM(){},
aP:function aP(){},
Y:function Y(){},
bP:function bP(){},
ap:function ap(){},
X:function X(){},
aO:function aO(){},
aQ:function aQ(){},
o:function o(a){this.$ti=a},
cv:function cv(a){this.$ti=a},
V:function V(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
aN:function aN(){},
aL:function aL(){},
bA:function bA(){},
a8:function a8(){}},A={e1:function e1(){},
hc(a,b,c){if(t.U.b(a))return new A.b4(a,b.j("@<0>").C(c).j("b4<1,2>"))
return new A.a6(a,b.j("@<0>").C(c).j("a6<1,2>"))},
eL(a){return new A.bC("Field '"+a+"' has been assigned during initialization.")},
dJ(a){var s,r=a^48
if(r<=9)return r
s=a|32
if(97<=s&&s<=102)return s-87
return-1},
a_(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
e8(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
es(a,b,c){return a},
ex(a){var s,r
for(s=$.ai.length,r=0;r<s;++r)if(a===$.ai[r])return!0
return!1},
hr(){return new A.b0("No element")},
a0:function a0(){},
br:function br(a,b){this.a=a
this.$ti=b},
a6:function a6(a,b){this.a=a
this.$ti=b},
b4:function b4(a,b){this.a=a
this.$ti=b},
b3:function b3(){},
M:function M(a,b){this.a=a
this.$ti=b},
bC:function bC(a){this.a=a},
bs:function bs(a){this.a=a},
cE:function cE(){},
c:function c(){},
I:function I(){},
am:function am(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
ab:function ab(a,b,c){this.a=a
this.b=b
this.$ti=c},
aK:function aK(){},
bV:function bV(){},
aq:function aq(){},
bj:function bj(){},
hi(){throw A.b(A.cJ("Cannot modify unmodifiable Map"))},
fP(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
jy(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.p.b(a)},
i(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.ak(a)
return s},
bQ(a){var s,r=$.eP
if(r==null)r=$.eP=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
eQ(a,b){var s,r,q,p,o,n=null,m=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(m==null)return n
s=m[3]
if(b==null){if(s!=null)return parseInt(a,10)
if(m[2]!=null)return parseInt(a,16)
return n}if(b<2||b>36)throw A.b(A.E(b,2,36,"radix",n))
if(b===10&&s!=null)return parseInt(a,10)
if(b<10||s==null){r=b<=10?47+b:86+b
q=m[1]
for(p=q.length,o=0;o<p;++o)if((q.charCodeAt(o)|32)>r)return n}return parseInt(a,b)},
cD(a){var s,r,q,p
if(a instanceof A.j)return A.D(A.aA(a),null)
s=J.ag(a)
if(s===B.z||s===B.B||t.o.b(a)){r=B.k(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.D(A.aA(a),null)},
eR(a){if(a==null||typeof a=="number"||A.en(a))return J.ak(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.a7)return a.h(0)
if(a instanceof A.b9)return a.aE(!0)
return"Instance of '"+A.cD(a)+"'"},
hE(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
O(a){var s
if(0<=a){if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.c.aa(s,10)|55296)>>>0,s&1023|56320)}}throw A.b(A.E(a,0,1114111,null,null))},
hD(a){var s=a.$thrownJsError
if(s==null)return null
return A.az(s)},
eS(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.x(a,s)
a.$thrownJsError=s
s.stack=b.h(0)}},
fJ(a,b){var s,r="index"
if(!A.fv(b))return new A.G(!0,b,r,null)
s=J.cg(a)
if(b<0||b>=s)return A.e_(b,s,a,r)
return A.hF(b,r)},
jl(a,b,c){if(a>c)return A.E(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.E(b,a,c,"end",null)
return new A.G(!0,b,"end",null)},
jf(a){return new A.G(!0,a,null,null)},
b(a){return A.x(a,new Error())},
x(a,b){var s
if(a==null)a=new A.P()
b.dartException=a
s=A.jJ
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
jJ(){return J.ak(this.dartException)},
ez(a,b){throw A.x(a,b==null?new Error():b)},
aC(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.ez(A.iE(a,b,c),s)},
iE(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.j.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.b1("'"+s+"': Cannot "+o+" "+l+k+n)},
dX(a){throw A.b(A.al(a))},
Q(a){var s,r,q,p,o,n
a=A.jE(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.k([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.cH(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
cI(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
eY(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
e2(a,b){var s=b==null,r=s?null:b.method
return new A.bB(a,r,s?null:b.receiver)},
aj(a){if(a==null)return new A.cC(a)
if(a instanceof A.aJ)return A.a5(a,a.a)
if(typeof a!=="object")return a
if("dartException" in a)return A.a5(a,a.dartException)
return A.je(a)},
a5(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
je(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.c.aa(r,16)&8191)===10)switch(q){case 438:return A.a5(a,A.e2(A.i(s)+" (Error "+q+")",null))
case 445:case 5007:A.i(s)
return A.a5(a,new A.aY())}}if(a instanceof TypeError){p=$.fQ()
o=$.fR()
n=$.fS()
m=$.fT()
l=$.fW()
k=$.fX()
j=$.fV()
$.fU()
i=$.fZ()
h=$.fY()
g=p.B(s)
if(g!=null)return A.a5(a,A.e2(s,g))
else{g=o.B(s)
if(g!=null){g.method="call"
return A.a5(a,A.e2(s,g))}else if(n.B(s)!=null||m.B(s)!=null||l.B(s)!=null||k.B(s)!=null||j.B(s)!=null||m.B(s)!=null||i.B(s)!=null||h.B(s)!=null)return A.a5(a,new A.aY())}return A.a5(a,new A.bU(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.b_()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.a5(a,new A.G(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.b_()
return a},
az(a){var s
if(a instanceof A.aJ)return a.b
if(a==null)return new A.ba(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.ba(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
fM(a){if(a==null)return J.T(a)
if(typeof a=="object")return A.bQ(a)
return J.T(a)},
jn(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.A(0,a[s],a[r])}return b},
iS(a,b,c,d,e,f){switch(b){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.b(new A.cY("Unsupported number of arguments for wrapped closure"))},
ay(a,b){var s=a.$identity
if(!!s)return s
s=A.jj(a,b)
a.$identity=s
return s},
jj(a,b){var s
switch(b){case 0:s=a.$0
break
case 1:s=a.$1
break
case 2:s=a.$2
break
case 3:s=a.$3
break
case 4:s=a.$4
break
default:s=null}if(s!=null)return s.bind(a)
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.iS)},
hh(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.cF().constructor.prototype):Object.create(new A.aE(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.eJ(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.hd(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.eJ(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
hd(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.b("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.ha)}throw A.b("Error in functionType of tearoff")},
he(a,b,c,d){var s=A.eI
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
eJ(a,b,c,d){if(c)return A.hg(a,b,d)
return A.he(b.length,d,a,b)},
hf(a,b,c,d){var s=A.eI,r=A.hb
switch(b?-1:a){case 0:throw A.b(new A.bS("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
hg(a,b,c){var s,r
if($.eG==null)$.eG=A.eF("interceptor")
if($.eH==null)$.eH=A.eF("receiver")
s=b.length
r=A.hf(s,c,a,b)
return r},
et(a){return A.hh(a)},
ha(a,b){return A.bf(v.typeUniverse,A.aA(a.a),b)},
eI(a){return a.a},
hb(a){return a.b},
eF(a){var s,r,q,p=new A.aE("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.b(A.U("Field name "+a+" not found.",null))},
jp(a){return v.getIsolateTag(a)},
jA(a){var s,r,q,p,o,n=$.fK.$1(a),m=$.dI[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.dS[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=$.fG.$2(a,n)
if(q!=null){m=$.dI[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.dS[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.dT(s)
$.dI[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.dS[n]=s
return s}if(p==="-"){o=A.dT(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.fN(a,s)
if(p==="*")throw A.b(A.eZ(n))
if(v.leafTags[n]===true){o=A.dT(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.fN(a,s)},
fN(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.ey(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
dT(a){return J.ey(a,!1,null,!!a.$iC)},
jC(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.dT(s)
else return J.ey(s,c,null,null)},
jv(){if(!0===$.ew)return
$.ew=!0
A.jw()},
jw(){var s,r,q,p,o,n,m,l
$.dI=Object.create(null)
$.dS=Object.create(null)
A.ju()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.fO.$1(o)
if(n!=null){m=A.jC(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
ju(){var s,r,q,p,o,n,m=B.p()
m=A.ax(B.q,A.ax(B.r,A.ax(B.l,A.ax(B.l,A.ax(B.t,A.ax(B.u,A.ax(B.v(B.k),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.fK=new A.dK(p)
$.fG=new A.dL(o)
$.fO=new A.dM(n)},
ax(a,b){return a(b)||b},
jk(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
eK(a,b,c,d,e,f){var s=b?"m":"",r=c?"":"i",q=d?"u":"",p=e?"s":"",o=function(g,h){try{return new RegExp(g,h)}catch(n){return n}}(a,s+r+q+p+f)
if(o instanceof RegExp)return o
throw A.b(A.y("Illegal RegExp pattern ("+String(o)+")",a,null))},
jG(a,b,c){var s=a.indexOf(b,c)
return s>=0},
jE(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
fD(a){return a},
jH(a,b,c,d){var s,r,q,p=new A.cS(b,a,0),o=t.F,n=0,m=""
for(;p.m();){s=p.d
if(s==null)s=o.a(s)
r=s.b
q=r.index
m=m+A.i(A.fD(B.a.i(a,n,q)))+A.i(c.$1(s))
n=q+r[0].length}p=m+A.i(A.fD(B.a.K(a,n)))
return p.charCodeAt(0)==0?p:p},
c8:function c8(a,b){this.a=a
this.b=b},
aF:function aF(){},
aH:function aH(a,b,c){this.a=a
this.b=b
this.$ti=c},
c5:function c5(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
aG:function aG(){},
aI:function aI(a,b,c){this.a=a
this.b=b
this.$ti=c},
cH:function cH(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
aY:function aY(){},
bB:function bB(a,b,c){this.a=a
this.b=b
this.c=c},
bU:function bU(a){this.a=a},
cC:function cC(a){this.a=a},
aJ:function aJ(a,b){this.a=a
this.b=b},
ba:function ba(a){this.a=a
this.b=null},
a7:function a7(){},
cj:function cj(){},
ck:function ck(){},
cG:function cG(){},
cF:function cF(){},
aE:function aE(a,b){this.a=a
this.b=b},
bS:function bS(a){this.a=a},
a9:function a9(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
cy:function cy(a,b){this.a=a
this.b=b
this.c=null},
aa:function aa(a,b){this.a=a
this.$ti=b},
bD:function bD(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
aS:function aS(a,b){this.a=a
this.$ti=b},
aR:function aR(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
dK:function dK(a){this.a=a},
dL:function dL(a){this.a=a},
dM:function dM(a){this.a=a},
b9:function b9(){},
c7:function c7(){},
cu:function cu(a,b){var _=this
_.a=a
_.b=b
_.e=_.d=_.c=null},
c6:function c6(a){this.b=a},
cS:function cS(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
iF(a){return a},
hA(a){return new Int8Array(a)},
hB(a){return new Uint8Array(a)},
ad(a,b,c){if(a>>>0!==a||a>=c)throw A.b(A.fJ(b,a))},
iC(a,b,c){var s
if(!(a>>>0!==a))s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.b(A.jl(a,b,c))
return b},
bE:function bE(){},
aW:function aW(){},
bF:function bF(){},
an:function an(){},
aU:function aU(){},
aV:function aV(){},
bG:function bG(){},
bH:function bH(){},
bI:function bI(){},
bJ:function bJ(){},
bK:function bK(){},
bL:function bL(){},
bM:function bM(){},
aX:function aX(){},
bN:function bN(){},
b5:function b5(){},
b6:function b6(){},
b7:function b7(){},
b8:function b8(){},
e7(a,b){var s=b.c
return s==null?b.c=A.bd(a,"W",[b.x]):s},
eU(a){var s=a.w
if(s===6||s===7)return A.eU(a.x)
return s===11||s===12},
hG(a){return a.as},
ce(a){return A.dl(v.typeUniverse,a,!1)},
ae(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.ae(a1,s,a3,a4)
if(r===s)return a2
return A.fa(a1,r,!0)
case 7:s=a2.x
r=A.ae(a1,s,a3,a4)
if(r===s)return a2
return A.f9(a1,r,!0)
case 8:q=a2.y
p=A.aw(a1,q,a3,a4)
if(p===q)return a2
return A.bd(a1,a2.x,p)
case 9:o=a2.x
n=A.ae(a1,o,a3,a4)
m=a2.y
l=A.aw(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.eb(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.aw(a1,j,a3,a4)
if(i===j)return a2
return A.fb(a1,k,i)
case 11:h=a2.x
g=A.ae(a1,h,a3,a4)
f=a2.y
e=A.jb(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.f8(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.aw(a1,d,a3,a4)
o=a2.x
n=A.ae(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.ec(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.b(A.bq("Attempted to substitute unexpected RTI kind "+a0))}},
aw(a,b,c,d){var s,r,q,p,o=b.length,n=A.du(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.ae(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
jc(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.du(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.ae(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
jb(a,b,c,d){var s,r=b.a,q=A.aw(a,r,c,d),p=b.b,o=A.aw(a,p,c,d),n=b.c,m=A.jc(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.c2()
s.a=q
s.b=o
s.c=m
return s},
k(a,b){a[v.arrayRti]=b
return a},
fI(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.jr(s)
return a.$S()}return null},
jx(a,b){var s
if(A.eU(b))if(a instanceof A.a7){s=A.fI(a)
if(s!=null)return s}return A.aA(a)},
aA(a){if(a instanceof A.j)return A.S(a)
if(Array.isArray(a))return A.a2(a)
return A.em(J.ag(a))},
a2(a){var s=a[v.arrayRti],r=t.b
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
S(a){var s=a.$ti
return s!=null?s:A.em(a)},
em(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.iO(a,s)},
iO(a,b){var s=a instanceof A.a7?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.i6(v.typeUniverse,s.name)
b.$ccache=r
return r},
jr(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.dl(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
jq(a){return A.af(A.S(a))},
eq(a){var s
if(a instanceof A.b9)return A.jm(a.$r,a.aw())
s=a instanceof A.a7?A.fI(a):null
if(s!=null)return s
if(t.k.b(a))return J.h9(a).a
if(Array.isArray(a))return A.a2(a)
return A.aA(a)},
af(a){var s=a.r
return s==null?a.r=new A.dk(a):s},
jm(a,b){var s,r,q=b,p=q.length
if(p===0)return t.d
s=A.bf(v.typeUniverse,A.eq(q[0]),"@<0>")
for(r=1;r<p;++r)s=A.fc(v.typeUniverse,s,A.eq(q[r]))
return A.bf(v.typeUniverse,s,a)},
K(a){return A.af(A.dl(v.typeUniverse,a,!1))},
iN(a){var s,r,q,p,o=this
if(o===t.K)return A.R(o,a,A.iX)
if(A.ah(o))return A.R(o,a,A.j0)
s=o.w
if(s===6)return A.R(o,a,A.iJ)
if(s===1)return A.R(o,a,A.fw)
if(s===7)return A.R(o,a,A.iT)
if(o===t.S)r=A.fv
else if(o===t.i||o===t.H)r=A.iW
else if(o===t.N)r=A.iZ
else r=o===t.y?A.en:null
if(r!=null)return A.R(o,a,r)
if(s===8){q=o.x
if(o.y.every(A.ah)){o.f="$i"+q
if(q==="f")return A.R(o,a,A.iV)
return A.R(o,a,A.j_)}}else if(s===10){p=A.jk(o.x,o.y)
return A.R(o,a,p==null?A.fw:p)}return A.R(o,a,A.iH)},
R(a,b,c){a.b=c
return a.b(b)},
iM(a){var s=this,r=A.iG
if(A.ah(s))r=A.iz
else if(s===t.K)r=A.iy
else if(A.aB(s))r=A.iI
if(s===t.S)r=A.ei
else if(s===t.x)r=A.ej
else if(s===t.N)r=A.ek
else if(s===t.w)r=A.fn
else if(s===t.y)r=A.is
else if(s===t.u)r=A.it
else if(s===t.H)r=A.iw
else if(s===t.n)r=A.ix
else if(s===t.i)r=A.iu
else if(s===t.I)r=A.iv
s.a=r
return s.a(a)},
iH(a){var s=this
if(a==null)return A.aB(s)
return A.jz(v.typeUniverse,A.jx(a,s),s)},
iJ(a){if(a==null)return!0
return this.x.b(a)},
j_(a){var s,r=this
if(a==null)return A.aB(r)
s=r.f
if(a instanceof A.j)return!!a[s]
return!!J.ag(a)[s]},
iV(a){var s,r=this
if(a==null)return A.aB(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.j)return!!a[s]
return!!J.ag(a)[s]},
iG(a){var s=this
if(a==null){if(A.aB(s))return a}else if(s.b(a))return a
throw A.x(A.fs(a,s),new Error())},
iI(a){var s=this
if(a==null||s.b(a))return a
throw A.x(A.fs(a,s),new Error())},
fs(a,b){return new A.bb("TypeError: "+A.f2(a,A.D(b,null)))},
f2(a,b){return A.cn(a)+": type '"+A.D(A.eq(a),null)+"' is not a subtype of type '"+b+"'"},
L(a,b){return new A.bb("TypeError: "+A.f2(a,b))},
iT(a){var s=this
return s.x.b(a)||A.e7(v.typeUniverse,s).b(a)},
iX(a){return a!=null},
iy(a){if(a!=null)return a
throw A.x(A.L(a,"Object"),new Error())},
j0(a){return!0},
iz(a){return a},
fw(a){return!1},
en(a){return!0===a||!1===a},
is(a){if(!0===a)return!0
if(!1===a)return!1
throw A.x(A.L(a,"bool"),new Error())},
it(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.x(A.L(a,"bool?"),new Error())},
iu(a){if(typeof a=="number")return a
throw A.x(A.L(a,"double"),new Error())},
iv(a){if(typeof a=="number")return a
if(a==null)return a
throw A.x(A.L(a,"double?"),new Error())},
fv(a){return typeof a=="number"&&Math.floor(a)===a},
ei(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.x(A.L(a,"int"),new Error())},
ej(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.x(A.L(a,"int?"),new Error())},
iW(a){return typeof a=="number"},
iw(a){if(typeof a=="number")return a
throw A.x(A.L(a,"num"),new Error())},
ix(a){if(typeof a=="number")return a
if(a==null)return a
throw A.x(A.L(a,"num?"),new Error())},
iZ(a){return typeof a=="string"},
ek(a){if(typeof a=="string")return a
throw A.x(A.L(a,"String"),new Error())},
fn(a){if(typeof a=="string")return a
if(a==null)return a
throw A.x(A.L(a,"String?"),new Error())},
fA(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.D(a[q],b)
return s},
j5(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.fA(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.D(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
ft(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=", ",a0=null
if(a3!=null){s=a3.length
if(a2==null)a2=A.k([],t.s)
else a0=a2.length
r=a2.length
for(q=s;q>0;--q)a2.push("T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a){o=o+n+a2[a2.length-1-q]
m=a3[q]
l=m.w
if(!(l===2||l===3||l===4||l===5||m===p))o+=" extends "+A.D(m,a2)}o+=">"}else o=""
p=a1.x
k=a1.y
j=k.a
i=j.length
h=k.b
g=h.length
f=k.c
e=f.length
d=A.D(p,a2)
for(c="",b="",q=0;q<i;++q,b=a)c+=b+A.D(j[q],a2)
if(g>0){c+=b+"["
for(b="",q=0;q<g;++q,b=a)c+=b+A.D(h[q],a2)
c+="]"}if(e>0){c+=b+"{"
for(b="",q=0;q<e;q+=3,b=a){c+=b
if(f[q+1])c+="required "
c+=A.D(f[q+2],a2)+" "+f[q]}c+="}"}if(a0!=null){a2.toString
a2.length=a0}return o+"("+c+") => "+d},
D(a,b){var s,r,q,p,o,n,m=a.w
if(m===5)return"erased"
if(m===2)return"dynamic"
if(m===3)return"void"
if(m===1)return"Never"
if(m===4)return"any"
if(m===6){s=a.x
r=A.D(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(m===7)return"FutureOr<"+A.D(a.x,b)+">"
if(m===8){p=A.jd(a.x)
o=a.y
return o.length>0?p+("<"+A.fA(o,b)+">"):p}if(m===10)return A.j5(a,b)
if(m===11)return A.ft(a,b,null)
if(m===12)return A.ft(a.x,b,a.y)
if(m===13){n=a.x
return b[b.length-1-n]}return"?"},
jd(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
i7(a,b){var s=a.tR[b]
for(;typeof s=="string";)s=a.tR[s]
return s},
i6(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.dl(a,b,!1)
else if(typeof m=="number"){s=m
r=A.be(a,5,"#")
q=A.du(s)
for(p=0;p<s;++p)q[p]=r
o=A.bd(a,b,q)
n[b]=o
return o}else return m},
i5(a,b){return A.fl(a.tR,b)},
i4(a,b){return A.fl(a.eT,b)},
dl(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.f6(A.f4(a,null,b,!1))
r.set(b,s)
return s},
bf(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.f6(A.f4(a,b,c,!0))
q.set(c,r)
return r},
fc(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.eb(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
a1(a,b){b.a=A.iM
b.b=A.iN
return b},
be(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.J(null,null)
s.w=b
s.as=c
r=A.a1(a,s)
a.eC.set(c,r)
return r},
fa(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.i2(a,b,r,c)
a.eC.set(r,s)
return s},
i2(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.ah(b))if(!(b===t.P||b===t.T))if(s!==6)r=s===7&&A.aB(b.x)
if(r)return b
else if(s===1)return t.P}q=new A.J(null,null)
q.w=6
q.x=b
q.as=c
return A.a1(a,q)},
f9(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.i0(a,b,r,c)
a.eC.set(r,s)
return s},
i0(a,b,c,d){var s,r
if(d){s=b.w
if(A.ah(b)||b===t.K)return b
else if(s===1)return A.bd(a,"W",[b])
else if(b===t.P||b===t.T)return t.W}r=new A.J(null,null)
r.w=7
r.x=b
r.as=c
return A.a1(a,r)},
i3(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.J(null,null)
s.w=13
s.x=b
s.as=q
r=A.a1(a,s)
a.eC.set(q,r)
return r},
bc(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
i_(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
bd(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.bc(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.J(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.a1(a,r)
a.eC.set(p,q)
return q},
eb(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.bc(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.J(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.a1(a,o)
a.eC.set(q,n)
return n},
fb(a,b,c){var s,r,q="+"+(b+"("+A.bc(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.J(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.a1(a,s)
a.eC.set(q,r)
return r},
f8(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.bc(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.bc(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.i_(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.J(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.a1(a,p)
a.eC.set(r,o)
return o},
ec(a,b,c,d){var s,r=b.as+("<"+A.bc(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.i1(a,b,c,r,d)
a.eC.set(r,s)
return s},
i1(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.du(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.ae(a,b,r,0)
m=A.aw(a,c,r,0)
return A.ec(a,n,m,c!==m)}}l=new A.J(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.a1(a,l)},
f4(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
f6(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.hU(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.f5(a,r,l,k,!1)
else if(q===46)r=A.f5(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.ac(a.u,a.e,k.pop()))
break
case 94:k.push(A.i3(a.u,k.pop()))
break
case 35:k.push(A.be(a.u,5,"#"))
break
case 64:k.push(A.be(a.u,2,"@"))
break
case 126:k.push(A.be(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.hW(a,k)
break
case 38:A.hV(a,k)
break
case 63:p=a.u
k.push(A.fa(p,A.ac(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.f9(p,A.ac(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.hT(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.f7(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.hY(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-2)
break
case 43:n=l.indexOf("(",r)
k.push(l.substring(r,n))
k.push(-4)
k.push(a.p)
a.p=k.length
r=n+1
break
default:throw"Bad character "+q}}}m=k.pop()
return A.ac(a.u,a.e,m)},
hU(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
f5(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.i7(s,o.x)[p]
if(n==null)A.ez('No "'+p+'" in "'+A.hG(o)+'"')
d.push(A.bf(s,o,n))}else d.push(p)
return m},
hW(a,b){var s,r=a.u,q=A.f3(a,b),p=b.pop()
if(typeof p=="string")b.push(A.bd(r,p,q))
else{s=A.ac(r,a.e,p)
switch(s.w){case 11:b.push(A.ec(r,s,q,a.n))
break
default:b.push(A.eb(r,s,q))
break}}},
hT(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.f3(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.ac(p,a.e,o)
q=new A.c2()
q.a=s
q.b=n
q.c=m
b.push(A.f8(p,r,q))
return
case-4:b.push(A.fb(p,b.pop(),s))
return
default:throw A.b(A.bq("Unexpected state under `()`: "+A.i(o)))}},
hV(a,b){var s=b.pop()
if(0===s){b.push(A.be(a.u,1,"0&"))
return}if(1===s){b.push(A.be(a.u,4,"1&"))
return}throw A.b(A.bq("Unexpected extended operation "+A.i(s)))},
f3(a,b){var s=b.splice(a.p)
A.f7(a.u,a.e,s)
a.p=b.pop()
return s},
ac(a,b,c){if(typeof c=="string")return A.bd(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.hX(a,b,c)}else return c},
f7(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.ac(a,b,c[s])},
hY(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.ac(a,b,c[s])},
hX(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.b(A.bq("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.b(A.bq("Bad index "+c+" for "+b.h(0)))},
jz(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.u(a,b,null,c,null)
r.set(c,s)}return s},
u(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.ah(d))return!0
s=b.w
if(s===4)return!0
if(A.ah(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.u(a,c[b.x],c,d,e))return!0
q=d.w
p=t.P
if(b===p||b===t.T){if(q===7)return A.u(a,b,c,d.x,e)
return d===p||d===t.T||q===6}if(d===t.K){if(s===7)return A.u(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.u(a,b.x,c,d,e))return!1
return A.u(a,A.e7(a,b),c,d,e)}if(s===6)return A.u(a,p,c,d,e)&&A.u(a,b.x,c,d,e)
if(q===7){if(A.u(a,b,c,d.x,e))return!0
return A.u(a,b,c,A.e7(a,d),e)}if(q===6)return A.u(a,b,c,p,e)||A.u(a,b,c,d.x,e)
if(r)return!1
p=s!==11
if((!p||s===12)&&d===t.Z)return!0
o=s===10
if(o&&d===t.L)return!0
if(q===12){if(b===t.g)return!0
if(s!==12)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.u(a,j,c,i,e)||!A.u(a,i,e,j,c))return!1}return A.fu(a,b.x,c,d.x,e)}if(q===11){if(b===t.g)return!0
if(p)return!1
return A.fu(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.iU(a,b,c,d,e)}if(o&&q===10)return A.iY(a,b,c,d,e)
return!1},
fu(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.u(a3,a4.x,a5,a6.x,a7))return!1
s=a4.y
r=a6.y
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.u(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.u(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.u(a3,k[h],a7,g,a5))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;!0;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
a2=f[b-2]
if(a1<a0){if(a2)return!1
continue}g=e[a+1]
if(a2&&!g)return!1
g=f[b-1]
if(!A.u(a3,e[a+2],a7,g,a5))return!1
break}}for(;b<d;){if(f[b+1])return!1
b+=3}return!0},
iU(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
for(;n!==m;){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.bf(a,b,r[o])
return A.fm(a,p,null,c,d.y,e)}return A.fm(a,b.y,null,c,d.y,e)},
fm(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.u(a,b[s],d,e[s],f))return!1
return!0},
iY(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.u(a,r[s],c,q[s],e))return!1
return!0},
aB(a){var s=a.w,r=!0
if(!(a===t.P||a===t.T))if(!A.ah(a))if(s!==6)r=s===7&&A.aB(a.x)
return r},
ah(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
fl(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
du(a){return a>0?new Array(a):v.typeUniverse.sEA},
J:function J(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
c2:function c2(){this.c=this.b=this.a=null},
dk:function dk(a){this.a=a},
c1:function c1(){},
bb:function bb(a){this.a=a},
hP(){var s,r,q
if(self.scheduleImmediate!=null)return A.jg()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.ay(new A.cU(s),1)).observe(r,{childList:true})
return new A.cT(s,r,q)}else if(self.setImmediate!=null)return A.jh()
return A.ji()},
hQ(a){self.scheduleImmediate(A.ay(new A.cV(a),0))},
hR(a){self.setImmediate(A.ay(new A.cW(a),0))},
hS(a){A.hZ(0,a)},
hZ(a,b){var s=new A.di()
s.b8(a,b)
return s},
fy(a){return new A.bY(new A.v($.p,a.j("v<0>")),a.j("bY<0>"))},
fr(a,b){a.$2(0,null)
b.b=!0
return b.a},
fo(a,b){A.iA(a,b)},
fq(a,b){b.ac(a)},
fp(a,b){b.ad(A.aj(a),A.az(a))},
iA(a,b){var s,r,q=new A.dw(b),p=new A.dx(b)
if(a instanceof A.v)a.aD(q,p,t.z)
else{s=t.z
if(a instanceof A.v)a.ao(q,p,s)
else{r=new A.v($.p,t.c)
r.a=8
r.c=a
r.aD(q,p,s)}}},
fF(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.p.aW(new A.dH(s))},
dZ(a){var s
if(t.C.b(a)){s=a.gJ()
if(s!=null)return s}return B.f},
iP(a,b){if($.p===B.d)return null
return null},
iQ(a,b){if($.p!==B.d)A.iP(a,b)
if(b==null)if(t.C.b(a)){b=a.gJ()
if(b==null){A.eS(a,B.f)
b=B.f}}else b=B.f
else if(t.C.b(a))A.eS(a,b)
return new A.H(a,b)},
e9(a,b,c){var s,r,q,p={},o=p.a=a
for(;s=o.a,(s&4)!==0;){o=o.c
p.a=o}if(o===b){s=A.hH()
b.a3(new A.H(new A.G(!0,o,null,"Cannot complete a future with itself"),s))
return}r=b.a&1
s=o.a=s|r
if((s&24)===0){q=b.c
b.a=b.a&1|4
b.c=o
o.aA(q)
return}if(!c)if(b.c==null)o=(s&16)===0||r!==0
else o=!1
else o=!0
if(o){q=b.T()
b.S(p.a)
A.at(b,q)
return}b.a^=2
A.cd(null,null,b.b,new A.d1(p,b))},
at(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g={},f=g.a=a
for(;!0;){s={}
r=f.a
q=(r&16)===0
p=!q
if(b==null){if(p&&(r&1)===0){f=f.c
A.ep(f.a,f.b)}return}s.a=b
o=b.a
for(f=b;o!=null;f=o,o=n){f.a=null
A.at(g.a,f)
s.a=o
n=o.a}r=g.a
m=r.c
s.b=p
s.c=m
if(q){l=f.c
l=(l&1)!==0||(l&15)===8}else l=!0
if(l){k=f.b.b
if(p){r=r.b===k
r=!(r||r)}else r=!1
if(r){A.ep(m.a,m.b)
return}j=$.p
if(j!==k)$.p=k
else j=null
f=f.c
if((f&15)===8)new A.d5(s,g,p).$0()
else if(q){if((f&1)!==0)new A.d4(s,m).$0()}else if((f&2)!==0)new A.d3(g,s).$0()
if(j!=null)$.p=j
f=s.c
if(f instanceof A.v){r=s.a.$ti
r=r.j("W<2>").b(f)||!r.y[1].b(f)}else r=!1
if(r){i=s.a.b
if((f.a&24)!==0){h=i.c
i.c=null
b=i.U(h)
i.a=f.a&30|i.a&1
i.c=f.c
g.a=f
continue}else A.e9(f,i,!0)
return}}i=s.a.b
h=i.c
i.c=null
b=i.U(h)
f=s.b
r=s.c
if(!f){i.a=8
i.c=r}else{i.a=i.a&1|16
i.c=r}g.a=i
f=i}},
j6(a,b){if(t.Q.b(a))return b.aW(a)
if(t.v.b(a))return a
throw A.b(A.eD(a,"onError",u.c))},
j3(){var s,r
for(s=$.av;s!=null;s=$.av){$.bl=null
r=s.b
$.av=r
if(r==null)$.bk=null
s.a.$0()}},
ja(){$.eo=!0
try{A.j3()}finally{$.bl=null
$.eo=!1
if($.av!=null)$.eB().$1(A.fH())}},
fC(a){var s=new A.bZ(a),r=$.bk
if(r==null){$.av=$.bk=s
if(!$.eo)$.eB().$1(A.fH())}else $.bk=r.b=s},
j9(a){var s,r,q,p=$.av
if(p==null){A.fC(a)
$.bl=$.bk
return}s=new A.bZ(a)
r=$.bl
if(r==null){s.b=p
$.av=$.bl=s}else{q=r.b
s.b=q
$.bl=r.b=s
if(q==null)$.bk=s}},
jP(a){A.es(a,"stream",t.K)
return new A.ca()},
ep(a,b){A.j9(new A.dF(a,b))},
fz(a,b,c,d){var s,r=$.p
if(r===c)return d.$0()
$.p=c
s=r
try{r=d.$0()
return r}finally{$.p=s}},
j8(a,b,c,d,e){var s,r=$.p
if(r===c)return d.$1(e)
$.p=c
s=r
try{r=d.$1(e)
return r}finally{$.p=s}},
j7(a,b,c,d,e,f){var s,r=$.p
if(r===c)return d.$2(e,f)
$.p=c
s=r
try{r=d.$2(e,f)
return r}finally{$.p=s}},
cd(a,b,c,d){if(B.d!==c)d=c.bs(d)
A.fC(d)},
cU:function cU(a){this.a=a},
cT:function cT(a,b,c){this.a=a
this.b=b
this.c=c},
cV:function cV(a){this.a=a},
cW:function cW(a){this.a=a},
di:function di(){},
dj:function dj(a,b){this.a=a
this.b=b},
bY:function bY(a,b){this.a=a
this.b=!1
this.$ti=b},
dw:function dw(a){this.a=a},
dx:function dx(a){this.a=a},
dH:function dH(a){this.a=a},
H:function H(a,b){this.a=a
this.b=b},
c_:function c_(){},
b2:function b2(a,b){this.a=a
this.$ti=b},
as:function as(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
v:function v(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
cZ:function cZ(a,b){this.a=a
this.b=b},
d2:function d2(a,b){this.a=a
this.b=b},
d1:function d1(a,b){this.a=a
this.b=b},
d0:function d0(a,b){this.a=a
this.b=b},
d_:function d_(a,b){this.a=a
this.b=b},
d5:function d5(a,b,c){this.a=a
this.b=b
this.c=c},
d6:function d6(a,b){this.a=a
this.b=b},
d7:function d7(a){this.a=a},
d4:function d4(a,b){this.a=a
this.b=b},
d3:function d3(a,b){this.a=a
this.b=b},
bZ:function bZ(a){this.a=a
this.b=null},
ca:function ca(){},
dv:function dv(){},
dF:function dF(a,b){this.a=a
this.b=b},
da:function da(){},
db:function db(a,b){this.a=a
this.b=b},
eM(a,b,c){return A.jn(a,new A.a9(b.j("@<0>").C(c).j("a9<1,2>")))},
e3(a,b){return new A.a9(a.j("@<0>").C(b).j("a9<1,2>"))},
hs(a){var s,r=A.a2(a),q=new J.V(a,a.length,r.j("V<1>"))
if(q.m()){s=q.d
return s==null?r.c.a(s):s}return null},
e4(a){var s,r
if(A.ex(a))return"{...}"
s=new A.A("")
try{r={}
$.ai.push(a)
s.a+="{"
r.a=!0
a.F(0,new A.cz(r,s))
s.a+="}"}finally{$.ai.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
e:function e(){},
N:function N(){},
cz:function cz(a,b){this.a=a
this.b=b},
cc:function cc(){},
aT:function aT(){},
ar:function ar(a,b){this.a=a
this.$ti=b},
ao:function ao(){},
bg:function bg(){},
j4(a,b){var s,r,q,p=null
try{p=JSON.parse(a)}catch(r){s=A.aj(r)
q=A.y(String(s),null,null)
throw A.b(q)}q=A.dy(p)
return q},
dy(a){var s
if(a==null)return null
if(typeof a!="object")return a
if(!Array.isArray(a))return new A.c3(a,Object.create(null))
for(s=0;s<a.length;++s)a[s]=A.dy(a[s])
return a},
iq(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.h4()
else s=new Uint8Array(o)
for(r=J.cf(a),q=0;q<o;++q){p=r.k(a,b+q)
if((p&255)!==p)p=255
s[q]=p}return s},
ip(a,b,c,d){var s=a?$.h3():$.h2()
if(s==null)return null
if(0===c&&d===b.length)return A.fk(s,b)
return A.fk(s,b.subarray(c,d))},
fk(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
eE(a,b,c,d,e,f){if(B.c.a0(f,4)!==0)throw A.b(A.y("Invalid base64 padding, padded length must be multiple of four, is "+f,a,c))
if(d+e!==f)throw A.b(A.y("Invalid base64 padding, '=' not at the end",a,b))
if(e>2)throw A.b(A.y("Invalid base64 padding, more than two '=' characters",a,b))},
ir(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
c3:function c3(a,b){this.a=a
this.b=b
this.c=null},
c4:function c4(a){this.a=a},
ds:function ds(){},
dr:function dr(){},
ch:function ch(){},
ci:function ci(){},
bt:function bt(){},
bv:function bv(){},
cm:function cm(){},
cp:function cp(){},
co:function co(){},
cw:function cw(){},
cx:function cx(a){this.a=a},
cP:function cP(){},
cR:function cR(){},
dt:function dt(a){this.b=0
this.c=a},
cQ:function cQ(a){this.a=a},
dq:function dq(a){this.a=a
this.b=16
this.c=0},
dR(a,b){var s=A.eQ(a,b)
if(s!=null)return s
throw A.b(A.y(a,null,null))},
hj(a,b){a=A.x(a,new Error())
a.stack=b.h(0)
throw a},
eO(a,b,c,d){var s,r=c?J.hw(a,d):J.hv(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
hz(a,b,c){var s,r,q=A.k([],c.j("o<0>"))
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.dX)(a),++r)q.push(a[r])
q.$flags=1
return q},
eN(a,b){var s,r
if(Array.isArray(a))return A.k(a.slice(0),b.j("o<0>"))
s=A.k([],b.j("o<0>"))
for(r=J.aD(a);r.m();)s.push(r.gn())
return s},
eX(a,b,c){var s,r
A.e5(b,"start")
if(c!=null){s=c-b
if(s<0)throw A.b(A.E(c,b,null,"end",null))
if(s===0)return""}r=A.hI(a,b,c)
return r},
hI(a,b,c){var s=a.length
if(b>=s)return""
return A.hE(a,b,c==null||c>s?s:c)},
eT(a,b){return new A.cu(a,A.eK(a,!1,b,!1,!1,""))},
eW(a,b,c){var s=J.aD(b)
if(!s.m())return a
if(c.length===0){do a+=A.i(s.gn())
while(s.m())}else{a+=A.i(s.gn())
for(;s.m();)a=a+c+A.i(s.gn())}return a},
fj(a,b,c,d){var s,r,q,p,o,n="0123456789ABCDEF"
if(c===B.e){s=$.h0()
s=s.b.test(b)}else s=!1
if(s)return b
r=B.y.H(b)
for(s=r.length,q=0,p="";q<s;++q){o=r[q]
if(o<128&&(u.f.charCodeAt(o)&a)!==0)p+=A.O(o)
else p=d&&o===32?p+"+":p+"%"+n[o>>>4&15]+n[o&15]}return p.charCodeAt(0)==0?p:p},
ig(a){var s,r,q
if(!$.h1())return A.ih(a)
s=new URLSearchParams()
a.F(0,new A.dp(s))
r=s.toString()
q=r.length
if(q>0&&r[q-1]==="=")r=B.a.i(r,0,q-1)
return r.replace(/=&|\*|%7E/g,b=>b==="=&"?"&":b==="*"?"%2A":"~")},
hH(){return A.az(new Error())},
cn(a){if(typeof a=="number"||A.en(a)||a==null)return J.ak(a)
if(typeof a=="string")return JSON.stringify(a)
return A.eR(a)},
hk(a,b){A.es(a,"error",t.K)
A.es(b,"stackTrace",t.l)
A.hj(a,b)},
bq(a){return new A.bp(a)},
U(a,b){return new A.G(!1,null,b,a)},
eD(a,b,c){return new A.G(!0,a,b,c)},
hF(a,b){return new A.aZ(null,null,!0,a,b,"Value not in range")},
E(a,b,c,d,e){return new A.aZ(b,c,!0,a,d,"Invalid value")},
bR(a,b,c){if(0>a||a>c)throw A.b(A.E(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.b(A.E(b,a,c,"end",null))
return b}return c},
e5(a,b){if(a<0)throw A.b(A.E(a,0,null,b,null))
return a},
e_(a,b,c,d){return new A.bx(b,!0,a,d,"Index out of range")},
cJ(a){return new A.b1(a)},
eZ(a){return new A.bT(a)},
eV(a){return new A.b0(a)},
al(a){return new A.bu(a)},
y(a,b,c){return new A.bw(a,b,c)},
ht(a,b,c){var s,r
if(A.ex(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.k([],t.s)
$.ai.push(a)
try{A.j1(a,s)}finally{$.ai.pop()}r=A.eW(b,s,", ")+c
return r.charCodeAt(0)==0?r:r},
e0(a,b,c){var s,r
if(A.ex(a))return b+"..."+c
s=new A.A(b)
$.ai.push(a)
try{r=s
r.a=A.eW(r.a,a,", ")}finally{$.ai.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
j1(a,b){var s,r,q,p,o,n,m,l=a.gv(a),k=0,j=0
while(!0){if(!(k<80||j<3))break
if(!l.m())return
s=A.i(l.gn())
b.push(s)
k+=s.length+2;++j}if(!l.m()){if(j<=5)return
r=b.pop()
q=b.pop()}else{p=l.gn();++j
if(!l.m()){if(j<=4){b.push(A.i(p))
return}r=A.i(p)
q=b.pop()
k+=r.length+2}else{o=l.gn();++j
for(;l.m();p=o,o=n){n=l.gn();++j
if(j>100){while(!0){if(!(k>75&&j>3))break
k-=b.pop().length+2;--j}b.push("...")
return}}q=A.i(p)
r=A.i(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
while(!0){if(!(k>80&&b.length>3))break
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)b.push(m)
b.push(q)
b.push(r)},
hC(a,b,c,d){var s
if(B.h===c){s=B.c.gp(a)
b=J.T(b)
return A.e8(A.a_(A.a_($.dY(),s),b))}if(B.h===d){s=B.c.gp(a)
b=J.T(b)
c=J.T(c)
return A.e8(A.a_(A.a_(A.a_($.dY(),s),b),c))}s=B.c.gp(a)
b=J.T(b)
c=J.T(c)
d=J.T(d)
d=A.e8(A.a_(A.a_(A.a_(A.a_($.dY(),s),b),c),d))
return d},
bX(a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=null
a6=a4.length
s=a5+5
if(a6>=s){r=((a4.charCodeAt(a5+4)^58)*3|a4.charCodeAt(a5)^100|a4.charCodeAt(a5+1)^97|a4.charCodeAt(a5+2)^116|a4.charCodeAt(a5+3)^97)>>>0
if(r===0)return A.f_(a5>0||a6<a6?B.a.i(a4,a5,a6):a4,5,a3).gaZ()
else if(r===32)return A.f_(B.a.i(a4,s,a6),0,a3).gaZ()}q=A.eO(8,0,!1,t.S)
q[0]=0
p=a5-1
q[1]=p
q[2]=p
q[7]=p
q[3]=a5
q[4]=a5
q[5]=a6
q[6]=a6
if(A.fB(a4,a5,a6,0,q)>=14)q[7]=a6
o=q[1]
if(o>=a5)if(A.fB(a4,a5,o,20,q)===20)q[7]=o
n=q[2]+1
m=q[3]
l=q[4]
k=q[5]
j=q[6]
if(j<k)k=j
if(l<n)l=k
else if(l<=o)l=o+1
if(m<n)m=l
i=q[7]<a5
h=a3
if(i){i=!1
if(!(n>o+3)){p=m>a5
g=0
if(!(p&&m+1===l)){if(!B.a.u(a4,"\\",l))if(n>a5)f=B.a.u(a4,"\\",n-1)||B.a.u(a4,"\\",n-2)
else f=!1
else f=!0
if(!f){if(!(k<a6&&k===l+2&&B.a.u(a4,"..",l)))f=k>l+2&&B.a.u(a4,"/..",k-3)
else f=!0
if(!f)if(o===a5+4){if(B.a.u(a4,"file",a5)){if(n<=a5){if(!B.a.u(a4,"/",l)){e="file:///"
r=3}else{e="file://"
r=2}a4=e+B.a.i(a4,l,a6)
o-=a5
s=r-a5
k+=s
j+=s
a6=a4.length
a5=g
n=7
m=7
l=7}else if(l===k){s=a5===0
s
if(s){a4=B.a.I(a4,l,k,"/");++k;++j;++a6}else{a4=B.a.i(a4,a5,l)+"/"+B.a.i(a4,k,a6)
o-=a5
n-=a5
m-=a5
l-=a5
s=1-a5
k+=s
j+=s
a6=a4.length
a5=g}}h="file"}else if(B.a.u(a4,"http",a5)){if(p&&m+3===l&&B.a.u(a4,"80",m+1)){s=a5===0
s
if(s){a4=B.a.I(a4,m,l,"")
l-=3
k-=3
j-=3
a6-=3}else{a4=B.a.i(a4,a5,m)+B.a.i(a4,l,a6)
o-=a5
n-=a5
m-=a5
s=3+a5
l-=s
k-=s
j-=s
a6=a4.length
a5=g}}h="http"}}else if(o===s&&B.a.u(a4,"https",a5)){if(p&&m+4===l&&B.a.u(a4,"443",m+1)){s=a5===0
s
if(s){a4=B.a.I(a4,m,l,"")
l-=4
k-=4
j-=4
a6-=3}else{a4=B.a.i(a4,a5,m)+B.a.i(a4,l,a6)
o-=a5
n-=a5
m-=a5
s=4+a5
l-=s
k-=s
j-=s
a6=a4.length
a5=g}}h="https"}i=!f}}}}if(i){if(a5>0||a6<a4.length){a4=B.a.i(a4,a5,a6)
o-=a5
n-=a5
m-=a5
l-=a5
k-=a5
j-=a5}return new A.c9(a4,o,n,m,l,k,j,h)}if(h==null)if(o>a5)h=A.ii(a4,a5,o)
else{if(o===a5)A.au(a4,a5,"Invalid empty scheme")
h=""}d=a3
if(n>a5){c=o+3
b=c<n?A.ij(a4,c,n-1):""
a=A.ic(a4,n,m,!1)
s=m+1
if(s<l){a0=A.eQ(B.a.i(a4,s,l),a3)
d=A.ie(a0==null?A.ez(A.y("Invalid port",a4,s)):a0,h)}}else{a=a3
b=""}a1=A.id(a4,l,k,a3,h,a!=null)
a2=k<j?A.ef(a4,k+1,j,a3):a3
return A.ed(h,b,a,d,a1,a2,j<a6?A.ib(a4,j+1,a6):a3)},
hO(a){var s,r,q=0,p=null
try{s=A.bX(a,q,p)
return s}catch(r){if(A.aj(r) instanceof A.bw)return null
else throw r}},
f1(a){var s=t.N
return B.b.by(A.k(a.split("&"),t.s),A.e3(s,s),new A.cO(B.e))},
hN(a,b,c){var s,r,q,p,o,n,m="IPv4 address should contain exactly 4 parts",l="each part must be in the range 0..255",k=new A.cL(a),j=new Uint8Array(4)
for(s=b,r=s,q=0;s<c;++s){p=a.charCodeAt(s)
if(p!==46){if((p^48)>9)k.$2("invalid character",s)}else{if(q===3)k.$2(m,s)
o=A.dR(B.a.i(a,r,s),null)
if(o>255)k.$2(l,r)
n=q+1
j[q]=o
r=s+1
q=n}}if(q!==3)k.$2(m,c)
o=A.dR(B.a.i(a,r,c),null)
if(o>255)k.$2(l,r)
j[q]=o
return j},
f0(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=null,d=new A.cM(a),c=new A.cN(d,a)
if(a.length<2)d.$2("address is too short",e)
s=A.k([],t.t)
for(r=b,q=r,p=!1,o=!1;r<a0;++r){n=a.charCodeAt(r)
if(n===58){if(r===b){++r
if(a.charCodeAt(r)!==58)d.$2("invalid start colon.",r)
q=r}if(r===q){if(p)d.$2("only one wildcard `::` is allowed",r)
s.push(-1)
p=!0}else s.push(c.$2(q,r))
q=r+1}else if(n===46)o=!0}if(s.length===0)d.$2("too few parts",e)
m=q===a0
l=B.b.gZ(s)
if(m&&l!==-1)d.$2("expected a part after last `:`",a0)
if(!m)if(!o)s.push(c.$2(q,a0))
else{k=A.hN(a,q,a0)
s.push((k[0]<<8|k[1])>>>0)
s.push((k[2]<<8|k[3])>>>0)}if(p){if(s.length>7)d.$2("an address with a wildcard must have less than 7 parts",e)}else if(s.length!==8)d.$2("an address without a wildcard must contain exactly 8 parts",e)
j=new Uint8Array(16)
for(l=s.length,i=9-l,r=0,h=0;r<l;++r){g=s[r]
if(g===-1)for(f=0;f<i;++f){j[h]=0
j[h+1]=0
h+=2}else{j[h]=B.c.aa(g,8)
j[h+1]=g&255
h+=2}}return j},
ed(a,b,c,d,e,f,g){return new A.bh(a,b,c,d,e,f,g)},
fd(a){if(a==="http")return 80
if(a==="https")return 443
return 0},
au(a,b,c){throw A.b(A.y(c,a,b))},
ie(a,b){if(a!=null&&a===A.fd(b))return null
return a},
ic(a,b,c,d){var s,r,q,p,o,n
if(b===c)return""
if(a.charCodeAt(b)===91){s=c-1
if(a.charCodeAt(s)!==93)A.au(a,b,"Missing end `]` to match `[` in host")
r=b+1
q=A.i9(a,r,s)
if(q<s){p=q+1
o=A.fi(a,B.a.u(a,"25",p)?q+3:p,s,"%25")}else o=""
A.f0(a,r,q)
return B.a.i(a,b,q).toLowerCase()+o+"]"}for(n=b;n<c;++n)if(a.charCodeAt(n)===58){q=B.a.Y(a,"%",b)
q=q>=b&&q<c?q:c
if(q<c){p=q+1
o=A.fi(a,B.a.u(a,"25",p)?q+3:p,c,"%25")}else o=""
A.f0(a,b,q)
return"["+B.a.i(a,b,q)+o+"]"}return A.il(a,b,c)},
i9(a,b,c){var s=B.a.Y(a,"%",b)
return s>=b&&s<c?s:c},
fi(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i=d!==""?new A.A(d):null
for(s=b,r=s,q=!0;s<c;){p=a.charCodeAt(s)
if(p===37){o=A.eg(a,s,!0)
n=o==null
if(n&&q){s+=3
continue}if(i==null)i=new A.A("")
m=i.a+=B.a.i(a,r,s)
if(n)o=B.a.i(a,s,s+3)
else if(o==="%")A.au(a,s,"ZoneID should not contain % anymore")
i.a=m+o
s+=3
r=s
q=!0}else if(p<127&&(u.f.charCodeAt(p)&1)!==0){if(q&&65<=p&&90>=p){if(i==null)i=new A.A("")
if(r<s){i.a+=B.a.i(a,r,s)
r=s}q=!1}++s}else{l=1
if((p&64512)===55296&&s+1<c){k=a.charCodeAt(s+1)
if((k&64512)===56320){p=65536+((p&1023)<<10)+(k&1023)
l=2}}j=B.a.i(a,r,s)
if(i==null){i=new A.A("")
n=i}else n=i
n.a+=j
m=A.ee(p)
n.a+=m
s+=l
r=s}}if(i==null)return B.a.i(a,b,c)
if(r<c){j=B.a.i(a,r,c)
i.a+=j}n=i.a
return n.charCodeAt(0)==0?n:n},
il(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h=u.f
for(s=b,r=s,q=null,p=!0;s<c;){o=a.charCodeAt(s)
if(o===37){n=A.eg(a,s,!0)
m=n==null
if(m&&p){s+=3
continue}if(q==null)q=new A.A("")
l=B.a.i(a,r,s)
if(!p)l=l.toLowerCase()
k=q.a+=l
j=3
if(m)n=B.a.i(a,s,s+3)
else if(n==="%"){n="%25"
j=1}q.a=k+n
s+=j
r=s
p=!0}else if(o<127&&(h.charCodeAt(o)&32)!==0){if(p&&65<=o&&90>=o){if(q==null)q=new A.A("")
if(r<s){q.a+=B.a.i(a,r,s)
r=s}p=!1}++s}else if(o<=93&&(h.charCodeAt(o)&1024)!==0)A.au(a,s,"Invalid character")
else{j=1
if((o&64512)===55296&&s+1<c){i=a.charCodeAt(s+1)
if((i&64512)===56320){o=65536+((o&1023)<<10)+(i&1023)
j=2}}l=B.a.i(a,r,s)
if(!p)l=l.toLowerCase()
if(q==null){q=new A.A("")
m=q}else m=q
m.a+=l
k=A.ee(o)
m.a+=k
s+=j
r=s}}if(q==null)return B.a.i(a,b,c)
if(r<c){l=B.a.i(a,r,c)
if(!p)l=l.toLowerCase()
q.a+=l}m=q.a
return m.charCodeAt(0)==0?m:m},
ii(a,b,c){var s,r,q
if(b===c)return""
if(!A.ff(a.charCodeAt(b)))A.au(a,b,"Scheme not starting with alphabetic character")
for(s=b,r=!1;s<c;++s){q=a.charCodeAt(s)
if(!(q<128&&(u.f.charCodeAt(q)&8)!==0))A.au(a,s,"Illegal scheme character")
if(65<=q&&q<=90)r=!0}a=B.a.i(a,b,c)
return A.i8(r?a.toLowerCase():a)},
i8(a){if(a==="http")return"http"
if(a==="file")return"file"
if(a==="https")return"https"
if(a==="package")return"package"
return a},
ij(a,b,c){return A.bi(a,b,c,16,!1,!1)},
id(a,b,c,d,e,f){var s,r=e==="file",q=r||f
if(a==null)return r?"/":""
else s=A.bi(a,b,c,128,!0,!0)
if(s.length===0){if(r)return"/"}else if(q&&!B.a.t(s,"/"))s="/"+s
return A.ik(s,e,f)},
ik(a,b,c){var s=b.length===0
if(s&&!c&&!B.a.t(a,"/")&&!B.a.t(a,"\\"))return A.im(a,!s||c)
return A.io(a)},
ef(a,b,c,d){if(a!=null){if(d!=null)throw A.b(A.U("Both query and queryParameters specified",null))
return A.bi(a,b,c,256,!0,!1)}if(d==null)return null
return A.ig(d)},
ih(a){var s={},r=new A.A("")
s.a=""
a.F(0,new A.dm(new A.dn(s,r)))
s=r.a
return s.charCodeAt(0)==0?s:s},
ib(a,b,c){return A.bi(a,b,c,256,!0,!1)},
eg(a,b,c){var s,r,q,p,o,n=b+2
if(n>=a.length)return"%"
s=a.charCodeAt(b+1)
r=a.charCodeAt(n)
q=A.dJ(s)
p=A.dJ(r)
if(q<0||p<0)return"%"
o=q*16+p
if(o<127&&(u.f.charCodeAt(o)&1)!==0)return A.O(c&&65<=o&&90>=o?(o|32)>>>0:o)
if(s>=97||r>=97)return B.a.i(a,b,b+3).toUpperCase()
return null},
ee(a){var s,r,q,p,o,n="0123456789ABCDEF"
if(a<=127){s=new Uint8Array(3)
s[0]=37
s[1]=n.charCodeAt(a>>>4)
s[2]=n.charCodeAt(a&15)}else{if(a>2047)if(a>65535){r=240
q=4}else{r=224
q=3}else{r=192
q=2}s=new Uint8Array(3*q)
for(p=0;--q,q>=0;r=128){o=B.c.bn(a,6*q)&63|r
s[p]=37
s[p+1]=n.charCodeAt(o>>>4)
s[p+2]=n.charCodeAt(o&15)
p+=3}}return A.eX(s,0,null)},
bi(a,b,c,d,e,f){var s=A.fh(a,b,c,d,e,f)
return s==null?B.a.i(a,b,c):s},
fh(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j=null,i=u.f
for(s=!e,r=b,q=r,p=j;r<c;){o=a.charCodeAt(r)
if(o<127&&(i.charCodeAt(o)&d)!==0)++r
else{n=1
if(o===37){m=A.eg(a,r,!1)
if(m==null){r+=3
continue}if("%"===m)m="%25"
else n=3}else if(o===92&&f)m="/"
else if(s&&o<=93&&(i.charCodeAt(o)&1024)!==0){A.au(a,r,"Invalid character")
n=j
m=n}else{if((o&64512)===55296){l=r+1
if(l<c){k=a.charCodeAt(l)
if((k&64512)===56320){o=65536+((o&1023)<<10)+(k&1023)
n=2}}}m=A.ee(o)}if(p==null){p=new A.A("")
l=p}else l=p
l.a=(l.a+=B.a.i(a,q,r))+m
r+=n
q=r}}if(p==null)return j
if(q<c){s=B.a.i(a,q,c)
p.a+=s}s=p.a
return s.charCodeAt(0)==0?s:s},
fg(a){if(B.a.t(a,"."))return!0
return B.a.aP(a,"/.")!==-1},
io(a){var s,r,q,p,o,n
if(!A.fg(a))return a
s=A.k([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(n===".."){if(s.length!==0){s.pop()
if(s.length===0)s.push("")}p=!0}else{p="."===n
if(!p)s.push(n)}}if(p)s.push("")
return B.b.aT(s,"/")},
im(a,b){var s,r,q,p,o,n
if(!A.fg(a))return!b?A.fe(a):a
s=A.k([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(".."===n){p=s.length!==0&&B.b.gZ(s)!==".."
if(p)s.pop()
else s.push("..")}else{p="."===n
if(!p)s.push(n)}}r=s.length
if(r!==0)r=r===1&&s[0].length===0
else r=!0
if(r)return"./"
if(p||B.b.gZ(s)==="..")s.push("")
if(!b)s[0]=A.fe(s[0])
return B.b.aT(s,"/")},
fe(a){var s,r,q=a.length
if(q>=2&&A.ff(a.charCodeAt(0)))for(s=1;s<q;++s){r=a.charCodeAt(s)
if(r===58)return B.a.i(a,0,s)+"%3A"+B.a.K(a,s+1)
if(r>127||(u.f.charCodeAt(r)&8)===0)break}return a},
ia(a,b){var s,r,q
for(s=0,r=0;r<2;++r){q=a.charCodeAt(b+r)
if(48<=q&&q<=57)s=s*16+q-48
else{q|=32
if(97<=q&&q<=102)s=s*16+q-87
else throw A.b(A.U("Invalid URL encoding",null))}}return s},
eh(a,b,c,d,e){var s,r,q,p,o=b
while(!0){if(!(o<c)){s=!0
break}r=a.charCodeAt(o)
q=!0
if(r<=127)if(r!==37)q=r===43
if(q){s=!1
break}++o}if(s)if(B.e===d)return B.a.i(a,b,c)
else p=new A.bs(B.a.i(a,b,c))
else{p=A.k([],t.t)
for(q=a.length,o=b;o<c;++o){r=a.charCodeAt(o)
if(r>127)throw A.b(A.U("Illegal percent encoding in URI",null))
if(r===37){if(o+3>q)throw A.b(A.U("Truncated URI",null))
p.push(A.ia(a,o+1))
o+=2}else if(r===43)p.push(32)
else p.push(r)}}return B.af.H(p)},
ff(a){var s=a|32
return 97<=s&&s<=122},
f_(a,b,c){var s,r,q,p,o,n,m,l,k="Invalid MIME type",j=A.k([b-1],t.t)
for(s=a.length,r=b,q=-1,p=null;r<s;++r){p=a.charCodeAt(r)
if(p===44||p===59)break
if(p===47){if(q<0){q=r
continue}throw A.b(A.y(k,a,r))}}if(q<0&&r>b)throw A.b(A.y(k,a,r))
for(;p!==44;){j.push(r);++r
for(o=-1;r<s;++r){p=a.charCodeAt(r)
if(p===61){if(o<0)o=r}else if(p===59||p===44)break}if(o>=0)j.push(o)
else{n=B.b.gZ(j)
if(p!==44||r!==n+7||!B.a.u(a,"base64",n+1))throw A.b(A.y("Expecting '='",a,r))
break}}j.push(r)
m=r+1
if((j.length&1)===1)a=B.o.bE(a,m,s)
else{l=A.fh(a,m,s,256,!0,!1)
if(l!=null)a=B.a.I(a,m,s,l)}return new A.cK(a,j,c)},
fB(a,b,c,d,e){var s,r,q
for(s=b;s<c;++s){r=a.charCodeAt(s)^96
if(r>95)r=31
q='\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe3\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x0e\x03\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xea\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\n\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xeb\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\xeb\xeb\xeb\x8b\xeb\xeb\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\xeb\x83\xeb\xeb\x8b\xeb\x8b\xeb\xcd\x8b\xeb\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x92\x83\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\xeb\x8b\xeb\x8b\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xebD\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x12D\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\xe5\xe5\xe5\x05\xe5D\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe8\x8a\xe5\xe5\x05\xe5\x05\xe5\xcd\x05\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x8a\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05f\x05\xe5\x05\xe5\xac\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\xe5\xe5\xe5\x05\xe5D\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\x8a\xe5\xe5\x05\xe5\x05\xe5\xcd\x05\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x8a\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05f\x05\xe5\x05\xe5\xac\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7D\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\xe7\xe7\xe7\xe7\xe7\xe7\xcd\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\xe7\x07\x07\x07\x07\x07\x07\x07\x07\x07\xe7\xe7\xe7\xe7\xe7\xac\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7D\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\xe7\xe7\xe7\xe7\xe7\xe7\xcd\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\x07\x07\x07\x07\x07\x07\x07\x07\x07\x07\xe7\xe7\xe7\xe7\xe7\xac\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\x05\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x10\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x12\n\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\v\n\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xec\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\xec\xec\xec\f\xec\xec\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\xec\xec\xec\xec\f\xec\f\xec\xcd\f\xec\f\f\f\f\f\f\f\f\f\xec\f\f\f\f\f\f\f\f\f\f\xec\f\xec\f\xec\f\xed\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\xed\xed\xed\r\xed\xed\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\xed\xed\xed\xed\r\xed\r\xed\xed\r\xed\r\r\r\r\r\r\r\r\r\xed\r\r\r\r\r\r\r\r\r\r\xed\r\xed\r\xed\r\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xea\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x0f\xea\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe9\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\t\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x11\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xe9\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\v\t\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x13\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\v\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xf5\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\x15\xf5\x15\x15\xf5\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\xf5\xf5\xf5\xf5\xf5\xf5'.charCodeAt(d*96+r)
d=q&31
e[q>>>5]=s}return d},
dp:function dp(a){this.a=a},
cX:function cX(){},
l:function l(){},
bp:function bp(a){this.a=a},
P:function P(){},
G:function G(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
aZ:function aZ(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
bx:function bx(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
b1:function b1(a){this.a=a},
bT:function bT(a){this.a=a},
b0:function b0(a){this.a=a},
bu:function bu(a){this.a=a},
bO:function bO(){},
b_:function b_(){},
cY:function cY(a){this.a=a},
bw:function bw(a,b,c){this.a=a
this.b=b
this.c=c},
r:function r(){},
t:function t(){},
j:function j(){},
cb:function cb(){},
A:function A(a){this.a=a},
cO:function cO(a){this.a=a},
cL:function cL(a){this.a=a},
cM:function cM(a){this.a=a},
cN:function cN(a,b){this.a=a
this.b=b},
bh:function bh(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=_.y=_.w=$},
dn:function dn(a,b){this.a=a
this.b=b},
dm:function dm(a){this.a=a},
cK:function cK(a,b,c){this.a=a
this.b=b
this.c=c},
c9:function c9(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=null},
c0:function c0(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=_.y=_.w=$},
a4(a){var s
if(typeof a=="function")throw A.b(A.U("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.iB,a)
s[$.eA()]=a
return s},
iB(a,b,c){if(c>=1)return a.$1(b)
return a.$0()},
dU(a,b){var s=new A.v($.p,b.j("v<0>")),r=new A.b2(s,b.j("b2<0>"))
a.then(A.ay(new A.dV(r),1),A.ay(new A.dW(r),1))
return s},
dV:function dV(a){this.a=a},
dW:function dW(a){this.a=a},
cB:function cB(a){this.a=a},
m:function m(a,b){this.a=a
this.b=b},
hn(a){var s,r,q,p,o,n,m,l,k="enclosedBy"
if(a.k(0,k)!=null){s=t.a.a(a.k(0,k))
r=new A.cl(A.ek(s.k(0,"name")),B.m[A.ei(s.k(0,"kind"))],A.ek(s.k(0,"href")))}else r=null
q=a.k(0,"name")
p=a.k(0,"qualifiedName")
o=A.ej(a.k(0,"packageRank"))
if(o==null)o=0
n=a.k(0,"href")
m=B.m[A.ei(a.k(0,"kind"))]
l=A.ej(a.k(0,"overriddenDepth"))
if(l==null)l=0
return new A.w(q,p,o,m,n,l,a.k(0,"desc"),r)},
B:function B(a,b){this.a=a
this.b=b},
cq:function cq(a){this.a=a},
ct:function ct(a,b){this.a=a
this.b=b},
cr:function cr(){},
cs:function cs(){},
w:function w(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h},
cl:function cl(a,b,c){this.a=a
this.b=b
this.c=c},
js(){var s=v.G,r=s.document.getElementById("search-box"),q=s.document.getElementById("search-body"),p=s.document.getElementById("search-sidebar")
A.dU(s.window.fetch($.bo()+"index.json"),t.m).aX(new A.dO(new A.dP(r,q,p),r,q,p),t.P)},
ea(a){var s=A.k([],t.O),r=A.k([],t.M)
return new A.dc(a,A.bX(v.G.window.location.href,0,null),s,r)},
iD(a,b){var s,r,q,p,o,n,m,l=v.G,k=l.document.createElement("div"),j=b.e
if(j==null)j=""
k.setAttribute("data-href",j)
k.classList.add("tt-suggestion")
s=l.document.createElement("span")
s.classList.add("tt-suggestion-title")
s.innerHTML=A.el(b.a+" "+b.d.h(0).toLowerCase(),a)
k.appendChild(s)
r=b.w
j=r!=null
if(j){s=l.document.createElement("span")
s.classList.add("tt-suggestion-container")
s.innerHTML="(in "+A.el(r.a,a)+")"
k.appendChild(s)}q=b.r
if(q!=null&&q.length!==0){s=l.document.createElement("blockquote")
s.classList.add("one-line-description")
p=l.document.createElement("textarea")
p.innerHTML=q
s.setAttribute("title",p.value)
s.innerHTML=A.el(q,a)
k.appendChild(s)}k.addEventListener("mousedown",A.a4(new A.dz()))
k.addEventListener("click",A.a4(new A.dA(b)))
if(j){j=r.a
o=r.b.h(0)
n=r.c
s=l.document.createElement("div")
s.classList.add("tt-container")
p=l.document.createElement("p")
p.textContent="Results from "
p.classList.add("tt-container-text")
m=l.document.createElement("a")
m.setAttribute("href",n)
m.innerHTML=j+" "+o
p.appendChild(m)
s.appendChild(p)
A.j2(s,k)}return k},
j2(a,b){var s,r=a.innerHTML
if(r.length===0)return
s=$.a3.k(0,r)
if(s!=null)s.appendChild(b)
else{a.appendChild(b)
$.a3.A(0,r,a)}},
el(a,b){return A.jH(a,A.eT(b,!1),new A.dB(),null)},
dC:function dC(){},
dP:function dP(a,b,c){this.a=a
this.b=b
this.c=c},
dO:function dO(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dc:function dc(a,b,c,d){var _=this
_.a=a
_.b=b
_.e=_.d=_.c=$
_.f=null
_.r=""
_.w=c
_.x=d
_.y=-1},
dd:function dd(a){this.a=a},
de:function de(a,b){this.a=a
this.b=b},
df:function df(a,b){this.a=a
this.b=b},
dg:function dg(a,b){this.a=a
this.b=b},
dh:function dh(a,b){this.a=a
this.b=b},
dz:function dz(){},
dA:function dA(a){this.a=a},
dB:function dB(){},
iL(){var s=v.G,r=s.document.getElementById("sidenav-left-toggle"),q=s.document.querySelector(".sidebar-offcanvas-left"),p=s.document.getElementById("overlay-under-drawer"),o=A.a4(new A.dD(q,p))
if(p!=null)p.addEventListener("click",o)
if(r!=null)r.addEventListener("click",o)},
iK(){var s,r,q,p,o=v.G,n=o.document.body
if(n==null)return
s=n.getAttribute("data-using-base-href")
if(s==null)return
if(s!=="true"){r=n.getAttribute("data-base-href")
if(r==null)return
q=r}else q=""
p=o.document.getElementById("dartdoc-main-content")
if(p==null)return
A.fx(q,p.getAttribute("data-above-sidebar"),o.document.getElementById("dartdoc-sidebar-left-content"))
A.fx(q,p.getAttribute("data-below-sidebar"),o.document.getElementById("dartdoc-sidebar-right"))},
fx(a,b,c){if(b==null||b.length===0||c==null)return
A.dU(v.G.window.fetch(a+b),t.m).aX(new A.dE(c,a),t.P)},
fE(a,b){var s,r,q,p,o,n=A.hu(b,"HTMLAnchorElement")
if(n){n=b.attributes.getNamedItem("href")
s=n==null?null:n.value
if(s==null)return
r=A.hO(s)
if(r!=null&&!r.gaS())b.href=a+s}q=b.childNodes
for(p=0;p<q.length;++p){o=q.item(p)
if(o!=null)A.fE(a,o)}},
dD:function dD(a,b){this.a=a
this.b=b},
dE:function dE(a,b){this.a=a
this.b=b},
jt(){var s,r,q,p=v.G,o=p.document.body
if(o==null)return
s=p.document.getElementById("theme-button")
if(s==null)s=t.m.a(s)
r=new A.dQ(o)
s.addEventListener("click",A.a4(new A.dN(o,r)))
q=p.window.localStorage.getItem("colorTheme")
if(q!=null)r.$1(q==="true")},
dQ:function dQ(a){this.a=a},
dN:function dN(a,b){this.a=a
this.b=b},
jD(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)},
jI(a){throw A.x(A.eL(a),new Error())},
bn(){throw A.x(A.eL(""),new Error())},
hu(a,b){var s,r,q,p,o,n
if(b.length===0)return!1
s=b.split(".")
r=v.G
for(q=s.length,p=t.A,o=0;o<q;++o){n=s[o]
r=p.a(r[n])
if(r==null)return!1}return a instanceof t.g.a(r)},
jB(){A.iK()
A.iL()
A.js()
var s=v.G.hljs
if(s!=null)s.highlightAll()
A.jt()}},B={}
var w=[A,J,B]
var $={}
A.e1.prototype={}
J.by.prototype={
E(a,b){return a===b},
gp(a){return A.bQ(a)},
h(a){return"Instance of '"+A.cD(a)+"'"},
gq(a){return A.af(A.em(this))}}
J.bz.prototype={
h(a){return String(a)},
gp(a){return a?519018:218159},
gq(a){return A.af(t.y)},
$ih:1,
$ibm:1}
J.aM.prototype={
E(a,b){return null==b},
h(a){return"null"},
gp(a){return 0},
$ih:1,
$it:1}
J.aP.prototype={$in:1}
J.Y.prototype={
gp(a){return 0},
h(a){return String(a)}}
J.bP.prototype={}
J.ap.prototype={}
J.X.prototype={
h(a){var s=a[$.eA()]
if(s==null)return this.b7(a)
return"JavaScript function for "+J.ak(s)}}
J.aO.prototype={
gp(a){return 0},
h(a){return String(a)}}
J.aQ.prototype={
gp(a){return 0},
h(a){return String(a)}}
J.o.prototype={
W(a,b){return new A.M(a,A.a2(a).j("@<1>").C(b).j("M<1,2>"))},
X(a){a.$flags&1&&A.aC(a,"clear","clear")
a.length=0},
aT(a,b){var s,r=A.eO(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)r[s]=A.i(a[s])
return r.join(b)},
bx(a,b,c){var s,r,q=a.length
for(s=b,r=0;r<q;++r){s=c.$2(s,a[r])
if(a.length!==q)throw A.b(A.al(a))}return s},
by(a,b,c){c.toString
return this.bx(a,b,c,t.z)},
D(a,b){return a[b]},
b6(a,b,c){var s=a.length
if(b>s)throw A.b(A.E(b,0,s,"start",null))
if(c<b||c>s)throw A.b(A.E(c,b,s,"end",null))
if(b===c)return A.k([],A.a2(a))
return A.k(a.slice(b,c),A.a2(a))},
gZ(a){var s=a.length
if(s>0)return a[s-1]
throw A.b(A.hr())},
b5(a,b){var s,r,q,p,o
a.$flags&2&&A.aC(a,"sort")
s=a.length
if(s<2)return
if(b==null)b=J.iR()
if(s===2){r=a[0]
q=a[1]
if(b.$2(r,q)>0){a[0]=q
a[1]=r}return}p=0
if(A.a2(a).c.b(null))for(o=0;o<a.length;++o)if(a[o]===void 0){a[o]=null;++p}a.sort(A.ay(b,2))
if(p>0)this.bl(a,p)},
bl(a,b){var s,r=a.length
for(;s=r-1,r>0;r=s)if(a[s]===null){a[s]=void 0;--b
if(b===0)break}},
h(a){return A.e0(a,"[","]")},
gv(a){return new J.V(a,a.length,A.a2(a).j("V<1>"))},
gp(a){return A.bQ(a)},
gl(a){return a.length},
k(a,b){if(!(b>=0&&b<a.length))throw A.b(A.fJ(a,b))
return a[b]},
$ic:1,
$if:1}
J.cv.prototype={}
J.V.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s,r=this,q=r.a,p=q.length
if(r.b!==p)throw A.b(A.dX(q))
s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0}}
J.aN.prototype={
aG(a,b){var s
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.gaj(b)
if(this.gaj(a)===s)return 0
if(this.gaj(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
gaj(a){return a===0?1/a<0:a<0},
h(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gp(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
a0(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
return s+b},
bo(a,b){return(a|0)===a?a/b|0:this.bp(a,b)},
bp(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.b(A.cJ("Result of truncating division is "+A.i(s)+": "+A.i(a)+" ~/ "+b))},
aa(a,b){var s
if(a>0)s=this.aC(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
bn(a,b){if(0>b)throw A.b(A.jf(b))
return this.aC(a,b)},
aC(a,b){return b>31?0:a>>>b},
gq(a){return A.af(t.H)},
$iq:1}
J.aL.prototype={
gq(a){return A.af(t.S)},
$ih:1,
$ia:1}
J.bA.prototype={
gq(a){return A.af(t.i)},
$ih:1}
J.a8.prototype={
I(a,b,c,d){var s=A.bR(b,c,a.length)
return a.substring(0,b)+d+a.substring(s)},
u(a,b,c){var s
if(c<0||c>a.length)throw A.b(A.E(c,0,a.length,null,null))
s=c+b.length
if(s>a.length)return!1
return b===a.substring(c,s)},
t(a,b){return this.u(a,b,0)},
i(a,b,c){return a.substring(b,A.bR(b,c,a.length))},
K(a,b){return this.i(a,b,null)},
b2(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.b(B.x)
for(s=a,r="";!0;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
Y(a,b,c){var s
if(c<0||c>a.length)throw A.b(A.E(c,0,a.length,null,null))
s=a.indexOf(b,c)
return s},
aP(a,b){return this.Y(a,b,0)},
N(a,b){return A.jG(a,b,0)},
aG(a,b){var s
if(a===b)s=0
else s=a<b?-1:1
return s},
h(a){return a},
gp(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gq(a){return A.af(t.N)},
gl(a){return a.length},
$ih:1,
$id:1}
A.a0.prototype={
gv(a){return new A.br(J.aD(this.gM()),A.S(this).j("br<1,2>"))},
gl(a){return J.cg(this.gM())},
D(a,b){return A.S(this).y[1].a(J.eC(this.gM(),b))},
h(a){return J.ak(this.gM())}}
A.br.prototype={
m(){return this.a.m()},
gn(){return this.$ti.y[1].a(this.a.gn())}}
A.a6.prototype={
gM(){return this.a}}
A.b4.prototype={$ic:1}
A.b3.prototype={
k(a,b){return this.$ti.y[1].a(J.h5(this.a,b))},
$ic:1,
$if:1}
A.M.prototype={
W(a,b){return new A.M(this.a,this.$ti.j("@<1>").C(b).j("M<1,2>"))},
gM(){return this.a}}
A.bC.prototype={
h(a){return"LateInitializationError: "+this.a}}
A.bs.prototype={
gl(a){return this.a.length},
k(a,b){return this.a.charCodeAt(b)}}
A.cE.prototype={}
A.c.prototype={}
A.I.prototype={
gv(a){var s=this
return new A.am(s,s.gl(s),A.S(s).j("am<I.E>"))}}
A.am.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s,r=this,q=r.a,p=J.cf(q),o=p.gl(q)
if(r.b!==o)throw A.b(A.al(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.D(q,s);++r.c
return!0}}
A.ab.prototype={
gl(a){return J.cg(this.a)},
D(a,b){return this.b.$1(J.eC(this.a,b))}}
A.aK.prototype={}
A.bV.prototype={}
A.aq.prototype={}
A.bj.prototype={}
A.c8.prototype={$r:"+item,matchPosition(1,2)",$s:1}
A.aF.prototype={
h(a){return A.e4(this)},
A(a,b,c){A.hi()},
$iz:1}
A.aH.prototype={
gl(a){return this.b.length},
gbi(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
O(a){if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
k(a,b){if(!this.O(b))return null
return this.b[this.a[b]]},
F(a,b){var s,r,q=this.gbi(),p=this.b
for(s=q.length,r=0;r<s;++r)b.$2(q[r],p[r])}}
A.c5.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0}}
A.aG.prototype={}
A.aI.prototype={
gl(a){return this.b},
gv(a){var s,r=this,q=r.$keys
if(q==null){q=Object.keys(r.a)
r.$keys=q}s=q
return new A.c5(s,s.length,r.$ti.j("c5<1>"))},
N(a,b){if("__proto__"===b)return!1
return this.a.hasOwnProperty(b)}}
A.cH.prototype={
B(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.aY.prototype={
h(a){return"Null check operator used on a null value"}}
A.bB.prototype={
h(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.bU.prototype={
h(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.cC.prototype={
h(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.aJ.prototype={}
A.ba.prototype={
h(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iZ:1}
A.a7.prototype={
h(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.fP(r==null?"unknown":r)+"'"},
gbN(){return this},
$C:"$1",
$R:1,
$D:null}
A.cj.prototype={$C:"$0",$R:0}
A.ck.prototype={$C:"$2",$R:2}
A.cG.prototype={}
A.cF.prototype={
h(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.fP(s)+"'"}}
A.aE.prototype={
E(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.aE))return!1
return this.$_target===b.$_target&&this.a===b.a},
gp(a){return(A.fM(this.a)^A.bQ(this.$_target))>>>0},
h(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.cD(this.a)+"'")}}
A.bS.prototype={
h(a){return"RuntimeError: "+this.a}}
A.a9.prototype={
gl(a){return this.a},
gP(){return new A.aa(this,A.S(this).j("aa<1>"))},
O(a){var s=this.b
if(s==null)return!1
return s[a]!=null},
k(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.bC(b)},
bC(a){var s,r,q=this.d
if(q==null)return null
s=q[this.aQ(a)]
r=this.aR(s,a)
if(r<0)return null
return s[r].b},
A(a,b,c){var s,r,q,p,o,n,m=this
if(typeof b=="string"){s=m.b
m.ap(s==null?m.b=m.a8():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=m.c
m.ap(r==null?m.c=m.a8():r,b,c)}else{q=m.d
if(q==null)q=m.d=m.a8()
p=m.aQ(b)
o=q[p]
if(o==null)q[p]=[m.a9(b,c)]
else{n=m.aR(o,b)
if(n>=0)o[n].b=c
else o.push(m.a9(b,c))}}},
X(a){var s=this
if(s.a>0){s.b=s.c=s.d=s.e=s.f=null
s.a=0
s.az()}},
F(a,b){var s=this,r=s.e,q=s.r
for(;r!=null;){b.$2(r.a,r.b)
if(q!==s.r)throw A.b(A.al(s))
r=r.c}},
ap(a,b,c){var s=a[b]
if(s==null)a[b]=this.a9(b,c)
else s.b=c},
az(){this.r=this.r+1&1073741823},
a9(a,b){var s=this,r=new A.cy(a,b)
if(s.e==null)s.e=s.f=r
else s.f=s.f.c=r;++s.a
s.az()
return r},
aQ(a){return J.T(a)&1073741823},
aR(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.F(a[r].a,b))return r
return-1},
h(a){return A.e4(this)},
a8(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s}}
A.cy.prototype={}
A.aa.prototype={
gl(a){return this.a.a},
gv(a){var s=this.a
return new A.bD(s,s.r,s.e)}}
A.bD.prototype={
gn(){return this.d},
m(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.b(A.al(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}}}
A.aS.prototype={
gl(a){return this.a.a},
gv(a){var s=this.a
return new A.aR(s,s.r,s.e)}}
A.aR.prototype={
gn(){return this.d},
m(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.b(A.al(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}}}
A.dK.prototype={
$1(a){return this.a(a)},
$S:9}
A.dL.prototype={
$2(a,b){return this.a(a,b)},
$S:10}
A.dM.prototype={
$1(a){return this.a(a)},
$S:11}
A.b9.prototype={
h(a){return this.aE(!1)},
aE(a){var s,r,q,p,o,n=this.bg(),m=this.aw(),l=(a?""+"Record ":"")+"("
for(s=n.length,r="",q=0;q<s;++q,r=", "){l+=r
p=n[q]
if(typeof p=="string")l=l+p+": "
o=m[q]
l=a?l+A.eR(o):l+A.i(o)}l+=")"
return l.charCodeAt(0)==0?l:l},
bg(){var s,r=this.$s
for(;$.d9.length<=r;)$.d9.push(null)
s=$.d9[r]
if(s==null){s=this.bb()
$.d9[r]=s}return s},
bb(){var s,r,q,p=this.$r,o=p.indexOf("("),n=p.substring(1,o),m=p.substring(o),l=m==="()"?0:m.replace(/[^,]/g,"").length+1,k=A.k(new Array(l),t.f)
for(s=0;s<l;++s)k[s]=s
if(n!==""){r=n.split(",")
s=r.length
for(q=l;s>0;){--q;--s
k[q]=r[s]}}k=A.hz(k,!1,t.K)
k.$flags=3
return k}}
A.c7.prototype={
aw(){return[this.a,this.b]},
E(a,b){if(b==null)return!1
return b instanceof A.c7&&this.$s===b.$s&&J.F(this.a,b.a)&&J.F(this.b,b.b)},
gp(a){return A.hC(this.$s,this.a,this.b,B.h)}}
A.cu.prototype={
h(a){return"RegExp/"+this.a+"/"+this.b.flags},
gbj(){var s=this,r=s.c
if(r!=null)return r
r=s.b
return s.c=A.eK(s.a,r.multiline,!r.ignoreCase,r.unicode,r.dotAll,"g")},
bf(a,b){var s,r=this.gbj()
r.lastIndex=b
s=r.exec(a)
if(s==null)return null
return new A.c6(s)}}
A.c6.prototype={
gbw(){var s=this.b
return s.index+s[0].length},
k(a,b){return this.b[b]},
$icA:1,
$ie6:1}
A.cS.prototype={
gn(){var s=this.d
return s==null?t.F.a(s):s},
m(){var s,r,q,p,o,n,m=this,l=m.b
if(l==null)return!1
s=m.c
r=l.length
if(s<=r){q=m.a
p=q.bf(l,s)
if(p!=null){m.d=p
o=p.gbw()
if(p.b.index===o){s=!1
if(q.b.unicode){q=m.c
n=q+1
if(n<r){r=l.charCodeAt(q)
if(r>=55296&&r<=56319){s=l.charCodeAt(n)
s=s>=56320&&s<=57343}}}o=(s?o+1:o)+1}m.c=o
return!0}}m.b=m.d=null
return!1}}
A.bE.prototype={
gq(a){return B.a3},
$ih:1}
A.aW.prototype={}
A.bF.prototype={
gq(a){return B.a4},
$ih:1}
A.an.prototype={
gl(a){return a.length},
$iC:1}
A.aU.prototype={
k(a,b){A.ad(b,a,a.length)
return a[b]},
$ic:1,
$if:1}
A.aV.prototype={$ic:1,$if:1}
A.bG.prototype={
gq(a){return B.a5},
$ih:1}
A.bH.prototype={
gq(a){return B.a6},
$ih:1}
A.bI.prototype={
gq(a){return B.a7},
k(a,b){A.ad(b,a,a.length)
return a[b]},
$ih:1}
A.bJ.prototype={
gq(a){return B.a8},
k(a,b){A.ad(b,a,a.length)
return a[b]},
$ih:1}
A.bK.prototype={
gq(a){return B.a9},
k(a,b){A.ad(b,a,a.length)
return a[b]},
$ih:1}
A.bL.prototype={
gq(a){return B.ab},
k(a,b){A.ad(b,a,a.length)
return a[b]},
$ih:1}
A.bM.prototype={
gq(a){return B.ac},
k(a,b){A.ad(b,a,a.length)
return a[b]},
$ih:1}
A.aX.prototype={
gq(a){return B.ad},
gl(a){return a.length},
k(a,b){A.ad(b,a,a.length)
return a[b]},
$ih:1}
A.bN.prototype={
gq(a){return B.ae},
gl(a){return a.length},
k(a,b){A.ad(b,a,a.length)
return a[b]},
$ih:1}
A.b5.prototype={}
A.b6.prototype={}
A.b7.prototype={}
A.b8.prototype={}
A.J.prototype={
j(a){return A.bf(v.typeUniverse,this,a)},
C(a){return A.fc(v.typeUniverse,this,a)}}
A.c2.prototype={}
A.dk.prototype={
h(a){return A.D(this.a,null)}}
A.c1.prototype={
h(a){return this.a}}
A.bb.prototype={$iP:1}
A.cU.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:4}
A.cT.prototype={
$1(a){var s,r
this.a.a=a
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:12}
A.cV.prototype={
$0(){this.a.$0()},
$S:5}
A.cW.prototype={
$0(){this.a.$0()},
$S:5}
A.di.prototype={
b8(a,b){if(self.setTimeout!=null)self.setTimeout(A.ay(new A.dj(this,b),0),a)
else throw A.b(A.cJ("`setTimeout()` not found."))}}
A.dj.prototype={
$0(){this.b.$0()},
$S:0}
A.bY.prototype={
ac(a){var s,r=this
if(a==null)a=r.$ti.c.a(a)
if(!r.b)r.a.aq(a)
else{s=r.a
if(r.$ti.j("W<1>").b(a))s.ar(a)
else s.au(a)}},
ad(a,b){var s=this.a
if(this.b)s.a4(new A.H(a,b))
else s.a3(new A.H(a,b))}}
A.dw.prototype={
$1(a){return this.a.$2(0,a)},
$S:2}
A.dx.prototype={
$2(a,b){this.a.$2(1,new A.aJ(a,b))},
$S:13}
A.dH.prototype={
$2(a,b){this.a(a,b)},
$S:14}
A.H.prototype={
h(a){return A.i(this.a)},
$il:1,
gJ(){return this.b}}
A.c_.prototype={
ad(a,b){var s=this.a
if((s.a&30)!==0)throw A.b(A.eV("Future already completed"))
s.a3(A.iQ(a,b))},
aH(a){return this.ad(a,null)}}
A.b2.prototype={
ac(a){var s=this.a
if((s.a&30)!==0)throw A.b(A.eV("Future already completed"))
s.aq(a)}}
A.as.prototype={
bD(a){if((this.c&15)!==6)return!0
return this.b.b.an(this.d,a.a)},
bz(a){var s,r=this.e,q=null,p=a.a,o=this.b.b
if(t.Q.b(r))q=o.bI(r,p,a.b)
else q=o.an(r,p)
try{p=q
return p}catch(s){if(t._.b(A.aj(s))){if((this.c&1)!==0)throw A.b(A.U("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.b(A.U("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.v.prototype={
ao(a,b,c){var s,r,q=$.p
if(q===B.d){if(b!=null&&!t.Q.b(b)&&!t.v.b(b))throw A.b(A.eD(b,"onError",u.c))}else if(b!=null)b=A.j6(b,q)
s=new A.v(q,c.j("v<0>"))
r=b==null?1:3
this.a2(new A.as(s,r,a,b,this.$ti.j("@<1>").C(c).j("as<1,2>")))
return s},
aX(a,b){a.toString
return this.ao(a,null,b)},
aD(a,b,c){var s=new A.v($.p,c.j("v<0>"))
this.a2(new A.as(s,19,a,b,this.$ti.j("@<1>").C(c).j("as<1,2>")))
return s},
bm(a){this.a=this.a&1|16
this.c=a},
S(a){this.a=a.a&30|this.a&1
this.c=a.c},
a2(a){var s=this,r=s.a
if(r<=3){a.a=s.c
s.c=a}else{if((r&4)!==0){r=s.c
if((r.a&24)===0){r.a2(a)
return}s.S(r)}A.cd(null,null,s.b,new A.cZ(s,a))}},
aA(a){var s,r,q,p,o,n=this,m={}
m.a=a
if(a==null)return
s=n.a
if(s<=3){r=n.c
n.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){s=n.c
if((s.a&24)===0){s.aA(a)
return}n.S(s)}m.a=n.U(a)
A.cd(null,null,n.b,new A.d2(m,n))}},
T(){var s=this.c
this.c=null
return this.U(s)},
U(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
au(a){var s=this,r=s.T()
s.a=8
s.c=a
A.at(s,r)},
ba(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.T()
q.S(a)
A.at(q,r)},
a4(a){var s=this.T()
this.bm(a)
A.at(this,s)},
aq(a){if(this.$ti.j("W<1>").b(a)){this.ar(a)
return}this.b9(a)},
b9(a){this.a^=2
A.cd(null,null,this.b,new A.d0(this,a))},
ar(a){A.e9(a,this,!1)
return},
a3(a){this.a^=2
A.cd(null,null,this.b,new A.d_(this,a))},
$iW:1}
A.cZ.prototype={
$0(){A.at(this.a,this.b)},
$S:0}
A.d2.prototype={
$0(){A.at(this.b,this.a.a)},
$S:0}
A.d1.prototype={
$0(){A.e9(this.a.a,this.b,!0)},
$S:0}
A.d0.prototype={
$0(){this.a.au(this.b)},
$S:0}
A.d_.prototype={
$0(){this.a.a4(this.b)},
$S:0}
A.d5.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.bG(q.d)}catch(p){s=A.aj(p)
r=A.az(p)
if(k.c&&k.b.a.c.a===s){q=k.a
q.c=k.b.a.c}else{q=s
o=r
if(o==null)o=A.dZ(q)
n=k.a
n.c=new A.H(q,o)
q=n}q.b=!0
return}if(j instanceof A.v&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=j.c
q.b=!0}return}if(j instanceof A.v){m=k.b.a
l=new A.v(m.b,m.$ti)
j.ao(new A.d6(l,m),new A.d7(l),t.q)
q=k.a
q.c=l
q.b=!1}},
$S:0}
A.d6.prototype={
$1(a){this.a.ba(this.b)},
$S:4}
A.d7.prototype={
$2(a,b){this.a.a4(new A.H(a,b))},
$S:15}
A.d4.prototype={
$0(){var s,r,q,p,o,n
try{q=this.a
p=q.a
q.c=p.b.b.an(p.d,this.b)}catch(o){s=A.aj(o)
r=A.az(o)
q=s
p=r
if(p==null)p=A.dZ(q)
n=this.a
n.c=new A.H(q,p)
n.b=!0}},
$S:0}
A.d3.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=l.a.a.c
p=l.b
if(p.a.bD(s)&&p.a.e!=null){p.c=p.a.bz(s)
p.b=!1}}catch(o){r=A.aj(o)
q=A.az(o)
p=l.a.a.c
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.dZ(p)
m=l.b
m.c=new A.H(p,n)
p=m}p.b=!0}},
$S:0}
A.bZ.prototype={}
A.ca.prototype={}
A.dv.prototype={}
A.dF.prototype={
$0(){A.hk(this.a,this.b)},
$S:0}
A.da.prototype={
bK(a){var s,r,q
try{if(B.d===$.p){a.$0()
return}A.fz(null,null,this,a)}catch(q){s=A.aj(q)
r=A.az(q)
A.ep(s,r)}},
bs(a){return new A.db(this,a)},
bH(a){if($.p===B.d)return a.$0()
return A.fz(null,null,this,a)},
bG(a){a.toString
return this.bH(a,t.z)},
bL(a,b){if($.p===B.d)return a.$1(b)
return A.j8(null,null,this,a,b)},
an(a,b){var s=t.z
a.toString
return this.bL(a,b,s,s)},
bJ(a,b,c){if($.p===B.d)return a.$2(b,c)
return A.j7(null,null,this,a,b,c)},
bI(a,b,c){var s=t.z
a.toString
return this.bJ(a,b,c,s,s,s)},
bF(a){return a},
aW(a){var s=t.z
a.toString
return this.bF(a,s,s,s)}}
A.db.prototype={
$0(){return this.a.bK(this.b)},
$S:0}
A.e.prototype={
gv(a){return new A.am(a,this.gl(a),A.aA(a).j("am<e.E>"))},
D(a,b){return this.k(a,b)},
W(a,b){return new A.M(a,A.aA(a).j("@<e.E>").C(b).j("M<1,2>"))},
h(a){return A.e0(a,"[","]")},
$ic:1,
$if:1}
A.N.prototype={
F(a,b){var s,r,q,p
for(s=this.gP(),s=s.gv(s),r=A.S(this).j("N.V");s.m();){q=s.gn()
p=this.k(0,q)
b.$2(q,p==null?r.a(p):p)}},
gl(a){var s=this.gP()
return s.gl(s)},
h(a){return A.e4(this)},
$iz:1}
A.cz.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.i(a)
r.a=(r.a+=s)+": "
s=A.i(b)
r.a+=s},
$S:16}
A.cc.prototype={
A(a,b,c){throw A.b(A.cJ("Cannot modify unmodifiable map"))}}
A.aT.prototype={
k(a,b){return this.a.k(0,b)},
A(a,b,c){this.a.A(0,b,c)},
gl(a){var s=this.a
return s.gl(s)},
h(a){return this.a.h(0)},
$iz:1}
A.ar.prototype={}
A.ao.prototype={
h(a){return A.e0(this,"{","}")},
D(a,b){var s,r
A.e5(b,"index")
s=this.gv(this)
for(r=b;s.m();){if(r===0)return s.gn();--r}throw A.b(A.e_(b,b-r,this,"index"))},
$ic:1}
A.bg.prototype={}
A.c3.prototype={
k(a,b){var s,r=this.b
if(r==null)return this.c.k(0,b)
else if(typeof b!="string")return null
else{s=r[b]
return typeof s=="undefined"?this.bk(b):s}},
gl(a){return this.b==null?this.c.a:this.L().length},
gP(){if(this.b==null){var s=this.c
return new A.aa(s,A.S(s).j("aa<1>"))}return new A.c4(this)},
A(a,b,c){var s,r,q=this
if(q.b==null)q.c.A(0,b,c)
else if(q.O(b)){s=q.b
s[b]=c
r=q.a
if(r==null?s!=null:r!==s)r[b]=null}else q.bq().A(0,b,c)},
O(a){if(this.b==null)return this.c.O(a)
return Object.prototype.hasOwnProperty.call(this.a,a)},
F(a,b){var s,r,q,p,o=this
if(o.b==null)return o.c.F(0,b)
s=o.L()
for(r=0;r<s.length;++r){q=s[r]
p=o.b[q]
if(typeof p=="undefined"){p=A.dy(o.a[q])
o.b[q]=p}b.$2(q,p)
if(s!==o.c)throw A.b(A.al(o))}},
L(){var s=this.c
if(s==null)s=this.c=A.k(Object.keys(this.a),t.s)
return s},
bq(){var s,r,q,p,o,n=this
if(n.b==null)return n.c
s=A.e3(t.N,t.z)
r=n.L()
for(q=0;p=r.length,q<p;++q){o=r[q]
s.A(0,o,n.k(0,o))}if(p===0)r.push("")
else B.b.X(r)
n.a=n.b=null
return n.c=s},
bk(a){var s
if(!Object.prototype.hasOwnProperty.call(this.a,a))return null
s=A.dy(this.a[a])
return this.b[a]=s}}
A.c4.prototype={
gl(a){return this.a.gl(0)},
D(a,b){var s=this.a
return s.b==null?s.gP().D(0,b):s.L()[b]},
gv(a){var s=this.a
if(s.b==null){s=s.gP()
s=s.gv(s)}else{s=s.L()
s=new J.V(s,s.length,A.a2(s).j("V<1>"))}return s}}
A.ds.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:6}
A.dr.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:6}
A.ch.prototype={
bE(a0,a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a="Invalid base64 encoding length "
a2=A.bR(a1,a2,a0.length)
s=$.h_()
for(r=a1,q=r,p=null,o=-1,n=-1,m=0;r<a2;r=l){l=r+1
k=a0.charCodeAt(r)
if(k===37){j=l+2
if(j<=a2){i=A.dJ(a0.charCodeAt(l))
h=A.dJ(a0.charCodeAt(l+1))
g=i*16+h-(h&256)
if(g===37)g=-1
l=j}else g=-1}else g=k
if(0<=g&&g<=127){f=s[g]
if(f>=0){g="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".charCodeAt(f)
if(g===k)continue
k=g}else{if(f===-1){if(o<0){e=p==null?null:p.a.length
if(e==null)e=0
o=e+(r-q)
n=r}++m
if(k===61)continue}k=g}if(f!==-2){if(p==null){p=new A.A("")
e=p}else e=p
e.a+=B.a.i(a0,q,r)
d=A.O(k)
e.a+=d
q=l
continue}}throw A.b(A.y("Invalid base64 data",a0,r))}if(p!=null){e=B.a.i(a0,q,a2)
e=p.a+=e
d=e.length
if(o>=0)A.eE(a0,n,a2,o,m,d)
else{c=B.c.a0(d-1,4)+1
if(c===1)throw A.b(A.y(a,a0,a2))
for(;c<4;){e+="="
p.a=e;++c}}e=p.a
return B.a.I(a0,a1,a2,e.charCodeAt(0)==0?e:e)}b=a2-a1
if(o>=0)A.eE(a0,n,a2,o,m,b)
else{c=B.c.a0(b,4)
if(c===1)throw A.b(A.y(a,a0,a2))
if(c>1)a0=B.a.I(a0,a2,a2,c===2?"==":"=")}return a0}}
A.ci.prototype={}
A.bt.prototype={}
A.bv.prototype={}
A.cm.prototype={}
A.cp.prototype={
h(a){return"unknown"}}
A.co.prototype={
H(a){var s=this.bd(a,0,a.length)
return s==null?a:s},
bd(a,b,c){var s,r,q,p
for(s=b,r=null;s<c;++s){switch(a[s]){case"&":q="&amp;"
break
case'"':q="&quot;"
break
case"'":q="&#39;"
break
case"<":q="&lt;"
break
case">":q="&gt;"
break
case"/":q="&#47;"
break
default:q=null}if(q!=null){if(r==null)r=new A.A("")
if(s>b)r.a+=B.a.i(a,b,s)
r.a+=q
b=s+1}}if(r==null)return null
if(c>b){p=B.a.i(a,b,c)
r.a+=p}p=r.a
return p.charCodeAt(0)==0?p:p}}
A.cw.prototype={
bt(a,b){var s=A.j4(a,this.gbv().a)
return s},
gbv(){return B.C}}
A.cx.prototype={}
A.cP.prototype={}
A.cR.prototype={
H(a){var s,r,q,p=A.bR(0,null,a.length)
if(p===0)return new Uint8Array(0)
s=p*3
r=new Uint8Array(s)
q=new A.dt(r)
if(q.bh(a,0,p)!==p)q.ab()
return new Uint8Array(r.subarray(0,A.iC(0,q.b,s)))}}
A.dt.prototype={
ab(){var s=this,r=s.c,q=s.b,p=s.b=q+1
r.$flags&2&&A.aC(r)
r[q]=239
q=s.b=p+1
r[p]=191
s.b=q+1
r[q]=189},
br(a,b){var s,r,q,p,o=this
if((b&64512)===56320){s=65536+((a&1023)<<10)|b&1023
r=o.c
q=o.b
p=o.b=q+1
r.$flags&2&&A.aC(r)
r[q]=s>>>18|240
q=o.b=p+1
r[p]=s>>>12&63|128
p=o.b=q+1
r[q]=s>>>6&63|128
o.b=p+1
r[p]=s&63|128
return!0}else{o.ab()
return!1}},
bh(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(b!==c&&(a.charCodeAt(c-1)&64512)===55296)--c
for(s=k.c,r=s.$flags|0,q=s.length,p=b;p<c;++p){o=a.charCodeAt(p)
if(o<=127){n=k.b
if(n>=q)break
k.b=n+1
r&2&&A.aC(s)
s[n]=o}else{n=o&64512
if(n===55296){if(k.b+4>q)break
m=p+1
if(k.br(o,a.charCodeAt(m)))p=m}else if(n===56320){if(k.b+3>q)break
k.ab()}else if(o<=2047){n=k.b
l=n+1
if(l>=q)break
k.b=l
r&2&&A.aC(s)
s[n]=o>>>6|192
k.b=l+1
s[l]=o&63|128}else{n=k.b
if(n+2>=q)break
l=k.b=n+1
r&2&&A.aC(s)
s[n]=o>>>12|224
n=k.b=l+1
s[l]=o>>>6&63|128
k.b=n+1
s[n]=o&63|128}}}return p}}
A.cQ.prototype={
H(a){return new A.dq(this.a).be(a,0,null,!0)}}
A.dq.prototype={
be(a,b,c,d){var s,r,q,p,o,n,m=this,l=A.bR(b,c,J.cg(a))
if(b===l)return""
if(a instanceof Uint8Array){s=a
r=s
q=0}else{r=A.iq(a,b,l)
l-=b
q=b
b=0}if(l-b>=15){p=m.a
o=A.ip(p,r,b,l)
if(o!=null){if(!p)return o
if(o.indexOf("\ufffd")<0)return o}}o=m.a5(r,b,l,!0)
p=m.b
if((p&1)!==0){n=A.ir(p)
m.b=0
throw A.b(A.y(n,a,q+m.c))}return o},
a5(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.c.bo(b+c,2)
r=q.a5(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.a5(a,s,c,d)}return q.bu(a,b,c,d)},
bu(a,b,c,d){var s,r,q,p,o,n,m,l=this,k=65533,j=l.b,i=l.c,h=new A.A(""),g=b+1,f=a[b]
$label0$0:for(s=l.a;!0;){for(;!0;g=p){r="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE".charCodeAt(f)&31
i=j<=32?f&61694>>>r:(f&63|i<<6)>>>0
j=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA".charCodeAt(j+r)
if(j===0){q=A.O(i)
h.a+=q
if(g===c)break $label0$0
break}else if((j&1)!==0){if(s)switch(j){case 69:case 67:q=A.O(k)
h.a+=q
break
case 65:q=A.O(k)
h.a+=q;--g
break
default:q=A.O(k)
h.a=(h.a+=q)+A.O(k)
break}else{l.b=j
l.c=g-1
return""}j=0}if(g===c)break $label0$0
p=g+1
f=a[g]}p=g+1
f=a[g]
if(f<128){while(!0){if(!(p<c)){o=c
break}n=p+1
f=a[p]
if(f>=128){o=n-1
p=n
break}p=n}if(o-g<20)for(m=g;m<o;++m){q=A.O(a[m])
h.a+=q}else{q=A.eX(a,g,o)
h.a+=q}if(o===c)break $label0$0
g=p}else g=p}if(d&&j>32)if(s){s=A.O(k)
h.a+=s}else{l.b=77
l.c=c
return""}l.b=j
l.c=i
s=h.a
return s.charCodeAt(0)==0?s:s}}
A.dp.prototype={
$2(a,b){var s,r
if(typeof b=="string")this.a.set(a,b)
else if(b==null)this.a.set(a,"")
else for(s=J.aD(b),r=this.a;s.m();){b=s.gn()
if(typeof b=="string")r.append(a,b)
else if(b==null)r.append(a,"")
else A.fn(b)}},
$S:7}
A.cX.prototype={
h(a){return this.av()}}
A.l.prototype={
gJ(){return A.hD(this)}}
A.bp.prototype={
h(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.cn(s)
return"Assertion failed"}}
A.P.prototype={}
A.G.prototype={
ga7(){return"Invalid argument"+(!this.a?"(s)":"")},
ga6(){return""},
h(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+p,n=s.ga7()+q+o
if(!s.a)return n
return n+s.ga6()+": "+A.cn(s.gai())},
gai(){return this.b}}
A.aZ.prototype={
gai(){return this.b},
ga7(){return"RangeError"},
ga6(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.i(q):""
else if(q==null)s=": Not greater than or equal to "+A.i(r)
else if(q>r)s=": Not in inclusive range "+A.i(r)+".."+A.i(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.i(r)
return s}}
A.bx.prototype={
gai(){return this.b},
ga7(){return"RangeError"},
ga6(){if(this.b<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gl(a){return this.f}}
A.b1.prototype={
h(a){return"Unsupported operation: "+this.a}}
A.bT.prototype={
h(a){return"UnimplementedError: "+this.a}}
A.b0.prototype={
h(a){return"Bad state: "+this.a}}
A.bu.prototype={
h(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.cn(s)+"."}}
A.bO.prototype={
h(a){return"Out of Memory"},
gJ(){return null},
$il:1}
A.b_.prototype={
h(a){return"Stack Overflow"},
gJ(){return null},
$il:1}
A.cY.prototype={
h(a){return"Exception: "+this.a}}
A.bw.prototype={
h(a){var s,r,q,p,o,n,m,l,k,j,i,h=this.a,g=""!==h?"FormatException: "+h:"FormatException",f=this.c,e=this.b
if(typeof e=="string"){if(f!=null)s=f<0||f>e.length
else s=!1
if(s)f=null
if(f==null){if(e.length>78)e=B.a.i(e,0,75)+"..."
return g+"\n"+e}for(r=1,q=0,p=!1,o=0;o<f;++o){n=e.charCodeAt(o)
if(n===10){if(q!==o||!p)++r
q=o+1
p=!1}else if(n===13){++r
q=o+1
p=!0}}g=r>1?g+(" (at line "+r+", character "+(f-q+1)+")\n"):g+(" (at character "+(f+1)+")\n")
m=e.length
for(o=f;o<m;++o){n=e.charCodeAt(o)
if(n===10||n===13){m=o
break}}l=""
if(m-q>78){k="..."
if(f-q<75){j=q+75
i=q}else{if(m-f<75){i=m-75
j=m
k=""}else{i=f-36
j=f+36}l="..."}}else{j=m
i=q
k=""}return g+l+B.a.i(e,i,j)+k+"\n"+B.a.b2(" ",f-i+l.length)+"^\n"}else return f!=null?g+(" (at offset "+A.i(f)+")"):g}}
A.r.prototype={
W(a,b){return A.hc(this,A.S(this).j("r.E"),b)},
gl(a){var s,r=this.gv(this)
for(s=0;r.m();)++s
return s},
D(a,b){var s,r
A.e5(b,"index")
s=this.gv(this)
for(r=b;s.m();){if(r===0)return s.gn();--r}throw A.b(A.e_(b,b-r,this,"index"))},
h(a){return A.ht(this,"(",")")}}
A.t.prototype={
gp(a){return A.j.prototype.gp.call(this,0)},
h(a){return"null"}}
A.j.prototype={$ij:1,
E(a,b){return this===b},
gp(a){return A.bQ(this)},
h(a){return"Instance of '"+A.cD(this)+"'"},
gq(a){return A.jq(this)},
toString(){return this.h(this)}}
A.cb.prototype={
h(a){return""},
$iZ:1}
A.A.prototype={
gl(a){return this.a.length},
h(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.cO.prototype={
$2(a,b){var s,r,q,p=B.a.aP(b,"=")
if(p===-1){if(b!=="")a.A(0,A.eh(b,0,b.length,this.a,!0),"")}else if(p!==0){s=B.a.i(b,0,p)
r=B.a.K(b,p+1)
q=this.a
a.A(0,A.eh(s,0,s.length,q,!0),A.eh(r,0,r.length,q,!0))}return a},
$S:17}
A.cL.prototype={
$2(a,b){throw A.b(A.y("Illegal IPv4 address, "+a,this.a,b))},
$S:18}
A.cM.prototype={
$2(a,b){throw A.b(A.y("Illegal IPv6 address, "+a,this.a,b))},
$S:19}
A.cN.prototype={
$2(a,b){var s
if(b-a>4)this.a.$2("an IPv6 part can only contain a maximum of 4 hex digits",a)
s=A.dR(B.a.i(this.b,a,b),16)
if(s<0||s>65535)this.a.$2("each part must be in the range of `0x0..0xFFFF`",a)
return s},
$S:20}
A.bh.prototype={
gV(){var s,r,q,p,o=this,n=o.w
if(n===$){s=o.a
r=s.length!==0?""+s+":":""
q=o.c
p=q==null
if(!p||s==="file"){s=r+"//"
r=o.b
if(r.length!==0)s=s+r+"@"
if(!p)s+=q
r=o.d
if(r!=null)s=s+":"+A.i(r)}else s=r
s+=o.e
r=o.f
if(r!=null)s=s+"?"+r
r=o.r
if(r!=null)s=s+"#"+r
n!==$&&A.bn()
n=o.w=s.charCodeAt(0)==0?s:s}return n},
gp(a){var s,r=this,q=r.y
if(q===$){s=B.a.gp(r.gV())
r.y!==$&&A.bn()
r.y=s
q=s}return q},
gal(){var s,r=this,q=r.z
if(q===$){s=r.f
s=A.f1(s==null?"":s)
r.z!==$&&A.bn()
q=r.z=new A.ar(s,t.h)}return q},
gb_(){return this.b},
gag(){var s=this.c
if(s==null)return""
if(B.a.t(s,"["))return B.a.i(s,1,s.length-1)
return s},
ga_(){var s=this.d
return s==null?A.fd(this.a):s},
gak(){var s=this.f
return s==null?"":s},
gaJ(){var s=this.r
return s==null?"":s},
am(a){var s,r,q,p,o=this,n=o.a,m=n==="file",l=o.b,k=o.d,j=o.c
if(!(j!=null))j=l.length!==0||k!=null||m?"":null
s=o.e
if(!m)r=j!=null&&s.length!==0
else r=!0
if(r&&!B.a.t(s,"/"))s="/"+s
q=s
p=A.ef(null,0,0,a)
return A.ed(n,l,j,k,q,p,o.r)},
gaS(){if(this.a!==""){var s=this.r
s=(s==null?"":s)===""}else s=!1
return s},
gaL(){return this.c!=null},
gaO(){return this.f!=null},
gaM(){return this.r!=null},
h(a){return this.gV()},
E(a,b){var s,r,q,p=this
if(b==null)return!1
if(p===b)return!0
s=!1
if(t.R.b(b))if(p.a===b.ga1())if(p.c!=null===b.gaL())if(p.b===b.gb_())if(p.gag()===b.gag())if(p.ga_()===b.ga_())if(p.e===b.gaV()){r=p.f
q=r==null
if(!q===b.gaO()){if(q)r=""
if(r===b.gak()){r=p.r
q=r==null
if(!q===b.gaM()){s=q?"":r
s=s===b.gaJ()}}}}return s},
$ibW:1,
ga1(){return this.a},
gaV(){return this.e}}
A.dn.prototype={
$2(a,b){var s=this.b,r=this.a
s.a+=r.a
r.a="&"
r=A.fj(1,a,B.e,!0)
r=s.a+=r
if(b!=null&&b.length!==0){s.a=r+"="
r=A.fj(1,b,B.e,!0)
s.a+=r}},
$S:21}
A.dm.prototype={
$2(a,b){var s,r
if(b==null||typeof b=="string")this.a.$2(a,b)
else for(s=J.aD(b),r=this.a;s.m();)r.$2(a,s.gn())},
$S:7}
A.cK.prototype={
gaZ(){var s,r,q,p,o=this,n=null,m=o.c
if(m==null){m=o.a
s=o.b[0]+1
r=B.a.Y(m,"?",s)
q=m.length
if(r>=0){p=A.bi(m,r+1,q,256,!1,!1)
q=r}else p=n
m=o.c=new A.c0("data","",n,n,A.bi(m,s,q,128,!1,!1),p,n)}return m},
h(a){var s=this.a
return this.b[0]===-1?"data:"+s:s}}
A.c9.prototype={
gaL(){return this.c>0},
gaN(){return this.c>0&&this.d+1<this.e},
gaO(){return this.f<this.r},
gaM(){return this.r<this.a.length},
gaS(){return this.b>0&&this.r>=this.a.length},
ga1(){var s=this.w
return s==null?this.w=this.bc():s},
bc(){var s,r=this,q=r.b
if(q<=0)return""
s=q===4
if(s&&B.a.t(r.a,"http"))return"http"
if(q===5&&B.a.t(r.a,"https"))return"https"
if(s&&B.a.t(r.a,"file"))return"file"
if(q===7&&B.a.t(r.a,"package"))return"package"
return B.a.i(r.a,0,q)},
gb_(){var s=this.c,r=this.b+3
return s>r?B.a.i(this.a,r,s-1):""},
gag(){var s=this.c
return s>0?B.a.i(this.a,s,this.d):""},
ga_(){var s,r=this
if(r.gaN())return A.dR(B.a.i(r.a,r.d+1,r.e),null)
s=r.b
if(s===4&&B.a.t(r.a,"http"))return 80
if(s===5&&B.a.t(r.a,"https"))return 443
return 0},
gaV(){return B.a.i(this.a,this.e,this.f)},
gak(){var s=this.f,r=this.r
return s<r?B.a.i(this.a,s+1,r):""},
gaJ(){var s=this.r,r=this.a
return s<r.length?B.a.K(r,s+1):""},
gal(){if(this.f>=this.r)return B.a_
return new A.ar(A.f1(this.gak()),t.h)},
am(a){var s,r,q,p,o,n=this,m=null,l=n.ga1(),k=l==="file",j=n.c,i=j>0?B.a.i(n.a,n.b+3,j):"",h=n.gaN()?n.ga_():m
j=n.c
if(j>0)s=B.a.i(n.a,j,n.d)
else s=i.length!==0||h!=null||k?"":m
j=n.a
r=B.a.i(j,n.e,n.f)
if(!k)q=s!=null&&r.length!==0
else q=!0
if(q&&!B.a.t(r,"/"))r="/"+r
p=A.ef(m,0,0,a)
q=n.r
o=q<j.length?B.a.K(j,q+1):m
return A.ed(l,i,s,h,r,p,o)},
gp(a){var s=this.x
return s==null?this.x=B.a.gp(this.a):s},
E(a,b){if(b==null)return!1
if(this===b)return!0
return t.R.b(b)&&this.a===b.h(0)},
h(a){return this.a},
$ibW:1}
A.c0.prototype={}
A.dV.prototype={
$1(a){return this.a.ac(a)},
$S:2}
A.dW.prototype={
$1(a){if(a==null)return this.a.aH(new A.cB(a===undefined))
return this.a.aH(a)},
$S:2}
A.cB.prototype={
h(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.m.prototype={
av(){return"Kind."+this.b},
h(a){var s
switch(this.a){case 0:s="accessor"
break
case 1:s="constant"
break
case 2:s="constructor"
break
case 3:s="class"
break
case 4:s="dynamic"
break
case 5:s="enum"
break
case 6:s="extension"
break
case 7:s="extension type"
break
case 8:s="function"
break
case 9:s="library"
break
case 10:s="method"
break
case 11:s="mixin"
break
case 12:s="Never"
break
case 13:s="package"
break
case 14:s="parameter"
break
case 15:s="prefix"
break
case 16:s="property"
break
case 17:s="SDK"
break
case 18:s="topic"
break
case 19:s="top-level constant"
break
case 20:s="top-level property"
break
case 21:s="typedef"
break
case 22:s="type parameter"
break
default:s=null}return s}}
A.B.prototype={
av(){return"_MatchPosition."+this.b}}
A.cq.prototype={
aI(a){var s,r,q,p,o,n,m,l,k,j,i
if(a.length===0)return A.k([],t.M)
s=a.toLowerCase()
r=A.k([],t.r)
for(q=this.a,p=q.length,o=s.length>1,n="dart:"+s,m=0;m<q.length;q.length===p||(0,A.dX)(q),++m){l=q[m]
k=new A.ct(r,l)
j=l.a.toLowerCase()
i=l.b.toLowerCase()
if(j===s||i===s||j===n)k.$1(B.ag)
else if(o)if(B.a.t(j,s)||B.a.t(i,s))k.$1(B.ah)
else if(B.a.N(j,s)||B.a.N(i,s))k.$1(B.ai)}B.b.b5(r,new A.cr())
q=t.V
q=A.eN(new A.ab(r,new A.cs(),q),q.j("I.E"))
return q}}
A.ct.prototype={
$1(a){this.a.push(new A.c8(this.b,a))},
$S:22}
A.cr.prototype={
$2(a,b){var s,r,q=a.b.a-b.b.a
if(q!==0)return q
s=a.a
r=b.a
q=s.c-r.c
if(q!==0)return q
q=s.gaB()-r.gaB()
if(q!==0)return q
q=s.f-r.f
if(q!==0)return q
return s.a.length-r.a.length},
$S:23}
A.cs.prototype={
$1(a){return a.a},
$S:24}
A.w.prototype={
gaB(){var s=0
switch(this.d.a){case 3:break
case 5:break
case 6:break
case 7:break
case 11:break
case 19:break
case 20:break
case 21:break
case 0:s=1
break
case 1:s=1
break
case 2:s=1
break
case 8:s=1
break
case 10:s=1
break
case 16:s=1
break
case 9:s=2
break
case 13:s=2
break
case 18:s=2
break
case 4:s=3
break
case 12:s=3
break
case 14:s=3
break
case 15:s=3
break
case 17:s=3
break
case 22:s=3
break
default:s=null}return s}}
A.cl.prototype={}
A.dC.prototype={
$0(){var s,r=v.G.document.body
if(r==null)return""
if(J.F(r.getAttribute("data-using-base-href"),"false")){s=r.getAttribute("data-base-href")
return s==null?"":s}else return""},
$S:25}
A.dP.prototype={
$0(){A.jD("Could not activate search functionality.")
var s=this.a
if(s!=null)s.placeholder="Failed to initialize search"
s=this.b
if(s!=null)s.placeholder="Failed to initialize search"
s=this.c
if(s!=null)s.placeholder="Failed to initialize search"},
$S:0}
A.dO.prototype={
$1(a){return this.b1(a)},
b1(a){var s=0,r=A.fy(t.P),q,p=this,o,n,m,l,k,j,i,h,g
var $async$$1=A.fF(function(b,c){if(b===1)return A.fp(c,r)
while(true)switch(s){case 0:if(!J.F(a.status,200)){p.a.$0()
s=1
break}i=J
h=t.j
g=B.w
s=3
return A.fo(A.dU(a.text(),t.N),$async$$1)
case 3:o=i.h6(h.a(g.bt(c,null)),t.a)
n=o.$ti.j("ab<e.E,w>")
n=A.eN(new A.ab(o,A.jF(),n),n.j("I.E"))
m=new A.cq(n)
n=v.G
l=A.bX(J.ak(n.window.location),0,null).gal().k(0,"search")
if(l!=null){k=A.hs(m.aI(l))
j=k==null?null:k.e
if(j!=null){n.window.location.assign($.bo()+j)
s=1
break}}n=p.b
if(n!=null)A.ea(m).ah(n)
n=p.c
if(n!=null)A.ea(m).ah(n)
n=p.d
if(n!=null)A.ea(m).ah(n)
case 1:return A.fq(q,r)}})
return A.fr($async$$1,r)},
$S:8}
A.dc.prototype={
gG(){var s,r=this,q=r.c
if(q===$){s=v.G.document.createElement("div")
s.setAttribute("role","listbox")
s.setAttribute("aria-expanded","false")
s.style.display="none"
s.classList.add("tt-menu")
s.appendChild(r.gaU())
s.appendChild(r.gR())
r.c!==$&&A.bn()
r.c=s
q=s}return q},
gaU(){var s,r=this.d
if(r===$){s=v.G.document.createElement("div")
s.classList.add("enter-search-message")
this.d!==$&&A.bn()
this.d=s
r=s}return r},
gR(){var s,r=this.e
if(r===$){s=v.G.document.createElement("div")
s.classList.add("tt-search-results")
this.e!==$&&A.bn()
this.e=s
r=s}return r},
ah(a){var s,r,q,p=this
a.disabled=!1
a.setAttribute("placeholder","Search API Docs")
s=v.G
s.document.addEventListener("keydown",A.a4(new A.dd(a)))
r=s.document.createElement("div")
r.classList.add("tt-wrapper")
a.replaceWith(r)
a.setAttribute("autocomplete","off")
a.setAttribute("spellcheck","false")
a.classList.add("tt-input")
r.appendChild(a)
r.appendChild(p.gG())
p.b3(a)
if(J.h8(s.window.location.href,"search.html")){q=p.b.gal().k(0,"q")
if(q==null)return
q=B.j.H(q)
$.er=$.dG
p.bB(q,!0)
p.b4(q)
p.af()
$.er=10}},
b4(a){var s,r,q,p=v.G,o=p.document.getElementById("dartdoc-main-content")
if(o==null)return
o.textContent=""
s=p.document.createElement("section")
s.classList.add("search-summary")
o.appendChild(s)
s=p.document.createElement("h2")
s.innerHTML="Search Results"
o.appendChild(s)
s=p.document.createElement("div")
s.classList.add("search-summary")
s.innerHTML=""+$.dG+' results for "'+a+'"'
o.appendChild(s)
if($.a3.a!==0)for(p=new A.aR($.a3,$.a3.r,$.a3.e);p.m();)o.appendChild(p.d)
else{s=p.document.createElement("div")
s.classList.add("search-summary")
s.innerHTML='There was not a match for "'+a+'". Want to try searching from additional Dart-related sites? '
r=A.bX("https://dart.dev/search?cx=011220921317074318178%3A_yy-tmb5t_i&ie=UTF-8&hl=en&q=",0,null).am(A.eM(["q",a],t.N,t.z))
q=p.document.createElement("a")
q.setAttribute("href",r.gV())
q.textContent="Search on dart.dev."
s.appendChild(q)
o.appendChild(s)}},
af(){var s=this.gG()
s.style.display="none"
s.setAttribute("aria-expanded","false")
return s},
aY(a,b,c){var s,r,q,p,o=this
o.x=A.k([],t.M)
s=o.w
B.b.X(s)
$.a3.X(0)
o.gR().textContent=""
r=b.length
if(r===0){o.af()
return}for(q=0;q<b.length;b.length===r||(0,A.dX)(b),++q)s.push(A.iD(a,b[q]))
for(r=J.aD(c?new A.aS($.a3,A.S($.a3).j("aS<2>")):s);r.m();){p=r.gn()
o.gR().appendChild(p)}o.x=b
o.y=-1
if(o.gR().hasChildNodes()){r=o.gG()
r.style.display="block"
r.setAttribute("aria-expanded","true")}r=$.dG
r=r>10?'Press "Enter" key to see all '+r+" results":""
o.gaU().textContent=r},
bM(a,b){return this.aY(a,b,!1)},
ae(a,b,c){var s,r,q,p=this
if(p.r===a&&!b)return
if(a.length===0){p.bM("",A.k([],t.M))
return}s=p.a.aI(a)
r=s.length
$.dG=r
q=$.er
if(r>q)s=B.b.b6(s,0,q)
p.r=a
p.aY(a,s,c)},
bB(a,b){return this.ae(a,!1,b)},
aK(a){return this.ae(a,!1,!1)},
bA(a,b){return this.ae(a,b,!1)},
aF(a){var s,r=this
r.y=-1
s=r.f
if(s!=null){a.value=s
r.f=null}r.af()},
b3(a){var s=this
a.addEventListener("focus",A.a4(new A.de(s,a)))
a.addEventListener("blur",A.a4(new A.df(s,a)))
a.addEventListener("input",A.a4(new A.dg(s,a)))
a.addEventListener("keydown",A.a4(new A.dh(s,a)))}}
A.dd.prototype={
$1(a){var s
if(!J.F(a.key,"/"))return
s=v.G.document.activeElement
if(s==null||!B.a2.N(0,s.nodeName.toLowerCase())){a.preventDefault()
this.a.focus()}},
$S:1}
A.de.prototype={
$1(a){this.a.bA(this.b.value,!0)},
$S:1}
A.df.prototype={
$1(a){this.a.aF(this.b)},
$S:1}
A.dg.prototype={
$1(a){this.a.aK(this.b.value)},
$S:1}
A.dh.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(!J.F(a.type,"keydown"))return
if(J.F(a.code,"Enter")){a.preventDefault()
s=e.a
r=s.y
if(r!==-1){q=s.w[r].getAttribute("data-href")
if(q!=null)v.G.window.location.assign($.bo()+q)
return}else{p=B.j.H(s.r)
o=A.bX($.bo()+"search.html",0,null).am(A.eM(["q",p],t.N,t.z))
v.G.window.location.assign(o.gV())
return}}s=e.a
r=s.w
n=r.length-1
m=s.y
if(J.F(a.code,"ArrowUp")){l=s.y
if(l===-1)s.y=n
else s.y=l-1}else if(J.F(a.code,"ArrowDown")){l=s.y
if(l===n)s.y=-1
else s.y=l+1}else if(J.F(a.code,"Escape"))s.aF(e.b)
else{if(s.f!=null){s.f=null
s.aK(e.b.value)}return}l=m!==-1
if(l)r[m].classList.remove("tt-cursor")
k=s.y
if(k!==-1){j=r[k]
j.classList.add("tt-cursor")
r=s.y
if(r===0)s.gG().scrollTop=0
else if(r===n)s.gG().scrollTop=s.gG().scrollHeight
else{i=j.offsetTop
h=s.gG().offsetHeight
if(i<h||h<i+j.offsetHeight)j.scrollIntoView()}if(s.f==null)s.f=e.b.value
e.b.value=s.x[s.y].a}else{g=s.f
if(g!=null){r=l
f=g}else{f=null
r=!1}if(r){e.b.value=f
s.f=null}}a.preventDefault()},
$S:1}
A.dz.prototype={
$1(a){a.preventDefault()},
$S:1}
A.dA.prototype={
$1(a){var s=this.a.e
if(s!=null){v.G.window.location.assign($.bo()+s)
a.preventDefault()}},
$S:1}
A.dB.prototype={
$1(a){return"<strong class='tt-highlight'>"+A.i(a.k(0,0))+"</strong>"},
$S:26}
A.dD.prototype={
$1(a){var s=this.a
if(s!=null)s.classList.toggle("active")
s=this.b
if(s!=null)s.classList.toggle("active")},
$S:1}
A.dE.prototype={
$1(a){return this.b0(a)},
b0(a){var s=0,r=A.fy(t.P),q,p=this,o,n
var $async$$1=A.fF(function(b,c){if(b===1)return A.fp(c,r)
while(true)switch(s){case 0:if(!J.F(a.status,200)){o=v.G.document.createElement("a")
o.href="https://dart.dev/tools/dart-doc#troubleshoot"
o.text="Failed to load sidebar. Visit dart.dev for help troubleshooting."
p.a.appendChild(o)
s=1
break}s=3
return A.fo(A.dU(a.text(),t.N),$async$$1)
case 3:n=c
o=v.G.document.createElement("div")
o.innerHTML=n
A.fE(p.b,o)
p.a.appendChild(o)
case 1:return A.fq(q,r)}})
return A.fr($async$$1,r)},
$S:8}
A.dQ.prototype={
$1(a){var s=this.a,r=v.G
if(a){s.classList.remove("light-theme")
s.classList.add("dark-theme")
r.window.localStorage.setItem("colorTheme","true")}else{s.classList.remove("dark-theme")
s.classList.add("light-theme")
r.window.localStorage.setItem("colorTheme","false")}},
$S:27}
A.dN.prototype={
$1(a){this.b.$1(!this.a.classList.contains("dark-theme"))},
$S:1};(function aliases(){var s=J.Y.prototype
s.b7=s.h})();(function installTearOffs(){var s=hunkHelpers._static_2,r=hunkHelpers._static_1,q=hunkHelpers._static_0
s(J,"iR","hy",28)
r(A,"jg","hQ",3)
r(A,"jh","hR",3)
r(A,"ji","hS",3)
q(A,"fH","ja",0)
r(A,"jF","hn",29)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.j,null)
q(A.j,[A.e1,J.by,J.V,A.r,A.br,A.l,A.e,A.cE,A.am,A.aK,A.bV,A.b9,A.aF,A.c5,A.ao,A.cH,A.cC,A.aJ,A.ba,A.a7,A.N,A.cy,A.bD,A.aR,A.cu,A.c6,A.cS,A.J,A.c2,A.dk,A.di,A.bY,A.H,A.c_,A.as,A.v,A.bZ,A.ca,A.dv,A.cc,A.aT,A.bt,A.bv,A.cp,A.dt,A.dq,A.cX,A.bO,A.b_,A.cY,A.bw,A.t,A.cb,A.A,A.bh,A.cK,A.c9,A.cB,A.cq,A.w,A.cl,A.dc])
q(J.by,[J.bz,J.aM,J.aP,J.aO,J.aQ,J.aN,J.a8])
q(J.aP,[J.Y,J.o,A.bE,A.aW])
q(J.Y,[J.bP,J.ap,J.X])
r(J.cv,J.o)
q(J.aN,[J.aL,J.bA])
q(A.r,[A.a0,A.c])
q(A.a0,[A.a6,A.bj])
r(A.b4,A.a6)
r(A.b3,A.bj)
r(A.M,A.b3)
q(A.l,[A.bC,A.P,A.bB,A.bU,A.bS,A.c1,A.bp,A.G,A.b1,A.bT,A.b0,A.bu])
r(A.aq,A.e)
r(A.bs,A.aq)
q(A.c,[A.I,A.aa,A.aS])
q(A.I,[A.ab,A.c4])
r(A.c7,A.b9)
r(A.c8,A.c7)
r(A.aH,A.aF)
r(A.aG,A.ao)
r(A.aI,A.aG)
r(A.aY,A.P)
q(A.a7,[A.cj,A.ck,A.cG,A.dK,A.dM,A.cU,A.cT,A.dw,A.d6,A.dV,A.dW,A.ct,A.cs,A.dO,A.dd,A.de,A.df,A.dg,A.dh,A.dz,A.dA,A.dB,A.dD,A.dE,A.dQ,A.dN])
q(A.cG,[A.cF,A.aE])
q(A.N,[A.a9,A.c3])
q(A.ck,[A.dL,A.dx,A.dH,A.d7,A.cz,A.dp,A.cO,A.cL,A.cM,A.cN,A.dn,A.dm,A.cr])
q(A.aW,[A.bF,A.an])
q(A.an,[A.b5,A.b7])
r(A.b6,A.b5)
r(A.aU,A.b6)
r(A.b8,A.b7)
r(A.aV,A.b8)
q(A.aU,[A.bG,A.bH])
q(A.aV,[A.bI,A.bJ,A.bK,A.bL,A.bM,A.aX,A.bN])
r(A.bb,A.c1)
q(A.cj,[A.cV,A.cW,A.dj,A.cZ,A.d2,A.d1,A.d0,A.d_,A.d5,A.d4,A.d3,A.dF,A.db,A.ds,A.dr,A.dC,A.dP])
r(A.b2,A.c_)
r(A.da,A.dv)
r(A.bg,A.aT)
r(A.ar,A.bg)
q(A.bt,[A.ch,A.cm,A.cw])
q(A.bv,[A.ci,A.co,A.cx,A.cR,A.cQ])
r(A.cP,A.cm)
q(A.G,[A.aZ,A.bx])
r(A.c0,A.bh)
q(A.cX,[A.m,A.B])
s(A.aq,A.bV)
s(A.bj,A.e)
s(A.b5,A.e)
s(A.b6,A.aK)
s(A.b7,A.e)
s(A.b8,A.aK)
s(A.bg,A.cc)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{a:"int",q:"double",fL:"num",d:"String",bm:"bool",t:"Null",f:"List",j:"Object",z:"Map"},mangledNames:{},types:["~()","t(n)","~(@)","~(~())","t(@)","t()","@()","~(d,@)","W<t>(n)","@(@)","@(@,d)","@(d)","t(~())","t(@,Z)","~(a,@)","t(j,Z)","~(j?,j?)","z<d,d>(z<d,d>,d)","~(d,a)","~(d,a?)","a(a,a)","~(d,d?)","~(B)","a(+item,matchPosition(w,B),+item,matchPosition(w,B))","w(+item,matchPosition(w,B))","d()","d(cA)","~(bm)","a(@,@)","w(z<d,@>)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{"2;item,matchPosition":(a,b)=>c=>c instanceof A.c8&&a.b(c.a)&&b.b(c.b)}}
A.i5(v.typeUniverse,JSON.parse('{"bP":"Y","ap":"Y","X":"Y","bz":{"bm":[],"h":[]},"aM":{"t":[],"h":[]},"aP":{"n":[]},"Y":{"n":[]},"o":{"f":["1"],"c":["1"],"n":[]},"cv":{"o":["1"],"f":["1"],"c":["1"],"n":[]},"aN":{"q":[]},"aL":{"q":[],"a":[],"h":[]},"bA":{"q":[],"h":[]},"a8":{"d":[],"h":[]},"a0":{"r":["2"]},"a6":{"a0":["1","2"],"r":["2"],"r.E":"2"},"b4":{"a6":["1","2"],"a0":["1","2"],"c":["2"],"r":["2"],"r.E":"2"},"b3":{"e":["2"],"f":["2"],"a0":["1","2"],"c":["2"],"r":["2"]},"M":{"b3":["1","2"],"e":["2"],"f":["2"],"a0":["1","2"],"c":["2"],"r":["2"],"e.E":"2","r.E":"2"},"bC":{"l":[]},"bs":{"e":["a"],"f":["a"],"c":["a"],"e.E":"a"},"c":{"r":["1"]},"I":{"c":["1"],"r":["1"]},"ab":{"I":["2"],"c":["2"],"r":["2"],"I.E":"2","r.E":"2"},"aq":{"e":["1"],"f":["1"],"c":["1"]},"aF":{"z":["1","2"]},"aH":{"z":["1","2"]},"aG":{"ao":["1"],"c":["1"]},"aI":{"ao":["1"],"c":["1"]},"aY":{"P":[],"l":[]},"bB":{"l":[]},"bU":{"l":[]},"ba":{"Z":[]},"bS":{"l":[]},"a9":{"N":["1","2"],"z":["1","2"],"N.V":"2"},"aa":{"c":["1"],"r":["1"],"r.E":"1"},"aS":{"c":["1"],"r":["1"],"r.E":"1"},"c6":{"e6":[],"cA":[]},"bE":{"n":[],"h":[]},"aW":{"n":[]},"bF":{"n":[],"h":[]},"an":{"C":["1"],"n":[]},"aU":{"e":["q"],"f":["q"],"C":["q"],"c":["q"],"n":[]},"aV":{"e":["a"],"f":["a"],"C":["a"],"c":["a"],"n":[]},"bG":{"e":["q"],"f":["q"],"C":["q"],"c":["q"],"n":[],"h":[],"e.E":"q"},"bH":{"e":["q"],"f":["q"],"C":["q"],"c":["q"],"n":[],"h":[],"e.E":"q"},"bI":{"e":["a"],"f":["a"],"C":["a"],"c":["a"],"n":[],"h":[],"e.E":"a"},"bJ":{"e":["a"],"f":["a"],"C":["a"],"c":["a"],"n":[],"h":[],"e.E":"a"},"bK":{"e":["a"],"f":["a"],"C":["a"],"c":["a"],"n":[],"h":[],"e.E":"a"},"bL":{"e":["a"],"f":["a"],"C":["a"],"c":["a"],"n":[],"h":[],"e.E":"a"},"bM":{"e":["a"],"f":["a"],"C":["a"],"c":["a"],"n":[],"h":[],"e.E":"a"},"aX":{"e":["a"],"f":["a"],"C":["a"],"c":["a"],"n":[],"h":[],"e.E":"a"},"bN":{"e":["a"],"f":["a"],"C":["a"],"c":["a"],"n":[],"h":[],"e.E":"a"},"c1":{"l":[]},"bb":{"P":[],"l":[]},"H":{"l":[]},"b2":{"c_":["1"]},"v":{"W":["1"]},"e":{"f":["1"],"c":["1"]},"N":{"z":["1","2"]},"aT":{"z":["1","2"]},"ar":{"z":["1","2"]},"ao":{"c":["1"]},"c3":{"N":["d","@"],"z":["d","@"],"N.V":"@"},"c4":{"I":["d"],"c":["d"],"r":["d"],"I.E":"d","r.E":"d"},"f":{"c":["1"]},"e6":{"cA":[]},"bp":{"l":[]},"P":{"l":[]},"G":{"l":[]},"aZ":{"l":[]},"bx":{"l":[]},"b1":{"l":[]},"bT":{"l":[]},"b0":{"l":[]},"bu":{"l":[]},"bO":{"l":[]},"b_":{"l":[]},"cb":{"Z":[]},"bh":{"bW":[]},"c9":{"bW":[]},"c0":{"bW":[]},"hq":{"f":["a"],"c":["a"]},"hM":{"f":["a"],"c":["a"]},"hL":{"f":["a"],"c":["a"]},"ho":{"f":["a"],"c":["a"]},"hJ":{"f":["a"],"c":["a"]},"hp":{"f":["a"],"c":["a"]},"hK":{"f":["a"],"c":["a"]},"hl":{"f":["q"],"c":["q"]},"hm":{"f":["q"],"c":["q"]}}'))
A.i4(v.typeUniverse,JSON.parse('{"aK":1,"bV":1,"aq":1,"bj":2,"aF":2,"aG":1,"bD":1,"aR":1,"an":1,"ca":1,"cc":2,"aT":2,"bg":2,"bt":2,"bv":2}'))
var u={f:"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\u03f6\x00\u0404\u03f4 \u03f4\u03f6\u01f6\u01f6\u03f6\u03fc\u01f4\u03ff\u03ff\u0584\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u05d4\u01f4\x00\u01f4\x00\u0504\u05c4\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u0400\x00\u0400\u0200\u03f7\u0200\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u0200\u0200\u0200\u03f7\x00",c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type"}
var t=(function rtii(){var s=A.ce
return{U:s("c<@>"),C:s("l"),Z:s("jN"),M:s("o<w>"),O:s("o<n>"),f:s("o<j>"),r:s("o<+item,matchPosition(w,B)>"),s:s("o<d>"),b:s("o<@>"),t:s("o<a>"),T:s("aM"),m:s("n"),g:s("X"),p:s("C<@>"),j:s("f<@>"),a:s("z<d,@>"),V:s("ab<+item,matchPosition(w,B),w>"),P:s("t"),K:s("j"),L:s("jO"),d:s("+()"),F:s("e6"),l:s("Z"),N:s("d"),k:s("h"),_:s("P"),o:s("ap"),h:s("ar<d,d>"),R:s("bW"),c:s("v<@>"),y:s("bm"),i:s("q"),z:s("@"),v:s("@(j)"),Q:s("@(j,Z)"),S:s("a"),W:s("W<t>?"),A:s("n?"),X:s("j?"),w:s("d?"),u:s("bm?"),I:s("q?"),x:s("a?"),n:s("fL?"),H:s("fL"),q:s("~")}})();(function constants(){var s=hunkHelpers.makeConstList
B.z=J.by.prototype
B.b=J.o.prototype
B.c=J.aL.prototype
B.a=J.a8.prototype
B.A=J.X.prototype
B.B=J.aP.prototype
B.n=J.bP.prototype
B.i=J.ap.prototype
B.aj=new A.ci()
B.o=new A.ch()
B.ak=new A.cp()
B.j=new A.co()
B.k=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.p=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.v=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.q=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.u=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.t=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.r=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.l=function(hooks) { return hooks; }

B.w=new A.cw()
B.x=new A.bO()
B.h=new A.cE()
B.e=new A.cP()
B.y=new A.cR()
B.d=new A.da()
B.f=new A.cb()
B.C=new A.cx(null)
B.D=new A.m(0,"accessor")
B.E=new A.m(1,"constant")
B.P=new A.m(2,"constructor")
B.T=new A.m(3,"class_")
B.U=new A.m(4,"dynamic")
B.V=new A.m(5,"enum_")
B.W=new A.m(6,"extension")
B.X=new A.m(7,"extensionType")
B.Y=new A.m(8,"function")
B.Z=new A.m(9,"library")
B.F=new A.m(10,"method")
B.G=new A.m(11,"mixin")
B.H=new A.m(12,"never")
B.I=new A.m(13,"package")
B.J=new A.m(14,"parameter")
B.K=new A.m(15,"prefix")
B.L=new A.m(16,"property")
B.M=new A.m(17,"sdk")
B.N=new A.m(18,"topic")
B.O=new A.m(19,"topLevelConstant")
B.Q=new A.m(20,"topLevelProperty")
B.R=new A.m(21,"typedef")
B.S=new A.m(22,"typeParameter")
B.m=A.k(s([B.D,B.E,B.P,B.T,B.U,B.V,B.W,B.X,B.Y,B.Z,B.F,B.G,B.H,B.I,B.J,B.K,B.L,B.M,B.N,B.O,B.Q,B.R,B.S]),A.ce("o<m>"))
B.a0={}
B.a_=new A.aH(B.a0,[],A.ce("aH<d,d>"))
B.a1={input:0,textarea:1}
B.a2=new A.aI(B.a1,2,A.ce("aI<d>"))
B.a3=A.K("jK")
B.a4=A.K("jL")
B.a5=A.K("hl")
B.a6=A.K("hm")
B.a7=A.K("ho")
B.a8=A.K("hp")
B.a9=A.K("hq")
B.aa=A.K("j")
B.ab=A.K("hJ")
B.ac=A.K("hK")
B.ad=A.K("hL")
B.ae=A.K("hM")
B.af=new A.cQ(!1)
B.ag=new A.B(0,"isExactly")
B.ah=new A.B(1,"startsWith")
B.ai=new A.B(2,"contains")})();(function staticFields(){$.d8=null
$.ai=A.k([],t.f)
$.eP=null
$.eH=null
$.eG=null
$.fK=null
$.fG=null
$.fO=null
$.dI=null
$.dS=null
$.ew=null
$.d9=A.k([],A.ce("o<f<j>?>"))
$.av=null
$.bk=null
$.bl=null
$.eo=!1
$.p=B.d
$.er=10
$.dG=0
$.a3=A.e3(t.N,t.m)})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal
s($,"jM","eA",()=>A.jp("_$dart_dartClosure"))
s($,"jQ","fQ",()=>A.Q(A.cI({
toString:function(){return"$receiver$"}})))
s($,"jR","fR",()=>A.Q(A.cI({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"jS","fS",()=>A.Q(A.cI(null)))
s($,"jT","fT",()=>A.Q(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"jW","fW",()=>A.Q(A.cI(void 0)))
s($,"jX","fX",()=>A.Q(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"jV","fV",()=>A.Q(A.eY(null)))
s($,"jU","fU",()=>A.Q(function(){try{null.$method$}catch(r){return r.message}}()))
s($,"jZ","fZ",()=>A.Q(A.eY(void 0)))
s($,"jY","fY",()=>A.Q(function(){try{(void 0).$method$}catch(r){return r.message}}()))
s($,"k_","eB",()=>A.hP())
s($,"k5","h4",()=>A.hB(4096))
s($,"k3","h2",()=>new A.ds().$0())
s($,"k4","h3",()=>new A.dr().$0())
s($,"k0","h_",()=>A.hA(A.iF(A.k([-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-2,-2,-2,-2,-2,62,-2,62,-2,63,52,53,54,55,56,57,58,59,60,61,-2,-2,-2,-1,-2,-2,-2,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-2,-2,-2,-2,63,-2,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-2,-2,-2,-2,-2],t.t))))
s($,"k1","h0",()=>A.eT("^[\\-\\.0-9A-Z_a-z~]*$",!0))
s($,"k2","h1",()=>typeof URLSearchParams=="function")
s($,"k6","dY",()=>A.fM(B.aa))
s($,"k7","bo",()=>new A.dC().$0())})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.bE,ArrayBufferView:A.aW,DataView:A.bF,Float32Array:A.bG,Float64Array:A.bH,Int16Array:A.bI,Int32Array:A.bJ,Int8Array:A.bK,Uint16Array:A.bL,Uint32Array:A.bM,Uint8ClampedArray:A.aX,CanvasPixelArray:A.aX,Uint8Array:A.bN})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.an.$nativeSuperclassTag="ArrayBufferView"
A.b5.$nativeSuperclassTag="ArrayBufferView"
A.b6.$nativeSuperclassTag="ArrayBufferView"
A.aU.$nativeSuperclassTag="ArrayBufferView"
A.b7.$nativeSuperclassTag="ArrayBufferView"
A.b8.$nativeSuperclassTag="ArrayBufferView"
A.aV.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$0=function(){return this()}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$1$1=function(a){return this(a)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$1$0=function(){return this()}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.jB
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=docs.dart.js.map
