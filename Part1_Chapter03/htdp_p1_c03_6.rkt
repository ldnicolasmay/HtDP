;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname htdp_p1_c03_6) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 3 How to Design Programs


(require 2htdp/universe)
(require 2htdp/image)

;; 3.5 Designing World Programs

; Depending on the needs of the program, the programmer must design functions
; that reponde to clock ticks, keystrokes, and mouse events. Ultimately, an
; interactive program may need need to stop when its current world belongs to
; a sub-class of states; `end?` recognizes these final states.

; Here the WorldState (cw) is spelled out in a schematic and simplified way:

; WorldState: data that represents the state of the world (cw)

; WorldState -> Image
; when needed, `big-bang` obtaions the image of the current state
; of the world by evaluating `(render cw)`
; (define (render cw) ...)

; WorldState -> WorldState
; for each tick of the clock, `big-bang` obtains the next state
; of the world from `(clock-tick-handler cw)`
; (define (clock-tick-handler cw) ...)

; WorldState String -> WorldState
; for each keystroke, `big-bang` obtains the next state from
; `(keystroke-handler cw ke)`; `ke`, "key event", represents the key
; (define (keystroke-handler cw ke) ...)

; WorldState Number Number String -> WorldState
; for each mouse gesture, `big-bang` obtains the next state from
; `(mouse-event-handler cw x y me)` where x and y are the coordinates
; of the event and me is its description
; (define (mouse-event-handler cw x y me) ...)

; WorldState -> Boolean
; after each even, `big-bang` evaluates `(end? cw)`
; (define (end? cw) ...)


; Sample problem: Design a program that moves a car from left to right on the
; world canvas, three pixels per clock tick.

; Below is me solving this problem without the design principles before reading
; about how to follow the systematic design-recipe approach.

; ======================================================
; Define needed constants
(define BACKGROUND (empty-scene 500 50))
(define WHEEL-RADIUS 10)
(define CAR-BODY
  (overlay/offset 
    (rectangle (* WHEEL-RADIUS 8) (* WHEEL-RADIUS 2) "solid" "red")
    0 (* WHEEL-RADIUS -1.5)
    (rectangle (* WHEEL-RADIUS 4) WHEEL-RADIUS "solid" "red")))
(define CAR-WHEELS
  (overlay/offset (circle WHEEL-RADIUS "solid" "black")
                  (* WHEEL-RADIUS 4) 0
                  (circle WHEEL-RADIUS "solid" "black")))
(define CAR
  (overlay/offset
    CAR-WHEELS
    0 (* WHEEL-RADIUS -1.5)
    CAR-BODY))

; (place-image CAR 25 35 BACKGROUND)
; (place-image CAR 475 35 BACKGROUND)

; Number -> Image
; draws image of car at point x on an empty-scene background
(check-expect (car-state 50) (place-image CAR 50 35 BACKGROUND))
(check-expect (car-state 100) (place-image CAR 100 35 BACKGROUND))
(define (car-state x)
  (place-image CAR x 35 BACKGROUND))

; Number -> Number
; adds three to a given number, to move CAR 3 pixels right
(check-expect (add3 -10) -7)
(check-expect (add3 0) 3)
(check-expect (add3 10) 13)
(define (add3 x)
  (+ x 3))

; Number -> Boolean
; checks if a given number is equal to 475, where the CAR will stop
(check-expect (far-right -475) #false)
(check-expect (far-right 0) #false)
(check-expect (far-right 475) #true)
(define (far-right x)
  (= x 475))

(define (main x)
  (big-bang x
    [to-draw car-state]
    [on-tick add3]
    [stop-when far-right]))
; ======================================================

; Instead of taking the above approach, here's what 2HtDP lays out in steps:

; 1. For all the properties of the world that remain the same over time and
;    are needed to render it as an Image, introduce constants. For the purpose
;    of world programs, we distinguish between two kinds of constants:
;
;    a. "Physical" constants describe general attributes of objects in the
;       world, such as speed or velocity of an object, its color, its height,
;       its width, its radius, etc. Here are some examples:
;          (define WIDTH-OF-WORLD 200)
;          (define WHEEL-RADIUS 5)
;          (define WHEEL-DISTANCE (* WHEEL-RADIUS 5))
;
;    b. Graphical constants are images of objects in the world. Here are some
;       examples:
;          (define WHEEL
;            (circle WHEEL-RADIUS "solid" "black"))
;          (define BOTH-WHEELS
;            (beside WHEEL SPACE WHEEL))
;
;    It's good practice to annotate constant definitions with explanations of
;    what they mean.

; 2. The properties that change over time -- in reaction to clock tics,
;    keystrokes, or mouse actions -- give rise to the current state of the
;    world. The programmer's task is to develop a data representation for all
;    possible states of the world. The development results in a data definition,
;    which comes with a comment that tells readers how to represent world
;    information as data and how to interpret data as information about the
;    world.
;
;    Choose simple forms of data to represent the state of the world.
;
;    For the car example, the data that represents the state of the world is
;    the car's distance from the left margin that changes over time. The
;    distance is measured in numbers, so the following is an adequate data
;    definition:
;
;    ; A WorldState is a Number.
;    ; interpretation: the number of pixels between the left border of the
;    ;                 scene of the car

; 3. Once you have a data representation for the state of the world, you need
;    to design a number of functions so that you can form a valid `big-bang`
;    expression.
;
;    To start with, you need a function that maps any given state into an
;    image so that `big-bang` can render the sequence of states of image:
;
;    ; render
;
;    Next you need to decide which kinds of events should change which aspects
;    of the world state. Depending on your decisions, you need to design some
;    or all of the following three functions:
;
;    ; clock-tick-handler
;    ; keystroke-handler
;    ; mouse-event-handler
;
;    Finally, if the problem statement suggests that the program should stop
;    if the world has certain properties (i.e., reaches a certain state), you
;    must design...
;
;    ; end?
;
;    For the sample program, this 3rd step would result in the following
;    wish list:
;
;    ; WorldState -> Image
;    ; places the image of the car x pixels from the left margin of the
;    ; BACKGROUND image
;    (define (render x)
;      BACKGROUND)
;
;    ; WorldState -> WorldState
;    ; adds 3 to x to move the car right
;    ; (define (tock x)
;        x)
;
; 4. Finally, you need a `(main ...)` function. Unlike all other functions,
;    the `main` function doesn't need to be designed and it doesn't need
;    testing. It only exists to launch the program from DrRacket's
;    interaction pane. (Reminder: Top pane is definitions pane; bottom pane
;    is interaction pane.)
;
;    The one decision you have to make concern `main`'s arguments. For our
;    example, we opt for one argument: the initial state of the world.
;
;    ; WorldState -> WorldState
;    ; launches the program from some initial state
;    (define (main ws)
;      (big-bang ws
;        [on-tick tock]
;        [to-draw render]))
;
;    Once `main` is defined, this example program can be launched with:
;
;    > (main 13)
;
;    ... which will launch the program with the CAR's center 13 pixels to the
;    right of the `big-bang`'s window. 
;
;
;;; Exercise 39
    
