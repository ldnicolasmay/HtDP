;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c03_5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 3 How to Design Programs


;; 3.5 On Testing

; To introduce BSL's testing facility, let's look again at the function that
; converts temperatores in Fahrenheit t Celsius...

; Number -> Number
; converts Fahrenheit temperatures to Celsius
; given: 32, expect: 0
; given: 212, expect: 100
; given: -40, expect: -40
(define (f2c f)
  (* 5/9 (- f 32)))

; Tesing the functions example calls can be formulated in the defitions area
; in DrRacket.
(check-expect (f2c -40) -40)
(check-expect (f2c 32) 0)
(check-expect (f2c 212) 100)

; `check-expect` specifications can go anywhere in the definitions area.
; It's good style to put the check-expect specifications below the signature
; and purpose statement, but above the function definition. Here's an
; example of the same function with a different name, "f2c-v2":

; Number -> Number
; converts Fahrenheit temperatures to Celsius
(check-expect (f2c-v2 -40) -40)
(check-expect (f2c-v2 32) 0)
(check-expect (f2c-v2 212) 100)
(define (f2c-v2 f)
  (* 5/9 (- f 32)))

; Just a note... (check-expect ...) works with images. You can copy-and-paste
; images directly into DrRacket or define the image via code.

; This kind of testing is called unit testing.





