#!/bin/bash
# script
#  strongpass.sh
#
# what it does?
#  Output a strong password
#
# usage: ./strongpass.sh <password length>
#
# author
#  felipe lopes - bolzin [at] gmail [dot] com
#
# Copyright (c) 2015 Felipe Lopes
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

SIZE=$1
SPECIAL=(\! \@ \# \$ \% \& \* \_ \- \+ \= \{ \[ \} \] \^ \~ \> \< \. \,)
LOWER=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
UPPER=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
NUM=(0 1 2 3 4 5 6 7 8 9)
PASS=""

for i in $(seq 1 $SIZE); do
   WAY=$(((RANDOM % 4) + 1))
   case $WAY in
      1)PASS=$PASS${SPECIAL[$((RANDOM % ${#SPECIAL[@]}))]};;
      2)PASS=$PASS${LOWER[$((RANDOM % ${#LOWER[@]}))]};;
      3)PASS=$PASS${UPPER[$((RANDOM % ${#UPPER[@]}))]};;
      4)PASS=$PASS${NUM[$((RANDOM % ${#NUM[@]}))]};;
   esac
done

echo $PASS
