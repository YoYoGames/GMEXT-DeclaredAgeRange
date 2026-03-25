cmake_minimum_required(VERSION 3.18)

# =============================================================================
# third_party template (production-ready) - Single INTERFACE target:
# ext_third_party - Per-platform imported libs with sensible defaults - Easy
# toggles for Apple Framework/XCFramework vs .dylib - Android AAR (Prefab) or
# raw per-ABI .so; auto-extract with stamp - Publishes: * EXT_TP_RUNTIME_DLLS
# (list of runtime binaries the parent may copy) * EXT_TP_ANDROID_AAR   (aar
# path if consumed; parent can add Gradle dep) - Comment/uncomment “OPTIONAL
# SECTIONS” to fit your SDK
# =============================================================================

# -----------------------------------------------------------------------------
# Core "bag of usage requirements" your main target links to
# -----------------------------------------------------------------------------
add_library(ext_third_party INTERFACE)

# Common compile defs (adjust or remove)
target_compile_definitions(ext_third_party INTERFACE HAVE_THIRDPARTY_FEATURE=1)

# List of runtime files to bubble up to parent
set(_EXT_TP_RUNTIME_DLLS "")

# Helper: map single-configs to Release
set(_MAP_REL_CONFIGS "Release")
# Helper macro to append runtime(s)
function(_ext_tp_append_runtime)
  foreach(_f IN LISTS ARGN)
    if(_f)
      list(APPEND _EXT_TP_RUNTIME_DLLS "${_f}")
    endif()
  endforeach()
  set(_EXT_TP_RUNTIME_DLLS
      "${_EXT_TP_RUNTIME_DLLS}"
      PARENT_SCOPE)
endfunction()

message(STATUS "[third_party] SDK_ROOT = ${SDK_ROOT}")
message(STATUS "[third_party] SDK_BASENAME = ${SDK_BASENAME}")


