;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c05_6) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 5 Adding Structure


(require 2htdp/universe)
(require 2htdp/image)

;; 5.6 Programming with Structure

; For structure types, there's a need for a description of what kind of data
; goes into which field. For some structure type definitions, formulating
; such descriptions is easy and obvious:

;(define-struct posn [x y])
; A Posn is a structure:
;   (make-posn Number Number)
; interpretation: a point x pixels from the left, y pixels from the top

(define-struct entry [name phone email])
; An Entry is a structure:
;   (make-entry String String String)
; interpretation: a contact's name, phone# and email

; For both `posn` and `entry`, a reader can easily interpret instance of
; these structures in the application domain.

; Contrast this simplicity with the structure type definition for `ball`,
; which obviously allows at least two distinct interpretations:

(define-struct ball [location velocity])
; A Ball-1d is a structure:
;   (make-ball Number Number)
; interpretation 1: distance to top and velocity
; interpretation 2: distance to left and velocity

; Whichever interpretation we use in a program, we must stick to it
; consistently.

; However, it's also possible to use `ball` structures in an entirely
; different manner:

; (define-struct ball [location velocity])
; A Ball-2d is a structure:
;   (make-ball Posn Vel)
; interpretation: a 2-dimensional position and velocity

(define-struct vel [deltax deltay])
; A Vel is a structure:
;   (make-vel Number Number)
; interpretation: (make-vel dx dy) means a velocity of
;                 dx pixels per tick along the horizontal direction and
;                 dy pixels per tick along the vertical direction

; In other words, it's possible to use one and the same structure type in
; TWO DIFFERENT WAYS. Of course, within one program, it's best to stick to
; one and only one use.

;;; Exercise 72
; Formulate a data definition for the above phone structure type definition
; that accommodates the given examples.

(define-struct phone [area number])
; A Phone is a structure:
;   (make-phone Number String)
; interpretation: a phone number's area code and local 7-digit number

; Next formulate a data definition for phone numbers using this structure
; type definition:

