;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c03_2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 3 How to Design Programs

(require 2htdp/image)

;; 3.2 Finger Exercises: Functions

; 1. Write fxn signature
; 2. Write fxn purpose statement
; 3. Write fxn header (which becomes fxn inventory)
; 4. Write fxn inventory
; 5. Code the fxn
; 6. Test the fxn


;;; Exercise 34

; String -> 1String
; extracts the first character from a non-empty string
; given: tennis, expect: t
; given: Racket, expect: R
; (define (string-first s) ; inventory
;   (... s ...))           ; inventory
(define (string-first s)
  (if (string? s)
      (substring s 0 1) ; then
      "The arg you passed is not a string" ; else
      ))


;;; Exercise 35

; String -> 1String
; extracts the last character from a non-empty string
; given: tennis, expect: s
; given: Racket, expect: t
; (define (string-last s) ; inventory
;   (... s ...))          ; inventory
(define (string-last s)
  (if (string? s)
      (substring s (sub1 (string-length s))) ; then
      "The arg you passed is not a string"   ; else
      ))


;;; Exercise 36

; Image -> Number
; counts the number of pixels in a given image
; given: (rectangle 100 60 "solid" "red"), expect: 6000
; given: (ellipse 40 50 "outline" "green"), expect: 2000
; (define (image-area img)
;   (... img ...)) 
(define (image-area img)
  (if (image? img)
      (* (image-width img) (image-height img)) ; then
      "The arg you passed is not an image"     ; else
      ))


;;; Exercise 37

; String -> String
; produces a string like the given one with the first character removed
; given: tennis, expect: ennis
; given: Racket, expect: acket
; (define (string-rest s)
;   (... s ...))
(define (string-rest s)
  (if (string? s)
      (substring s 1 (string-length s)) ; then
      "The arg you passed is not a string"     ; else
      ))


;;; Exercise 38

; String -> String
; produces a string like the given one with the last character removed
; given: tennis, expect: tenni
; given: Racket, expect: Racke
; (define (string-remove-last s)
;   (... s ...))
(define (string-remove-last s)
  (if (string? s)
      (substring s 0 (sub1 (string-length s))) ; then
      "The arg you passed is not a string" ; else
      ))


