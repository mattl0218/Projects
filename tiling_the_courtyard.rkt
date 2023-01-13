#lang racket

#|-------------------------------------------------------------------------------
 | Name: Matthew Luzzi
 | Pledge: I pledge my honor that I have abided by the Stevens Honor System
 |-------------------------------------------------------------------------------|#


#| Tiles the entire courtyard! Takes in an empty courtyard of size s with only one tile occupied at row r and column c and
 |  5 numbers to fill the courtyard with:
      - 0s for the empty courtyard
      - 1 for the blank space
      - 2 3 and 4 for the alternating numbers (colors)

 | The smallest size courtyard that can be tiled is a 4 by 4
 | The largest size courtyard that can be tiled within 10 seconds is 128 by 128 |#
 (define (tile-courtyard s r c)
   (rec-fill (rec-center (place-center (modify-courtyard (build-courtyard s 0) r c 1) 2) 2) 3 4))

 #| Test Cases:

 4 by 4 courtyard with blank space at row 0 and column 0
  | (tile-courtyard 4 0 0)

 8 by 8 courtyard with blank space at row 7 and column 3
  | (tile-courtyard 8 7 3)

 16 by 16 courtyard with blank space at row 3 and column 5
  | (tile-courtyard 16 3 5)

 32 by 32 courtyard with blank space at row 9 and column 22
  | (tile-courtyard 32 9 22)

 64 by 64 courtyard with blank space at row 49 and columnn 60
  | (tile-courtyard 64 49 60)

 128 by 128 courtyard with blank space at row 83 and column 79
  | (tile-courtyard 128 83 79)
  |#


#| Helper functions: |#

#| Builds a 2^4 by 2^4 empty courtyard |#
(define (empty-courtyard-16-16) (build-courtyard 16 0))

