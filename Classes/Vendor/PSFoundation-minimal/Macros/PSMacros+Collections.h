//;
//  PSMacros-Collections.h
//  PSFoundation
//
//  Includes code by the following:
//   - Michael Ash.       2010. BSD.
//   - Dirk Holtwick.
//   - Peter Steinberger. 2010. BSD.
//


#define IDARRAY(...) ((id[]){ __VA_ARGS__ })
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))

#define ARRAY(...) ([NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])
#define SET(...) ([NSSet setWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])

// this is key/object order, not object/key order, thus all the fuss
#define DICT(...) MADictionaryWithKeysAndObjects(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

#define IDARRAY(...) ((id[]){ __VA_ARGS__ })
#define CFTYPEARRAY(...) ((CFTypeRef[]){ __VA_ARGS__ })
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))
#define CFTYPECOUNT(...) (sizeof(CFTYPEARRAY(__VA_ARGS__)) / sizeof(CFTypeRef))

#define CFARRAY(...) CFArrayCreate(kCFAllocatorDefault, CFTYPEARRAY(__VA_ARGS__), CFTYPECOUNT(__VA_ARGS__), NULL)
#define CFSET(...) CFSetCreate(kCFAllocatorDefault, CFTYPEARRAY(__VA_ARGS__), CFTYPECOUNT(__VA_ARGS__), NULL)

#define EACH_WRAPPER(...) (^{ __block CFMutableDictionaryRef MA_eachTable = nil; \
(void)MA_eachTable; \
__typeof__(__VA_ARGS__) MA_retval = __VA_ARGS__; \
if(MA_eachTable) \
CFRelease(MA_eachTable); \
return MA_retval; \
}())

NS_INLINE NSDictionary *MADictionaryWithKeysAndObjects(id *keysAndObjs, NSUInteger count) {
    id keys[count];
    id objs[count];
    for(NSUInteger i = 0; i < count; i++)
    {
        keys[i] = keysAndObjs[i * 2];
        objs[i] = keysAndObjs[i * 2 + 1];
    }
    
    return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
}

// collection shortcuts
#define XDEFAULT(v, d)  ([[NSNull null] isEqual:(v)] ? (d) : (v))
#define XSTR(...)       [NSString stringWithFormat:__VA_ARGS__]
#define XMSTR(...)      [NSMutableString stringWithFormat:__VA_ARGS__]
#define XFMT(...)       [NSString stringWithFormat:__VA_ARGS__]
#define XARRAY(...)     [NSArray arrayWithObjects: __VA_ARGS__, nil]
#define XMARRAY(...)    [NSMutableArray arrayWithObjects: __VA_ARGS__, nil]
#define XSET(...)       [NSSet setWithObjects: __VA_ARGS__, nil]
#define XMSET(...)      [NSMutableSet setWithObjects: __VA_ARGS__, nil]
#define XDICT(...)      [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]
#define XMDICT(...)     [NSMutableDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]