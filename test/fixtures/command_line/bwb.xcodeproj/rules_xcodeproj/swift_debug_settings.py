#!/usr/bin/python3

"""An lldb module that registers a stop hook to set swift settings."""

import lldb

_SETTINGS = {
  "$(BUILD_DIR)/bazel-out/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/Tests/LibSwiftTests.xctest/Contents/MacOS/LibSwiftTests" : {
    "clang" : "\"-F$(BAZEL_EXTERNAL)/examples_command_line_external\" -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin\" -iquote \"$(BAZEL_EXTERNAL)/examples_command_line_external\" -iquote \"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/external/examples_command_line_external\" -fmodule-map-file=\"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/lib/lib_impl.swift.modulemap\" -fmodule-map-file=\"$(PROJECT_DIR)/examples/command_line/swift_c_module/c_lib.modulemap\" -fmodule-map-file=\"$(BAZEL_EXTERNAL)/examples_command_line_external/ExternalFramework.framework/Modules/module.modulemap\" -fmodule-map-file=\"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/external/examples_command_line_external/Library.swift.modulemap\" -fmodule-map-file=\"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/lib/lib_swift.swift.modulemap\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -DSECRET_3=\"Hello\" -DSECRET_2=\"World!\" -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin\" -iquote \"$(BAZEL_EXTERNAL)/examples_command_line_external\" -iquote \"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/external/examples_command_line_external\" -fmodule-map-file=\"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/lib/lib_impl.swift.modulemap\" -fmodule-map-file=\"$(PROJECT_DIR)/examples/command_line/swift_c_module/c_lib.modulemap\" -fmodule-map-file=\"$(BAZEL_EXTERNAL)/examples_command_line_external/ExternalFramework.framework/Modules/module.modulemap\" -fmodule-map-file=\"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/external/examples_command_line_external/Library.swift.modulemap\" -fmodule-map-file=\"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/lib/private_lib.swift.modulemap\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -DSECRET_3=\"Hello\" -DSECRET_2=\"World!\" -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all",
    "frameworks" : [
      "$(BAZEL_EXTERNAL)/examples_command_line_external"
    ],
    "includes" : [
      "$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/lib"
    ]
  },
  "$(BUILD_DIR)/bazel-out/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/tool/tool" : {
    "clang" : "\"-F$(BAZEL_EXTERNAL)/examples_command_line_external\" -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin\" -iquote \"$(BAZEL_EXTERNAL)/examples_command_line_external\" -iquote \"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/external/examples_command_line_external\" -fmodule-map-file=\"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/lib/lib_impl.swift.modulemap\" -fmodule-map-file=\"$(PROJECT_DIR)/examples/command_line/swift_c_module/c_lib.modulemap\" -fmodule-map-file=\"$(BAZEL_EXTERNAL)/examples_command_line_external/ExternalFramework.framework/Modules/module.modulemap\" -fmodule-map-file=\"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/external/examples_command_line_external/Library.swift.modulemap\" -fmodule-map-file=\"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/lib/private_lib.swift.modulemap\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -DSECRET_3=\"Hello\" -DSECRET_2=\"World!\" -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all",
    "frameworks" : [
      "$(BAZEL_EXTERNAL)/examples_command_line_external"
    ],
    "includes" : [
      "$(BAZEL_OUT)/macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-01f14ffe769b/bin/examples/command_line/lib"
    ]
  }
}

def __lldb_init_module(debugger, _internal_dict):
    # Register the stop hook when this module is loaded in lldb
    debugger.HandleCommand(
        "target stop-hook add -P swift_debug_settings.StopHook",
    )

class StopHook:
    "An lldb stop hook class, that sets swift settings for the current module."

    def __init__(self, _target, _extra_args, _internal_dict):
        pass

    def handle_stop(self, exe_ctx, _stream):
        "Method that is called when the user stops in lldb."
        module = exe_ctx.frame.module.file.__get_fullpath__()
        settings = _SETTINGS.get(module)
        if settings:
            frameworks = " ".join([
                f'"{path}"'
                for path in settings["frameworks"]
            ])
            if frameworks:
                lldb.debugger.HandleCommand(
                    f"settings set -- target.swift-framework-search-paths {frameworks}",
                )
            else:
                lldb.debugger.HandleCommand(
                    f"settings clear target.swift-framework-search-paths",
                )

            includes = " ".join([
                f'"{path}"'
                for path in settings["includes"]
            ])
            if includes:
                lldb.debugger.HandleCommand(
                    f"settings set -- target.swift-module-search-paths {includes}",
                )
            else:
                lldb.debugger.HandleCommand(
                    f"settings clear target.swift-module-search-paths",
                )

            clang = settings["clang"]
            if clang:
                lldb.debugger.HandleCommand(
                    f"settings set -- target.swift-extra-clang-flags '{clang}'",
                )
            else:
                lldb.debugger.HandleCommand(
                    f"settings clear target.swift-extra-clang-flags",
                )

        return True