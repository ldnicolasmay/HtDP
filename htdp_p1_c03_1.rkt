;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname htdp_p1_c03_1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; 3 How to Design Programs

(require 2htdp/image)
(require 2htdp/batch-io)
(require 2htdp/universe)

;; 3.1 Designing Functions

; The Design Process
; Once you understand how to represent input information (from the domain) as
; data (in the program) and to interpret data as information, the design of
; an individual function proceeds according to a straightforward process:

; 1. Express how you with to represent information as data. A one-line
;    comment suffices, e.g.,
;    ; We use numbers to represent centimeters.

; 2. Write down a signature, a statement of purpose, and a function header.
;    a. Function Signature tells readers how many inputs go into function,
;    what classes they are, and what kind of data the function produces.
;    Function Signature examples:
;       ; String -> Number ; consume one String & produce a Number
;       ; Temperature -> String ; consume one Temperature & produce a String
;       ; Number String IMage -> Image
;    b. Function Purpose Statement summarizes the purpose of the function in
;       a single line. It answers "What does this function compute?"
;    c. Function Header is a simplistic function definition, also called a
;       "stub".
;       Function Header examples that match above Function Signatures:
;       ; (define (f str) 0)
;       ; (define (g num) "a")
;       ; (define (h num str img) (empty-scene 100 100))
;    Here's a full example:
;       ; Number String Image -> Image
;       ; adds s to img, y pixels from the top and 10 from the left
;       (define (add-image y s img)
;         (empty-scene 100 100))

; 3. Illustrate the Signature and Purpose Statement with some functional
;    examples.
;    Example:
;       ; Number -> Number
;       ; computes the area of a square with side len
;       ; given: 2, expect: 4
;       ; given: 7, expect: 49
;       (define (area-of-square len) 0)

; 4. Take inventory what are the givens and what we need to compute/produce.
;    Replace the functions body with a template.
;    Inventory Template example:
;       (define (area-of-square len)
;         (... len ...))

; 5. Code. Write the complete definition of the function.

;    Example 1:
; Number -> Number
; computes the area of a square with side len
; given: 2, expect: 4
; given: 7, expect: 49
(define (area-of-square len)
  (sqr len))

;    Example 2:
; Number String Image -> Image
; adds str to img, y pixels from top, 10 pixels to the left
; given:
;   5 for y,
;   "hello" for str, and
;   (empty-scene 100 100) for img
; expected:
;   (place-image (text "hello" 10 "red") 10 5 ...)
;   where ... is (empty-scene 100 100)
(define (add-image y str img)
  (place-image (text str 10 "red") 10 y img))

; 6. Test the function on examples you worked out before. For now this is
;    simply running the functions in the interaction pane.
