;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname htdp_p1_c02_3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; 2 Functions and Programs

(require 2htdp/image)    ; teachpack
(require 2htdp/batch-io) ; teachpack
(require 2htdp/universe) ; teachpack


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

; (letter "Bill" "McGillicuddy" "John")
; (letter "Matthew" "Fisler" "Felleisen")
; (letter "Kathi" "Felleisen" "Findler")

; (require 2htdp/bath-io) ; this adds `(write-file ...)` function

; (write-file 'stdout (letter "Matt" "Fiss" "Fell"))

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
; (map profit (range 1.00 5.50 0.1))


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
; (map profit-2 (range 1.00 5.50 1))
; (map profit-2 (range 2.50 3.50 0.10)) ; $2.90 maximizes profit


;;; Exercise 29
; (map profit-2 (range 2.50 3.50 0.10)) ; still, $2.90 maximizes profit



