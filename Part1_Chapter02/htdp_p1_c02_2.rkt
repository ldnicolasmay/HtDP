;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname htdp_p1_c02_2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; 2 Functions and Programs

(require 2htdp/image)    ; teachpack
(require 2htdp/batch-io) ; teachpack
(require 2htdp/universe) ; teachpack


;; 2.2 Computing

(define (ff a) (* 10 a))
(ff (+ 1 1))

; Curiosity... `apply` and `map`
; Requires ASL... not BSL
;(define (ff_l lst)
;  (apply * lst))
;(define (ff_l_2 lst)
;  lst)
;(define (ff_l_3 lst)
;  (map ff lst))


;;; Exercise 21
(ff (ff 1))
(+ (ff 1) (ff 1))


;;; Exercise 22
(define (distance-to-origin x y)
  (sqrt (+ (sqr x) (sqr y))))
(distance-to-origin 3 4)


;;; Exercise 23
(define (string-first s)
  (substring s 0 1))
(string-first "hello world")


;;; Exercise 24
(define (==> x y)
  (or (not x) y))
(==> #true #false)


;;; Exercise 25
(define (image-classify img)
  (cond
    [(>= (image-height img) (image-width img)) "tall"]
    [(=  (image-height img) (image-width img)) "square"]
    [(<= (image-height img) (image-width img)) "wide"]))
; the above isn't quite right b/c
;   (>= ...) should be (> ...) and
;   (<= ...) should be (< ...)
(image-classify (square 50 "solid" "red")) ; returns "tall", which is wrong


;;; Exercise 26
(define (string-insert s i)
  (string-append (substring s 0 i)
                 "_"
                 (substring s i)))
(string-insert "helloworld" 6)








