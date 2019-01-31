;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c05_1-2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 5 Adding Structure

; Every programming language provides some mechanism to combine several
; pieces of data into a single piece of _compound data_ and ways to retrieve
; the constiuent values when needed. This chapter introduces BSL's
; mechanics, so-called structure type definitions, and how to design
; programs that work on compound data.

(require 2htdp/universe)
(require 2htdp/image)

;; 5.1 From Positions to posn Structures

; A position on a world canvas is uniquely identified by two pieces of data:
; the distance from the left margin and the distance from the top margin.
; The first is called an x-coordinate and the second one is a y-coordinate.

; DrRacket (which is basically a BSL program) represents such positions with
; `posn` structures. A `posn` structure combines two numbers into a single
; value. We can create a `posn` structure with the operation `make-posn`,
; which consumes two numbers and makes a `posn`. For example,

(make-posn 3 4)

; is an expression that creates a `posn` structure whose x-coordinate is 3
; and whose y-coordinate is 4.

; A `posn` structure has the same status as a number or a Boolean or a
; string. In particular, both primitive operations and functions may consume
; and produce structures. Also, a program can name a `posn` structure:

(define one-posn (make-posn 8 6))

; `one-posn` is a `posn` structure with 8 for an x-coordinate and 6 for a
; y-coordinate.

; In 5.2 Computing with `posn`s, we'll look at the laws of computation for
; `posn` structures. This will allow us to both create functions that
; process `posn` structures and predict what they compute.


;; 5.2 Computing with `posn`s

; Defining a variable p as a `posn` structure is straightforward.

(define p (make-posn 31 26))

; Extracting the x- and y- coordinates, we use the `posn-x` and `posn-y`
; functions. This is like subscript notation in math (p_x and p_y).

(posn-x p)
(posn-y p)

; Computationally speaking, `posn` structures come with two equations:
;   (posn-x (make-posn x0 y0)) == x0
;   (posn-y (make-posn x0 y0)) == y0

; Here's an example of a computation involving `posn` stuctures:

(posn-x p)
; == ; DrRacket replaces p with (make-posn 31 26)
(posn-x (make-posn 31 26))
; == ; DrRacket uses the law for `posn-x`
31


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
