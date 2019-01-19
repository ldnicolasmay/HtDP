;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname factorial) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (factorial n)
  (if (= n 1)                      ; if base case
      1                            ; then, return 1
      (* n (factorial (- n 1)))))  ; else, return n * (factorial n-1)