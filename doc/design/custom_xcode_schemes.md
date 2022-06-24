# Custom Xcode Schemes

This document is a proposal for how custom Xcode schemes can be defined and implemented in
`rules_xcodeproj`.

## No Custom Schemes

As of this writing, the ruleset generates an Xcode scheme for every buildable target provided to
the `xcodeproj` rule. This allows a client to quickly define an `xcodeproj` target and generate an
Xcode project.

The following declaration will generate two schemes: `Foo` and
`FooTests.__internal__.__test_bundle`. The `Foo` scheme contains configuration that builds
`//Sources/Foo`, but has no configuration for test, launch or any of the other actions. The
`FooTests.__internal__.__test_bundle` scheme contains configuration that builds `//Tests/FooTests`
and executes the test.

```python
# Assumptions
#   //Sources/Foo:Foo - swift_library
#   //Sources/FooTests:FooTests = ios_unit_test

xcodeproj(
    name = "generate_xcodeproj",
    project_name = "Command Line",
    tags = ["manual"],
    targets = [
        "//Sources/Foo",
        "//Tests/FooTests",
    ],
)
```

While functional, most developers would prefer a single scheme that built both targets and executed
the `//Test/FooTests` target when test execution was requested.

## Introduction of the `scheme` Rule

The `scheme` rule allows a client to define an Xcode scheme. It provides an `XcodeSchemeInfo`
provider which contains information about the scheme. It does not generate any files during the
build. (The current scheme generation logic requires information that is not available outside of
the `xcodeproj` generation logic.)

```python
XcodeSchemeInfo = provider(
    "Provides information about an Xcode scheme.",
    fields = {
        "scheme_name": """\
The user-visible name for the scheme.\
""",
        "build_action": """\
An `XcodeBuildActionInfo` that contains the targets to be built along with any \
build information.\
""",
        "test_action": """\
Optional. An `XcodeTestActionInfo` that lists the testable targets.\
""",
        "launch_action": """\
Optional. An `XcodeLaunchActionInfo` that identifies the target to execute on \
launch along with any arguments and environment variables.\
""",
    },
)

XcodeBuildActionInfo = provider(
    "Provides information about an Xcode build action.",
    fields = {
        "targets": """\
A `depset` of targets to build.\
""",
    },
)

XcodeTestActionInfo = provider(
    "Provides information about an Xcode test action.",
    fields = {
        "targets": """\
A `depset` of targets to execute when testing is requested.\
""",
    },
)

XcodeLaunchActionInfo = provider(
    "Provides information about an Xcode launch action.",
    fields = {
        "target": """\
A `struct` describing the target to launch with the run action is requested.\
""",
        "args": """\
A `list` of `string` values that are passed as arguments when the launch target \
is executed.\
"""'
    },
        "env": """\
A `dict` of enviornment variables to set when the launch target is executed.\
"""'
    },
)
```

The `xcodeproj` rule, in addition to the existing target types, now accepts targets that provide
`XcodeSchemeInfo`. The targets contained in `XcodeSchemeInfo` instances are included in the set of
targets that are used to generate the Xcode project. Any targets that are provided by other means
(i.e., not through `XcodeSchemeInfo`) will have an `XcodeSchemeInfo` instance created

Building on the previous example, let's define a scheme that combines the two targets.

```python
scheme(
    name = "foo_scheme",
    scheme_name = "Foo Module",
    targets = [
        "//Sources/Foo",
        "//Tests/FooTests",
    ],
)

xcodeproj(
    name = "generate_xcodeproj",
    project_name = "Command Line",
    tags = ["manual"],
    targets = [
        ":foo_scheme",
    ],
)
```

The `foo_scheme` target generates a scheme with a user visible name of `Foo Module`. It is
configured to build `//Sources/Foo` and `//Tests/FooTests`. It is also configured to execute the
test `//Tests/FooTests` using the existing logic for identifying testable targets.


## Complex with `launch_args` and `launch_env`

```python
scheme(
    name = "foo_scheme",
    scheme_name = "Foo Module",
    targets = [
        "//Sources/Foo",
        "//Tests/FooTests",
    ],
)

scheme(
    name = "bar_scheme",
    scheme_name = "Bar Module",
    targets = [
        "//Sources/Bar",
        "//Tests/BarTests",
    ],
)

scheme(
    name = "app_scheme",
    scheme_name = "My Application",
    targets = [
        "//Sources/App",
        "//Sources/Foo",
        "//Sources/Bar",
        "//Tests/FooTests",
        "//Tests/BarTests",
        "//Tests/AppUITests",
    ],
    launch_target = "//Sources/App",
    launch_args = [
        "path/to/a/file.txt",
    ]
    launch_env = {
        "RELEASE_THE_KRAKEN": "true",
    }
)

xcodeproj(
    name = "generate_xcodeproj",
    project_name = "Command Line",
    tags = ["manual"],
    schemes = [
        ":foo_app_scheme",
        ":foo_scheme",
        ":bar_scheme",
    ],
)
```

## Complex with Launch Action

```python
scheme(
    name = "foo_scheme",
    scheme_name = "Foo Module",
    targets = [
        "//Sources/Foo",
        "//Tests/FooTests",
    ],
)

scheme(
    name = "bar_scheme",
    scheme_name = "Bar Module",
    targets = [
        "//Sources/Bar",
        "//Tests/BarTests",
    ],
)

launch_action(
    name = "app_launch_action",
    target = "//Sources/App,"
    args = [
        "path/to/a/file.txt",
    ]
    env = {
        "RELEASE_THE_KRAKEN": "true",
    }
)

scheme(
    name = "app_scheme",
    scheme_name = "My Application",
    targets = [
        ":app_launch_action",
        "//Sources/Foo",
        "//Sources/Bar",
        "//Tests/FooTests",
        "//Tests/BarTests",
        "//Tests/AppUITests",
    ],
)

xcodeproj(
    name = "generate_xcodeproj",
    project_name = "Command Line",
    tags = ["manual"],
    schemes = [
        ":foo_app_scheme",
        ":foo_scheme",
        ":bar_scheme",
    ],
)
```
