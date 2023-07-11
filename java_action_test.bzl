def _jar_counter_impl(ctx):
    output = ctx.actions.declare_file(ctx.attr.name + ".txt")
    jar_counter = ctx.executable.jar_counter
    file_list = ""
    for f in ctx.files.inputs:
        file_list += "{file} ".format(file=f.path)

    ctx.actions.run_shell(
        inputs = ctx.files.inputs,
        outputs = [output],
        tools = [jar_counter],
        command = "set -e -o pipefail; {counter} ./{input} > {output}".format(
            input = file_list,
            output = output.path,
            counter = jar_counter.path,
        ),
    )
    return DefaultInfo(files = depset([output]))

jar_counter = rule(
    implementation = _jar_counter_impl,
    attrs = {
        "inputs": attr.label_list(allow_files = True),
        "jar_counter": attr.label(
              default = Label("//:count_class_files"),
              executable = True,
              cfg = "host",
        )
    },
)