# =============================================================================
# APPLE: split macOS vs iOS/tvOS
# =============================================================================
if(APPLE)

  # ----------------------
  # iOS / tvOS (mobile)
  # ----------------------
  if((CMAKE_OSX_SYSROOT MATCHES "iphone") OR (CMAKE_OSX_SYSROOT MATCHES "appletv"))
    # Choose either xcframework/framework or static .a for mobile
    option(EXT_TP_IOS_USE_XCFRAMEWORK
           "iOS/tvOS: link (XC)Framework via -F/-framework" OFF)
    option(EXT_TP_IOS_USE_STATIC "iOS/tvOS: link static .a" OFF)

    # Common defaults; feel free to tweak
    if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
      set(_PLAT_NAME "ios")
      set(_IOS_FRAME_DIR_DEFAULT
          "${SDK_ROOT}/lib/release/discord_partner_sdk.xcframework"
      )# folder that contains Foo.xcframework or Foo.framework
      set(_IOS_FRAME_NAME "discord_partner_sdk")
      set(_IOS_HEADERS_DEFAULT "${SDK_ROOT}/include")
      set(_IOS_STATIC_DEFAULT "${SDK_ROOT}/lib/release/lib${SDK_BASENAME}.a")
    else()
      set(_PLAT_NAME "tvos")
      set(_IOS_FRAME_DIR_DEFAULT
          "${SDK_ROOT}/lib/release/discord_partner_sdk.xcframework")
      set(_IOS_FRAME_NAME "discord_partner_sdk")
      set(_IOS_HEADERS_DEFAULT "${SDK_ROOT}/include")
      set(_IOS_STATIC_DEFAULT "${SDK_ROOT}/lib/release/lib${SDK_BASENAME}.a")
    endif()

    if(EXT_TP_IOS_USE_XCFRAMEWORK)
      # If you have an .xcframework (recommended), just add its parent dir to -F
      # and use -framework Foo Xcode will pick the proper slice (device/sim,
      # arch) automatically.
      set(SDK_IOS_FRAMEWORK_DIR
          "${_IOS_FRAME_DIR_DEFAULT}"
          CACHE PATH "iOS/tvOS -F search path to (XC)Framework")
      set(SDK_IOS_FRAMEWORK_NAME
          "${_IOS_FRAME_NAME}"
          CACHE STRING "iOS/tvOS framework name (without extension)")
      target_link_options(
        ext_third_party INTERFACE "-F${SDK_IOS_FRAMEWORK_DIR}" "-framework"
        "${SDK_IOS_FRAMEWORK_NAME}")
      # If the vendor gives extra Apple frameworks you must link, add them here:
      # target_link_options(ext_third_party INTERFACE "-framework"
      # "AVFoundation" "-framework" "AudioToolbox")
    endif()

    if(EXT_TP_IOS_USE_STATIC)
      # Static import: your vendor must provide an iOS/tvOS static library (NOT
      # macOS!)
      set(SDK_IOS_STATIC_A
          "${_IOS_STATIC_DEFAULT}"
          CACHE FILEPATH "iOS/tvOS static .a")
      if(NOT EXISTS "${SDK_IOS_STATIC_A}")
        message(
          FATAL_ERROR
            "[third_party] Missing ${_PLAT_NAME} static library: ${SDK_IOS_STATIC_A}"
        )
      endif()
      add_library(${SDK_BASENAME}_${_PLAT_NAME}_static STATIC IMPORTED GLOBAL)
      set_target_properties(
        ${SDK_BASENAME}_${_PLAT_NAME}_static
        PROPERTIES
          IMPORTED_LOCATION "${SDK_IOS_STATIC_A}"
          INTERFACE_INCLUDE_DIRECTORIES
          "$<TARGET_PROPERTY:ext_third_party,INTERFACE_INCLUDE_DIRECTORIES>")
      target_link_libraries(ext_third_party
                            INTERFACE ${SDK_BASENAME}_${_PLAT_NAME}_static)
      # Add required Apple frameworks when linking a static vendor lib, e.g.:
      # target_link_options(ext_third_party INTERFACE "-framework" "Foundation"
      # "-framework" "Security")
    endif()

  # ----------------------
  # macOS (desktop)
  # ----------------------
  else()
    # Choose either a macOS .dylib or a (XC)Framework
    option(EXT_TP_MAC_USE_DYLIB "macOS: link prebuilt .dylib" OFF)
    option(EXT_TP_MAC_USE_FRAMEWORK
           "macOS: link Framework/XCFramework via -F/-framework" OFF)

    if(EXT_TP_MAC_USE_DYLIB)
      set(SDK_MAC_DYLIB_DEBUG
          "${SDK_ROOT}/lib/debug/lib${SDK_BASENAME}.dylib"
          CACHE FILEPATH "macOS .dylib (Debug)")
      set(SDK_MAC_DYLIB_RELEASE
          "${SDK_ROOT}/lib/release/lib${SDK_BASENAME}.dylib"
          CACHE FILEPATH "macOS .dylib (Release)")

      add_library(${SDK_BASENAME}_mac_dylib SHARED IMPORTED GLOBAL)
      set_target_properties(
        ${SDK_BASENAME}_mac_dylib
        PROPERTIES
          IMPORTED_CONFIGURATIONS "Debug;Release"
          IMPORTED_LOCATION_DEBUG "${SDK_MAC_DYLIB_DEBUG}"
          IMPORTED_LOCATION_RELEASE "${SDK_MAC_DYLIB_RELEASE}"
          MAP_IMPORTED_CONFIG_RELWITHDEBINFO "${_MAP_REL_CONFIGS}"
          MAP_IMPORTED_CONFIG_MINSIZEREL "${_MAP_REL_CONFIGS}"
          INTERFACE_INCLUDE_DIRECTORIES
          "$<TARGET_PROPERTY:ext_third_party,INTERFACE_INCLUDE_DIRECTORIES>")
      target_link_libraries(ext_third_party INTERFACE ${SDK_BASENAME}_mac_dylib)

      _ext_tp_append_runtime(
        $<$<CONFIG:Debug>:${SDK_MAC_DYLIB_DEBUG}>
        $<$<OR:$<CONFIG:Release>,$<CONFIG:RelWithDebInfo>,$<CONFIG:MinSizeRel>>:${SDK_MAC_DYLIB_RELEASE}>
      )
    endif()

    if(EXT_TP_MAC_USE_FRAMEWORK)
      set(SDK_MAC_FRAMEWORK_DIR
          "${SDK_ROOT}/lib/macos"
          CACHE PATH "macOS -F search path to (XC)Framework")
      set(SDK_MAC_FRAMEWORK_NAME
          "DiscordPartnerSDK"
          CACHE STRING "macOS framework name (without .framework)")
      target_link_options(
        ext_third_party INTERFACE "-F${SDK_MAC_FRAMEWORK_DIR}" "-framework"
        "${SDK_MAC_FRAMEWORK_NAME}")
      # Optional extra frameworks: target_link_options(ext_third_party INTERFACE
      # "-framework" "Cocoa" "-framework" "IOKit")
    endif()
  endif() # macOS

endif()

# =============================================================================
# (OPTIONAL) Console SDK hooks (uncomment and point to vendor toolchains)
# =============================================================================
# if(CMAKE_SYSTEM_NAME STREQUAL "ORBIS") # PS4: add imported lib and link;
# publish runtime if needed elseif(CMAKE_SYSTEM_NAME STREQUAL "Prospero") # PS5:
# similar elseif(CMAKE_SYSTEM_NAME STREQUAL "NintendoSwitch" OR DEFINED
# ENV{NINTENDO_SDK_ROOT}) # Switch: similar endif()

# =============================================================================
# Bubble up runtime list to parent
# =============================================================================
set(EXT_TP_RUNTIME_DLLS "${_EXT_TP_RUNTIME_DLLS}" PARENT_SCOPE)
