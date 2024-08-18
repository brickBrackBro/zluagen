pub fn Type(comptime T: type) type {
    return struct {
        pub fn writeComment(writer: anytype) !void {
            try writer.print("---@type {s}\n", .{@typeName(T)});
        }
    };
}
pub fn Class(comptime T: type) type {
    return struct {
        pub fn writeComment(writer: anytype) !void {
            try writer.print("---@class {s}\n", .{@typeName(T)});
        }
    };
}
pub fn Field(comptime T: type, comptime name: []const u8) type {
    return struct {
        pub fn writeComment(writer: anytype) !void {
            try writer.print("---@field {s} {s}\n", .{ name, @typeName(T) });
        }
    };
}
pub fn Param(comptime T: type, comptime name: []const u8) type {
    return struct {
        pub fn writeComment(writer: anytype) !void {
            try writer.print("---@param {s} {s}", .{ name, @typeName(T) });
        }
    };
}
pub fn Return(comptime T: type) type {
    return struct {
        pub fn writeComment(writer: anytype) !void {
            try writer.print("---@return {}", .{@typeName(T)});
        }
    };
}
