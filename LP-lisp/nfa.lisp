					;Agazzi_Ruben_844736_LP_202001
					;Facchi_Giuseppe_845662_LP_202001

(defun ricorsiva-plus (regexp initial final)
  (list
   (nfa-regexp-comp-tot initial
			(list 'seq regexp
			      (list 'star regexp))final)))

(defun ricorsiva-star (re initial final) 
  ((lambda (initialStar finalStar)
     (list 
      (list initial 'epsilon initialStar) 
      (list finalStar 'epsilon final) 
      (list finalStar 'epsilon initialStar) 
      (list initial 'epsilon final)
      (if (atom (second re))
	  (nfa-regexp-comp-tot
	   initialStar
	   (list (second re))
	   finalStar)
	(nfa-regexp-comp-tot
	 initialStar
	 (second re)
	 finalStar))))
   (gensym "q")  (gensym "q")))

(defun ricorsiva-seq (re initial final length)
  (if (= length 2)(cond ((atom (second re))
			 ((lambda (initialSeq finalSeq)
			    (list 
			     (list initial 'epsilon initialSeq)
			     (list finalSeq 'epsilon final)
			     (nfa-regexp-comp-tot 
			      initialSeq 
			      (list (second re)) 
			      finalSeq)))
			  
			  (gensym "q") (gensym "q")))
			((consp (second re))
			 ((lambda (initialSeq finalSeq)
			    (list 
			     (list initial 'epsilon initialSeq)
			     (list finalSeq 'epsilon final)
			     (nfa-regexp-comp-tot
			      initialSeq
			      (second re)
			      finalSeq)))
			  (gensym "q") (gensym "q"))))
    
    (if (= length 3)((lambda (initialSeq1 initialSeq2 finalSeq1 finalSeq2)
		       (cond ((and (atom (second re))
				   (atom (third re)))
			      (list 
			       (list initial 'epsilon initialSeq1)
			       (list finalSeq1 'epsilon initialseq2)
			       (list finalSeq2 'epsilon final)
			       (nfa-regexp-comp-tot
				initialSeq1
				(list (second re))
				finalSeq1)
			       (nfa-regexp-comp-tot
				initialSeq2
				(list (third re))
				finalSeq2)))
			     ((and (consp (second re))
				   (atom (third re)))
			      (list 
			       (list initial 'epsilon initialSeq1)
			       (list finalSeq1 'epsilon initialseq2)
			       (list finalSeq2 'epsilon final)
			       (nfa-regexp-comp-tot
				initialSeq1
				(second re)
				finalSeq1)
			       (nfa-regexp-comp-tot
				initialSeq2
				(list (third re))
				finalSeq2)))
			     ((and (atom (second re))
				   (consp (third re)))
			      (list 
			       (list initial 'epsilon initialSeq1)
			       (list finalSeq1 'epsilon initialseq2)
			       (list finalSeq2 'epsilon final)
			       (nfa-regexp-comp-tot
				initialSeq1
				(list (second re))
				finalSeq1)
			       (nfa-regexp-comp-tot
				initialSeq2
				(third re)
				finalSeq2)))
			     ((and (consp (second re))
				   (consp (third re)))
			      (list 
			       (list initial 'epsilon initialSeq1)
			       (list finalSeq1 'epsilon initialseq2)
			       (list finalSeq2 'epsilon final)
			       (nfa-regexp-comp-tot
				initialSeq1
				(second re)
				finalSeq1)
			       (nfa-regexp-comp-tot
				initialSeq2
				(third re)
				finalSeq2)))))

		     (gensym "q") (gensym "q") (gensym "q") (gensym "q"))
      
      (if (= length 4) 
	  ((lambda (initialSeq1 initialSeq2 initialSeq3 finalSeq1 finalSeq2)
             (cond ((and (atom (second re))
			 (atom (third re)))  
		    (list
		     (list initial 'epsilon initialSeq1)
		     (list finalSeq1 'epsilon initialseq2)
		     (list finalSeq2 'epsilon initialSeq3)
		     (nfa-regexp-comp-tot
		      initialSeq1
		      (list (second re))
		      finalSeq1)
		     (nfa-regexp-comp-tot
		      initialSeq2
		      (list (third re))
		      finalSeq2)
		     (nfa-regexp-comp-tot
		      initialSeq3
		      (nthcdr 3 re)
		      final)))
                   ((and (consp (second re))
			 (atom (third re)))
		    (list 
		     (list initial 'epsilon initialSeq1)
		     (list finalSeq1 'epsilon initialseq2)
		     (list finalSeq2 'epsilon initialSeq3)
		     (nfa-regexp-comp-tot
		      initialSeq1
		      (second re)
		      finalSeq1)
		     (nfa-regexp-comp-tot
		      initialSeq2
		      (list (third re))
		      finalSeq2)
		     (nfa-regexp-comp-tot
		      initialSeq3
		      (nthcdr 3 re)
		      final)))
                   ((and (atom (second re))
			 (consp (third re))) 
		    (list 
		     (list initial 'epsilon initialSeq1)
		     (list finalSeq1 'epsilon initialseq2)
		     (list finalSeq2 'epsilon initialSeq3)
		     (nfa-regexp-comp-tot
		      initialSeq1
		      (list (second re))
		      finalSeq1)
		     (nfa-regexp-comp-tot
		      initialSeq2
		      (third re)
		      finalSeq2)
		     (nfa-regexp-comp-tot
		      initialSeq3
		      (nthcdr 3 re)
		      final)))
                   ((and (consp (second re))
			 (consp (third re)))
		    (list 
		     (list initial 'epsilon initialSeq1)
		     (list finalSeq1 'epsilon initialseq2)
		     (list finalSeq2 'epsilon initialSeq3)
		     (nfa-regexp-comp-tot
		      initialSeq1
		      (second re)
		      finalSeq1)
		     (nfa-regexp-comp-tot
		      initialSeq2
		      (third re)
		      finalSeq2)
		     (nfa-regexp-comp-tot
		      initialseq3
		      (nthcdr 3 re)
		      final)))))
	   (gensym "q")
	   (gensym "q")
	   (gensym "q")
	   (gensym "q")
	   (gensym "q"))))))

(defun nfa-regexp-comp-tot (initial re final)
  (cond 
   ((null re) (list initial 'epsilon final))
   ((atom re) (list initial re final))
   
   ((eq (car re) 'plus)
    (cond ((= (lunghezza re) 2)
           ((lambda (regexp)
              (ricorsiva-plus regexp initial final))
            (second re)))))
   ((eq (car re) 'star)
    (cond ((= (lunghezza re) 2)
           (ricorsiva-star re initial final))
          ((> (lunghezza re) 2)
           (error "Regexp non valida"))))
   ((eq (car re) 'seq) 
    (cond ((= (lunghezza re) 2)
           (ricorsiva-seq re initial final 2))
          ((= (lunghezza re) 3)
           (ricorsiva-seq re initial final 3))
          ((> (lunghezza re) 3)
           (ricorsiva-seq re initial final 4))))
   
   ((eq (car re) 'or)
    (cond ((= (lunghezza re) 2)
	   ((lambda (initialOr finalOr)
              (list 
               (list initial 'epsilon initialOr) 
               (list finalOr 'epsilon final) 
               (nfa-regexp-comp-tot initialOr (cdr re) finalOr)))
	    (gensym "q") (gensym "q")))
	  ((= (lunghezza re) 3)
	   ((lambda (initialOr1 initialOr2 finalOr1 finalOr2)
              (cond 
               ((and (atom (second re))
		     (atom (third re)))
		(list 
		 (list (list initial 'epsilon initialOr1)
		       (list initial 'epsilon initialOr2)
		       (list finalOr1 'epsilon final)
		       (list finalOr2 'epsilon final)
		       (nfa-regexp-comp-tot
			initialOr1
			(list (second re))
			finalOr1)
		       (nfa-regexp-comp-tot
			initialOr2
			(list (third re))
			finalOr2))))
               ((and (atom (second re))
		     (consp (third re)))
		(list (list initial 'epsilon initialOr1)
		      (list initial 'epsilon initialOr2)
		      (list finalOr1 'epsilon final) 
		      (list finalOr2 'epsilon final) 
		      (nfa-regexp-comp-tot
		       initialOr1
		       (list (second re))
		       finalOr1)
		      (nfa-regexp-comp-tot
		       initialOr2
		       (third re)
		       finalOr2)))
               ((and (consp (second re))
		     (atom (third re)))
		(list (list initial 'epsilon initialOr1)
		      (list initial 'epsilon initialOr2)
		      (list finalOr1 'epsilon final) 
		      (list finalOr2 'epsilon final) 
		      (nfa-regexp-comp-tot
		       initialOr1
		       (second re)
		       finalOr1)
		      (nfa-regexp-comp-tot
		       initialOr2
		       (list (third re))
		       finalOr2)))
               ((and (consp (second re))
		     (consp (third re)))
		(list (list initial 'epsilon initialOr1) 
                      (list initial 'epsilon initialOr2) 
                      (list finalOr1 'epsilon final) 
                      (list finalOr2 'epsilon final) 
                      (nfa-regexp-comp-tot
		       initialOr1
		       (second re)
		       finalOr1)
                      (nfa-regexp-comp-tot
		       initialOr2
		       (third re)
		       finalOr2)))))
	    (gensym "q") (gensym "q") (gensym "q") (gensym "q")))
          
	  ((> (lunghezza re) 3)
	   (cond 
	    ((and (atom (second re))
		  (atom (third re)))
             ((lambda (initialOr1 initialOr2 finalOr1 finalOr2 customList)
		(list (list initial 'epsilon initialOr1) 
		      (list initial 'epsilon initialOr2) 
		      (list finalOr1 'epsilon final) 
		      (list finalOr2 'epsilon final) 
		      (nfa-regexp-comp-tot
		       initialOr1
		       (list (second re))
		       finalOr1)
		      (nfa-regexp-comp-tot
		       initialOr2
		       (list (third re))
		       finalOr2)
		      (nfa-regexp-comp-tot
		       initial
		       customList
		       final)))
              (gensym "q")
              (gensym "q") 
              (gensym "q") 
              (gensym "q") 
              (append (list 'or) (nthcdr 3 re))))
	    ((and (consp (second re))
		  (atom (third re)))
             ((lambda (initialOr1 initialOr2 finalOr1 finalOr2 customList)
		(list (list initial 'epsilon initialOr1) 
		      (list initial 'epsilon initialOr2) 
		      (list finalOr1 'epsilon final) 
		      (list finalOr2 'epsilon final) 
		      (nfa-regexp-comp-tot
		       initialOr1
		       (second re)
		       finalOr1)
		      (nfa-regexp-comp-tot
		       initialOr2
		       (list (third re))
		       finalOr2)
		      (nfa-regexp-comp-tot
		       initial
		       customList
		       final)))
              (gensym "q") 
              (gensym "q") 
              (gensym "q") 
              (gensym "q") 
              (append (list 'or) (nthcdr 3 re))))
	    ((and (atom (second re))
		  (consp (third re)))
             ((lambda (initialOr1 initialOr2 finalOr1 finalOr2 customList)
		(list 
		 (list initial 'epsilon initialOr1) 
		 (list initial 'epsilon initialOr2) 
		 (list finalOr1 'epsilon final) 
		 (list finalOr2 'epsilon final) 
		 (nfa-regexp-comp-tot
		  initialOr1
		  (list (second re))
		  finalOr1)
		 (nfa-regexp-comp-tot
		  initialOr2
		  (third re)
		  finalOr2)
		 (nfa-regexp-comp-tot
		  initial
		  customList
		  final)))
              (gensym "q") 
              (gensym "q") 
              (gensym "q") 
              (gensym "q") 
              (append (list 'or) (nthcdr 3 re))))
	    ((and (consp (second re))
		  (consp (third re)))
             ((lambda (initialOr1 initialOr2 finalOr1 finalOr2 customList)
		(list 
		 (list initial 'epsilon initialOr1) 
		 (list initial 'epsilon initialOr2) 
		 (list finalOr1 'epsilon final) 
		 (list finalOr2 'epsilon final) 
		 (nfa-regexp-comp-tot
		  initialOr1
		  (second re)
		  finalOr1)
		 (nfa-regexp-comp-tot
		  initialOr2
		  (third re)
		  finalOr2)
		 (nfa-regexp-comp-tot
		  initial
		  customList
		  final)))
              (gensym "q") 
              (gensym "q") 
              (gensym "q") 
              (gensym "q") 
              (append (list 'or) (nthcdr 3 re))))))))
   
   (t (progn
        ((lambda (final1)
           (if (consp (first re)) 
               (list
                (nfa-regexp-comp-tot initial (first re) final1)
		(nfa-regexp-comp-tot final1 (cdr re) final))
             (list
              (list initial (first re) final1)
              (nfa-regexp-comp-tot final1 (cdr re) final))))
         (gensym "q"))))))

(defun lunghezza (l)
  (if (null l) 
      0
    (+ 1 (lunghezza (cdr l)))))

(defun nfa-regexp-comp (re)
  (if (is-regexp re) 
      (group (flatten (nfa-regexp-comp-tot 'iniziale re 'finale)))
    (error "regexp non valida")))


(defun flatten (structure)
  (cond ((null structure) nil)
        ((atom structure) (list structure))
        (t (mapcan #'flatten structure))))

(defun group (elements)
  (if (null elements) nil
    (append (list (list (first elements)(second elements)(third elements)))
            (group (nthcdr 3 elements)))))

(defun nfa-test (nfa re)
  (if (null nfa)(error "NFA non valido")
    (nfa-test-helper nfa (flatten re) 'iniziale)))

(defun nfa-test-helper (nfa re state)

  (if (and (eq state 'finale) (null re))t 
    (if (null state) nil 
      (if (atom state)(nfa-test-helper nfa re (get-current-deltas nfa state))
        (if (eq (second (car state)) 'epsilon) 
            (if (nfa-test-helper nfa re (third (car state))) t
              (nfa-test-helper nfa re (cdr state)))	  
          (if (null re) nil 
            (if (consp re)
                (if (eq (car re) (second (car state)))
                    (if (nfa-test-helper nfa (cdr re) (third (car state)))t
                      (nfa-test-helper nfa re (cdr state)))
                  (nfa-test-helper nfa re (cdr state))))))))))
(defun get-current-deltas (nfa state)
  
  (group ( get-current-deltas-helper nfa state)))

(defun get-current-deltas-helper (nfa state)
  (if 
      (null nfa) nil
    (if (eq (first (car nfa)) state) 
	(append (car nfa) (get-current-deltas-helper (cdr nfa) state))
      (get-current-deltas-helper (cdr nfa) state))))

(defun is-regexp (re) 
  (if (null re) t
    (if (atom re)t
      (if (eq (car re) 'seq) (is-regexp (cdr re))
	(if (eq (car re) 'or) (is-regexp (cdr re))
	  (if (eq (car re) 'star)
	      (if (= (lunghezza re) 2) (is-regexp (cdr re))
		(error "regexp non valida"))
	    (if (eq (car re) 'plus)
		(if (= (lunghezza re) 2) (is-regexp (cdr re))
		  (error "regexp non valida"))
	      (is-regexp (cdr re)))))))))
