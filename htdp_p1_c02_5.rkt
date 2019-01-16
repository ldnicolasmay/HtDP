;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname htdp_p1_c02_5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; 2.5 Programs

(require 2htdp/batch-io)

(define (C f)
  (* 5/9 (- f 32)))

(define (convert in out)
  (write-file out
              (string-append
               (number->string
                (C
                 (string->number
                  (read-file in))))
               "\n")))
(convert "sample.dat" 'stdout)
(convert "sample.dat" "sample_out.dat")
(read-file "sample_out.dat")