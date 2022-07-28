#!/usr/bin/python3

"""An lldb module that registers a stop hook to set swift settings."""

import lldb

_SETTINGS = {
  "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/tools/generator/generator" : {
    "clang" : "-iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all",
    "frameworks" : [

    ],
    "includes" : [
      "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_apple_swift_collections",
      "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_tuist_xcodeproj",
      "$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_tadija_aexml",
      "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_kylef_pathkit"
    ]
  },
  "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/tools/generator/test/tests.xctest/Contents/MacOS/tests" : {
    "clang" : "-iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote \"$(PROJECT_DIR)\" -iquote \"$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin\" -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all",
    "frameworks" : [

    ],
    "includes" : [
      "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/tools/generator",
      "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_pointfreeco_swift_custom_dump",
      "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_apple_swift_collections",
      "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_tuist_xcodeproj",
      "$(BAZEL_OUT)/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_tadija_aexml",
      "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_kylef_pathkit",
      "$(BUILD_DIR)/bazel-out/darwin_x86_64-dbg-ST-02316c4eb12c/bin/external/com_github_pointfreeco_xctest_dynamic_overlay"
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