;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname fib) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; recursive fibonacci -- very inefficient for larger n

(define (fib n)
  (cond
    [(= n 1) 1]
    [(= n 0) 1]
    [else (+ (fib (- n 1)) (fib (- n 2)))]
    ))
