const std=@import("std");
test "benchmark 1M SET pequenos" { var i:usize=0; while(i<1_000_000):(i+=1){} try std.testing.expect(i==1_000_000); }
