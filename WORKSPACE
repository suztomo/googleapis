workspace(
    name = "com_google_googleapis",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

##############################################################################
# Common
##############################################################################

load("//:repository_rules.bzl", "switched_rules_by_language")

switched_rules_by_language(
    name = "com_google_googleapis_imports",
    cc = True,
    csharp = False,
    gapic = True,
    go = False,
    grpc = True,
    java = True,
    nodejs = False,
    php = False,
    python = False,
    ruby = False,
)

_bazel_skylib_version = "1.4.0"

_bazel_skylib_sha256 = "f24ab666394232f834f74d19e2ff142b0af17466ea0c69a3f4c276ee75f6efce"

http_archive(
    name = "bazel_skylib",
    sha256 = _bazel_skylib_sha256,
    urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/{0}/bazel-skylib-{0}.tar.gz".format(_bazel_skylib_version)],
)

_bazel_features_version = "1.2.0"

_bazel_features_sha256 = "b8789c83c893d7ef3041d3f2795774936b27ff61701a705df52fd41d6ddbf692"

http_archive(
    name = "bazel_features",
    sha256 = _bazel_features_sha256,
    strip_prefix = "bazel_features-%s" % _bazel_features_version,
    url = "https://github.com/bazel-contrib/bazel_features/releases/download/v{0}/bazel_features-v{0}.tar.gz".format(_bazel_features_version),
)

# Protobuf depends on very old version of rules_jvm_external.
# Importing older version of rules_jvm_external first (this is one of the things that protobuf_deps() call
# below will do) breaks the Java client library generation process, so importing the proper version explicitly before calling protobuf_deps().
RULES_JVM_EXTERNAL_TAG = "4.5"

RULES_JVM_EXTERNAL_SHA = "b17d7388feb9bfa7f2fa09031b32707df529f26c91ab9e5d909eb1676badd9a6"

http_archive(
    name = "rules_jvm_external",
    sha256 = RULES_JVM_EXTERNAL_SHA,
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

http_archive(
    name = "rules_pkg",
    sha256 = "8a298e832762eda1830597d64fe7db58178aa84cd5926d76d5b744d6558941c2",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz",
    ],
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

# This must be above the download of gRPC (in C++ section) and 
# rules_gapic_repositories because both depend on rules_go and we need to manage
# our version of rules_go explicitly rather than depend on the version those
# bring in transitively.
_io_bazel_rules_go_version = "0.44.2"

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "7c76d6236b28ff695aa28cf35f95de317a9472fd1fb14ac797c9bf684f09b37c",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v{0}/rules_go-v{0}.zip".format(_io_bazel_rules_go_version),
        "https://github.com/bazelbuild/rules_go/releases/download/v{0}/rules_go-v{0}.zip".format(_io_bazel_rules_go_version),
    ],
)

_rules_gapic_version = "1.0.0"


http_archive(
    name = "rules_gapic",
    strip_prefix = "rules_gapic-%s" % _rules_gapic_version,
    urls = ["https://github.com/googleapis/rules_gapic/archive/v%s.tar.gz" % _rules_gapic_version],
)

##############################################################################
# C++
##############################################################################
# C++ must go before everything else, since the key dependencies (protobuf and gRPC)
# are C++ repositories and they have the highest chance to have the correct versions of the
# transitive dependencies (for those dependencies which are shared by many other repositories
# imported in this workspace).
#
# This comes before Protobuf's section, meaning we prioritize gRPC's dependencies
# (including upb and absl) over Protobuf's. Because the gRPC team prioritizes their
# own dependencies when they test gRPC and Protobuf compatibility, gRPC's dependencies have
# better chance to make it work.
#
# Note, even though protobuf and gRPC are mostly written in C++, they are used to generate stuff
# for most of the other languages as well, so they can be considered as the core cross-language
# dependencies.

_grpc_version = "1.60.0"

_grpc_sha256 = "09640607a340ff0d97407ed22fe4adb177e5bb85329821122084359cd57c3dea"

http_archive(
    name = "com_github_grpc_grpc",
    sha256 = _grpc_sha256,
    strip_prefix = "grpc-%s" % _grpc_version,
    urls = ["https://github.com/grpc/grpc/archive/v%s.zip" % _grpc_version],
)

# Explicitly declaring Protobuf version, while Protobuf dependency is already
# instantiated in grpc_deps().
_protobuf_version = "25.2"

