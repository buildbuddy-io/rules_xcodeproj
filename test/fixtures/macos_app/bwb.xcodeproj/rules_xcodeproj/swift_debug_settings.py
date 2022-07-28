#!/usr/bin/python3

"""An lldb module that registers a stop hook to set swift settings."""

import lldb

_SETTINGS = {
  "$(BUILD_DIR)/bazel-out/macos-x86_64-min15.0-applebin_macos-darwin_x86_64-dbg-ST-f078ed151a68/bin/examples/macos_app/Example/macOSApp.app/Contents/MacOS/macOSApp" : {
    "clang" : "\"-F$(PROJECT_DIR)/examples/macos_app/third_party\" -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/macos-x86_64-min15.0-applebin_macos-darwin_x86_64-dbg-ST-f078ed151a68/bin\" -fmodule-map-file=\"$(PROJECT_DIR)/examples/macos_app/third_party/ExampleFramework.framework/Modules/module.modulemap\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all",
    "frameworks" : [
      "$(PROJECT_DIR)/examples/macos_app/third_party"
    ],
    "includes" : [

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