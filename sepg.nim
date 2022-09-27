/*
 * @Author: winger
 * @Date: 2022-09-27 13:33:27
 
 * @Description: 简单可用, 后面再扩展. 这个文件是基础模块.
 */

# Social engineering password generator
# https://i.loli.net/2019/08/15/XE5KzcLRpiOaHms.png
# 参考这个
# 密码组合方式，分成两个主要概念
# 一个是组合的元素，一个是组合的模式
# A B C 是元素
# ABC,ACB,BCA是组合模式
# AABC
# aBC
# A@B ABC@2022  abc_2022 
# @ _ 这些是额外的元素

# 还有个概念是play
# 就是调用sepg的特定模式生成指定集合的密码
# 这个密码生成的顺序可以记录下来
# 以后都用这个序列操作
# 这样可以尽可能的保持speg本身简单

# 基本基本生成模型
import  algorithm
import sequtils
import strutils

# var pre_seq = @["winger","yunzhen"]
# var mid_seq = @["@"]
# # var mid_seq = @["@","_","-"]
# var end_seq = @["2022","2021","2019"] 
# var mix_seq = @[pre_seq, mid_seq, end_seq]
# # echo product(mix_seq)
# # 然后 三个seq按顺序组合
# echo product(mix_seq).mapIt(it.join(""))
# @["yunzhen@2019", "winger@2019", "yunzhen@2021", "winger@2021", "yunzhen@2022", "winger@2022"]


# 要自动化识别拼音和英文名的首字母, 需要额外的代码而且不一定能正确识别.
# 这块建议人工输入
# 大量人名的情况下需要预处理.
# 这个时候输入数据的时候, 要使用"空格"(或者其他特定的分割符)做分割符
# "zhang shang" "Li Bruce" 
# pre_seq 预处理
# 1. 首字母大写
# 2. 首字母集合
# 3. 首字母集合(集合的第一个字母大写)
# 4. 首字母大写集合

# @todo
# Cupp/Cewl
# pydictory
# https://chirec.github.io/2019/03/25/Generate-Social-Engineering-Wordlist/
# https://github.com/ChireC/RW_Password
# 


# 工具函数
# 多维seq 一维化 
# # https://forum.nim-lang.org/t/1762
# proc flatten*[T](a: seq[seq[T]]): seq[T] =
#   var k = 0
#   for subseq in a:
#     k += len(subseq)
#   result = newSeq[T](k)
#   k = 0
#   for subseq in a:
#     for elem in subseq:
#       result[k] = elem
#       k += 1
# import sequtils

proc flatten[T](a: seq[T]): seq[T] = a
proc flatten[T](a: seq[seq[T]]): auto = a.concat.flatten


type 
    Password =  ref object of RootObj
        name*: string # 生成器名
        # 下面的这些seq要素的组合位置不固定, end_seq也可能在最前
        # mid_seq也可以没有
        keyword_seq*:  seq[string] # 密码关键字列表 一般在最前
        mid_seq*: seq[string] # 其他特殊符号列表, 连接符
        end_seq*: seq[string] # 后缀, 一般可以是时间或者一些固定的数字等, 某些情况下也可以放到最前
        # number: int # 数量,这个属性暂时不用
        codebook*: seq[string] # 密码本,存储密码seq用
    # rPassword = ref  ptr  Password

proc init*(this:Password, name = "default_gen", keyword_seq:seq[string] , mid_seq = @[""], end_seq = @[""]):Password =
    this.name = name
    this.keyword_seq = keyword_seq
    this.mid_seq = mid_seq
    this.end_seq = end_seq
    return this

# # 这个编写组合模式
# proc gen*(this:Password):seq =
#     echo "\n[Generation ALL Permutation]"
#     # result = newSeq[string]()
#     product(@[this.keyword_seq, this.mid_seq, this.end_seq]).mapIt(it.join(""))
#     # for k in this.keyword_seq:
#     #     result.add(k)
#         # return result

# 这个编写组合模式
proc gen*(this:Password, mix_seq:var seq[seq[string]]):seq =
    echo "\n[Generation ALL Product]"
    # result = newSeq[string]()
    product(mix_seq).mapIt(it.join(""))
    # for k in this.keyword_seq:
    #     result.add(k)
        # return result