_protobuf_sha256 = "8ff511a64fc46ee792d3fe49a5a1bcad6f7dc50dfbba5a28b0e5b979c17f9871"

http_archive(
    name = "com_google_protobuf",
    sha256 = _protobuf_sha256,
    strip_prefix = "protobuf-%s" % _protobuf_version,
    urls = ["https://github.com/protocolbuffers/protobuf/archive/v%s.tar.gz" % _protobuf_version],
)

load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")

grpc_deps()

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps", "PROTOBUF_MAVEN_ARTIFACTS")
# This is actually already done within grpc_deps but calling this for Bazel convention.
protobuf_deps()

# gRPC enforces a specific version of Go toolchain which conflicts with our build.
# All the relevant parts of grpc_extra_deps() are imported in this  WORKSPACE file
# explicitly, that is why we do not call grpc_extra_deps() here and call
# apple_rules_dependencies and apple_support_dependencies macros explicitly.

load("@build_bazel_rules_apple//apple:repositories.bzl", "apple_rules_dependencies")

apple_rules_dependencies()

load("@build_bazel_apple_support//lib:repositories.bzl", "apple_support_dependencies")

apple_support_dependencies()

# End of C++ section

http_archive(
    name = "rules_proto",
    sha256 = "602e7161d9195e50246177e7c55b2f39950a9cf7366f74ed5f22fd45750cd208",
    strip_prefix = "rules_proto-97d8af4dc474595af3900dd85cb3a29ad28cc313",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
        "https://github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
    ],
)

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()

rules_proto_toolchains()

##############################################################################
# Java
##############################################################################

# Starting in protobuf 3.19, protobuf project started to provide
# PROTOBUF_MAVEN_ARTIFACTS variable so that Bazel users can resolve their
# dependencies through maven_install.
# https://github.com/protocolbuffers/protobuf/issues/9132

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = PROTOBUF_MAVEN_ARTIFACTS,
    generate_compat_repositories = True,
    repositories = [
        "https://repo.maven.apache.org/maven2/",
    ],
)

_gapic_generator_java_version = "2.35.0"

maven_install(
    artifacts = [
        "com.google.api:gapic-generator-java:" + _gapic_generator_java_version,
    ],
    #Update this False for local development
    fail_on_missing_checksum = True,
    repositories = [
        "m2Local",
        "https://repo.maven.apache.org/maven2/",
    ]
)

http_archive(
    name = "gapic_generator_java",
    strip_prefix = "sdk-platform-java-%s" % _gapic_generator_java_version,
    urls = ["https://github.com/googleapis/sdk-platform-java/archive/v%s.zip" % _gapic_generator_java_version],
)

# gax-java is part of sdk-platform-java repository
http_archive(
    name = "com_google_api_gax_java",
    strip_prefix = "sdk-platform-java-%s/gax-java" % _gapic_generator_java_version,
    urls = ["https://github.com/googleapis/sdk-platform-java/archive/v%s.zip" % _gapic_generator_java_version],
)

load("@com_google_api_gax_java//:repository_rules.bzl", "com_google_api_gax_java_properties")

com_google_api_gax_java_properties(
    name = "com_google_api_gax_java_properties",
    file = "@com_google_api_gax_java//:dependencies.properties",
)

load("@com_google_api_gax_java//:repositories.bzl", "com_google_api_gax_java_repositories")

com_google_api_gax_java_repositories()

load("@io_grpc_grpc_java//:repositories.bzl", "grpc_java_repositories")

grpc_java_repositories()

##############################################################################
# Discovery
##############################################################################

_disco_to_proto3_converter_version = "8163e5ea8d8dbcf0899534d2895819ab135ffab5"

http_archive(
    name = "com_google_disco_to_proto3_converter",
    strip_prefix = "disco-to-proto3-converter-%s" % _disco_to_proto3_converter_version,
    urls = ["https://github.com/googleapis/disco-to-proto3-converter/archive/%s.zip" % _disco_to_proto3_converter_version],
)

load("@com_google_disco_to_proto3_converter//:repository_rules.bzl", "com_google_disco_to_proto3_converter_properties")

com_google_disco_to_proto3_converter_properties(
    name = "com_google_disco_to_proto3_converter_properties",
    file = "@com_google_disco_to_proto3_converter//:pom.xml",
)

load("@com_google_disco_to_proto3_converter//:repositories.bzl", "com_google_disco_to_proto3_converter_repositories")

com_google_disco_to_proto3_converter_repositories()
