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


