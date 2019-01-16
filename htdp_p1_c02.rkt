;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname htdp_p1_c02) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; 2 Functions and Programs

(require 2htdp/image)    ; teachpack
(require 2htdp/batch-io) ; teachpack



;; 2.1 Functions

; Constant definition:
; (define Variable Expression)

; Function definition:
; (define (FunctionName Variable ... Variable)
;   Expression)

(define (f x) 1)
(define (g x y) (+ 1 1))
(define (h x y z) (+ (* 2 2) 3))

(define (ff a)
  (* 10 a))

; Function application:
; (FunctionName Argument ... Argument)
(f 3)
(f "hello world")
(f #true)
; (f) ; throws error: "f: expects 1 argument, but found none"
; (f 1 2 3 4 5) ; similar: "f: expects only 1 argument, but found 5"
(g 4 5)
(h 6 7 8)
(ff 3)

; Nesting function applications
(+ (ff 3) 2)
(ff (ff 1.23))

;;; Exercise 11
(define (distance x y) (sqrt (+ (sqr x) (sqr y))))
(distance 3 4)
(distance 6 8)
(distance 12 5)

;;; Exercise 12
(define (cvolume s) (expt s 3))
(cvolume 3)
(define (csurface s) (* (sqr s) 6))
(csurface 3)

;;; Exercise 13
(define (string-first s)
  (if (string? s)                   ; is arg a string?
      (if (> (string-length s) 0)   ; arg is a string; is arg len > 0?
          (string-ith s 0)
          "String must not be empty")
      "Argument must be a string")) ; arg is NOT a string
(string-first "blah")
(string-first "")
(string-first 5)
(string-first #true)

;;; Exercise 14
(define (string-last s)
  (if (string? s)                   ; is arg a string?
      (if (> (string-length s) 0)   ; arg is a string; is arg len > 0?
          (string-ith s (sub1 (string-length s)))
          "String must not be empty")
      "Argument must be a string")) ; arg is NOT a string
(string-last "blah")
(string-last "")
(string-last 5)
(string-last #true)

;;; Exercise 15
(define (==> sunny friday)
  (if (and (boolean? sunny) (boolean? friday))
      (and (not sunny) friday)
      "Arguments must both be booleans"))
(==> #false #true)  ; #true
(==> #false #false) ; #false
(==> #true #true)   ; #false
(==> #true #false)  ; #false

;;; Exercise 16
(define (image-area i)
  (if (image? i)
      (* (image-width i) (image-height i))
      "Argument must be an image"))
(define gray-rectangle (rectangle 60 15 "solid" "gray"))
(image-area gray-rectangle)

;;; Exercise 17
; Using (if ...)
; (define (image-classify i)
;   (if (image? i)
;       (if (= (image-width i) (image-height i)) "square"
;           (if (> (image-width i) (image-height i)) "wide" "tall"))
;       "Argument must be an image"))
; Using (cond [...] [...])
(define (image-classify i)
  (cond
    [(> (image-width i) (image-height i)) "wide"  ]
    [(= (image-width i) (image-height i)) "square"]
    [(< (image-width i) (image-height i)) "tall"  ]))
(image-classify gray-rectangle) ; wide
(image-classify (square 40 "solid" "black")) ; square
(image-classify (ellipse 20 80 "outline" "green")) ; tall

;;; Exercise 18
(define (string-join s1 s2)
  (if (and (string? s1) (string? s2))
      (string-append s1 "_" s2)          ; then
      "Arguments must both be strings")) ; else
(string-join "" "")
(string-join "hello" "world")

;;; Exercise 19
(define (string-insert s i)
  (if (and (string? s) (integer? i) (>= i 0) (<= i (string-length s)))
      (string-append (substring s 0 i) "_" (substring s i))  ; then
      "1st arg must be string and 2nd arg must be integer")) ; else
(string-insert "Nicolas" 4)
(string-insert "" 0)

;;; Exercise 20
(define (string-delete str i)
  (if (and (string? str)
           (integer? i)
           (>= i 0)
           (< i (string-length str)))
      (string-append (substring str 0 i) (substring str (add1 i)))    ; then
      "1st arg must be nonempty string and 2nd art must be integer")) ; else
(string-delete "Nicolas" 4)
(string-delete "" 0)



;; 2.2 Computing

; Look in file htdp_p1_c02_2.rkt for following example using stepper
; (define (ff a) (* 10 a))
; (ff (+ 1 1))

;;; Exercises 21 throught 26 -- see htdp_p1_c02_02.rkt



;; 2.3 Composing Functions

;;;;;
;;
;;  SLOGAN: DEFINE ONE FUNCTION PER TASK.
;;
;;;;;

; main function
(define (letter fst lst signature-name)
  (string-append
   (opening fst)
   "\n\n"
   (body fst lst)
   "\n\n"
   (closing signature-name)))

; helper function 1
(define (opening fst)
  (string-append "Dear " fst ","))

; helper function 2
(define (body fst lst)
  (string-append
   "We have discovered that all people with the" "\n"
   "last name " lst " have won our lottery. So, " "\n"
   fst ", hurry and pick up your prize."))

; helper function 3
(define (closing signature-name)
  (string-append
   "Sincerely," "\n\n"
   signature-name "\n"))

(letter "Bill" "McGillicuddy" "John")
(letter "Matthew" "Fisler" "Felleisen")
(letter "Kathi" "Felleisen" "Findler")

; (require 2htdp/bath-io) ; this adds `(write-file ...)` function

(write-file 'stdout (letter "Matt" "Fiss" "Fell"))

; expected attendees
(define (attendees ticket-price)
  (- 120 (* (- ticket-price 5.0) (/ 15 0.1))))

; revenue (money earned)
(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

; cost (money spent)
(define (cost ticket-price)
  (+ 180 (* 0.04 (attendees ticket-price))))

; profit (revenue - cost)
(define (profit ticket-price)
  (- (revenue ticket-price) (cost ticket-price)))

; (range 4.0 6.0 0.1)
(map profit (range 1.00 5.50 0.1))


;;; Exercise 27
; Revise movie theater profit program above to include constants

; constant definitions
(define BASE-ATTENDEES 120)
(define BASE-TIX-PRICE 5.00)
(define ATTENDEE-CHANGE 15)
(define TIX-PRICE-CHANGE 0.10)
; (define FIXED-COST 180.00) ; Exer. 29 changed this
(define FIXED-COST 0.00)     ;
; (define FLUX-COST 0.04)    ; Exer. 29 changed this
(define FLUX-COST 1.50)      ;

; expected attendees
(define (attendees-2 ticket-price)
  (- BASE-ATTENDEES
     (* (- ticket-price BASE-TIX-PRICE)
        (/ ATTENDEE-CHANGE TIX-PRICE-CHANGE))))

; revenue (money earned)
(define (revenue-2 ticket-price)
  (* ticket-price (attendees ticket-price)))

; cost (money spent)
(define (cost-2 ticket-price)
  (+ FIXED-COST (* FLUX-COST (attendees ticket-price))))

; profit (revenue - cost)
(define (profit-2 ticket-price)
  (- (revenue ticket-price) (cost ticket-price)))


;;; Exercise 28
(map profit-2 (range 1.00 5.50 1))
(map profit-2 (range 2.50 3.50 0.10)) ; $2.90 maximizes profit


;;; Exercise 29
(map profit-2 (range 2.50 3.50 0.10)) ; still, $2.90 maximizes profit



;; 2.4 Global Constants

;;;;;
;;
;;  SLOGAN: FOR EVERY CONSTANT MENTIONED IN A PROBLEM STATEMENT,
;;          INTRODUCE ONE CONSTANT DEFINITION.
;;
;;;;;

; Constant definitions -- ALL CAPS by convention
(define CURRENT-PRICE 5) ; 5 is the "right hand side", here a literal constant
(define ALMOST-PI 3.14)  ; literal constant
(define NL "\n")         ; literal constant
(define MT (empty-scene 100 100)) ; RHS is an expression

; Constant defn.s, RHS literal constants and expressions
(define WIDTH 100)
(define HEIGHT 200)
(define MID-WIDTH (/ WIDTH 2))
(define MID-HEIGHT (/ HEIGHT 2))


;;; Exercise 30

; constant definitions
(define PRICE-SENSITIVITY-OF-ATTENDANCE
  (* ATTENDEE-CHANGE TIX-PRICE-CHANGE))

; expected attendees
(define (attendees-3 ticket-price)
  (- BASE-ATTENDEES
     (* (- ticket-price BASE-TIX-PRICE)
        PRICE-SENSITIVITY-OF-ATTENDANCE)))

; revenue (money earned)
(define (revenue-3 ticket-price)
  (* ticket-price (attendees ticket-price)))

; cost (money spent)
(define (cost-3 ticket-price)
  (+ FIXED-COST (* FLUX-COST (attendees ticket-price))))

; profit (revenue - cost)
(define (profit-3 ticket-price)
  (- (revenue ticket-price) (cost ticket-price)))

(map profit-3 (range 2.50 3.50 0.10))



;; 2.5 Programs

; Two distinct kinds of programs:
;   1. batch program - consumes all it's inputs at once and computes its result
;   2. interactive program - consumes some of its inputs, computes, produces
;      some output, consumes more input, and so on.

; (require 2htdp/batch-io) adds (read-file ...) and (write-file ...) functions

(write-file "sample.dat" "212")
(read-file "sample.dat")

(write-file 'stdout "212\n")

(define (C f)
  (* 5/9 (- f 32)))
(C 32)
(C 212)
(C -40)

(define (convert in out)
  (write-file out
              (string-append
               (number->string
                (C
                 (string->number
                  (read-file in))))
               "\n")))





