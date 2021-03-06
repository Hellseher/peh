;;;; sequences.lisp ---
;;;; Created :  <2020-02-24 Mon 23:33:08 GMT>
;;;; Modified : <2020-3-07 Sat 20:45:14 gmt>

;;;; Commentary:
;;; This section contains all sort of list sequences generated by
;;; predicates or directly if there is a know algorithm of calculation
;;; exits.

(in-package :peh-utils)

(defun slide-list (list slide)
  "Convert a given LIST into subsequences with SLIDE parameter.

:LIST 1 2 3 4 5 6 7 8 9 10
:SLIDE 3

1 2 3
2 3 4
3 4 5
4 5 6
5 6 7
6 7 8
7 8 9
8 9 10"
  (if (endp list)
      (error "Required LIST is empty.")
      (loop
         :repeat (1+ (- (length list) slide))
         :for l :on list
         :collect (subseq l 0 slide))))

(defun sum-list (list)
  "Return a sum of all numbers in a given list LIST."
  (check-type list (and list (not null)))
  (reduce #'+ list))

(defun product-list (list)
  "Return a sum of all numbers in a given list LIST."
  (check-type list (and list (not null)))
  (reduce #'* list))

(defun max-product-subseq (list)
  "Return a subsequence and max value of a given LIST which
  `product-list' value is maximized."
  (let ((max (loop
                :for l :in list
                :maximize (product-list l))))
    (loop
       :for l :in list
       :when (= (product-list l) max)
         :collect (list l max))))

(defun max-sum-subseq (list)
  "Return a subsequence and max value of a given LIST which
  `sum-list' value is maximized."
  (let ((max (loop
                :for l :in list
                :maximize (sum-list l))))
    (loop
       :for l :in list
       :when (= (sum-list l) max)
         :collect (list l max))))



(defun seq-fibonaccis (n)
  "Return a Fibonacci sequence up to Nth element."
  (check-type n (integer 0 *))
  (loop :for i :upto n
     :collect (nth-fibonacci i)))

(defun seq-fibonaccies-less (n)
  "Return a list of Fibonacci numbers with the last element less
  then N."
  (check-type n (integer 0 *)))

(defun seq-factors (num)
  "Return a list of all positive factors of NUM."
  (check-type num (integer 0 *))
  (if (<= num 1)
      '()
      (let ((divs (list 1)))
        (loop :for i :from 2 :upto (isqrt num)
           :do (when (zerop (mod num i))
                (push i divs)
                (let ((j (/ num i)))
                  (when (/= j i)
                    (push j divs)))))
        divs)))

(defun seq-prime-factors (num)
  "Return a list of all prime proper devisors of NUM."
  (loop
     :for i :from 2 :upto (sqrt num)
     :when (and (primep i) (zerop (mod num i)))
     :collect i))

(defun seq-perfect-numbers (n)
  "Return a set of perfect numbers upto Nth position.
WARNING: Slow after 1000000"
  (loop
     :for i :from 1 :upto n
     :when (perfectp i)
     :collect i))

(defun seq-square-pyramidal-numbers (n)
  "https://oeis.org/A000330

Return a sequence of pyramid numbers upto Nth element."
  (check-type n (integer 0 *))
  (loop
     :for i :from 1 :upto n
     :collect (square-pyramidal-number i)))

(defun seq-deficient-numbers (n)
  "https://oeis.org/A005100

Return a sequence of deficient numbers up to Nth."
  (check-type n (integer 0 *))
  (loop
     :for i :upto n
     :when (deficientp i)
     :collect i))

(defun seq-prime-numbers (n)
  "Return sequence of primes upto Nth elements."
  (loop
     :with num-collected := 0
     :for i :from 2
     :while (< num-collected n)
     :when (primep i)
     :collect i
     :and :do (incf num-collected)))

(defun seq-primes-below (n)
  "Return a sequence of prime numbers below given N."
  (loop
    :for i :upto n
    :when (primep i)
      :collect i))

;; sequences.lisp ends here
