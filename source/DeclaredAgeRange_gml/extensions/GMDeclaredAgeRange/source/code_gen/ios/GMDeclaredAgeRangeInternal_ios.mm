// ##### extgen :: Auto-generated file do not edit!! #####

#import <objc/runtime.h>
#import "core/GMExtUtils.h"
#import "GMDeclaredAgeRangeInternal_ios.h"

#ifdef __cplusplus
#import "GMDeclaredAgeRange-Swift.h"
using namespace GMDeclaredAgeRange;
#endif


extern "C" const char* extOptGetString(char* _ext, char* _opt);

// Adapter: matches const signature expected by your C++ API
static const char* ExtOptGetString(const char* ext, const char* opt)
{
    return extOptGetString(const_cast<char*>(ext), const_cast<char*>(opt));
}

static BOOL GMIsSubclassOf(Class cls, Class base)
{
    for (Class c = cls; c != Nil; c = class_getSuperclass(c)) {
        if (c == base) return YES;
    }
    return NO;
}

static void GMInjectSelectorsIntoSubclass(Class subclass, Class base)
{
    // Build set of methods already defined on subclass
    unsigned subCount = 0;
    Method *subList = class_copyMethodList(subclass, &subCount);

    CFMutableSetRef owned = CFSetCreateMutable(kCFAllocatorDefault, 0, NULL);
    for (unsigned i = 0; i < subCount; ++i) {
        CFSetAddValue(owned, method_getName(subList[i]));
    }

    // Walk base class methods
    unsigned baseCount = 0;
    Method *baseList = class_copyMethodList(base, &baseCount);

    for (unsigned i = 0; i < baseCount; ++i) {
        SEL sel = method_getName(baseList[i]);
        const char *name = sel_getName(sel);

        // Only inject your extension selectors
        if (!name || strncmp(name, "__EXT_NATIVE__", 13) != 0) continue;

        // Add only if subclass doesn't already have it
        if (!CFSetContainsValue(owned, sel)) {
            IMP imp = method_getImplementation(baseList[i]);
            const char *types = method_getTypeEncoding(baseList[i]);
            if (class_addMethod(subclass, sel, imp, types)) {
                CFSetAddValue(owned, sel);
            }
        }
    }

    if (subList) free(subList);
    if (baseList) free(baseList);
    if (owned) CFRelease(owned);
}

@interface GMDeclaredAgeRangeInternal ()
{
    GMDeclaredAgeRangeSwift * __impl;
}@end


@implementation GMDeclaredAgeRangeInternal

+ (void)load
{
    // Find all loaded classes
    int num = objc_getClassList(NULL, 0);
    if (num <= 0) return;

    Class *classes = (Class *)malloc(sizeof(Class) * (unsigned)num);
    num = objc_getClassList(classes, num);

    Class base = [GMDeclaredAgeRangeInternal class];

    for (int i = 0; i < num; ++i) {
        Class cls = classes[i];
        if (cls == base) continue;

        // We only care about direct or indirect subclasses
        if (GMIsSubclassOf(cls, base)) {
            GMInjectSelectorsIntoSubclass(cls, base);
        }
    }

    free(classes);

    gm::details::GMRTRunnerInterface ri{};
    ri.ExtOptGetString = &ExtOptGetString;
    GMExtensionInitialise(&ri, sizeof(ri));
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        #ifdef __cplusplus
        // Create Swift object once
        __impl = new GMDeclaredAgeRangeSwift(GMDeclaredAgeRangeSwift::init());
        #endif
    }
    return self;
}
- (double)__EXT_NATIVE__declared_age_range_is_supported
{
    double __result = __impl->__EXT_SWIFT__declared_age_range_is_supported();
    return __result;
}

- (double)__EXT_NATIVE__declared_age_range_request:(char*)__arg_buffer arg1:(double)__arg_buffer_length
{
    __impl->__EXT_SWIFT__declared_age_range_request(__arg_buffer, __arg_buffer_length);
    return 0;
}

// Internal function used for fetching dispatched function calls to GML
- (double)__EXT_NATIVE__GMDeclaredAgeRange_invocation_handler:(char*)__ret_buffer arg1:(double)__ret_buffer_length
{
    return __impl->__EXT_SWIFT__GMDeclaredAgeRange_invocation_handler(__ret_buffer, __ret_buffer_length);
}

@end

