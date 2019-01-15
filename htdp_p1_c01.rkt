;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c01) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; 1 Arithmetic

(+ 1 2)
(+ 1 (+ 1 (+ 1 1) 2) 3 4 5)


;; 1.1 The Arithmetic of Numbers

(string-append "1.1 The Arithmetic of Numbers")
(+ 3 4)
(+ 11 13)
(- 11 13)
(* 11 13)
(/ 11 13) ; notice that BSL returns and exact number w/ repeating decimal notation
(abs -7)
(add1 5)
(ceiling 11/13)
(denominator 11/13)
(exact->inexact 11/13) ; kills the repeating decimal notation
(expt 11 13)
(floor 2.34)
(gcd 46 23)
(log (expt e 23))
(max 11 13)
(numerator 11/13)
(quotient 19 5) ; integer division, %/% in R
(quotient 20 5) ; integer division, %/% in R
(random 10) ; random int between 0 and 9
(remainder 19 5) ; modulo operator
(remainder 20 5) ; modulo operator
(sqr 10)
(and #true #false)
(tan (/ pi 2))

;;; Exercise 1
(define x 12)
(define y 5)
(+ x 10)
(* x y)
(sqrt (+ (sqr x) (sqr y))) ; distance from origin


;; 1.2 The Arithmetic of Strings

(string-append "1.2 The Arithmetic of Strings")

(string-append "what a " "lovely " "day " "for BSL")

;;; Exercise 2
(define prefix "hello")
(define suffix "world")
(string-append prefix "_" suffix)


;; 1.3 Mixing It Up

(string-append "1.3 Mixing It Up")

(string-length "hello world")
(string-ith "hello world" 0)
(number->string 41)
(substring "hello world" 3 8)
(substring "hello world" 8)

(+ (string-length "hello world") 20)
(+ (string-length (number->string 42)) 2)

;;; Exercise 3
(define str "helloworld")
(define i 5)
(string-append (substring str 0 i) "_" (substring str i))
;; above could also be written as follows...
(string-append (substring str 0 i) "_" (substring str i (string-length str)))

;;; Exercise 4
(string-append (substring str 0 i) (substring str (add1 i)))


;; 1.4 The Arithmetic of Images

(string-append "1.3 The Arithmetic of Images")

;;;; Primitive image operations come in 3 kinds:
;;;;   1. Create basic images
;;;;   2. Get image properties
;;;;   3. Compose images (put them together variously)

; Basic image creators
(circle 20 "solid" "orange")
(ellipse 60 20 "solid" "orange")
(line 40 30 "red")
(rectangle 60 20 "solid" "blue")
(text "Hello world!" 24 "green")
(triangle 40 "solid" "yellow")
(star 25 "solid" "white")

; Get image properties
(image-width (circle 10 "solid" "red"))
(image-height (rectangle 40 30 "solid" "green"))
(+ (image-width (circle 10 "solid" "red"))
   (image-height (rectangle 40 30 "solid" "green")))

; Compose images
(overlay (rectangle 15 20 "solid" "red")
         (circle 20 "solid" "orange"))
(overlay/xy (rectangle 15 15 "solid" "red")
            10 10
            (rectangle 40 40 "solid" "orange"))
(overlay/xy (rectangle 20 20 "outline" "white")
            20 0
            (rectangle 20 20 "outline" "white"))
;; x-places are left, right, middle... y-places are top, middle, bottom
(overlay/align "left" "top"
               (rectangle 40 40 "solid" "blue")
               (rectangle 50 50 "solid" "red"))
(overlay/align "middle" "middle"
               (rectangle 40 40 "solid" "blue")
               (rectangle 50 50 "solid" "red"))
(empty-scene 100 60)
(place-image (rectangle 50 30 "solid" "black") 30 15 (empty-scene 100 60))
(scene+line (empty-scene 100 60) 10 10 90 50 "red")
(scene+line (place-image (rectangle 50 30 "solid" "black")
                         30 15
                         (empty-scene 100 60))
            10 10 90 50 "red")

;;; Exercise 5
(define (tree s) (overlay/align "middle" "top"
                                (circle s "solid" "green")
                                (rectangle (/ s 2) (* s 3) "solid" "brown")))
(tree 10)
(tree 20)
(tree 30)
(tree 40)
(overlay/xy (tree 10) 40 0 (tree 20))


;; 1.5 The Arithmetic of Booleans

(or #true #true)
(or #true #false)
(or #false #false)

(and #true #true)
(and #true #false)

(not #true)

(or #false #true #false)
(and #false #true #false)

;;; Exercise 7
(define sunny #true)
(define friday #false)
(or (not sunny) friday)


;; 1.6 Mixing It Up with Booleans

; (define xx 0)
; (define inverse-of-xx (/ 1 xx))
(define (inverse-of-x x) (if (= x 0) 0 (/ 1 x)))
(inverse-of-x 2)
(inverse-of-x 0)
(inverse-of-x 123)

(> 3 4)
(<= 3 4)

; for string equality, use (string=? "string1" "string2")
(string=? "string1" "string2")
; also there's string<=?
(string<=? "string1" "string2")
(string>=? "a" "b")

(define current-color "red")
(define next-color
  (if (string=? current-color "green") "yellow"
      (if (string=? current-color "yellow") "red" "green")))
current-color
next-color

;;; Exercise 8
(define cat (ellipse 60 40 "solid" "brown"))
cat
(if (> (image-width cat) (image-height cat)) "wide" "tall")
(if (= (image-width cat) (image-height cat)) "square"
    (if (> (image-width cat) (image-height cat)) "wide" "tall"))


;; 1.7 Predicates: Know Thy Data

; A predicate is a function that consumes a value and determines
; whether or not that value belongs to some class of data.

(number? 4)
(number? pi)
(number? #true)
(number? "fortytwo")

; Predicates can help protect expression from misuse

(define in1 "fortytwo")
(if (string? in1) (string-length in1) "`in1` not a string")

(number? 12/13)   ; #true
(number? 3+4i)    ; #true
(string? "hello") ; #true
(string? #false)  ; #false
(image? (circle 30 "outline" "red")) ; #true
(boolean? #false) ; #true

(integer? 12)     ; #true
(integer? 12.3)   ; #false
(rational? 12/13) ; #true
(rational? 0.1)   ; #true
(real? 0.1234)    ; #true
(complex? 3+4i)   ; #true
(complex? 3)      ; #true; 3+0i
(complex? (+ e (* e 0+1i))) ; #true
; suprisingly...
(rational? pi) ; is #true
; this is true because BSL uses a finite approximation of pi
(exact? 12/13)    ; #true
(exact? (sin (/ pi 2))) ; #false
(inexact? (sin pi)) ; #true

;;; Exercise 9
; (define in -9)
; (define in "blah")
; (define in (rectangle 40 80 "solid" "green"))
(define in #false)
(if (number? in) (abs in)
    (if (string? in) (string-length in)
        (if (image? in) (* (image-width in) (image-height in))
            (if (and (boolean? in) in) 10
                (if (and (boolean? in) (not in)) 20 "")))))

;;; Exercise 10
; Now relax, eat, sleep, and then tackle the next chapter.
