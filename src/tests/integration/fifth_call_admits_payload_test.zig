const std=@import("std");
test "integration quinta chamada admite payload" { var c:u32=0; while(c<5):(c+=1){} try std.testing.expect(c==5); }
