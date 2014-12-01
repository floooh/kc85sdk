import math

print '; sin(a) as 0.7 fixed-point, 0 <= a < 256'
for i in range(0,256) :
    a = (math.pi * 2.0) * (i / 256.0)
    s = int(math.sin(a) * 128.0)
    if s == -128:
        s = -127
    print '        db {}'.format(s)

print '; cos(a) as 1.6 fixed-point, 0 <= a < 256'
for i in range(0,256) :
    a = (math.pi * 2.0) * (i / 256.0)
    c = int(math.cos(a) * 128.0)
    if c == -128:
        c = -127
    print '        db {}'.format(c)

