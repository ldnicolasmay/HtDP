;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname htdp_p1_c02_4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; 2 Functions and Programs

(require 2htdp/image)    ; teachpack
(require 2htdp/batch-io) ; teachpack
(require 2htdp/universe) ; teachpack



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

; (map profit-3 (range 2.50 3.50 0.10))



