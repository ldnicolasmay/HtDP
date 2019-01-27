;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname htdp_p1_c04_6) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Chapter 4 Intervals, Enumerations, and Itemizations


(require 2htdp/universe)
(require 2htdp/image)

;; 4.6 Designing with Itemizations


; Sample Problem
; The state of Tax Land has created a three-stage sales tax to cope with its
; budget deficit. Inexpensive items, those costing less than $1,000, are not
; taxed. Luxury items, with a price of more than $10,000, are taxed at the
; rate of eight percent (8.00% = 0.0800). Everything in between comes with a
; five percent (5.00% = 0.0500) markup.
;
; Design a function for a cash register that, given the price of an item,
; computes the sales tax.

; Keep this problem in mind as we revise the steps of the design recipe:

; 1. When the problem statement distinguishes different classes of input
;    information, you need carefully formulated data definitions.
;
;    A data definition must use distinct _clauses_ for each sub-class of
;    data or in some cases just individual pieces of data. Each clause
;    specifies a data representation for a particular sub-class of
;    information. The key is that each sub-class of data is distinct from
;    every other class, so that our function can proceed by analyzing
;    disjoint cases.
;
;    Our sample problem deals with prices and taxes, which are usually
;    positive numbers. It also clearly distinguishes three ranges:
;
;    ; A Price falls into one of three intervals:
;    ; - 0 through 999
;    ; - 1000 through 9999
;    ; - 10000 and above
;    ; interpretation: the price of an item

; 2. As far as the signature, purpose statement, and function header are
;    concerned, you proceed as before.
;
;    ; Price -> Number
;    ; computes the amount of tax charged for p (price)
;    (define (sales-tax p) 0)

; 3. For functional examples, however, it is imperative that you pick at
;    least one example from each sub-class in the data definition. Also, if
;    a sub-class is a finite range, be sure to pick examples from the
;    boundaries of the range and from its interior.
;
;    Since our sample data definition involves three distinct intervals,
;    let's pick all boundary examples and one price from inside each
;    interval and determine the amount of tax for each: 0, 537, 1000, 1282,
;    10000, and 12017
;
;    p     | tax
;    ------|--------
;        0 |   0.00
;      537 |   0.00
;     1000 |  50.00 <= problem statement is vague, but we land here
;     1282 |  64.10
;    10000 | 800.00 <= problem statement is vague, but we land here
;    12017 | 961.36
;
;    Generate some test cases.
;
;    (check-expect (sales-tax 0)     0)
;    (check-expect (sales-tax 537)   0)
;    (check-expect (sales-tax 1000)  (* 1000 0.05))
;    (check-expect (sales-tax 1282)  (* 1282 0.05))
;    (check-expect (sales-tax 10000) (* 10000 0.08))
;    (check-expect (sales-tax 12017) (* 12017 0.08))
;
; 4. The biggest novelty is the conditional template. In general...
;
;    THE TEMPLATE MIRRORS THE ORGANIZATION OF SUB-CLASSES WITH A `cond`.
;
;    This means two things:
;
;    a. First, the function's body must be a conditional expression with as
;       many clauses as there are distinct sub-classes in the data
;       definition. If the data definition mentions three distinct
;       sub-classes of input data, you need three `cond` clauses; if it has
;       seventeen sub-classes, the `cond` expression contains seventeen
;       clauses.
;    b. Second, you must formulate one condition expression per `cond`
;       clause. Each expression involves the function parameter and
;       identifies one of the sub-classes of data in the data definition.
;
;    (define (sales-tax p)
;      (cond
;        [(and (<= 0 p)    (< p 1000))  ...]
;        [(and (<= 1000 p) (< p 10000)) ...]
;        [(>= p 10000)                  ...]))
;
; 5. When you have finished the template, you are ready to define the
;    function. Given that the function body already contains a schematic
;    `cond` expression, it is natural to start from the various `cond`
;    lines. For each `cond` line, you may assume that the input parameter
;    meets the condition and so you exploit the corresponding test cases.
;    To formulate the corresponding result expression, you write down the
;    computation for this example as an expression that involves the
;    function parameter. Ignore all other possible kinds of input data when
;    you work on one line; the other `cond` clauses take care of those.
;
;    (define (sales-tax p)
;      (cond
;        [(and (<= 0 p)    (< p 1000))  0         ]
;        [(and (<= 1000 p) (< p 10000)) (* p 0.05)]
;        [(>= p 10000)                  (* p 0.08)]))
;
; 6. Finally, run the tests and ensure that they cover all `cond` clauses.

;;; Exercise 58

; Constants
(define 5-PERCENT-TAX 0.05)
(define 8-PERCENT-TAX 0.08)
(define 5-PERCENT-MIN 1000)
(define 8-PERCENT-MIN 10000)

; A Price falls into one of three intervals:
; - 0 through 999
; - 1000 through 9999
; - 10000 and above
; interpretation: the price of an item
(check-expect (sales-tax 0)     0)
(check-expect (sales-tax 537)   0)
(check-expect (sales-tax 1000)  (* 1000 5-PERCENT-TAX))
(check-expect (sales-tax 1282)  (* 1282 5-PERCENT-TAX))
(check-expect (sales-tax 10000) (* 10000 8-PERCENT-TAX))
(check-expect (sales-tax 12017) (* 12017 8-PERCENT-TAX))
(define (sales-tax p)
  (cond
    [(and (<= 0 p)             (< p 5-PERCENT-MIN)) 0                  ]
    [(and (<= 5-PERCENT-MIN p) (< p 8-PERCENT-MIN)) (* p 5-PERCENT-TAX)]
    [(>= p 8-PERCENT-MIN)                           (* p 8-PERCENT-TAX)]))



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
