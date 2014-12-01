import math

print '; low bytes'
for i in range(0,256):
    low = (i*i) & 255
    print 'db {}'.format(low)
print '; high bytes'
for i in range(0,256):
    hi = ((i*i) >> 8) & 255
    print 'db {}'.format(hi)

