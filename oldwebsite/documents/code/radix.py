#Author: Steven Hart
#Date: Spring 2013
#Description: radix.py -- implementation of an integer Radix Sort 
# for the purposes of speed efficiency algorithm testing against
# a common insertion sort
# Test Factors for input include:  Random, Sorted, Reverse-Sorted, Half-sorted,
#   small input (10), large input (100000), and extra large input (1000000000)

from math import log
from random import randint
import time, copy

#----------------------------INSERTION SORT FUNCTION                                                                                                                                                            
def insertion_sort(l):

    for i in xrange(1, len(l)):
        j = i - 1
        key = l[i]
        while (l[j] > key) and (j >= 0):
            l[j + 1] = l[j]
            j -= 1
        l[j + 1] = key

#-------------------------------------RADIX                                                                                                                                                          
def getDigit(num, base, digit_num):
    # pulls the selected digit                                                                                                                                                                       
    return (num // base ** digit_num) % base
def makeBlanks(size):
    # create a list of empty lists to hold the split by digit                                                                                                                                        
    return [ [] for i in range(size) ]
    # helper method for radix sort
def split(a_list, base, digit_num):
    buckets = makeBlanks(base)
    for num in a_list:
        # append the number to the list selected by the digit                                                                                                                                        
        buckets[getDigit(num, base, digit_num)].append(num)
    return buckets
# concatenate the lists back in order for the next step                                                                                                                                              
def merge(a_list):
    new_list = []
    for sublist in a_list:
       new_list.extend(sublist)
    return new_list

def maxAbs(a_list):
    # largest abs value element of a list                                                                                                                                                            
    return max(abs(num) for num in a_list)
def radixSort(a_list, base):
    # there are as many passes as there are digits in the longest number                                                                                                                             
    passes = int(log(maxAbs(a_list), base) + 1)
    new_list = list(a_list)
    for digit_num in range(passes):
        new_list = merge(split(new_list, base, digit_num))
 #       print new_list                                                                                                                                                                              
    return new_list

#-----------------------------------DRIVER                                                                                                                                                           

def main():
    num_list = []
    num_list2 = []
    num_input = input("How many numbers would you like to input: ")

    for i in range(num_input):
        num = randint(100, 999)
        num_list.append(num)

    num_list2 = copy.deepcopy(num_list)
    #presort the list                                                                                                                                                                                
    insertion_sort(num_list2)

    #for -25% sorted --> change index to i for sorted                                                                                                                                                
#    for i in range((num_input-1)*.25):                                                                                                                                                              
#        num_list.append(num_list2[num_input-1-i])                                                                                                                                                   

    #for -50% sorted                                                                                                                                                                                 
    for i in range((num_input-1)*.5):
        num_list.append(num_list2[num_input-1-i])

    print(len(num_list))
    size = len(num_list)
    num_list2 = []
    for i in range(size):
#       print i                                                                                                                                                                                      
       num_list2.append(num_list[size-i-1])
    num_list = num_list2
#    print("Original:")                                                                                                                                                                              
#    print(num_list)                                                                                                                                                                                 

#    print("Insertion Sort:")                                                                                                                                                                        
    start = time.clock()
    insertion_sort(num_list)
    elapsed = (time.clock() - start)
    print "Insertion Sort took %.10f seconds" % (elapsed * 10)
#    print(num_list)                                                                                                                                                                                 

#    print("Radix Sort:")                                                                                                                                                                            
#    print num_list2, "<<< UNSORTED"                                                                                                                                                                 
    start = time.clock()
    radixSort(num_list, 2)
    elapsed = (time.clock() - start)
    print "Radix Sort took %.10f seconds" % (elapsed * 10)
#    print(num_list2)                                                                                                                                                                                


main()



