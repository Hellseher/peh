;;;; pe-utils.lisp
;;;; Created  : <2020-02-09 Sun 21:39:50 GMT>
;;;; Modified : <2020-02-12 Wed 01:29:10 GMT>

(in-package :peh/utils)

(defun compute-cache-path ()
  "Computes the directory where accumulated cache should reside."
  (merge-pathnames
   (make-pathname :directory '(:relative "cache"))
   (make-pathname :directory
                  (pathname-directory
                   (truename (asdf:system-source-directory :peh))))))

(defun cache-save (file)
  "Save acumulated cache under local source to the cache/FILE"

  (let ((cache-path (compute-cache-path)))
    (ensure-directories-exist cache-path)
    file))

(defun cache-load (file)
  (let ((cache-path (compute-cache-path)))
    cache-path
    file
    cache-path))
;;; TODO
;; + add caching of sequences
;; + add load/save functionality
;; + arguments checks
;; + load from cache when exists or save first to cache if not
;; + key or option to use cache

;;; Prime numbers

(defun primep (n)
  "Primality test of the N by trial division."
  (check-type n (integer 0 *))
  (cond ((= n 1) nil)
        ((< n 4) t)
        ((zerop (mod n 2)) nil)
        ((< n 9) t)
        ((zerop (mod n 3)) nil)
        (t (loop :for i :from 5 :upto (sqrt n) :by 2
              :do (when (zerop (mod n i))
                   (return-from primep nil)))
           t)))

(defun prime-set (n)
  "Return a set of prime nberes up to N."
  (check-type n (integer 0 *))
    (loop :for i :from 1 :upto n
       :when (primep i)
       :collect i))


;;;;

(defun fibonacci (n)
  "Compute N's Fibonacci number."
  (check-type n (integer 0 *))
  (loop :for f1 = 0 :then f2
     :and f2 = 1 :then (+ f1 f2)
     :repeat n :finally (return f1)))

(defun fib (n)
  (fibonacci n))


;;; Sequences

(defun seq-fibonaccies (n)
  "Return sequence of Fibonacci numbers upto N."
  (check-type n (integer 0 *))
  (loop :for i :from 1 :upto n
     :collect (fib i)))

(defun seq-fibonaccies-less (n)
  "Return a list of Fibonacci numbers with the last element less
  then N."
  (check-type n (integer 0 *)))

(defun seq-primes (n)
  (check-type n (integer 0 *))
  (prime-set n))

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
  (loop :for i :from 2 :upto (sqrt num)
     :when (and (primep i)
                (zerop (mod num i)))
     :collect i))


(defun aliquot-sum (num)
  "Return the sum of all proper devisors of NUM."
  (reduce #'+ (factors-set num)))

(defun perfect-p (num)
  "Test NUM for perfectness."
  (if (= (aliquot-sum num) num)
      t
      nil))

(defun perfects-set (num)
  "Return a set of perfect numbers upto NUM.
WARNING: Slow after 1000000"
  (let ((perfets ()))
    (loop for i from 1 upto num
       do (when (perfect-p i)
            (push i perfets)))
    perfets))


;;; DIGITS

(defun %num-to-list (num)
  "Coercing NUM to list."
  (map 'list #'digit-char-p (prin1-to-string num)))

(defun digit-sum (num)
  "Return a sum of digits for NUM."
  (reduce #'+ (%num-to-list num)))

(defun factorial (n)
  "Return factorial of N."
  (check-type n (integer 0 *))
  (apply #'* (loop :for i :from 1 :to n :collect i)))

(defun ! (n)
  "Aliace to `factorial'"
  (check-type n (integer 0 *))
  (factorial n))


;;; FIGURATE NUMBERS

(defun fig-three-num (n)
  "Return computed NTH triangular number."
  (check-type n (integer 0 *))
  (if (= n 1)
      1
      (/ (* n (+ n 1)) 2)))

(defun fig-three-num-p (n)
  "Check whether N is a triangular number."
    (= (sqrt (+ (* 8 n) 1))
     (isqrt (+ (* 8 n) 1))))

(defun fig-three-num-set (n)
  "Return a list of triangular numbers up to N."
  (check-type n (integer 0 *))
  (loop :for i :from 1 :to n
     :collect (fig-three-num n)))

(defun fig-four-num (n)
  "Return computed Nth figurative number four."
  (check-type n (integer 0 *))
  n)

(defun fig-four-num-p (n)
  "Check whether N is a figurative number four."
  n)

(defun fig-four-num-set (n)
  "Return a list of figurative numbers of four."
  (check-type n (integer 0 *))
  n)

;;; STRINGS

;; Not working with UNICODE only Enlish alphabet.
(defun word-to-alpha-pos (word)
  "Return a list of numbers for each letter in the WORD corresponding to its
  alphabetical position."
  (mapcar (lambda (char) (+ (- char (char-code #\A)) 1))
          (mapcar #'char-code (coerce (string-upcase word) 'list))))
;;; End of project-euler.lisp
