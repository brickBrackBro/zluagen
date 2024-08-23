const std = @import("std");
const meta = std.meta;
const testing = std.testing;
const lua = @import("lua");

pub const CommentTags = union(enum) {
    pub const Alias = struct {
        name: []const u8,
        type: []const u8,
    };
    pub const Field = struct {
        name: []const u8,
        type: []const u8,
    };
    pub const Param = struct {
        name: []const u8,
        type: []const u8,
    };
    alias: Alias,
    class: []const u8,
    field: Field,
    meta,
    param: Param,
    @"return": []const u8,
    type: []const u8,
    pub fn emitTag(self: CommentTags, writer: anytype) !void {
        switch (self) {
            .meta => try writer.print("---@{s}\n\n", .{@tagName(self)}),
            inline .class, .@"return", .type => |v, tag| try writer.print("---@{s} {s}\n", .{ @tagName(tag), v }),
            inline else => |v, tag| try writer.print("---@{s} {s} {s}\n", .{ @tagName(tag), v.name, v.type }),
        }
    }
};
test "print meta" {
    const tag: CommentTags = .meta;
    var buff = std.ArrayList(u8).init(testing.allocator);
    defer buff.deinit();
    const writer = buff.writer();
    try tag.emitTag(writer);
    try testing.expectEqualStrings("---@meta\n\n", buff.items);
}