# var p1 = Password().init(keyword_seq= @["winger","yunzheng","admin"], mid_seq = @["@"], end_seq = @["2022","2019"])
# var mix_seq1:seq[seq[string]] = @[p1.keyword_seq, p1.mid_seq, p1.end_seq]
# for pwd in p1.gen(mix_seq1):
#     echo pwd
# admin@2019
# yunzheng@2019
# winger@2019
# admin@2022
# yunzheng@2022
# winger@2022

# echo @"abcdef"
# @['a', 'b', 'c', 'd', 'e', 'f']

# import  algorithm
# echo product(@[@["A", "B"], @["@"], @["1", "2"]])
# @[@["B", "@", "2"], @["A", "@", "2"], @["B", "@", "1"], @["A", "@", "1"]]
# import sequtils
# import strutils
# echo product(@[@["A", "B"], @["@"], @["1", "2"]]).mapIt(it.join(""))
# @["B@2", "A@2", "B@1", "A@1"]

# @todo
# https://github.com/remigijusj/perms-nim/blob/master/examples/example2.nim
# https://github.com/narimiran/itertools
# 这里的组合库的速度可以测试下
# 先用官方的试试
# var mix_seq = @[p1.keyword_seq[0], p1.mid_seq[0], p1.end_seq[0]]
# echo mix_seq
# echo type(mix_seq)
# mix_seq.sort()
# echo mix_seq
# while  mix_seq.nextPermutation():
#     echo mix_seq
# @["2022", "@", "winger"]
# @["2022", "winger", "@"]
# @["@", "2022", "winger"]
# @["@", "winger", "2022"]
# @["winger", "2022", "@"]
# @["winger", "@", "2022"]


# 重复排列
# 所有顺序组合
# 参数:
# @[@["a"],@["b"],@["c"]]
# 返回
# @["acb", "bac", "bca", "cab", "cba"]
# 会修改入传 mix_seq
proc gen_permutation*(this:Password, mix_seq:var seq[seq[string]]):seq[string]=
    echo "\n[Generation ALL Permutation repeat]"
    # var result = newSeq[string]()
    # echo product(mix_seq)
    # echo "============================"
    # echo flatten(@[@["a","b"],@["6666"]])
    # var x0 = @["z","b"]
    # # sort(x0) # 改变x0的排序, 不返回内容
    # echo x0
    # echo sorted(x0) # 返回排序过的内容, x0不会改变
    # echo x0

    # echo product(mix_seq)
    var tseq = product(mix_seq).mapIt(sorted(it))
    # var tmp
    for e in tseq:
        var tmpseq = e
        while tmpseq.nextPermutation():
            result.add(join(tmpseq))

        # tmp.nextPermutation():
    #     tseq.sort()
    #     # # echo mix_seq
    #     while  tseq.nextPermutation():
    #     #     # echo result
    #     #     echo tseq
    #         result.add(join(tseq))
        # return  @["a"]
    # return @["a"]

# var mix_seq2:seq[seq[string]] = @[p1.mid_seq, p1.keyword_seq, p1.end_seq]
# echo "\n",mix_seq
# @["@", "winger", "2022"]
# for pwd in p1.gen_permutation(mix_seq2):
#     echo pwd
# 2022winger@
# @2022winger
# @winger2022
# winger2022@
# winger@2022

# echo mix_seq
# @["winger", "@", "2022"] 
# mix_seq被改变了

#  其他手工排序生成算法
# https://forum.nim-lang.org/t/2812






# https://forum.nim-lang.org/t/8127
# iterator flatten[T](source: openArray[T]): auto =
#   ## Flattens an arbitrarily nested
#   ## sequence
#   when T isnot seq:
#     for element in source:
#       yield element
#   else:
#     for each in source:
#       for e in flatten(each):
#         yield e
# # echo flatten([@["a","b","c"],@["666","888"]]):
#     echo i
# a
# a
# b
# c
# 666
# 888


# import sequtils

# proc flatten[T](a: seq[T]): seq[T] = a
# proc flatten[T](a: seq[seq[T]]): auto = a.concat.flatten


# let s = @[@[1,2,3],@[4,5,6]]
# echo s.flatten
# # @[1, 2, 3, 4, 5, 6]