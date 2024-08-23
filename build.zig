const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseFast });
    const lua_dep = b.dependency("lua", .{
        .target = target,
        .release = optimize == .ReleaseFast,
    });
    const lua_mod = lua_dep.module("lua");
    const gen_mod = b.addModule("luagen", .{
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    gen_mod.addImport("lua", lua_mod);

    const test_cmd = b.addTest(.{
        .name = "gen_tests",
        .optimize = optimize,
        .target = target,
        .root_source_file = b.path("src/root.zig"),
    });
    test_cmd.root_module.addImport("lua", lua_mod);
    const exe_test_cmd = b.addRunArtifact(test_cmd);
    const test_step = b.step("test", "run tests");
    test_step.dependOn(&exe_test_cmd.step);
}
