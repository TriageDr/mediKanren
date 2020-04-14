#lang racket
(provide (all-defined-out))
(require "query.rkt"
          racket/engine)

(define make-directly-regulate-gene
  (lambda (regulation-predicates)
    (lambda (gene-curie)
      (displayln "\nRunning 1-hop up query with concept categories")
      (define q (query/graph
                 (
                  ;; concepts
                  (X       drug)
                  (my-gene gene-curie)
		  )
                 ;; edges
                 ((X->my-gene regulation-predicates))
                 ;; paths
                 (X X->my-gene my-gene)))
      q)))

(define directly-upregulate-gene (make-directly-regulate-gene positively-regulates))
(define directly-downregulate-gene (make-directly-regulate-gene negatively-regulates))



(define curie-to-anything
  (lambda (curie predicate*)
    ;;(printf "starting curie-to-anything with curie ~s and preds ~s\n" curie predicate*)
    (let ((val (query/graph
                ( ;; concepts
                 (X curie)
                 (T #f))
                ;; edges
                ((X->T predicate*))
                ;; paths      
                (X X->T T))))
      ;;(printf "finished curie-to-anything with curie ~s and preds ~s\n" curie predicate*)
      val)))

(define curie-to-tradenames
  (lambda (curie)
    (curie-to-anything curie '("has_tradename"))))

(define curie-to-clinical-trials
  (lambda (curie)
    (curie-to-anything curie '("clinically_tested_approved_unknown_phase"
                               "clinically_tested_terminated_phase_2"
                               "clinically_tested_terminated_phase_3"
                               "clinically_tested_terminated_phase_2_or_phase_3"
                               "clinically_tested_withdrawn_phase_3"
                               "clinically_tested_withdrawn_phase_2_or_phase_3"
                               "clinically_tested_withdrawn_phase_2"
                               "clinically_tested_suspended_phase_2"
                               "clinically_tested_suspended_phase_3"
                               "clinically_tested_suspended_phase_2_or_phase_3"))))

(define curie-to-indicated_for
  (lambda (curie)
    (curie-to-anything curie '("indicated_for"))))

(define curie-to-contraindicated_for
  (lambda (curie)
    (curie-to-anything curie '("contraindicated_for"))))


(define pubmed-URLs-from-composite-edge
  (lambda (composite-edge)
    ;;(printf "starting pubmed-URLs-from-composite-edge\n")
    (define concrete-edges (list-ref composite-edge 2))
    ;;(printf "concrete-edges length = ~s\n" (length concrete-edges))
    (let ((url-ls (map pubmed-URLs-from-edge concrete-edges)))
      ;;(printf "url-ls = ~s\n" url-ls)
      (remove-duplicates (append* url-ls)))))


(define drug-info-for-curie
  (lambda (curie)
    ; (printf "*** starting drug-info-for-curie ~s\n" curie)
    (map
     (lambda (l)
       (match l
         [`(,name . ,q)
          ; (printf "*** calculating curie-synonyms/names list for curie ~s\n" curie)
          (let ((ls (map curie-synonyms/names (curies/query q 'T))))
            ; (printf "*** calculated curie-synonyms/names list for curie ~s\n" curie)
            ; (printf "*** ls length = ~s\n" (apply + (map length ls)))
            (cons name ls))]))
     (list 
      (cons 'tradenames (curie-to-tradenames curie))
      (cons 'clinical-trials (curie-to-clinical-trials curie))
      (cons 'indicated_for (curie-to-indicated_for curie))
      (cons 'contraindicated_for (curie-to-contraindicated_for curie))))))


(define drug-info-from-composite-edge
  (lambda (composite-edge)    
    (define curie (caar composite-edge))
    ; (printf "*** drug-info-from-composite-edge for curie = ~s\n" curie)
    (define pubmed-URLs (pubmed-URLs-from-composite-edge composite-edge))
    ; (printf "*** calculating curie-synonyms/names\n")
    (define synonyms/names (curie-synonyms/names curie))
    ; (printf "*** calculated curie-synonyms/names of length ~s\n" (length synonyms/names))
    (append
     (list (cons 'curie curie))
     (list (cons 'curie-synonyms/names synonyms/names))
     (drug-info-for-curie curie)
     (list (cons 'pubmeds pubmed-URLs)))))

(define drug-info-for-tsv-from-composite-edge
  (lambda (composite-edge)
    (match composite-edge
      (`((,composite-subject . ,composite-object) ,score ,edges)
        (define subject-info (map cdr (drug-info-for-curie composite-subject)))
        (append*
          (map (lambda (edge)
                 (define pub-info (publications-info-alist-from-edge edge))
                 (define pub-urls (pubmed-URLs-from-edge edge))
                 (match edge
                   [`(,db
                       ,edge-id
                       (,_ ,subject-curie ,subject-name (,_ . ,subject-cat) . ,_)
                       (,_ ,object-curie ,object-name (,_ . ,object-cat) . ,_)
                       (,_ . ,predicate) . ,_)
                     (define (entry pubmed-url pub-date sentence)
                       (append
                         (list db
                               subject-curie subject-cat subject-name
                               predicate
                               object-name object-cat object-curie
                               pubmed-url pub-date sentence)
                         subject-info))
                     (cond ((pair? pub-info)
                            (map (lambda (info)
                                   (match info
                                     [`(,pubmed-url ,pub-date ,subject-score ,object-score ,sentence)
                                       (entry pubmed-url pub-date sentence)]))
                                 pub-info))
                           ((pair? pub-urls)
                            (map (lambda (url) (entry url "" "")) pub-urls))
                           (else (list (entry "" "" ""))))]))
               edges))))))


(define (make-dr-query1-up/down direction directly-up/down-regulate-gene)
  (lambda (the-gene-curie the-gene-symbol)

    ; (printf "*** getting directly ~s for gene CURIE ~s\n" direction the-gene-curie)
    
    (define directly-up/down (directly-up/down-regulate-gene the-gene-curie))
    ;; returns the set of all query results (for X, for gene, for edges X->my-gene, etc.)

    ;; unused
    ;; (define directly-up/down-Xs (curies/query directly-up/down 'X))

    ; (printf "*** getting edges/X->directly-~s for gene CURIE ~s\n" direction the-gene-curie)
  
    ;; each edge corresponds to an X in Xs
    (define edges/X->directly-up/down (edges/ranked (ranked-paths directly-up/down) 0 0))

    (printf "*** getting directly-~s-drug-info for gene CURIE ~s\n" direction the-gene-curie)
  
    (define directly-up/down-drug-info (map drug-info-from-composite-edge edges/X->directly-up/down))

    (printf "*** getting directly-~s-drug-info-for-tsv for gene CURIE ~s\n" direction the-gene-curie)
  
    (define directly-up/down-drug-info-for-tsv (map drug-info-for-tsv-from-composite-edge edges/X->directly-up/down))

    (printf "*** finished getting directly-~s-drug-info-for-tsv for gene CURIE ~s\n" direction the-gene-curie)

    directly-up/down-drug-info-for-tsv
        
    ))

(define dr-query1-up (make-dr-query1-up/down 'up directly-upregulate-gene))

(define dr-query1-down (make-dr-query1-up/down 'down directly-downregulate-gene))


(define (dr-query1 the-gene-curie)

  (printf "*** dr-query1 called for gene CURIE ~s\n" the-gene-curie)

  (printf "*** getting gene symbol for gene CURIE ~s\n" the-gene-curie)
  
  (define the-gene-symbol (concept->name (car (find-concepts #t (list the-gene-curie)))))
  
  (printf "*** found gene symbol ~s for gene CURIE ~s\n" the-gene-symbol the-gene-curie)

  (printf "*** finding up-regulators for gene CURIE ~s\n" the-gene-curie)

  (define up-query-results (dr-query1-up the-gene-curie the-gene-symbol))
    
  ; (printf "*** finding down-regulators for gene CURIE ~s\n" the-gene-curie)

  (define down-query-results (dr-query1-down the-gene-curie the-gene-symbol))
  
  (define my-query-result (append up-query-results down-query-results))
  
  (define output-file-name (format "~a-budging.tsv" the-gene-symbol))
  
  ; (printf "*** writing results for gene CURIE ~s to file ~s\n" the-gene-curie output-file-name)
  
  (with-output-to-file output-file-name
    (tsv-for the-gene-curie the-gene-symbol my-query-result)
    #:exists 'replace)

  ; (printf "*** finished processing gene CURIE ~s\n" the-gene-curie)

  'finished
  )

(define (dr-query gene-curies)
  (for-each
    (lambda (curie)
      ;; 10 minute timeout per curie
      (define timeout-ms (* 10 60 1000))
      ; (printf "@@@ dr-query creating engine for curie ~s\n" curie)
      (define eng (engine (lambda (p)
                            (dr-query1 curie))))
      ; (printf "@@@ dr-query running engine for ~s ms for curie ~s\n" timeout-ms curie)
      (engine-run timeout-ms eng)
      ; (printf "@@@ dr-query engine for curie ~s finished\n" curie)
      ; (if (engine-result eng)
      ;   (printf "@@@ dr-query engine for curie ~s ran to completion\n" curie)
      ;   (printf "@@@ dr-query engine for curie ~s timed out!!\n" curie))
      ;(printf "@@@ dr-query killing engine for curie ~s\n" curie)
      (engine-kill eng)
      ;(printf "@@@ dr-query killed engine for curie ~s\n" curie)
      )
    gene-curies))

(define (tsv-for gene-curie gene-symbol infos)
  (lambda ()
    (printf "~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\n"
            "gene CURIE"
            "gene symbol"
            "db"
            "subject CURIE" "subject category" "subject"
            "predicate"
            "object" "object category" "object CURIE"
            "pub URL" "pub date" "pub sentence"
            "tradenames" "clinical trials" "indicated for" "contraindicated for")
    (for-each (lambda (xs)
                (for-each (lambda (x)
                            (apply printf "~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\t~a\n"
                                   gene-curie gene-symbol x))
                          xs))
              infos)))




; (define the-gene-curies (list "HGNC:11390" "HGNC:13557" "HGNC:2537"))
; (define the-gene-curies (list "HGNC:29079" "HGNC:11390" "HGNC:13557" "HGNC:2537"))

; kdm1a
; (define the-gene-curies (list "HGNC:29079"))

; ACE2
;(define the-gene-curies (list "HGNC:13557"))

; CTSL
;(define the-gene-curies (list "HGNC:2537"))


#|
;; aurkb
(define aurkb-directly-up (directly-upregulate-gene "HGNC:11390"))
;; returns the set of all query results (for X, for gene, for edges X->my-gene, etc.)

(define aurkb-directly-up-Xs (curies/query aurkb-directly-up 'X))

;; each edge corresponds to an X in aurkb-Xs
(define edges/X->aurkb-directly-up (edges/ranked (ranked-paths aurkb-directly-up) 0 0))

(define aurkb-directly-up-drug-info (map drug-info-from-composite-edge edges/X->aurkb-directly-up))
|#

#|
(printf "starting downregulation...\n")

(define kdm1a-directly-down (directly-downregulate-gene "HGNC:29079"))
;; returns the set of all query results (for X, for gene, for edges X->my-gene, etc.)

(define kdm1a-directly-down-Xs (curies/query kdm1a-directly-down 'X))

;; each edge corresponds to an X in kdm1a-Xs
(define edges/X->kdm1a-directly-down (edges/ranked (ranked-paths kdm1a-directly-down) 0 0))

;; 
(define kdm1a-directly-down-drug-info (map drug-info-from-composite-edge edges/X->kdm1a-directly-down))
|#



;;; 2-hop

;; ACE2   HGNC:13557

;; CTSL   HGNC:2537

;; include semmed sentences, when possible  (date would be nice)

