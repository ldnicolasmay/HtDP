;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c05_5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 5 Adding Structure


(require 2htdp/universe)
(require 2htdp/image)

;; 5.5 Computing with Structure

(define-struct entry [name phone email])
(define-struct vel [deltax deltay])
(define-struct ball [location velocity]) ; `posn` structure already defined

; Computing with structure instances generalizes the manipulation of
; Cartesian points. To appreciate this idea, let's look at a diagrammatic
; way to think about structure instances as lockboxes with as many
; compartments as there are fields.

; Here's a representation of this constant definition (`pl`)...

(define pl (make-entry "Al Abe" "666-7771" "lee@x.me"))

; ... as a diagram:

;                              +-------+
;                              | entry |
; +----------+------------+------------+
; | name     | phone      | email      |
; +----------+------------+------------+
; | "Al Abe" | "666-7771" | "lee@x.me" |
; +----------+------------+------------+

; Here's another instance.

(make-entry "Tara Harp" "666-7770" "th@smlu.edu")

;                                    +-------+
;                                    | entry |
; +-------------+------------+---------------+
; | name        | phone      | email         |
; |-------------|------------|---------------|
; | "Tara Harp" | "666-7770" | "th@smlu.edu" |
; +-------------+------------+---------------+

; Not surprisingly, nested structure instances hava a diagram of boxes
; nested in boxes. The instance `ball1` from Section 5.4...

(define ball1 (make-ball (make-posn 30 40) (make-vel -10 5)))

; ... is diagrammed as:

;                                  +------+
;                                  | ball |
; +---------------+-----------------------+
; | location      | velocity              |
; +---------------+-----------------------+
; |     +------+  |              +-----+  |
; |     | posn |  |              | vel |  |
; |  +----+----+  |  +--------+--------+  |
; |  | x  | y  |  |  | deltax | deltay |  |
; |  +----+----+  |  +--------+--------+  |
; |  | 30 | 40 |  |  | -10    | 5      |  |
; |  +----+----+  |  +--------+--------+  |
; +---------------+-----------------------+

; In the context of this imagery, a selector is like a key. It opens a
; specific compartment for a certai kind of box and enables the holder to
; extract its content. Applyring the `entry-name` to `pl` yields a string:

(entry-name pl) ; returns "Al Abe"

; `entry-name` applied to a `posn` structure signals an error.

;(entry-name (make-posn 42 5))
; above prints: "entry-name: expects an entry, given (make-posn 42 5)"

; If a structure instance compartment contains a box, it might be necessary
; to use two selectors in a row to get the desired number.

(ball-velocity ball1) ; returns the `vel` instance of ball1, so...
(vel-deltax (ball-velocity ball1))

; When DrRacket encounters a structure type definition with two fields

; (define-struct ball [location velocity])

; ... it introduces two laws, one per selector:

; (ball-location (make-ball l0 v0)) == l0
; (ball-velocity (make-ball l0 v0)) == v0

; For different structure type definitions, it introduces analagous laws:

; (define-struct vel [deltax deltay])
; (vel-deltax (make-vel dx0 dy0)) == dx0
; (vel-deltay (make-vel dx0 dy0)) == dy0

; Using these laws we can explain the interaction from above:

(vel-deltax (ball-velocity ball1))
; ==
(vel-deltax
 (ball-velocity
  (make-ball (make-posn 30 40) (make-vel -10 5))))
; ==
(vel-deltax (make-vel -10 5))
; ==
-10


;;; Exercise 70
; Spell out the laws for these structure type definitions:

(define-struct centry [name home office cell])
; (centry-name (make-centry ["blah" "123-4567" "234-5678" "345-6789"]))
; (centry-home ...)
; (centry-office ...)
; (centry-cell ...)

(define-struct phone [area number])
; (phone-area (make-phone 123 "456-7890"))
; (phone-number ...)

(phone-area
 (centry-office
  (make-centry "Shriram Fisler"
               (make-phone 207 "363-2421")
               (make-phone 101 "776-1099")
               (make-phone 208 "112-9981"))))

; Predicates
; As mentioned, every structure type definition introduces one new predicate.
; DrRacket uses thse predicates to discover whether a selector is applied to
; the proper kind of value; the next chapter explains this idea in detail.
; These predicates are just like the predicates `number?` and `string?`;
; they return `#true` or `#false` if the the expression passed to it
; evaluates to an instance of the structure type in question. That is, if
; you pass a `posn` expression to `posn?` it returns `#true`, otherwise it
; returns `#false`.

(define ap (make-posn 7 0))
(posn? ap) ; returns `#true`
(posn? 42) ; returns `#false`
(posn? #true) ; returns `#false`
(posn? (make-posn 3 4)) ; returns `#true`

; (define pl (make-entry "Al Abe" "666-7771" "lee@x.me"))
(entry? pl) ; returns `#true`
(entry? 42) ; returns `#false`
(entry? #true) ; returns `#false`


;;; Exercise 71

; distances in terms of pixels:
(define HEIGHT 200)
(define MIDDLE (quotient HEIGHT 2))
(define WIDTH  400)
(define CENTER (quotient WIDTH 2))

(define-struct game [left-player right-player ball])
 
(define game0
  (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))

;(game-ball game0)
;(posn? (game-ball game0))
;(game-left-player game0)


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
