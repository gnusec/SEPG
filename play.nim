/*
 * @Author: winger
 * @Date: 2022-09-27 13:33:27
 
 * @Description: 这个文件负责各类生成算法
 */

# 
# 就是调用sepg的特定模式生成指定集合的密码
# 这个密码生成的顺序可以记录下来
# 以后都用这个序列操作
# 这样可以尽可能的保持speg本身简单
# 

include "./sepg.nim"


var p1 = Password().init(keyword_seq= @["winger","yunzheng","admin"], mid_seq = @["@"], end_seq = @["2022","2019"])
var mix_seq1:seq[seq[string]] = @[p1.keyword_seq, p1.mid_seq, p1.end_seq]
for pwd in p1.gen(mix_seq1):
    echo pwd

# 姓名首字母大写
var mix_seq1_cap = @[p1.keyword_seq.mapIt(capitalizeAscii(it)), p1.mid_seq, p1.end_seq]
for pwd in p1.gen(mix_seq1_cap):
    echo pwd

var mix_seq2:seq[seq[string]] = @[p1.mid_seq, p1.keyword_seq, p1.end_seq]
for pwd in p1.gen_permutation(mix_seq2):
    echo pwd

# 身份证后六位组合

# 出生年月组合

# 居住门牌号

# 小孩和亲人名字

# 小名(weiwei liangliang)