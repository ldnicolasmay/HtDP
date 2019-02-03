;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c05_4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 5 Adding Structure


(require 2htdp/universe)
(require 2htdp/image)

;; 5.4 Defining Structure Types

; A "structure type definition" is another form of definition, distinct from
; constant and function definitions. Here is how the creator of DrRacket
; defined the `posn` structure type in BSL:

; (define-struct posn [x y])

; In general, a structure type definition has this shape:

; (define-struct StructureName [FieldName ...])

; The keyword define-struct signals the introduction of a new structure
; type. Then comes the name of the structure (e.g., `posn`). Third is a
; sequence of names enclosed in brackets; these names are the "fields".

; A structure type definition actually defines functions. But, unlike any
; ordinary function definition, A STRUCTURE TYPE DEFINITION DEFINES MANY
; FUNCTIONS simultaneously. Specifically, it defines three kinds of
; functions:

; 1. one constructor, a function that creates structure instances. It takes
;    as many values as there are fields; as mentioned, structure is short
;    for structure instance. The phrase "structure type" is a generic name
;    for the collection of all possible instances;
; 2. one selector per field, which extracts the value of the field from a
;    structure instance; and
; 3. one structure predicate, which, like ordinary predicates, distinguishes
;    instances from all other kinds of values.

; A program can use use these functions as if they were functions or
; pre-built primitives.

; Curiously, a structure type definition makes up names for the various new
; operations it creates. For the name of the constructor, it prefixes the
; structure name with `make-` (e.g. `make-posn`). For the names of the
; selectors, it postfixes the structure name with the field names (e.g.,
; posn-x, posn-y). Finally, the predicate is just the structure name with
; `?` appended to the end, pronounced "huh" when read aloud (e.g., `posn?`)


;;; Exercise 65

(define-struct movie [title producer year])
; constructor: make-movie
; selectors:   movie-title, movie-producer, movie-year
; predicate:   movie?

(define-struct person [name hair eyes phone])
; constructor: make-person
; selectors:   person-name, person-hair, person-eyes, person-phone
; predicate:   person?

(define-struct pet [name number])
; constructor: make-pet
; selectors:   pet-name, pet-number
; predicate:   pet?

(define-struct CD [artist title price])
; constructor: make-CD
; selectors:   CD-artist, CD-title, CD-price
; predicate:   CD?

(define-struct sweater [material size producer])
; constructor: make-sweater
; selectors:   sweater-material, sweater-size, sweater-producer
; predicate:   sweater?


(define-struct entry [name phone email])
; This structure type definition creates...
; constructor: make-entry
; selectors:   entry-name, entry-phone, entry-email
; predicate:   entry?

; Here's an instance of an `entry`:

(make-entry "Al Abe" "666-7771" "lee@x.me")

(define al (make-entry "Al Abe" "666-7771" "lee@x.me"))
(entry-name al)
(entry-phone al)
(entry-email al)
(entry? al)


;;; Exercise 66

(make-movie "Jaws" "Billy Joe" 1978)
(movie-title (make-movie "Jaws" "Billy Joe" 1978))
(movie-year (make-movie "Jaws" "Billy Joe" 1978))
(movie? (make-movie "Jaws" "Billy Joe" 1978))

(make-person "Bill McGillicuddy" "brown" "hazel" "555-555-5555")
(make-pet "Spot" 1234567)
(make-CD "Prince" "7" 10.99)
(make-sweater "cotton" "M" "Itchies")

; Sample Problem
; Develop a structure type definition for a program that deals with
; "bouncing balls", briefly mentioned at the very beginning of this chapter.
; The ball's location is a single number, namely the distance of pixes from
; the top. Its constant speed is the number of pixels it move per clock tick.
; Its velocity is the speed plus the direction in which it moves.

; Since the ball moves along a straight, vertical line, a number is a
; perfectly adequate data representation for its velocity:
; * A positive number means the ball moves down.
; * A negative number means it moves up.

; We can use this domain knowledge to formulate a structure type definition:

(define-struct ball [location velocity])

;;; Exercise 67
(define SPEED 3)
(define-struct balld [location direction])
(make-balld 10 "up")
(make-balld 30 "down")

; Since structures are values (just like numbers or Booleans or strings),
; it makes sense that one instance of a structure occurs inside another
; instance. Unlike bouncing balls, game objects don't always move along
; vertical lines. Instead, they move in some oblique manner across the
; canvas.

; Clearly, `posn` structures can represent locations. For the velocities, we
; define the `vel` structure type:

(define-struct vel [deltax deltay])

; Now we can use instance of `ball` to combine a `posn` structure with a
; `vel` structure to represent balls that move in straight lines but not
; necessarily along only vertical (or horizontal) lines:

(define ball1
  (make-ball (make-posn 30 40) (make-vel -10 5)))

; One way to interpret this instance is to think of a ball that is 30 pixels
; from the left and 40 pixels from the top. It moves 10 pixels toward the
; left per clock tick and move 5 pixels down per clock tick.

;;; Exercise 68
; An alternative to the nested data representation of balls uses four fields
; to keep track of the four properties:

(define-struct ballf [x y deltax deltay])

; Programmers call this a flat representation. Create an instance of a
; `ballf` that has the same interpretation as `ball1`.

(define ballf1 (make-ballf 30 40 -10 5))
; ballf1


; For a second example of nested structures, let's look at the exmaple of
; contact lists. Many cell phones support contact lists that allow several
; phone numbers per name: one for a home line, one for the office, and one
; for a cell phone number. For phone numbers, we wish to include both the
; area code and the local number. Since this nests the information, it's
; best to create a nested data representation, too:

(define-struct centry [name home office cell])

(define-struct phone [area number])

(make-centry "Shriram Fisler"
             (make-phone 207 "363-2421")
             (make-phone 101 "776-1099")
             (make-phone 208 "112-9981"))

; Nesting information is natural. The best way to represent such information
; with data is to mirror the nesting with nested structure instances. Doing
; so makes it easy to interpret the data in the application domain of the
; program, and it is also straightforward to go from examples of information
; to data. Of course, it is really the task of data definitions to specify
; how to go back and forth between information and data. Before we study
; data definitions for structure type definitions, however, we first take
; a systematic look at computing with, and thinking about, structures.


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
