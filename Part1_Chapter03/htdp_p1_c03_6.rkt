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
(define CAR (rectangle 40 15 "solid" "red"))
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
;    right of the left margin.


;;; Exercise 39

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
(define CAR-2
  (overlay/offset
    CAR-WHEELS
    0 (* WHEEL-RADIUS -1.5)
    CAR-BODY))


; Now let's design the clock tick handling function.

; WorldState -> WorldState
; moves the car by 3 pixels for every clock tick
; (define (tock ws) ws)

; The above becomes...

; WorldState -> WorldState
; moves the car by 3 pixels for every clock tick
; examples:
;   given: 20, expect: 23
;   given: 78, expect: 81
; (define (tock ws)
;   (+ ws 3))

;;; Exercise 40
; With Exercise 40, the above becomes...

; WorldState -> WorldState
; moves the car by 3 pixels for every clock tick
; (check-expect (tock -10) -7)
; (check-expect (tock 0) 3)
; (check-expect (tock 10) 13)
; (define (tock ws)
;   (+ ws 3))


; The next entry on the function wish list translate the World State into an
; image.

; WorldState -> Image
; places the car into the BACKGROUND scene,
;   according to the given world state
; (define (render ws)
;   BACKGROUND)

; At this point it's often useful to sketch out the graphics that will be
; displayed as the world state changes from event to event. (See Figure 19.)

; For each sketch, it's useful to write down expressions that would draw the
; pictures sketched in the step above. The examples given in Figure 19 are...
;
; ws  | expression
; ----|---------------------------------------
;  50 | (place-image CAR 50 Y-CAR BACKGROUND)
; 100 | (place-image CAR 100 Y-CAR BACKGROUND)
; 150 | (place-image CAR 150 Y-CAR BACKGROUND)
; 200 | (place-image CAR 200 Y-CAR BACKGROUND)

; ("Y-CAR" is the car's y position.)

; The info from this table is used to update the function we're designing.

; WorldState -> Image
; places the car into the BACKGROUND scene,
;   according to the given world state
; (define (render ws)
;   (place-image CAR ws Y-CAR BACKGROUND))

; And that's mostly all there is to designing a simple world program.


;;; Exercise 41
; Finish the sample problem and get the program to run.

(define TREE
  (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))
(define BACKGROUND-2 (place-image TREE 350 25 (empty-scene 500 100)))
(define Y-CAR (/ (image-height BACKGROUND-2) 2))

; Wish List:
;   * clock tick handler fxn
;   * render fxn
;   * end? fxn

; clock tick handler fxn
; WorldState -> WorldState
; moves the car 3 pixels right for every clock tick
(check-expect (tock -10) -7)
(check-expect (tock 0) 3)
(check-expect (tock 10) 13)
(define (tock ws)
  (+ ws 3))

; render fxn
; WorldState -> Image
; places the car on the BACKGROUND scene,
;   according to the given world state
(check-expect (render 50) (place-image CAR-2 50 Y-CAR BACKGROUND-2))
(check-expect (render 100) (place-image CAR-2 100 Y-CAR BACKGROUND-2))
(check-expect (render 200) (place-image CAR-2 200 Y-CAR BACKGROUND-2))
(define (render ws)
  (place-image CAR-2 ws Y-CAR BACKGROUND-2))

; end fxn
; WorldState -> Boolean
; stops the program when the car has left the background
; given: 0, expect: #false
; given: 550; expect: #true
(check-expect (car-gone? 0) #false)
(check-expect (car-gone? (+ 500 (/ (image-width CAR-2) 2))) #true)
(define (car-gone? ws)
  (>= ws (+ 500 (/ (image-width CAR-2) 2))))

(define (main-2 ws)
  (big-bang ws
    [on-tick tock]
    [to-draw render]
    [stop-when car-gone?]))


;;; Exercise 42 --- SKIPPING ---

;;; Exercise 43

; An AnimationState is a Number.
; interpretation: the number of clock ticks since the animation started

; Wish list:
;   * clock tick handler fxn
;   * render fxn
;   * end? fxn

(define VELOCITY 3)

; clock tick handler fxn
; AnimationState -> AnimationState
; speeds up or slows down time by applying a fxn to every clock tick
; given: 50, expect: 51
; given: 100, expect: 101
(define (tock-2 as)
  (add1 as))

; render fxn
; AnimationState -> Image
; places the car on the BACKGROUND following a sine wave,
;   according to the given animation state
(define (render-2 as)
  (place-image CAR-2
               (* as VELOCITY)                  ; distance = as * VELOCITY
               (+ Y-CAR (* 10 (sin (/ as 10)))) ; y = f(distance)
               BACKGROUND-2))

; end? fxn
; AnimationState -> Boolean
; stops the program when the car has left the background --
; which is when CAR-2 distance >= BACKGROUND-2 witdth + half the car length
(check-expect (car-gone?-2 0) #false)
(check-expect (car-gone?-2 (+ 500 (/ (image-width CAR-2) 2))) #true)
(define (car-gone?-2 as)
  (>= (* as VELOCITY)
      (+ 500 (/ (image-width CAR-2) 2))
      ))

(define (main-3 as)
  (big-bang as
    [on-tick tock-2]
    [to-draw render-2]
    [stop-when car-gone?-2]))


; Now we're going to add some mouse functionality. If the mouse is clicked
; anywhere on the canvas, the car is placed at at the x-coordinate of that
; click.

; This is just a modification of the original problem. Here's what we need to
; consider:
;
; 1. There are no new properties, so we don't have to add any new constants.
; 2. The program is still concerned with just one property that changes over
;    time, viz. the x-coordinate of the car. So, the data representation we
;    have in place will do. No need to change the data model.
; 3. The revised problem calls for a mouse-event handler, but it doesn't
;    give up the clock-based movement of the car. So, we need to add a
;    mouse event handler to our fxn wishlist:
;
;    ; WorldState Number Number String -> WorldState
;    ; place the car at x-mouse, if the given `me` is "button-down"
;    (define (hyperspace x-position-of-car x-mouse y-mouse me)
;      x-position-of-car)
;
; 4. Lastly, we need to modify `main` to take care of the mouse events. This
;    only requires the addition of an `on-mouse` clause that defers to the
;    new entry on our wish list:
;
;    (define (main ws)
;      (big-bang ws
;        [on-tick tock]
;        [on-mouse hyper]
;        [to-draw render]))

; For the mouse event handler fxn, we have the signature, purpose, and
; function header. Now we need to develop some functional examples:
;
; WorldState Number Number String -> WorldState
; place the car at x-mouse, if the given `me` is "button-down"
; given: 21 10 20 "enter", want: 21
; given: 42 10 20 "button-down", want: 10
; given: 42 10 20 "move", want: 42
(check-expect (hyperspace 21 10 20 "enter") 21)
(check-expect (hyperspace 42 10 20 "button-down") 10)
(check-expect (hyperspace 42 10 20 "move") 42)
; (define (hyperspace x-position-of-car x-mouse y-mouse me)
;   x-position-of-car) ; this isn't good enough... we need conditionals
(define (hyperspace x-position-of-car x-mouse y-mouse me)
  (cond
    [(string=? me "button-down") x-mouse]
    [else x-position-of-car]))

(define (main-4 ws)
  (big-bang ws
    [on-tick tock]
    [on-mouse hyperspace]
    [to-draw render]))




