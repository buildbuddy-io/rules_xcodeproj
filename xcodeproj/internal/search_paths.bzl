""" Functions for processing search paths """

load(":collections.bzl", "set_if_true")
load(
    ":files.bzl",
    "file_path_to_dto",
    "parsed_file_path",
)

def process_search_paths(*, cc_info, objc, opts_search_paths):
    """ Process search paths

    Args:
        cc_info: A CcInfo provider object
        objc: A ObjC provider object
        opts_search_paths: optiions for search paths

    Returns:
        All search paths for the provided objects
    """
    search_paths = {}
    if cc_info:
        compilation_context = cc_info.compilation_context
        set_if_true(
            search_paths,
            "quote_includes",
            [
                file_path_to_dto(parsed_file_path(path))
                for path in compilation_context.quote_includes.to_list() +
                            opts_search_paths.quote_includes
            ],
        )
        set_if_true(
            search_paths,
            "includes",
            [
                file_path_to_dto(parsed_file_path(path))
                for path in (compilation_context.includes.to_list() +
                             opts_search_paths.includes)
            ],
        )
        set_if_true(
            search_paths,
            "system_includes",
            [
                file_path_to_dto(parsed_file_path(path))
                for path in (compilation_context.system_includes.to_list() +
                             opts_search_paths.system_includes)
            ],
        )

    if objc:
        framework_paths = depset(
            transitive = [
                objc.static_framework_paths,
                objc.dynamic_framework_paths,
            ],
        )

        set_if_true(
            search_paths,
            "framework_includes",
            [
                file_path_to_dto(parsed_file_path(path))
                for path in framework_paths.to_list()
            ],
        )

    return search_paths
