;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname htdp_p1_c04_4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 4 Intervals, Enumerations, and Itemizations


(require 2htdp/universe)
(require 2htdp/image)

;; 4.4 Intervals


; Sample Problem
; Design a program that simulates the descent of a UFO.

; A WorldState is a Number.
; interpretation: number of pixels between the top and the UFO

(define WIDTH 300)
(define HEIGHT 100)
(define CLOSE (/ HEIGHT 3))
(define MTSCN (empty-scene WIDTH HEIGHT))
(define UFO (overlay/align "middle" "bottom"
                           (circle 10 "solid" "green")
                           (ellipse 40 12.5 "solid" "green")))

; WorldState -> WorldState
(define (main y0)
  (big-bang y0
    [on-tick nxt]
    [to-draw render/status]))

; WorldState -> WorldState
; computes next location of UFO
(check-expect (nxt 11) 14)
(define (nxt y)
  (+ y 3))

; WorldState -> Image
; places UFO at given height into the center of MTSCN
(check-expect (render 11) (place-image UFO (/ WIDTH 2) 11 MTSCN))
(define (render y)
  (place-image UFO (/ WIDTH 2) y MTSCN))

; WorldState -> Image
; add a status line to the scene created by `render`
(check-expect (render/status 0)
              (place-image (text "descending" 11 "green") 35 10 (render 0)))
(check-expect (render/status 35)
              (place-image (text "closing in" 11 "orange") 35 10 (render 35)))
(check-expect (render/status 100)
              (place-image (text "landed!" 11 "red") 35 10 (render 100)))
(define (render/status y)
  (place-image
   (cond 
     [(<= 0 y CLOSE)     (text "descending" 11 "green" )]
     [(< CLOSE y HEIGHT) (text "closing in" 11 "orange")]
     [(<= HEIGHT y)      (text "landed!"    11 "red"   )])
   35 10
   (render y)))

; WorldState -> Boolean
; stops the program when the WordlState reaches the MTSCN HEIGHT
; (check-expect (end? 0) #false)
; (check-expect (end? 100) #true)
; (define (end? y)
;   (= y HEIGHT))


; An interval is a description of a class of numbers via boundaries. The
; simplest interval has two boundaries: left and right. If the left boundary
; is included in the interval, we say it's "closed on the left" (and the same
; with the right). If a boundary does NOT include the boundary, we say it's
; "open".

; [3, 5] is close on both sides so includes both 3 and 5
; (3, 5] is left-open and right-closed, so it only includes 5
; [3, 5) is left-closed and right-open, so it only includes 3
; (3, 5) is left-open and right-open, so excludes both 3 and 5

;;; Exercise 52
; Which integers are contained in the four intervals above?
; [3, 5] -- 3, 4, 5
; (3, 5] -- 4, 5
; [3, 5) -- 3, 4
; (3, 5) -- 4

; The interval concept helps us formulate a data definition that captures the
; revised problem statement better than the "numbers"-based definition:

; A WorldState falls into one of three intervals:
; - between 0 and CLOSE
; - between CLOSE and HEIGHT
; - below HEIGHT

; Visualizing the data definition helps with the design in two ways:
;   1. It immediately suggests how to pick examples. We want the function to
;      work within the intervals and at the ends of the intervals.
;   2. The visualization tells us that we need to formulate a condition that
;      determines whether or not some "point" is within one of these intervals.


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