#| Builds the courtyard (2d array) of size s |#
(define (build-courtyard s n)
  (define (b-rows r)
    (if (equal? r 0) '() (cons n (b-rows (- r 1))) ))
  (define (b-cols c)
    (if (equal? c 0) '() (append (list(b-rows s)) (b-cols (- c 1))) ))
  (b-cols s))

#| filled? finds if there is at least one filled in space on the courtyard going from left to right and top to bottom
 | filled?-r is a helpfer for filler? that determines whether each row is filled with at least one space |#
(define (filled? C)
  (define (filled?-r L)
    (cond [(equal? L '()) #f] [(not (equal? (car L) 0)) #t] [else (filled?-r (cdr L))]))
  (cond [(equal? C '()) #f] [(equal? (filled?-r (car C)) #t) #t] [else (filled? (cdr C))]))

#| Reverses the row R (or courtyard R) |#
(define (reverse-row R)
  (define (helper R N)
    (if (equal? R '()) N (helper (cdr R) (cons (car R) N)) ))
  (helper R '()))

#| Modifies row R at index i (helper for modifying the courtyard at a single tile) |#
(define (modify-row R i val)
  (define (helper R N i v)
    (cond [(equal? R '()) N]
        [(equal? i 0) (helper (cdr R) (cons v N) (- i 1) v)]
        [else (helper (cdr R) (cons (car R) N) (- i 1) v)] ))
  (reverse-row (helper R '() i val)))

#| Modifies courtyard at row r and col c (but it actually creates a new one N with the same courtyard values but with a new index |#
(define (modify-courtyard C r c val)
  (define (helper C N nr c v)
    (cond [(equal? C '()) N]
          [(= nr 0) (helper (cdr C) (append (list (modify-row (car C) c v)) N) (- nr 1) c v)]          
          [else (helper (cdr C) (append (list (car C)) N) (- nr 1) c v)]))
  (reverse-row (helper C '() r c val)))

#| Helpers for quadrants function: |#

#| Helpers to divide each row and column into 2 (this will split the courtyard horizontally) |#
(define (split-row R)
  (define (helper R N)
    (if (equal? (length R) (length N)) (append (list (reverse-row N)) (list R)) (helper (cdr R) (cons (car R) N))))
  (helper R '()))

(define (split-col C)
  (define (helper C N)
    (if (equal? (length C) (length N)) (append (list (reverse-row N)) (list C)) (helper (cdr C) (append (list (car C)) N)) ))
  (helper C '()))

#| Helpers for the quadrants function to get the front (left side) and back (right side) of the courtyard |#
(define (get-front C)
  (define (helper C N)
    (if (equal? C '()) N (helper (cdr C) (append (list (car (split-row (car C)))) N))))
  (reverse-row (helper C '())))

(define (get-back C)
  (define (helper C N)
    (if (equal? C '()) N (helper (cdr C) (append (list (cadr (split-row (car C)))) N))))
  (reverse-row (helper C '())))

#| Divides the courtyard into 4 quadrants (q2 q3 q1 q4) |#
(define (quadrants C)
  (if (equal? (length (car C)) 1) (append (car C) (caddr C) (cadr C) (cadddr C)) (append (split-col (get-front C)) (split-col (get-back C)))))

#| Gets quadrants individually for quadrants 1-4 |#
(define (q1 Q) (caddr Q))
(define (q2 Q) (car Q))
(define (q3 Q) (cadr Q))
(define (q4 Q) (cadddr Q))

#| Helpers for putting the quadrants back together into a courtyard: |#

#| Gets the top and bottom individually (puts the first and second quadrant together and the third and fourth together)
    so that the four quadrants can be combined back into a courtyard |#
(define (get-top-to-c Q1 Q2)
  (define (helper Q1 Q2 N)
    (if (equal? Q1 '()) N (helper (cdr Q1) (cdr Q2) (append (reverse-row (car Q1)) (reverse-row (car Q2)) N) ) ))
  (reverse-row (helper Q1 Q2 '()) ))

(define (get-bot-to-c Q3 Q4)
  (define (helper Q3 Q4 N)
    (if (equal? Q3 '()) N (helper (cdr Q3) (cdr Q4) (append (reverse-row (car Q4)) (reverse-row (car Q3)) N) ) ))
  (reverse-row (helper Q3 Q4 '()) ))

#| Splits a list evenly vertically (helper for q-to-c) |#
(define (split-even L)
  (define (helper C rt N r)
    (cond [(equal? C '()) N] [(equal? rt 0) (helper C (sqrt (length L)) (append (list r) N) '())] [else (helper (cdr C) (- rt 1) N (cons (car C) r))]))
  (append (list (reverse-row (get-first L))) (helper (reverse-row L) (sqrt (length L)) '() '())))

#| Helper for split-even: Gets the first half (left side) of the quadrants (in the wrong order and is fixed with reverse-row) |#
(define (get-first L)
  (define (helper L rt N)
    (if (equal? rt 0) N (helper (cdr L) (- rt 1) (cons (car L) N))))
  (helper L (sqrt (length L)) '()))


#| Combines the 4 quadrants back into one courtyard |#
(define (q-to-c Q)
  (split-even (append (get-top-to-c (q1 Q) (q2 Q)) (get-bot-to-c (q3 Q) (q4 Q)))))

#| Places tromino on center of courtyard C with number n (excluding a quadrant with a space already filled)
   Smallest size: 2 by 2 |#
 (define (place-center C n)
     (cond [(filled? (q2 (quadrants C))) (modify-courtyard (modify-courtyard (modify-courtyard C (- (/ (length C) 2) 1) (/ (length C) 2) n)
                                                                   (/ (length C) 2) (- (/ (length C) 2) 1) n)
                                                 (/ (length C) 2) (/ (length C) 2) n) ]
           [(filled? (q1 (quadrants C))) (modify-courtyard (modify-courtyard (modify-courtyard C (- (/ (length C) 2) 1) (- (/ (length C) 2) 1) n)
                                                                   (/ (length C) 2) (- (/ (length C) 2) 1) n)
                                                 (/ (length C) 2) (/ (length C) 2) n) ]
           [(filled? (q3 (quadrants C))) (modify-courtyard (modify-courtyard (modify-courtyard C (- (/ (length C) 2) 1) (- (/ (length C) 2) 1) n)
                                                                   (- (/ (length C) 2) 1) (/ (length C) 2) n)
                                                 (/ (length C) 2) (/ (length C) 2) n) ]
           [else (modify-courtyard (modify-courtyard (modify-courtyard C (- (/ (length C) 2) 1) (- (/ (length C) 2) 1) n)
                                                                   (- (/ (length C) 2) 1) (/ (length C) 2) n)
                                                 (/ (length C) 2) (- (/ (length C) 2) 1) n) ]))

#| Recursively places all the centers down until base case of 4 by 4 is filled in |#
(define (rec-center C n)
   (if (= (length C) 2) C
         (q-to-c (append (list (rec-center (q2 (quadrants (place-center C n))) n))
                               (list (rec-center (q3 (quadrants (place-center C n))) n))
                               (list (rec-center (q1 (quadrants (place-center C n))) n))
                               (list (rec-center (q4 (quadrants (place-center C n))) n)) )) ))

#| Recursively fills every 2 by 2 in the courtyard (NOTE: make sure that each color alternates) with number n1 and number n2
   while keeping track of which coordinate it's in|# 
 (define (rec-fill C n1 n2)
   (define (helper C n1 n2 q)
     (cond [(and (= (length C) 2) (or (= q 2) (= q 4)))  (place-center C n1)]
           [(and (= (length C) 2) (or (= q 1) (= q 3)))  (place-center C n2)]
           [else (q-to-c (append (list (helper (q2 (quadrants C)) n1 n2 2))
                                 (list (helper (q3 (quadrants C)) n1 n2 3))
                                 (list (helper (q1 (quadrants C)) n1 n2 1))
                                 (list (helper (q4 (quadrants C)) n1 n2 4)) ))] ))
   (helper C n1 n2 0))