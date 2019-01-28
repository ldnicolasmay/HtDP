;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname htdp_p1_c04_7) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 4 Intervals, Enumerations, and Itemizations


(require 2htdp/universe)
(require 2htdp/image)

;; 4.7 Finite State Worlds

; Finite State Machine = FSM

; With the design knowledge in this chapter, you can develop a complete
; simulation of American traffic lights.


;;; Exercise 59

; -- Data Definition --

; A TrafficLight is one of the following Strings:
; - "red"
; - "green"
; - "yellow"
; interpretation: the three strings represent the three possible states that
;                 a traffic light may assume

; -- Constants --

(define BACKGROUND-X 90)
(define BACKGROUND-Y 30)
(define BACKGROUND (empty-scene BACKGROUND-X BACKGROUND-Y "gray"))
(define CIRCLE-RADIUS (- (/ BACKGROUND-Y 2) 2.5))
(define RED-ON (circle CIRCLE-RADIUS "solid" "red"))
(define RED-OFF (circle CIRCLE-RADIUS "outline" "red"))
(define YLW-ON (circle CIRCLE-RADIUS "solid" "yellow"))
(define YLW-OFF (circle CIRCLE-RADIUS "outline" "yellow"))
(define GRN-ON (circle CIRCLE-RADIUS "solid" "green"))
(define GRN-OFF (circle CIRCLE-RADIUS "outline" "green"))
(define LIGHTS-OFF-SCN
  (place-image RED-OFF
               15 15
               (place-image YLW-OFF
                            45 15
                            (place-image GRN-OFF
                                         75 15
                                         BACKGROUND))))

; -- Fxn Wish List --

; TrafficLight -> TrafficLight
; yields the next state, given current state cs
(check-expect (tl-next "red") "green")
(check-expect (tl-next "green") "yellow")
(check-expect (tl-next "yellow") "red")
(define (tl-next cs)
  (cond
    [(string=? cs "red") "green"]
    [(string=? cs "green") "yellow"]
    [(string=? cs "yellow") "red"]))

; TrafficLight -> Image
; renders the current state cs as an image
(check-expect (tl-render "red")    (place-image RED-ON 15 15 LIGHTS-OFF-SCN))
(check-expect (tl-render "yellow") (place-image YLW-ON 45 15 LIGHTS-OFF-SCN))
(check-expect (tl-render "green")  (place-image GRN-ON 75 15 LIGHTS-OFF-SCN))
(define (tl-render cs)
  (cond
    [(string=? cs "red")    (tl-turn-on RED-ON 15)]
    [(string=? cs "yellow") (tl-turn-on YLW-ON 45)]
    [(string=? cs "green")  (tl-turn-on GRN-ON 75)]))

; Image Number -> Image
; helper fxn to render ON light on traffic lights-off scene
(check-expect (tl-turn-on RED-ON 15) (place-image RED-ON 15 15 LIGHTS-OFF-SCN))
(check-expect (tl-turn-on YLW-ON 45) (place-image YLW-ON 45 15 LIGHTS-OFF-SCN))
(check-expect (tl-turn-on GRN-ON 75) (place-image GRN-ON 75 15 LIGHTS-OFF-SCN))
(define (tl-turn-on on-light light-x)
  (place-image on-light light-x 15 LIGHTS-OFF-SCN))

; -- Main Fxn --
(define (traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render]
    [on-tick tl-next 1]))


;;; Exercise 60
; An alternative data representation for a traffic light program may use
; numbers instead of strings:

; An N-Traffic-Light is one of:
; - 0 ; interpretation: the traffic light shows red
; - 1 ; interpretation: the traffic light shows green
; - 2 ; interpretation: the traffic light shows yellow

; This refomulation greatly simplifies `tl-next`:

; N-TrafficLight -> N-TrafficLight
; yields the next state, given current state cs
(check-expect (n-tl-next 0) 1)
(check-expect (n-tl-next 1) 2)
(check-expect (n-tl-next 2) 0)
(check-expect (n-tl-next 3) 1)
(check-expect (n-tl-next 4) 2)
(check-expect (n-tl-next 5) 0)
(define (n-tl-next cs)
  (modulo (+ cs 1) 3))


;;; Exercise 61
; Here's a symbolic constant approach to the TrafficLight problem:

; -- Constants --
(define RED 0)
(define GREEN 1)
(define YELLOW 2)

; -- Data Definition -- 
; An S-TrafficLight is one of      ... ... ... ("S-" for "symbolic")
; - RED
; - GREEN
; - YELLOW



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
