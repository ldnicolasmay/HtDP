;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c02) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))

; 2 Functions and Programs

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
(define (image-classify i)
  (if (image? i)
      (if (= (image-width i) (image-height i)) "square"
          (if (> (image-width i) (image-height i)) "wide" "tall"))
      "Argument must be an image"))
(image-classify gray-rectangle)
(image-classify (square 40 "solid" "black"))
(image-classify (ellipse 20 80 "outline" "green"))

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






