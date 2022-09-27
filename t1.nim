import algorithm
var v = @["winger", "@", "2022"]
v.sort()
echo v
while v.nextPermutation():
    echo v