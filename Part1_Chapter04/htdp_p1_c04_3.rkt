;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname htdp_p1_c04_3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 4 Intervals, Enumerations, and Itemizations


(require 2htdp/universe)
(require 2htdp/image)

;; 4.3 Enumerations

; Only six strings are used to notify programs of mouse events:
;
; A MouseEvt is one of these Strings:
; - "button-down"
; - "button-up"
; - "drag"
; - "move"
; - "enter"
; - "leave"
;
; The data definition for representing mouse events as strings is quite
; different from the data definitions we've seen so far. Here, the data
; definition is called an "enumeration" because it is a data representation
; in which every possibility is listed. Enumerations are common.

; Here's another enumeration:
;
; A TrafficLight is one of the following Strings:
; - "red"
; - "green"
; - "yellow"
; interpretation: the three strings represent the three possible states
; that a traffic light may assume
;
; This is a simplistic representation of the states that a traffic light can
; take on ("simplistic" because 'off', 'flashing yellow' and 'flashing red'
; aren't included.

; Programming with enumerations is most straightforward. When a function's
; input is a class of data whose description spells out its elements on a
; case-by-case basis, the function should distinguish just those cases and
; compute the result on a per-case basis. Here's an example with the traffic
; light enumeration.
;
; TrafficLight -> TrafficLight
; yields the next state given current state s
(check-expect (traffic-light-next "red") "green")
(define (traffic-light-next s)
  (cond
    [(string=? s "red")    "green" ]
    [(string=? s "green")  "yellow"]
    [(string=? s "yellow") "red"   ]))


;;; Exercise 50
(check-expect (traffic-light-next "green") "yellow")
(check-expect (traffic-light-next "yellow") "red")


;;; Exercise 51
; Design a big-bang program that simulates a traffic light for a given
; duration. The program renders the state of a traffic light as a solid
; circle of the appropriate color, and it changes state on every clock tick.
; What is the most appropriate initial state? Ask your engineering friends.

; --- First attempt where TrafficLight is a number ---

; -- I. Constants --
(define BACKGROUND-SIDE 100)
(define BACKGROUND-SIDE-HALF (/ BACKGROUND-SIDE 2))
(define BACKGROUND (empty-scene BACKGROUND-SIDE BACKGROUND-SIDE))
(define CIRCLE-RADIUS (- (/ BACKGROUND-SIDE 2) 10))
(define RED-CIRCLE (circle CIRCLE-RADIUS "solid" "red"))
(define YELLOW-CIRCLE (circle CIRCLE-RADIUS "solid" "yellow"))
(define GREEN-CIRCLE (circle CIRCLE-RADIUS "solid" "green"))


; -- II. Data Definitions --

; A TrafficLight is a Number:
; - 0-49 for "red"
; - 50-89 for "green"
; - 90-99 for "yellow"
; interpretation: the three numbers represent the three possible states that
;                 a traffic light may assume


; -- III. Fxn Wish List --

; 1. render fxn
; TrafficLight -> Image
; places traffic light colored circle on the background
; given: 0, expect: (place-image RED-CIRCLE
;                                BACKGROUND-SIDE-HALF
;                                BACKGROUND-SIDE-HALF
;                                BACKGROUND)
(check-expect (render 0) (place-image RED-CIRCLE
                                      BACKGROUND-SIDE-HALF
                                      BACKGROUND-SIDE-HALF
                                      BACKGROUND))
(check-expect (render 150) (place-image GREEN-CIRCLE
                                        BACKGROUND-SIDE-HALF
                                        BACKGROUND-SIDE-HALF
                                        BACKGROUND))
(check-expect (render 290) (place-image YELLOW-CIRCLE
                                        BACKGROUND-SIDE-HALF
                                        BACKGROUND-SIDE-HALF
                                        BACKGROUND))
(define (render ws)
  (place-image (cond [(and (<= 0 (modulo ws 100))                  ; red
                           (< (modulo ws 100) 50)) RED-CIRCLE   ]
                     [(and (<= 50 (modulo ws 100))                 ; green
                           (< (modulo ws 100) 90)) GREEN-CIRCLE ]
                     [else                         YELLOW-CIRCLE]) ; yellow
               BACKGROUND-SIDE-HALF
               BACKGROUND-SIDE-HALF
               BACKGROUND))


; 2. clock tick handler fxn
; TrafficLight -> TrafficLight
; changes the traffic light color based on the number of clock ticks
; given: 0, expect: 1
; given: 1, expect: 2
(check-expect (tock 0) 1)
(check-expect (tock 1) 2)
(check-expect (tock 2) 3)
(define (tock ws)
  (add1 ws))


; -- IV. Main/Driver Fxn --
(define (main ws)
  (big-bang ws
    [to-draw render]
    [on-tick tock]))


; -- Second attempt where TrafficLight is a String --

; -- I. Constants --

; Use the same constants as above.

; -- II. Data Definitions --

; A TrafficLight is one of the following Strings:
; - "red"
; - "green"
; - "yellow"
; interpretation: the three strings represent the three possible states that
;                 a traffic light may assume

; -- III. Fxn Wish List --

; 1. render fxn
; TrafficLight -> Image
; places traffic light colored circle on the background
; given: "red", expect: (place-image RED-CIRCLE
;                                    BACKGROUND-SIDE-HALF
;                                    BACKGROUND-SIDE-HALF
;                                    BACKGROUND)
(check-expect (render-2 "red")
              (place-image RED-CIRCLE
                           BACKGROUND-SIDE-HALF
                           BACKGROUND-SIDE-HALF
                           BACKGROUND))
(check-expect (render-2 "green")
              (place-image GREEN-CIRCLE
                           BACKGROUND-SIDE-HALF
                           BACKGROUND-SIDE-HALF
                           BACKGROUND))
(check-expect (render-2 "yellow")
              (place-image YELLOW-CIRCLE
                           BACKGROUND-SIDE-HALF
                           BACKGROUND-SIDE-HALF
                           BACKGROUND))
(define (render-2 tl)
  (place-image (cond [(string=? tl "red"  ) RED-CIRCLE   ]
                     [(string=? tl "green") GREEN-CIRCLE ]
                     [else                  YELLOW-CIRCLE])
               BACKGROUND-SIDE-HALF
               BACKGROUND-SIDE-HALF
               BACKGROUND))

; 2. clock tick handler fxn
; TrafficLight -> TrafficLight
; changes the traffic light color with every clock tick
; given: "red", expect: "green"
; given: "green", expect: "yellow"
; given: "yellow", expect: "red"
(check-expect (tock-2 "red"   ) "green" )
(check-expect (tock-2 "green" ) "yellow")
(check-expect (tock-2 "yellow") "red"   )
(define (tock-2 tl)
  (cond
    [(string=? tl "red"  ) "green" ]
    [(string=? tl "green") "yellow"]
    [else                  "red"   ]))


; 4. main/driver fxn
(define (main-2 tl)
  (big-bang tl
    [to-draw render-2]
    [on-tick tock-2]))


; The main idea of an enumeration is that it defines a collection of data as
; a FINITE number of pieces of data. Usually the pieces of data are simply
; shown as they are (like "red" "green" "yellow" above). But other times, the
; list can be described in English without listing _every single element_.

; For example...

; A 1String is a String of length 1, including
; - "\\" (backslash),
; - " "  (space),
; - "\t" (tab),
; - "\r" (return), and
; - "\b" (backspace).
; interpretation: represents key on the keyboard

; Notice that this data definition of an enumeration (for 1Strings) doesn't
; list every single 1String (like "q", "w", "e", "r", ...). Instead it
; describes what a 1String is (String of length 1) and includes a few
; examples.

; Such a data definition is "proper" if you can describe all of its elements
; with a BSL test. In the case of 1String, you can find out whether some
; string `s` belongs to the collection/enumeration with:
; (= (string-length s) 1)

; Most keys on the keyboard are represented as 1Strings, but some are not.
; If we want to define a collection/enumeration of Key Events
; (https://docs.racket-lang.org/teachpack/2htdpuniverse.html) that include
; 1Strings, we could do this:

; A KeyEvent is one of:
; - 1String (already defined above)
; - "left"
; - "right"
; - "up"
; - ...

; With this compound data definition, we can design a key-event handler
; systematically. Here's a sketch:

; WorldState KeyEvent -> ...
; (define (handle-key-events w ke)
;   (cond
;     [(= (string-length ke) 1) ...]
;     [(string=? "left"  ke) ...]
;     [(string=? "right" ke) ...]
;     [(string=? "up"    ke) ...]
;     [(string=? "down"  ke) ...]
;     ...))

; Sometimes programs only use part of the enumeration. To illustrate the
; point, let's design a key-event handler function based on the above
; enumeration data definition.

; Sample Problem
; Design a key-event handler that moves a red dot left or right on a
; horizontal line in response to pressing the left and right arrow keys.

; A Position is a Number.
; interpretation: distance between the left margin and the ball

; Position KeyEvent -> Position
; computes the next location of the ball

(check-expect (keh-1 13 "left" ) 8 )
(check-expect (keh-1 13 "right") 18)
(check-expect (keh-1 13 "a"    ) 13)

(check-expect (keh-2 13 "left" ) 8 )
(check-expect (keh-2 13 "right") 18)
(check-expect (keh-2 13 "a"    ) 13)


; here's the fxn def.n based on the enumeration above
(define (keh-1 p k)
  (cond
    [(= (string-length k) 1) p]
    [(string=? "left"  k) (- p 5)]
    [(string=? "right" k) (+ p 5)]
    [else p]))

; but here's a simpler/better evolution of the first fxn def.n just above
(define (keh-2 p k)
  (cond
    [(string=? "left"  k) (- p 5)]
    [(string=? "right" k) (+ p 5)]
    [else p]))


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
