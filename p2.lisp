Answer 1
(defun circle-space (r)
(* 3.14 r r))


Answer 2
(defun temp-change (f)
(- (/ (* (+ f 40) 5) 9) 40))

Answer 3
(setq x '(a b c d))
(A B C D)

(defun front-or-back (l)
(if (evenp (length l))
(first l)
(first (last l))))

(setq x '(a b c d e))
(A B C D E)


Answer 4
(defun create-list (m c)
    (if (equal c 0) () (cons m (create-list m (- c 1))))
)

Answer 5
(defun item-convert (i)
(cond ( (equal (numberp i) T)
(circle-space i))
( (and (equal (numberp i) nil) (equal (listp i) nil))
(create-list i 4))
( (equal (listp i) T) (front-or-back i))
)
)
