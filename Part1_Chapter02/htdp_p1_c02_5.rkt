;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname htdp_p1_c02_5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; 2 Functions and Programs

(require 2htdp/image)    ; teachpack
(require 2htdp/batch-io) ; teachpack
(require 2htdp/universe) ; teachpack



;; 2.5 Programs

; Two distinct kinds of programs:
;   1. batch program - consumes all it's inputs at once and computes its result
;   2. interactive program - consumes some of its inputs, computes, produces
;      some output, consumes more input, and so on.

; (require 2htdp/batch-io) adds (read-file ...) and (write-file ...) functions

; (write-file "sample.dat" "212")
; (read-file "sample.dat")

; (write-file 'stdout "212\n")

(define (C f)
  (* 5/9 (- f 32)))
; (C 32)
; (C 212)
; (C -40)

(define (convert in out)
  (write-file out
              (string-append
               (number->string
                (C
                 (string->number
                  (read-file in))))
               "\n")))
; (convert "sample.dat" 'stdout)
; (convert "sample.dat" "sample_out.dat")
; (read-file "sample_out.dat")


;;; Exercise 31

; (write-file 'stdout (letter "Matthew" "Fisler" "Felleisen"))

(define (main in-fst in-lst in-signature out)
  (write-file out
              (letter (read-file in-fst)
                      (read-file in-lst)
                      (read-file in-signature))))
; (main "first_name.dat" "last_name.dat" "signature_name.dat" "letter_out.dat")


;;; Exercise 32
; Most people no longer use desktop computers just to run applications but
; also employ cell phones, tablets, and their cars’ information control screen.
; Soon people will use wearable computers in the form of intelligent glasses,
; clothes, and sports gear. In the somewhat more distant future, people may
; come with built-in bio computers that directly interact with body functions.
; Think of ten different forms of events that software applications on such
; computers will have to deal with.
; 1.  blood pressure measures
; 2.  heart rate
; 3.  eletrical brain activity
; 4.  body fluid chemistry metrics
; 5.  vaso-constriction metrics
; 6.  body sweat
; 7.  body temperature
; 8.  respiration rate
; 9.
; 10.

(define (number->square s)
  (square s "solid" "red"))
; (number->square 5)
; (number->square 10)
; (number->square 15)

; (require 2htdp/universe)

; (big-bang 100 [to-draw number->square])

; (big-bang 100
;   [to-draw number->square]
;   [on-tick sub1]
;   [stop-when zero?])

(define (reset s ke) ; s = state; ke = key event (string)
  100)
; (define (reset s ke)
;   (if (string=? ke " ") 50 100))

; (big-bang 100
;   [to-draw number->square] ; render fxn: (number->square s)
;   [on-tick sub1]           ; tock fxn:   (sub1 s)
;   [stop-when zero?]        ; end? fxn:   (zero? s)
;   [on-key reset])          ; ke-h fxn:   (reset s ke)

; (me-h (tock (ke-h cw0 "a")) "button-down" 90 100)

; Place dot program
(define BACKGROUND (empty-scene 100 100))
(define DOT (circle 3 "solid" "red"))

(define (main-2 y)
  (big-bang y
    [on-tick sub1]
    [stop-when zero?]
    [to-draw place-dot-at]
    [on-key stop]))

(define (place-dot-at y)
  (place-image DOT 50 y BACKGROUND))

(define (stop y ke)
  0)









