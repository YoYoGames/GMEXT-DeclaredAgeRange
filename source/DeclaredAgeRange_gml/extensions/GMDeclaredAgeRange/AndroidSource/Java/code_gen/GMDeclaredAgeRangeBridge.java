package com.gamemaker.ExtensionCore.ExtBridge;
import java.lang.String;
import java.nio.ByteBuffer;
import ${YYAndroidPackageName}.GMExtUtils;

public final class GMDeclaredAgeRangeBridge {
    static {
        // this is the extension lib name
        System.loadLibrary("GMDeclaredAgeRange");
        nativeRegister();
    }
    // this registers the native functions on the C++ layer
    private static native void nativeRegister();

    String __EXT_JAVA__GetExtensionOption(String extName, String optName) public static
    {
        return GMExtUtils.GetExtensionOption(extName, optName);
    }

    public static native double __EXT_JNI__declared_age_range_test();
}