# book-list-builder
Shell script to pull info from the library of congress from a list of ISBNs

# usage

```
# isbns.txt
9780521755511 # Elements of Greek
0020868308 # Mere Christianity
9781862280984 # Greek new testament
9780441013593 # Dune
```

```
$ ./build_list.sh isbns.txt booklist.txt
Done.
```

booklist.txt:
```
BT77 .L348 1984 Mere Christianity (1st pbk. ed.) - C.S. Lewis. Macmillan Pub. Co. 1960
PA817.W4 2005   The Elements of New Testament Greek (3 edition) - Cambridge University Press May 16, 2005
PS3558.E63 D8 2005  Dune (40th anniversary ed.) - Frank Herbert. Ace Books 2005
```

isbns.txt_errors.txt:
```
# Errors from run on Sun Dec 20 04:46:16 PM CST 2020
9781862280984 # Greek new testament
```
