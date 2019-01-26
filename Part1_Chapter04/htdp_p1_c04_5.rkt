;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname htdp_p1_c04_5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 4 Intervals, Enumerations, and Itemizations


(require 2htdp/universe)
(require 2htdp/image)

;; 4.5 Itemizations

; Itemizations are data definitions that include elements from both
; enumerations and intervals... and may also include individual pieces of
; data.

; The description of the `string->number` primitive employes the idea of an
; itemization in a sophisticated way. Its signature is...
;
; String -> NorF (Number or #false)
; converts a given string into a number;
; produces #false if impossible
; (define (string->number s) (... s ...))
;
; ... meaning that the result signature names a simple class of data:
; An NorF is one of:
; - #false
; - a Number
;
; This itemization combines one piece of data (#false) with a large, and
; distinct, class of data (Number).

; Imagin a function that consumes the result of `string->number` and adds 3,
; dealing with #false as if it were 0 (zero):
;
; NorF -> Number
; adds 3 to the given number; 3 otherwise
; (check-expect (add3 #false) 3)
; (check-expect (add3 0.12) 3.12)
; (define (add3 x)
;   (cond
;     [(false? x) 3]
;     [else (+ x 3)]))
;
; Like other functions with enumerations and intervals, this function uses
; a `cond` expression to handle its itemization input data.

; New design task...
; Sample Problem
; Design a program that launches a rocket when the user of your program
; presses the space bar. The program first displays the rocket sitting at the
; bottom of the canvas. Once launched, it moves upward at three pixels per
; clock tick.
;
; This revised version suggests a representation with two classes of states:
;
; A LaunchingRocket (LR in the books) is one of:
; - "resting"
; - NonnegativeNumber
; interpretation: "resting" represents a grounded rocket,
; and a number denotes the heigh of a rocket in flight


; -- Constants --
(define WIDTH 100)
(define HEIGHT 300)
(define ROCKET (rectangle 10 30 "solid" "orange"))
(define X-ROCKET (/ WIDTH 2))
(define MTSCN (empty-scene WIDTH HEIGHT))
(define Y-DELTA 3)

; -- Fxn Wish List --

; render fxn
; LaunchingRocket -> Image
; places the ROCKET at given height in the middle of MTSCN
(check-expect (render "resting") (place-image ROCKET
                                              X-ROCKET HEIGHT
                                              MTSCN))
(check-expect (render (- HEIGHT Y-DELTA))
              (place-image ROCKET
                           X-ROCKET (- HEIGHT Y-DELTA)
                           MTSCN))
(check-expect (render 0) (place-image
                          ROCKET X-ROCKET 0
                          MTSCN))
(define (render lr)
  (cond
    [(and (string? lr) (string=? lr "resting")) (place-image ROCKET
                                                             X-ROCKET HEIGHT
                                                             MTSCN)]
    [(number? lr) (place-image ROCKET X-ROCKET lr MTSCN)]))


; clock handler fxn
; LaunchingRocket -> LaunchingRocket
; computes next location of ROCKET
; input: resting, expect: resting
; input: HEIGHT, expect: (- HEIGHT 3)
; input: 100, expect: 97
(check-expect (tock "resting") "resting")
(check-expect (tock HEIGHT) (- HEIGHT Y-DELTA))
(define (tock lr)
  (cond
    [(and (string? lr) (string=? lr "resting")) "resting"]
    [(number? lr) (- lr Y-DELTA)]))

; key event handler fxn
; LaunchingRocket KeyEvent -> LaunchingRocket
; when space bar is pressed, switches WorldState from "resting"
;   to a NonnegativeNumber (- HEIGHT 3)
; input: lr "a", expect: lr
; input: lr " ", expect: (- HEIGHT 3)
(check-expect (keh "resting" " ") (- HEIGHT 3))
(check-expect (keh "resting" "a") "resting")
(check-expect (keh 100 " ") 100)
(check-expect (keh 100 "a") 100)
(define (keh lr ke)
  (cond
    [(and (string? lr) (string=? lr "resting") (string=? ke " ")) (- HEIGHT 3)]
    [else lr]))

; -- Main Fxn --
; (define (main lr)
;   (big-bang lr
;     [to-draw render]
;     [on-tick tock]
;     [on-key  keh]))


; In reality, rocket launches come with countdowns.

; Sample Problem (revised)
; Design a program that launches a rocket when the user presses the space
; bar. At that point, the simulation starts a countdown for three ticks,
; before it displays the scenery of a rising rocket. The rocket should move
; upward at a rate of three pixels per clock tick.

(define HEIGHT-2 300)
(define WIDTH-2  100)
(define Y-DELTA-2 3)
(define BACKG-2 (empty-scene WIDTH-2 HEIGHT-2))
(define ROCKET-2 (rectangle 5 30 "solid" "red"))
(define CENTER-2 (/ (image-height ROCKET-2) 2))

; Revised problem calls for three distinct sub-classes of states:

; An LRCD (LaunchingRocketCountDown) is one of:
; - "resting"
; - a Number between -3 and -1 (inclusive)
; - a NonnegativeNumer
; interpretation: a grounded rocket in countdown mode,
;   a number denotes the number of pixels between the 
;   top of the canvas and the rocket (its height)

; LRCD -> Image
; renders the state as a resting for flying rocket
(check-expect (show "resting")
              (place-image ROCKET-2 10 (- HEIGHT-2 CENTER-2) BACKG-2))
(check-expect (show -2)
              (place-image (text "-2" 20 "red")
                           10 (* 3/4 WIDTH-2)
                           (place-image ROCKET-2
                                        10 (- HEIGHT-2 CENTER-2)
                                        BACKG-2)))
(check-expect (show 53)
              (place-image ROCKET-2 10 (- 53 CENTER-2) BACKG-2))
(check-expect (show 0)
              (place-image ROCKET-2 10 (- 0 CENTER-2) BACKG-2))
(define (show x)
  (cond
    [(string? x)
     (rocket-on-bg HEIGHT-2)]
    [(<= -3 x -1)
     (place-image (text (number->string x) 20 "red")
                  10 (* 3/4 WIDTH-2)
                  (rocket-on-bg HEIGHT-2))]
    [(<= 0 x)
     (rocket-on-bg x)]))

;;; Exercise 55
; LRCD -> Image
; helper function to render rocket on ground or in flight
(check-expect (rocket-on-bg HEIGHT-2)
              (place-image ROCKET-2 10 (- HEIGHT-2 CENTER-2) BACKG-2))
(check-expect (rocket-on-bg 50)
              (place-image ROCKET-2 10 (- 50 CENTER-2) BACKG-2))
(define (rocket-on-bg x)
  (place-image ROCKET-2 10 (- x CENTER-2) BACKG-2))

; LRCD KeyEvent -> LRCD
; starts the countdown when space bar is pressed,
;   if the rocket is still resting
(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)
(define (launch x ke)
  (cond
    [(string? x) (if (string=? ke " ") -3 x)]
    [(<= -3 x -1) x]
    [(<= 0 x) x]))

; LRCD -> LRCD
; raises the rocket by YDELTA for each clock tick after launch
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) HEIGHT-2)
(check-expect (fly 10) (- 10 Y-DELTA-2))
(check-expect (fly 22) (- 22 Y-DELTA-2))
(define (fly x)
  (cond
    [(string? x) x]
    [(<= -3 x -1) (if (= x -1) HEIGHT-2 (+ x 1))]
    [(<= -10 x) (- x Y-DELTA-2)]))

;;; Exercise 56
; LRCD -> Boolean
; stops the program when the rocket exits the scene
(check-expect (end? "resting") #false)
(check-expect (end? -3) #false)
(check-expect (end? HEIGHT) #false)
(check-expect (end? 50) #false)
(check-expect (end? 0) #true)
(define (end? x)
  (cond
    [(string? x) #false]
    [(<= -3 x -1) #false]
    [(<= 1 x HEIGHT) #false]
    [else #true]
    ))

; LRCD -> LRCD
(define (main-2 s)
  (big-bang s
    [stop-when end?]
    [to-draw show]
    [on-key launch]
    [on-tick fly]
    ))


;;; Exercise 57 -- skipping --
; This is just addition/subtration on the Y coordinate

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
