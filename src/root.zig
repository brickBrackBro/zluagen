const std = @import("std");
const TypeInfo = std.builtin.Type;
const meta = std.meta;
const mem = std.mem;
const testing = std.testing;
const lua = @import("lua");

// ---@class [(exact)] <TypeName>
// ---@field name type
// local Rectangle = {}
//
// ---@return integer
// function Rectangle:get_area()

// ---@class libfoo
// ---@field area Rectangle
// local M = {}
//
// ---@param n integer
// M.fibinachii = function (n) end
//
// return M

fn shortenTypeName(n: []const u8) []const u8 {
    return if (mem.lastIndexOf(u8, n, ".")) |pos|
        n[pos + 1 ..]
    else
        n;
}
fn getPrimitiveTypeName(comptime T: type) []const u8 {
    return switch (@typeInfo(T)) {
        .Struct => shortenTypeName(@typeName(T)),
        .Int => "interger",
        .Float => "number",
        .Optional => |opt| "?" ++ getPrimitiveTypeName(opt.child),
        .Array => |arr| if (arr.child == u8) "string" else @compileError("invalide array type"),

        else => @compileError("invalid type"),
    };
}
pub fn genStructComments(comptime T: type, writer: anytype) !void {
    try writer.print("---@class (exact) {s}\n", .{shortenTypeName(@typeName(T))});

    inline for (@typeInfo(T).Struct.fields) |field| {
        try writer.print("---@field {s} {s}\n", .{ field.name, getPrimitiveTypeName(field.type) });
    }
}

pub fn genFnComments(comptime Fn: type, comptime param_names: []const []const u8, writer: anytype) !void {
    const FnInfo = @typeInfo(Fn).Fn;
    inline for (FnInfo.params, param_names) |param, name| {
        try writer.print("---@param {s} {s}\n", .{ name, if (param.type) |t| getPrimitiveTypeName(t) else "any" });
    }
    if (FnInfo.return_type) |t|
        try writer.print("---@return {s}\n", .{getPrimitiveTypeName(t)});
}
