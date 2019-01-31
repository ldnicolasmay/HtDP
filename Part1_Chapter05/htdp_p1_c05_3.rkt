;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c05_3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 5 Adding Structure


(require 2htdp/universe)
(require 2htdp/image)

;; 5.3 Programming with `posn`

; Now consider a function that computes the distance of some location to the
; origin of the canvas (i.e., the top left corner).

; Here's the purpose statement and the header of that fxn:

; computes the distance of ap to the origin
;(define (distance-to-0 ap)
;  0)

; In order to make up examples, we need to know how to compute this disance.
; For point with 0 (zero) as one of the coordinates, the result is the other
; coordinate.

(check-expect (distance-to-0 (make-posn 0 5)) 5)
(check-expect (distance-to-0 (make-posn 7 0)) 7)

; For the general case, we can recall the distance formula from geometry:
; the square root of the sum of x squared and y squared

; With the distance formula, we can easily make up more functional examples:

(check-expect (distance-to-0 (make-posn 3 4)) 5)
(check-expect (distance-to-0 (make-posn 8 6)) 10)
(check-expect (distance-to-0 (make-posn 5 12)) 13)

; Now we can start thinking about the function definition, which'll
; definitely require the `posn-x` and `posn-y` functions.

;(define (distance-to-0 ap)
;  (... (posn-x ap) ...
;   ... (posn-y ap) ...))

; Using the template above and the examples, the rest is straightforward:

(define (distance-to-0 ap)
  (sqrt (+ (sqr (posn-x ap)) (sqr (posn-y ap)))))

;;; Exercise 64
; Design the function `manhattan-distance`, which measures the Manhattan
; distance of the given `posn` to the origin.

; measures the Manhattan distance of a given `posn` to the origin
(check-expect (manhattan-distance (make-posn 0 0)) 0)
(check-expect (manhattan-distance (make-posn 1 0)) 1)
(check-expect (manhattan-distance (make-posn 0 1)) 1)
(check-expect (manhattan-distance (make-posn 1 2)) 3)
(define (manhattan-distance ap)
  (+ (posn-x ap) (posn-y ap)))


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