(define-struct phone# [area switch num])
; A Phone# is a structure:
;   (make Number Number String)
; interpretation: (make-phone# a s n) means a phone number whose
;                 a is the three-digit area code from 200 to 999,
;                 s is the three-digit exchange code from 200 to 999, and
;                 n is the four-digit line number from 0000 to 9999

; Sample Problem
; Your team is designing an interactive game program that moves a red dot
; across a 100 x 100 canvas and allows player to use the mouse to reset the
; dot. Here is how far you got together:

(define MTS (empty-scene 100 100))
(define DOT (circle 3 "solid" "red"))

; A Posn represents the state of the world.

; Posn -> Posn
(define (main p0)
  (big-bang p0
    [on-tick x+]
    [on-mouse reset-dot]
    [to-draw scene+dot]))

; Your task is to design `scene+dot`, the function that adds a red dot to the
; empty canvas at the specified position.

; The problem context dictates the signature of your function:

; Posn -> Image
; adds a red spot to MTS at p
;(define (scene+dot p) MTS)

; Now we work out a couple of examples and formulate them as tests:

(check-expect (scene+dot (make-posn 10 20))
              (place-image DOT 10 20 MTS))
(check-expect (scene+dot (make-posn 88 73))
              (place-image DOT 88 73 MTS))

; Given that the fxn consumes a Posn, we know that the function can extract
; the values of the `x` and `y` fields:

;(define (scene+dot p)
;  (... (posn-x p) ... (posn-y p) ...))

; Filling out the rest of the fxn is straightforward.

(define (scene+dot p)
  (place-image DOT (posn-x p) (posn-y p) MTS))

; A function can produce structures (among other things).

; Sample Problem (cont.)
; A colleague is asked to define `x+`, a function that consumes a Posn and
; increases the x-coordinate by 3.

; Posn -> Posn
; increases the x-coordinate of p by 3
(check-expect (x+ (make-posn 10 0)) (make-posn 13 0))
;(define (x+ p)
;  (... (posn-x p) ... (posn-y p) ...)

; The signature, purpose, and example all come out of the problem statement.
; Finishing the fxn defn is easy now.

(define (x+ p)
  (make-posn (+ (posn-x p) 3) (posn-y p)))

;;; Exercise 73
; Design the function `posn-up-x`, which consumes a Posn `p` and a Number `n`.
; It produces a Posn like `p` with `n` in the `x` field.

; Posn Number -> Posn
; changes the x-coordinate of `p` to `n`
(check-expect (posn-up-x (make-posn 10 15) 30) (make-posn 30 15))
;(define (posn-up-x p n)
;  (... n ... (posn-y p) ...))
(define (posn-up-x p n)
  (make-posn n (posn-y p)))

; A function can also produce instance of atomic data.

; Sample Problem
; Another colleague is tasked to design `reset-dot`, a function that resets
; the dot when the mouse is clicked.

; Recall that mouse event handlers consume four values:
; 1. the current state of the world
; 2. the mouse pointer x coordinate
; 3. the mouse pointer y coordinate
; 4. a MouseEvent

; By adding the knowledge from the sample problem to the program design
; recipe, we get a signature, a purpose statement, and a header.

; Posn Number Number MouseEvt -> Posn
; for mouse clicks, (make-posn x y); otherwise p
;(define (reset-dot p x y me) p)

(check-expect
 (reset-dot (make-posn 10 20) 29 31 "button-down")
 (make-posn 29 31))
(check-expect
 (reset-dot (make-posn 10 20) 29 31 "button-up")
 (make-posn 10 20))

; The purpose statement and examples suggest a differentiation between two
; kinds of MouseEvts: "buttow-down" and all others. Hence, a `cond`
; expression.

;(define (reset-dot p x y me)
;  (cond
;    [(mouse=? "button-down" me) (... p ... x y ...)]
;    [else (... p ... x y ...)]))

(define (reset-dot p x y me)
  (cond
    [(mouse=? "button-down" me) (make-posn x y)]
    [else p]))

;;; Exercise 74
; Copy all relevant constant and function definitions to DrRacket’s
; definitions area. Add the tests and make sure they pass. Then run the
; program and use the mouse to place the red dot.
; (All done above. Run `(main (make-posn 0 10))` to run.)


; May programs deal with nested structures. We illustrate this point with
; another small excerpt from a world program.

; Sample Problem
; Your team is designing a game program that keeps track of an object that
; moves across the canvas at changing speed. The chosen data representation
; requires two data definitions:

(define-struct ufo [loc vel])
; A UFO is a structure:
;   (make-ufo Posn Vel)
; interpretation: (make-ufo p v) is at location p moving at velocity v

; The fxn `ufo-move-1` needs to be developed. The fxn computes the location
; of a given UFO after one click tick passes.

(define v1 (make-vel 8 -3))
(define v2 (make-vel -5 -3))

(define p1 (make-posn 22 80))
(define p2 (make-posn 30 77))

(define u1 (make-ufo p1 v1))
(define u2 (make-ufo p1 v2))
(define u3 (make-ufo p2 v1))
(define u4 (make-ufo p2 v2))

; Now we'll write a signature, purpose, some examples, and a function header.

; UFO -> UFO
; determines where u moves in one clock tick;
; leaves the velocity as is
(check-expect (ufo-move-1 u1) u3)
(check-expect (ufo-move-1 u2) (make-ufo (make-posn 17 77) v2))
; (define (ufo-move-1 u) u)

;; my own attempt before guidance
;(define (ufo-move-1 u)
;  ; get the ufo posn-x (posn-x (ufo-loc u))
;  ; get the ufo posn-y (posn-y (ufo-loc u))
;  ; get the ufo vel-deltax (vel-deltax (ufo-vel u))
;  ; get the ufo vel-deltay (vel-deltay (ufo-vel u))
;  (make-ufo (make-posn (+ (posn-x (ufo-loc u)) (vel-deltax (ufo-vel u))) ; loc
;                       (+ (posn-y (ufo-loc u)) (vel-deltay (ufo-vel u)))) 
;            (ufo-vel u))) ; vel

; Now we need to figure out how to combine the Posn and Vel inside the UFO
; to obtain the next location of the UFO. Let's create a function for adding
; a Vel to a Posn.

; Posn Vel -> Posn
; adds v to p
(check-expect (posn+ p1 v1) p2)
(check-expect (posn+ p1 v2) (make-posn 17 77))
(define (posn+ p v)
  (make-posn (+ (posn-x p) (vel-deltax v))
             (+ (posn-y p) (vel-deltay v))))

; With this little helper function, we can now simplify `ufo-move-1`.

(define (ufo-move-1 u)
  (make-ufo (posn+ (ufo-loc u) (ufo-vel u))
            (ufo-vel u)))

;;; Exercise 75
; Enter these definitions and their test cases into the definitions area of
; DrRacket and make sure they work. This is the first time that you have
; dealt with a “wish,” and you need to make sure you understand how the two
; functions work together.
; (This is done above.)


;##@    #==--  :  --==#    @##==---==##@##==---==##@    #==--  :  --==#    @##;
;==##@    #==-- --==#    @##==---==##@   @##==---==##@    #==-- --==#    @##==;
;--==##@    #==-==#    @##==---==##@   #   @##==---==##@    #==-==#    @##==--;
;=---==##@    #=#    @##==---==##@    #=#    @##==---==##@    #=#    @##==---=;
;#==---==##@   #   @##==---==##@    #==-==#    @##==---==##@   #   @##==---==#;
;@##==---==##@   @##==---==##@    #==-- --==#    @##==---==##@   @##==---==##@;
;  @##==---==##@##==---==##@    EXTRA  :  SPACE    @##==---==##@##==---==##@  ;
;@##==---==##@   @##==---==##@    #==-- --==#    @##==---==##@   @##==---==##@;
;#==---==##@   #   @##==---==##@    #==-==#    @##==---==##@   #   @##==---==#;
;=---==##@    #=#    @##==---==##@    #=#    @##==---==##@    #=#    @##==---=;
;--==##@    #==-==#    @##==---==##@   #   @##==---==##@    #==-==#    @##==--;
;==##@    #==-- --==#    @##==---==##@   @##==---==##@    #==-- --==#    @##==;
;##@    #==--  :  --==#    @##==---==##@##==---==##@    #==--  :  --==#    @##;
;==##@    #==-- --==#    @##==---==##@   @##==---==##@    #==-- --==#    @##==;
;--==##@    #==-==#    @##==---==##@   #   @##==---==##@    #==-==#    @##==--;
;=---==##@    #=#    @##==---==##@    #=#    @##==---==##@    #=#    @##==---=;
;#==---==##@   #   @##==---==##@    #==-==#    @##==---==##@   #   @##==---==#;
;@##==---==##@   @##==---==##@    #==-- --==#    @##==---==##@   @##==---==##@;
;  @##==---==##@##==---==##@    EXTRA  :  SPACE    @##==---==##@##==---==##@  ;
;@##==---==##@   @##==---==##@    #==-- --==#    @##==---==##@   @##==---==##@;
;#==---==##@   #   @##==---==##@    #==-==#    @##==---==##@   #   @##==---==#;
;=---==##@    #=#    @##==---==##@    #=#    @##==---==##@    #=#    @##==---=;
;--==##@    #==-==#    @##==---==##@   #   @##==---==##@    #==-==#    @##==--;
;==##@    #==-- --==#    @##==---==##@   @##==---==##@    #==-- --==#    @##==;
;##@    #==--  :  --==#    @##==---==##@##==---==##@    #==--  :  --==#    @##;
