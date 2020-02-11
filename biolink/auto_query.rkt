#lang racket
(provide (all-defined-out)
         (all-from-out "common.rkt" "mk-db.rkt"))
(require "common.rkt" "mk-db.rkt")
(require racket/date)
(require csv-reading)
(require csv-writing)
(require "csv.rkt"
         "repr.rkt")
(require racket/list racket/port racket/set racket/stream racket/string)
(provide set-field-separator!
         csv-records)

#|CSV INPUT-FILE WITH SPECIFIC HEADERS REQUIRED FOR AUTOMATED MK-QUERIES|#
<<<<<<< HEAD

(define input/path
  "/Users/michaelpatton/git/automated_medikanren_queries/auto_query_template.csv" )
(define input-file
  (open-input-file "/Users/michaelpatton/git/automated_medikanren_queries/auto_query_template.csv" ))
=======
(define input/path
  "/home/mjpatton/PhD/CaseReviews/test_prototype_files/01_23_2020_template_spark.csv")

(define input-file
  (open-input-file "/home/mjpatton/PhD/CaseReviews/test_prototype_files/01_23_2020_template_spark.csv"))
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4

(define header-expected
  "record_id,phenotype_or_symptom,phenotype_or_symptom_id,drug_or_medication,drug_or_medication_id,diagnosis_or_disease,diagnosis_or_disease_id,genetic_variant_symbol,genetic_variant_id")

(define automated-query-template-record-headers
  '("record_id"
    "phenotype_or_symptom"
    "phenotype_or_symptom_id"
    "drug_or_medication"
    "drug_or_medication_id"
    "diagnosis_or_disease"
    "diagnosis_or_disease_id"
    "genetic_variant_symbol"
    "genetic_variant_id" 
    ))

(define validate-header
  (lambda (expected-header input)
    (let ((header-found (read-line input 'any)))
      (when (not (equal? header-found header-expected))
        (error (format "INPUT-FILE HEADER ERROR!\nHEADER FOUND:~a\nHEADER-EXPECTED: ~a" header-found header-expected))))))

(define pmi-records
  (time (call-with-input-file
          (expand-user-path input/path)
        (lambda (in)
          (validate-header header-expected in)
          (csv->list (make-csv-reader in))))))

(define index-of-field
  (lambda (header-names field-name)
    (index-of header-names field-name)))

;; transposition 
(define make-association-ls
  (lambda (ls)
    (map (lambda (header-name index)
           (cons header-name (list-ref ls 
                                       #;(index-of-field automated-query-template-record-headers header-name)
                                       index)))
         automated-query-template-record-headers (range (length automated-query-template-record-headers)))))

(define pmi-assoc-ls
  (map make-association-ls pmi-records))

;; (apply map list pmi-assoc-ls) is transposition of list
;; need state and bucket and previous-buckets
(define lookup-field
  (lambda (row field-name)
    (cdr (assoc field-name row))))

(define group-by
  (lambda (rows field-to-group-by)    
    (define final-state 
      (foldl (lambda (row state)
               (define id (car state))
               (define current-bucket (cadr state))
               (define previous-buckets (caddr state))
               (define current-id (lookup-field row field-to-group-by))
               (cond
                 ((equal? id current-id)            
                  (list id (cons row current-bucket) previous-buckets))
                 (else
                  (list current-id (list row) (cons (reverse current-bucket) previous-buckets)))))
             (list (lookup-field (car rows) field-to-group-by) '() '()) rows))
    (reverse (cons (cadr final-state) (caddr final-state)))))

(define record-assoc-ls
  (group-by pmi-assoc-ls "record_id"))

(define extract-symbol-name-from-concept-or-edge
  (lambda (query-ls els)
    (cond
      ((null? query-ls) (set-union els))
      ((or (boolean? (car query-ls))
           (void? (car query-ls)))
       (extract-symbol-name-from-concept-or-edge
        (cdr query-ls) els))
      (else 
       (match (car query-ls)
         [`(,db ,cui ,id ,name ,category ,properties-list)
          (extract-symbol-name-from-concept-or-edge
           (cdr query-ls)
           (set-union
            (list name) els))]
         [`(,db ,edge-cui
                (,subject-cui ,subject-id ,subject-name (,_ . ,subject-category) ,subject-props-assoc)
                (,concept-cui ,concept-id ,concept-name (,_ . ,concept-category) ,concept-props-assoc)
                (,_ . ,pred)
                ,pred-props-assoc)
          (extract-symbol-name-from-concept-or-edge (cdr query-ls)
                                                    (set-union
                                                     (list subject-name) els))])))))

#|ASSOCIATION-LIST KEYS FOR KNOWLEDGE GRAPH CONCEPTS|#
(define robokop-concept-key/eq-id "equivalent_identifiers")
(define robokop-xref-key "equivalent_identifiers")
(define orange-concept-key/synonym "synonym")
(define orange-concept-key/same-as "same_as")
(define semmed-concept-key/xrefs "xrefs")
(define semmed-concept-key/id "id")
(define publication-key "publications")
(define publication-key/pmids "pmids")
(define drug-bank/key "drugbank.groups") 
(define drug-bank/withdrawn/key "withdrawn_flag")
(define drug-bank/approved/key "drugbank.approved")
(define drug-bank/therapeutic/key "therapeutic_flag")
(define drug-bank/investigational/key "drugbank.investigational")
(define umls-type-label/key "umls_type_label")
(define umls-type/key "umls_type")
(define PUBMED_URL_PREFIX "https://www.ncbi.nlm.nih.gov/pubmed/")

(define decreases-pred-str/ls
  '("negatively_regulates"
    "negatively_regulates__entity_to_entity"
    "decreases_molecular_interaction"
    "decreases_secretion_of"
    "decreases_synthesis_of"
    "decreases_transport_of"
    "decreases_uptake_of"
    "prevents"
    "treats"
    "disrupts"
    "increases_degradation_of"
    "decreases_activity_of"
    "decreases_expression_of"))

(define increases-pred-str/ls
  '("positively_regulates"
     "produces"
     "causes"
     "causes_condition"
     "causally_related_to"
     "contributes_to"
     "gene_associated_with_condition"
     "positively_regulates__entity_to_entity"
     "gene_mutations_contribute_to"
     "decreases_degradation_of"
     "increases_activity_of"
     "increases_expression_of"
     "increases_molecular_interaction"
     "increases_response_to"
     "increases_secretion_of"
     "increases_stability_of"
     "increases_synthesis_of"
     "increases_transport_of"
     "increases_uptake_of"))

(define predicate-str/ls
  '("physically_interacts_with"
    "regulates"
    "directly_interacts_with")) 

(define atom?
  (lambda (x)
    (and (not (pair? x))
         (not (list? x)))))

(define member?
  (lambda (x ls)
    (cond
      ((null? ls) #f)
      (else 
       (or (equal? x (car ls))
           (member? x (cdr ls)))))))
(define union
  (lambda (ls1 ls2)
    (cond
      ((null? ls1) ls2)
      ((member? (car ls1) ls2)
       (union (cdr ls1) ls2))
      (else
       (cons (car ls1)
             (union (cdr ls1) ls2))))))

(define intersect?
  (lambda (ls1 ls2)
    (cond
      ((null? ls1) #f)
      ((member? (car ls1) ls2) #t)
      (else
       (intersect? (cdr ls1) ls2)))))

(define intersect
  (lambda (ls1 ls2)
    (cond
      ((null? ls1) '())
      ((member? (car ls1) ls2)
       (cons (car ls1)
             (intersect (cdr ls1) ls2)))
      (else
       (intersect (cdr ls1) ls2)))))

(define get-xrefs 
  (lambda (key properties-ls)
    (cond 
      [(assoc key properties-ls)
       => (lambda (assoc-ls)
            (define x-refs (cdr assoc-ls))
            (define in (open-input-string x-refs))
            (cons (read in) '()))]
      (else
       '()))))

(define get-assoc-value
  (lambda (key assoc-ls)
    (cond
      ((assoc key assoc-ls)
       => (lambda (assoc-ls)
            (let ((assoc-key (car assoc-ls))
                  (assoc-value (cdr assoc-ls)))
              (if (equal? assoc-key key)
                  assoc-value
                  "NA"))))
      (else
       '()))))

(define prune-xrefs
  (lambda (ls els)
    (cond
      ((null? ls) els)
      ((or (void? (car ls))
           (boolean? (car ls)))
       (prune-xrefs (cdr ls) els))
      ((string-contains? (car ls) "HGNC")
       (cons (car ls)
             (prune-xrefs (cdr ls)
                          (cons
                           (string-replace (car ls) "HGNC:" "HGNC:HGNC:") els))))
      ((string-contains? (car ls) "NCBI")
       (prune-xrefs (cdr ls)
                    (cons 
                     (string-replace (car ls) "NCBIGENE:" "NCBIGene:") els)))
      (else
       (prune-xrefs (cdr ls) (cons (car ls) els)))))) 

<<<<<<< HEAD
;;removing get-assoc-value semmed to see how rtx2 behaves
;;here
#|
=======
;;here 
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
(define get-concept-xrefs
  (lambda (query-ls els)
    (cond
      ((null? query-ls)
       (remove-duplicates (flatten els)))
      ((or (boolean? (car query-ls))
           (void? (car query-ls)))
       (get-concept-xrefs (cdr query-ls) els))
      (else 
       (match (car query-ls)
              [`(,db ,cui ,id ,name ,category ,properties-list)
               (get-concept-xrefs (cdr query-ls)
<<<<<<< HEAD
                                  (cons
=======
                                  (set-union
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
                                   (list id name
                                         (get-xrefs orange-concept-key/same-as properties-list)
                                         (get-xrefs orange-concept-key/synonym properties-list)
                                         (get-xrefs semmed-concept-key/xrefs properties-list)
                                         (get-xrefs robokop-concept-key/eq-id properties-list)
                                         (get-assoc-value semmed-concept-key/id properties-list)) els))])))))
<<<<<<< HEAD
|#
;; rtx2 has a [] in the synonym . value part of the assoc-list
;; using get-assoc on synonym to get full list 
(define get-concept-xrefs
  (lambda (query-ls els)
    (cond
      ((null? query-ls)
       (remove-duplicates (flatten els)))
      ((or (boolean? (car query-ls))
           (void? (car query-ls)))
       (get-concept-xrefs (cdr query-ls) els))
      (else 
       (match (car query-ls)
              [`(,db ,cui ,id ,name ,category ,properties-list)
               (get-concept-xrefs (cdr query-ls)
                                  (cons
                                   (list id name
                                         (get-xrefs orange-concept-key/same-as properties-list)
                                         (get-assoc-value orange-concept-key/synonym properties-list)
                                         (get-xrefs semmed-concept-key/xrefs properties-list)
                                         (get-xrefs robokop-concept-key/eq-id properties-list)
                                         (get-assoc-value semmed-concept-key/id properties-list)) els))])))))

;; create function to split out [] string ids from rtx2

=======
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4

(define get-rxnorm
  (lambda (ls els)
    (cond
      ((null? ls) (set-union els))
      ((or (boolean? (car ls))
           (void? (car ls)))
       (get-rxnorm (cdr ls)
                   (cons "NA" els)))
      ((atom? (car ls))
       (cond
         ((regexp-match #rx"[Rr][Xx][Nn][Oo][Rr][Mm]:" (car ls))
          (get-rxnorm (cdr ls)
                      (set-union
                       (cons (car ls) els))))
         (else
          (get-rxnorm (cdr ls) els))))
      (else
       (set-union (get-rxnorm (car ls) els)
                  (get-rxnorm (cdr ls) els))))))

(define substitute
  (lambda (ls old new)
    (cond 
      ((null? ls) '())
      ((or (boolean? (car ls))
           (void? (car ls)))
       (substitute (cdr ls) old new))
      ((equal? (car ls) old)
     (cons new
           (substitute (cdr ls) old new)))
    (else
     (cons (car ls)
           (substitute (cdr ls) old new))))))

(define str-converter
  (lambda (ls)
    (cond
      ((null? ls)
       (substitute ls '() "NA"))
      ((or (boolean? (car ls))
           (void? (car ls)))
       (str-converter (cdr ls)))
      (else 
       (if (symbol? (car ls))
           (string-join (map symbol->string ls) " ")
           (string-join ls " "))))))

(define append-predicate-symbol
  (lambda (pred-str inc-pred dec-pred els)
    (cond
      ((null? pred-str) (car els))
      ((or (boolean? (car pred-str))
           (void? (car pred-str)))
       (append-predicate-symbol
        (cdr pred-str) inc-pred dec-pred els))
      ((member? (car pred-str) inc-pred)
       (append-predicate-symbol
        (cdr pred-str)
        inc-pred
        dec-pred
        (cons
         "+" els)))
      ((member? (car pred-str) dec-pred)
        (append-predicate-symbol
         (cdr pred-str)
         inc-pred
         dec-pred
         (cons
          "-" els)))
      ((not (member? (car pred-str) dec-pred))
       (append-predicate-symbol
        (cdr pred-str)
         inc-pred
         dec-pred
         (cons
          "&" els)))
      (else
       (error (format "PREDICATE NOT A MEMBER OF GLOBAL VARIABLE:\n ~a" (car pred-str)))))))

(define match-drug-pred-gene-edges
  (lambda (edges-ls els record-id)
    (cond
      ((null? edges-ls) els)
      (else 
       (match (car edges-ls)
         [`(,db ,edge-cui (,drug-cui ,drug-id ,drug-name (,_ . ,drug-category) ,drug-props-assoc)
                (,gene-cui ,gene-id ,gene-name (,_ . ,gene-category) ,gene-props-assoc)
                (,_ . ,pred) ,pred-props-assoc)
          (match-drug-pred-gene-edges
           (cdr edges-ls)
           (cons 
            (substitute
             (list
              record-id
              db
              drug-name
              drug-id
              (str-converter
               (flatten
                (list
                 (get-xrefs umls-type-label/key drug-props-assoc)
                 (get-xrefs umls-type/key drug-props-assoc))))
              (str-converter
               (flatten
                (list 
                 (get-xrefs drug-bank/key drug-props-assoc))))
              (str-converter
               (get-rxnorm
                (flatten
                 (get-concept-xrefs 
                  (find-concepts
                   #t 
                   (substitute
                    (flatten
                     (list drug-name
                           drug-id
                           (get-xrefs semmed-concept-key/xrefs drug-props-assoc)
                           (get-xrefs orange-concept-key/same-as drug-props-assoc)
<<<<<<< HEAD
                           (get-assoc-value orange-concept-key/synonym drug-props-assoc)
=======
                           (get-xrefs orange-concept-key/synonym drug-props-assoc)
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
                           (get-xrefs robokop-concept-key/eq-id drug-props-assoc)
                           (get-assoc-value semmed-concept-key/id drug-props-assoc))) "#f" "NA")) '())) '()))
              pred
              (append-predicate-symbol (list pred) increases-pred-str/ls decreases-pred-str/ls '())
              gene-name
              gene-id
              (length (pubmed-ids-from-edge-props pred-props-assoc))
              (string-join
               (map (lambda (pubmed)
                      (string-append PUBMED_URL_PREFIX (~a pubmed)))
                    (pubmed-ids-from-edge-props pred-props-assoc)) " ")) '() "NA") els) record-id)])))))

<<<<<<< HEAD
;; changed get-xrefs orange-concept-key/synonym to get-assoc-value do to [] in 
=======
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
(newline)
(displayln "HELPER-FUNCTIONS LOADED, BEGINNING GENE-CONCEPT BUILDING")
(newline)

(define filter-umls-string-concepts
  (lambda (ls-query suffix els)
    (cond
      ((null? ls-query)
       els)
      ((or (boolean? (car ls-query))
           (void? (car ls-query)))
       (filter-umls-string-concepts
        (cdr ls-query)
        suffix
        els))
      ((member? (list-ref (car ls-query) 3) suffix)
       (filter-umls-string-concepts
        (cdr ls-query)
        suffix
        (cons (car ls-query) els)))
      (else
       (filter-umls-string-concepts
        (cdr ls-query)
        suffix
        els)))))

(define query-hgnc-curie-for-hgnc-symbol
  (lambda (ls els)
    (cond
      ((null? ls)
       (remove-duplicates (flatten els)))
      ((or (boolean? (car ls))
           (void? (car ls)))
       (query-hgnc-curie-for-hgnc-symbol
        (cdr ls) els))
      ((string-contains? (car ls) "HGNC:")
       (query-hgnc-curie-for-hgnc-symbol
        (cdr ls)
        (cons
         (extract-symbol-name-from-concept-or-edge
          (find-concepts #t (list (car ls))) '())
         els)))
      (else
       (query-hgnc-curie-for-hgnc-symbol
        (cdr ls) els)))))
 
(define 2-hop/prune
  (lambda (ls els)
    (cond
      ((null? ls) (remove-duplicates els))
      ((or (boolean? (car ls))
           (void? (car ls)))
       (2-hop/prune
        (cdr ls) els))
      ((regexp-match #rx"^HGNC:[0-9]+" (car ls))
       (2-hop/prune (cdr ls)
                    (cons (car ls) els)))
      ((regexp-match #rx"^NCI_NCI-HGNC:HGNC:[0-9]+" (car ls))
       (2-hop/prune (cdr ls)
                    (cons
                     (string-replace (car ls) "NCI_NCI-HGNC:HGNC:" "HGNC:")
                     els)))
      ((regexp-match #rx"^HGNC:HGNC:[0-9]+" (car ls))
       (2-hop/prune (cdr ls)
                    (cons
                     (string-replace (car ls) "HGNC:HGNC:" "HGNC:")
                     els)))
      ((string-contains? (car ls) "NCBIGENE:")
       (2-hop/prune (cdr ls)
                    (cons 
                     (string-replace (car ls) "NCBIGENE:" "NCBIGene:")
                     els)))
      ((string-contains? (car ls) ":")
       (2-hop/prune (cdr ls)
                    (cons (car ls) els)))
      (else
       (2-hop/prune (cdr ls) els)))))

(define xrefs-ls->hgnc-id
  (lambda (ls els)
    (cond
      ((null? ls) (remove-duplicates els))
      ((or (boolean? (car ls))
           (void? (car ls)))
       (xrefs-ls->hgnc-id
        (cdr ls) els))
      ((regexp-match #rx"^HGNC:[0-9]+" (car ls))
       (xrefs-ls->hgnc-id (cdr ls)
                    (cons (car ls) els)))
      ((regexp-match #rx"^NCI_NCI-HGNC:HGNC:[0-9]+" (car ls))
       (xrefs-ls->hgnc-id (cdr ls)
                          (cons
                           (string-replace (car ls) "NCI_NCI-HGNC:HGNC:" "HGNC:")
                           els)))
      ((regexp-match #rx"^HGNC:HGNC:[0-9]+" (car ls))
       (xrefs-ls->hgnc-id (cdr ls)
                    (cons
                     (string-replace (car ls) "HGNC:HGNC:" "HGNC:")
                     els)))
      ((regexp-match #rx"^.* wt Allele$" (car ls))
       (xrefs-ls->hgnc-id (cdr ls)
                          (cons (car ls) els)))
      (else
       (xrefs-ls->hgnc-id (cdr ls) els)))))

#|HELPER FUNCTIONS FOR TAB DELIMITED EXPORT FILE HEADERS & DATA|#

(define export-column-headers
  (lambda (headers port path)
    (cond 
      ((= (file-size path) 0)
       (cond
         ((null? headers)
          (fprintf port "~c" #\newline))
         (else
          (fprintf port "~a~c" (car headers) #\tab)
          (export-column-headers (cdr headers) port path))))
      (else
       (void)))))

(define outer-loop
  (lambda (ls port)
    (cond
      ((null? ls)
       (close-output-port port))
      (else
       (inner-loop (car ls) port)
       (fprintf port (format "~c" #\newline))
       (outer-loop (cdr ls) port)))))

(define inner-loop
  (lambda (ls port)
    (cond
      ((null? ls) (void))
      (else
       (fprintf port "~a~c" (car ls) #\tab)
       (inner-loop (cdr ls) port)))))


#|COMMA DELIMITED EXPORT HELPER FUNCTIONS |#
#|
(define inner-loop
  (lambda (ls port)
    (cond
      ((null? ls) (void))
      (else
       (fprintf port "~a~c" (car ls) #\,)
       (inner-loop (cdr ls) port)))))

(define outer-loop
  (lambda (ls port)
    (cond
      ((null? ls)
       (close-output-port port))
      (else
       (inner-loop (car ls) port)
       (fprintf port (format "~c" #\newline))
       (outer-loop (cdr ls) port)))))

(define export-column-headers
  (lambda (headers port path)
    (cond 
      ((= (file-size path) 0)
       (cond
         ((null? headers)
          (fprintf port "~c" #\newline))
         (else
          (fprintf port "~a~c" (car headers) #\,)
          (export-column-headers (cdr headers) port path))))
      (else
       (void)))))
|#

(define remove-item
  (lambda (x ls els)
    (cond
      ((null? ls) (reverse els))
      ((or (boolean? (car ls))
           (void? (car ls)))
       (remove-item
        x (cdr ls) els))
      ((equal? x (car ls))
       (remove-item x (cdr ls) els))
      (else
       (remove-item x (cdr ls)
                    (cons (car ls) els))))))
        
(newline)
(displayln "PROCESSING PMI-RECORD IN QUERY LISTS")
(newline)

(define start-function
  (lambda (record-assoc-ls)
    (cond
      ((null? record-assoc-ls) (void))
      (else
       (pmi-record->query-ls (car record-assoc-ls))
       (start-function (cdr record-assoc-ls))))))

(define pmi-record->query-ls
  (time 
   (lambda (patient-record-assoc-ls)
     (let* ((pmi-case-number-ls
             (remove-item "_" (map (lambda (ls) (lookup-field ls "record_id")) patient-record-assoc-ls) '()))
            #|(symptom-name-ls
            (remove-item "_" (map (lambda (ls) (lookup-field ls "phenotype_or_symptom")) record-assoc-ls) '()))
            (symptom-curie-ls
             (remove-item "_" (map (lambda (ls) (lookup-field ls "phenotype_or_symptom_id"))  record-assoc-ls) '()))
            (diagnosis-name-ls
             (remove-item "_" (map (lambda (ls) (lookup-field ls "diagnosis_or_disease")) record-assoc-ls) '()))
            (diagnosis-curie-ls
            (remove-item "_" (map (lambda (ls) (lookup-field ls "diagnosis_or_disease_id")) record-assoc-ls) '()))
            (medication-name-ls
             (remove-item "_" (map (lambda (ls) (lookup-field ls "drug_or_medication")) record-assoc-ls) '()))                      
            (medication-curie-ls
             (remove-item "_" (map (lambda (ls) (lookup-field ls "drug_or_medication_id")) record-assoc-ls) '()))|#
            (genetic_variant-name-ls
             (remove-item "_" (map (lambda (ls) (lookup-field ls "genetic_variant_symbol")) patient-record-assoc-ls) '()))                               
            (genetic_variant-curie-ls
             (remove-item "_" (map (lambda (ls) (lookup-field ls "genetic_variant_id")) patient-record-assoc-ls) '())))            
       (cond
         ((null? patient-record-assoc-ls)
          (void))
         (else
          (handle
           (car pmi-case-number-ls)
           (car genetic_variant-name-ls)
           (car genetic_variant-curie-ls))
          (pmi-record->query-ls
           (cdr patient-record-assoc-ls))))))))

(newline)
(displayln "STARTING AUTOMATED QUERY OF PROCESSED PMI-RECORD")

(define handle
  (time
   (lambda (pmi-case-number-ls
            genetic_variant-name-ls
            genetic_variant-curie-ls)
     (cond 
       ((null? pmi-case-number-ls) (void))
       (else
	(let* ((date (seconds->date (current-seconds)))
	       (export-date 
		(format "~a_~a_~a" 
			(number->string (date-month date))
			(number->string (date-day date))
			(number->string (date-year date))))
	       (export-path
                (cdr (assoc "automated_query_export_path" (config))))               
	       (filtered-X-drug "BIOLOGICAL/CHEMICAL-SUBSTANCE")
	       (filtered-X-molecular_entity "MOLECULAR-ENTITY")
 	       (filtered-X-disease "SYMPTOM/DISEASE")
               (umls-suffix-ls
                '(" protein, human" " gene" " wt Allele"))
                (umls-protein-concept-suffix
               " protein, human")
               (umls-gene-concept-suffix
                " gene")
               (umls-wt-Allele-concept-suffix
                " wt Allele"))
          
          #|CREATE EXPORT DIRECTORY|#
<<<<<<< HEAD
          
=======
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
          (define directory/path
            (format "~a~a_~a_~a/" export-path export-date pmi-case-number-ls genetic_variant-name-ls))          

          ;;read in existing file, delete it and re-export         
          (define make-export-directory
            (if (directory-exists? directory/path)
                (call-with-output-file directory/path
                  (lambda (out)
                    out)
                  #:mode 'replace)
                (make-directory directory/path)))
          
          (define ALLc-->ALLp-->TARGET-CONCEPT/path
            (format			
             "~a~a_[ALLc]_ALLp_~a.tsv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))
          
          (define ALLc-->ALLp-->GENEc--ALLp-->TARGET-CONCEPT/path
            (format			
             "~a~a_[ALLc]_ALLp_GENEc_ALLp_~a.tsv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))

          (define TARGET-CONCEPT-->ALLp-->ALLc/path
            (format			
             "~a~a_~a_ALLp_[ALLc].tsv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))
          
          (define TARGET-CONCEPT-->ALLp-->GENEc<--ALLp<--ALLc/path
            (format			
             "~a~a_~a_ALLp_GENEc_ALLp_[ALLc].tsv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))          

          (define ALLc-->ALLp-->TARGET-CONCEPT/port
            (open-output-file ALLc-->ALLp-->TARGET-CONCEPT/path #:exists 'can-update))

          (define ALLc-->ALLp-->GENEc--ALLp-->TARGET-CONCEPT/port		
            (open-output-file ALLc-->ALLp-->GENEc--ALLp-->TARGET-CONCEPT/path #:exists 'can-update))

          (define TARGET-CONCEPT-->ALLp-->ALLc/port
            (open-output-file TARGET-CONCEPT-->ALLp-->ALLc/path #:exists 'can-update))
          
          (define TARGET-CONCEPT-->ALLp-->GENEc<--ALLp<--ALLc/port
            (open-output-file TARGET-CONCEPT-->ALLp-->GENEc<--ALLp<--ALLc/path  #:exists 'can-update))
<<<<<<< HEAD

=======
          
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
          (displayln "PMI-CASE-NUMBER")
          (pretty-print pmi-case-number-ls)

          (displayln "GENETIC-VARIANT-NAME")
          (pretty-print genetic_variant-name-ls)
          
          (displayln "GENETIC-VARIANT-SYMBOL")
          (pretty-print genetic_variant-curie-ls)
          
<<<<<<< HEAD
          (define extract-name/curie-from-concept
            (lambda (query-ls els)
              (cond
                ((null? query-ls) els)
                ((or (void? (car query-ls))
                     (boolean? (car query-ls)))
                 (extract-name/curie-from-concept
                  (cdr query-ls) els))
                (else 
                 (match (car query-ls)
                   [`(,db ,cui ,id ,name ,category ,properties-list)
                    (extract-name/curie-from-concept
                     (cdr query-ls)
                     (cons
                      (list db name id) els))])))))
          
          (define hgnc-concept-from-input
            (find-concepts #t (list genetic_variant-curie-ls)))

          (define xref-predicates/str-ls
            (list "xref" "encodes" "equivalent_to"))
          
          (define xref-predicates
            (find-predicates
             (list
              "xref"
              "encodes"
              "equivalent_to"
              "mapped_to")))

          (match-define
	   (list hgnc-input-->ALL=>concepts hgnc-input-->ALL=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (hgnc-input hgnc-concept-from-input))
             ((encodes_xref--> (find-predicates (list "encodes" "xref" "equivalent_to" "mapped_to"))))
             (hgnc-input encodes_xref--> ALL))))

          (define hgnc-input-->ALL/derived-concepts
            (hash-ref hgnc-input-->ALL=>concepts 'ALL))

          (match-define
	   (list ALL-->hgnc-input=>concepts ALL-->hgnc-input=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (hgnc-input hgnc-concept-from-input))
             ((encodes_xref--> (find-predicates (list "encodes" "xref" "equivalent_to" "mapped_to"))))
             (ALL encodes_xref--> hgnc-input))))

          (define ALL-->hgnc-input/derived-concepts
            (hash-ref ALL-->hgnc-input=>concepts 'ALL))

          (define ALL-->hgnc-input-->ALL/concept-ls
            (remove-duplicates
             (append
              hgnc-input-->ALL/derived-concepts
              ALL-->hgnc-input/derived-concepts)))

          (displayln (format "LENGTH of ALL-->hgnc-input-->ALL/concept-ls LIST:~a" (length ALL-->hgnc-input-->ALL/concept-ls)))
          (newline)          
          (pretty-print
           (extract-name/curie-from-concept ALL-->hgnc-input-->ALL/concept-ls '()))

          (match-define
	   (list ALL-->xrefs=>concepts ALL-->xrefs=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (hgnc-input/derived-concepts ALL-->hgnc-input-->ALL/concept-ls))
             ((encodes_xref--> (find-predicates (list "encodes" "xref" "equivalent_to" "mapped_to"))))
	     (ALL encodes_xref--> hgnc-input/derived-concepts))))

          (define ALL-->xrefs/derived-concepts
            (hash-ref ALL-->xrefs=>concepts 'ALL))

          (match-define
	   (list xrefs-->ALL=>concepts xrefs-->ALL=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (hgnc-input/derived-concepts ALL-->hgnc-input-->ALL/concept-ls))
             ((encodes_xref--> (find-predicates (list "encodes" "xref" "equivalent_to" "mapped_to"))))
	     (hgnc-input/derived-concepts encodes_xref--> ALL))))

          (define xrefs-->ALL/derived-concepts
            (hash-ref xrefs-->ALL=>concepts 'ALL))

          (define ALL-->xrefs-->ALL/concept-ls
            (remove-duplicates
             (append
              ALL-->xrefs/derived-concepts
              xrefs-->ALL/derived-concepts)))

          (define ALL-->xrefs+hgnc-input-->ALL/concept-ls
            (remove-duplicates
             (append
              ALL-->xrefs-->ALL/concept-ls
              ALL-->hgnc-input-->ALL/concept-ls)))

          (displayln (format "LENGTH of ALL-->xrefs+hgnc-input-->ALL/concept-ls LIST:~a" (length ALL-->xrefs+hgnc-input-->ALL/concept-ls)))
          (newline)          
          (pretty-print
           (extract-name/curie-from-concept ALL-->xrefs+hgnc-input-->ALL/concept-ls '()))
         

          (match-define
	   (list xrefs+hgnc-input-->ALL=>concepts xrefs+hgnc-input-->ALL=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (xrefs+hgnc-input/derived-concepts ALL-->xrefs+hgnc-input-->ALL/concept-ls))
             ((encodes_xref--> (find-predicates (list "encodes" "xref" "equivalent_to" "mapped_to"))))
	     (xrefs+hgnc-input/derived-concepts encodes_xref--> ALL))))

          (define xrefs+hgnc-input-->ALL/derived-concepts
            (hash-ref xrefs+hgnc-input-->ALL=>concepts 'ALL))

           (match-define
	   (list ALL-->xrefs+hgnc-input=>concepts ALL-->xrefs+hgnc-input=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (xrefs+hgnc-input/derived-concepts ALL-->xrefs+hgnc-input-->ALL/concept-ls))
             ((encodes_xref--> (find-predicates (list "encodes" "xref" "equivalent_to" "mapped_to"))))
	     (ALL encodes_xref--> xrefs+hgnc-input/derived-concepts))))

           (define ALL-->xrefs+hgnc-input/derived-concepts
             (hash-ref ALL-->xrefs+hgnc-input=>concepts 'ALL))

           (define 2nd_query_ALL-->xrefs+hgnc-input-->ALL/concept-ls
             (remove-duplicates
              (append
               xrefs+hgnc-input-->ALL/derived-concepts
               ALL-->xrefs+hgnc-input/derived-concepts)))

           (define gene+protein-concept-ls/from-rtx2-ontology
             (remove-duplicates
              (append
               2nd_query_ALL-->xrefs+hgnc-input-->ALL/concept-ls
               ALL-->xrefs+hgnc-input-->ALL/concept-ls)))
                      
           (displayln (format "LENGTH of gene+protein-concept-ls/from-rtx2-ontology LIST:~a" (length gene+protein-concept-ls/from-rtx2-ontology)))
           (newline)          
           (pretty-print
            (extract-name/curie-from-concept gene+protein-concept-ls/from-rtx2-ontology '()))

           (match-define
	   (list ALL-->3rd_concept_query=>concepts ALL-->3rd_concept_query=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (3rd_concept_query gene+protein-concept-ls/from-rtx2-ontology))
             ((encodes_xref--> (find-predicates (list "encodes" "xref" "equivalent_to" "mapped_to"))))
	     (ALL encodes_xref--> 3rd_concept_query))))
           
           (define ALL-->3rd_concept_query/derived-concepts
             (hash-ref ALL-->3rd_concept_query=>concepts 'ALL))

           (match-define
	   (list 3rd_concept_query-->ALL=>concepts 3rd_concept_query-->ALL=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (3rd_concept_query gene+protein-concept-ls/from-rtx2-ontology))
             ((encodes_xref--> (find-predicates (list "encodes" "xref" "equivalent_to" "mapped_to"))))
	     (3rd_concept_query encodes_xref--> ALL))))

           (define 3rd_concept_query-->ALL/derived-concepts
             (hash-ref 3rd_concept_query-->ALL=>concepts 'ALL))

           (define ALL-->3rd_concept_query-->ALL/concept-ls
             (remove-duplicates
              (append
               ALL-->3rd_concept_query/derived-concepts
               3rd_concept_query-->ALL/derived-concepts)))

           (define 3rd_query_gene+protein-concept-ls/from-rtx2-ontology
             (append
              gene+protein-concept-ls/from-rtx2-ontology
              ALL-->3rd_concept_query-->ALL/concept-ls))
              
           (displayln (format "LENGTH of 3rd_query_gene+protein-concept-ls/from-rtx2-ontology LIST:~a" (length 3rd_query_gene+protein-concept-ls/from-rtx2-ontology)))
           (newline)          
           (pretty-print
            (extract-name/curie-from-concept 3rd_query_gene+protein-concept-ls/from-rtx2-ontology '()))
                          
          (define extract-curie-from-concept-ls
            (lambda (query-ls els)
              (cond
                ((null? query-ls) (remove-duplicates els))
                ((or (void? (car query-ls))
                     (boolean? (car query-ls)))
                 (extract-curie-from-concept-ls
=======
          (define hgnc-symbol/id-pair
            (lambda (ls1 ls2 els)
              (cond
                ((and (null? ls1)
                      (null? ls2))
                 els)
                (else
                 (hgnc-symbol/id-pair
                  (cdr ls1) (cdr ls2)
                  (cons
                   (cons (car ls1)
                         (car ls2)) els))))))
          
          (define hgnc-symbol/pair-from-input
            (hgnc-symbol/id-pair
             (list genetic_variant-name-ls)
             (list genetic_variant-curie-ls) '()))
 
          (displayln "HGNC SYMBOL/ID FROM INPUT FORM:")
          (pretty-print hgnc-symbol/pair-from-input)

          (define get-hgnc-symbol-string
            (lambda (ls)
              (cond 
                ((null? ls) '())
                ((or (boolean? (car ls))
                     (void? (car ls)))
                 (get-hgnc-symbol-string
                  (cdr ls)))
                (else 
                 (query-hgnc-curie-for-hgnc-symbol ls '())))))
          
          (define hgnc-symbol-string
            (get-hgnc-symbol-string
             (list genetic_variant-curie-ls)))

          (define get-hgnc-symbol-with-umls-suffix
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (boolean? (car ls))
                     (void? (car ls)))
                 (get-hgnc-symbol-with-umls-suffix
                  (cdr ls) els))
                (else
                 (get-hgnc-symbol-with-umls-suffix
                  (cdr ls)
                  (set-union  
                   (flatten
                    (list
                     (map (lambda (ls)
                            (string-append ls umls-gene-concept-suffix))
                          ls)
                     (map (lambda (ls)
                            (string-append ls umls-protein-concept-suffix))
                          ls)
                     (map (lambda (ls)
                            (string-append ls umls-wt-Allele-concept-suffix))
                          ls))) els))))))

          (define hgnc-symbol-with-umls-suffix
            (get-hgnc-symbol-with-umls-suffix
             hgnc-symbol-string '()))
          
          #|(newline)
          (displayln "hgnc-symbol-with-umls-suffix")
          (pretty-print hgnc-symbol-with-umls-suffix)
          |#
          
          (define get-molecular-entity-concepts-from-hgnc
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (boolean? (car ls))
                     (void? (car ls)))
                 (get-molecular-entity-concepts-from-hgnc
                  (cdr ls) els))
                (else
                 (get-molecular-entity-concepts-from-hgnc
                  (cdr ls)
                  (set-union (find-concepts #t (list (car ls))) els))))))          
          
          (define query-start/hgnc
            (get-molecular-entity-concepts-from-hgnc
             (list genetic_variant-curie-ls) '()))
          
          (displayln "query-start/hgnc")
          (newline)
          (pretty-print query-start/hgnc)

          (define raw-concepts/hgnc
            (get-concept-xrefs query-start/hgnc '()))

          (define xrefs-from-hgnc
            (remove-duplicates
             (prune-xrefs
              (get-concept-xrefs query-start/hgnc '()) '())))
          
          (newline)
          (displayln "xrefs-from-hgnc")
          (pretty-print xrefs-from-hgnc)
          
          (define get-gene-concepts-ls/curie-or-string
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (boolean? (car ls))
                     (void? (car ls)))
                 (get-gene-concepts-ls/curie-or-string
                  (cdr ls) els))
                ((string-contains? (car ls) ":")
                 (get-gene-concepts-ls/curie-or-string
                  (cdr ls)
                  (set-union
                   (find-concepts #t (list (car ls))) els)))
                ((string-contains? (car ls) "Allele")
                 (get-gene-concepts-ls/curie-or-string
                  (cdr ls)
                  (set-union
                   (find-concepts/options #f #f 0 #f (list (car ls))) els)))
                (else
                 (get-gene-concepts-ls/curie-or-string
                  (cdr ls)
                  els)))))
          
          (define get-gene-concepts-ls/from-curies
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (void? (car ls))
                     (boolean? (car ls)))
                 (get-gene-concepts-ls/from-curies
                  (cdr ls)
                  els))
                (else
                 (get-gene-concepts-ls/from-curies
                  (cdr ls)
                  (set-union
                   (find-concepts #t (list (car ls))) els))))))

          (define gene-concepts-ls/from-curies
            (get-gene-concepts-ls/from-curies
             xrefs-from-hgnc '()))
          
          (define get-gene-concepts-ls/from-hgnc-symbol-string
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (void? (car ls))
                     (boolean? (car ls)))
                 (get-gene-concepts-ls/from-hgnc-symbol-string
                  (cdr ls) els))
                (else
                 (get-gene-concepts-ls/from-hgnc-symbol-string
                  (cdr ls)
                  (set-union 
                   (find-concepts/options #f #f 0 #f (list (car ls))) els))))))

          (define gene-concepts-ls/from-hgnc-symbol-string
            (get-gene-concepts-ls/from-hgnc-symbol-string
             hgnc-symbol-string '()))     
                 
          (define filtered-gene-concepts-from-fuzzy-string-search
            (filter-umls-string-concepts
             gene-concepts-ls/from-hgnc-symbol-string
             hgnc-symbol-with-umls-suffix
             '()))

          (define gene-concept-ls
            (append filtered-gene-concepts-from-fuzzy-string-search
                    gene-concepts-ls/from-curies))

          (define extract-name/curie-from-concept
            (lambda (query-ls els)
              (cond
                ((null? query-ls) els)
                ((or (void? (car query-ls))
                     (boolean? (car query-ls)))
                 (extract-name/curie-from-concept
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
                  (cdr query-ls) els))
                (else 
                 (match (car query-ls)
                   [`(,db ,cui ,id ,name ,category ,properties-list)
<<<<<<< HEAD
                    (extract-curie-from-concept-ls
                     (cdr query-ls)
                     (cons
                      id els))])))))
                   
          (define gene/protein-curie-ls
            (extract-curie-from-concept-ls 3rd_query_gene+protein-concept-ls/from-rtx2-ontology  '()))

          (define gene-concept-ls
            (find-concepts #t gene/protein-curie-ls))
          
          
          (displayln "FULL CONCEPT LIST FOR GENE/PROTEIN QUERY:")
          (newline)
          (pretty-print gene-concept-ls)

          (displayln (format "LENGTH OF HGNC-ID DERIVED CONCEPT LIST FOR GENE/PROTEIN QUERY:~a" (length gene-concept-ls)))
          (newline)
          (pretty-print (extract-name/curie-from-concept gene-concept-ls '()))
          (newline)

          (match-define
	   (list ALLc-->ALLp-->TARGET-CONCEPT=>concepts ALLc-->ALLp-->TARGET-CONCEPT=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (gene-concept-ls gene-concept-ls))
             ((ALL-> (find-predicates (list ""))))
	     (ALL ALL-> gene-concept-ls))))

             
	  (define ALLc-->ALLp-->TARGET-CONCEPT/edges (hash-ref ALLc-->ALLp-->TARGET-CONCEPT=>edges 'ALL->))
          (define ALLc-->ALLp-->TARGET-CONCEPT/concepts
            (remove-duplicates (hash-ref ALLc-->ALLp-->TARGET-CONCEPT=>concepts 'ALL)))

          (define COLUMN-HEADERS_SUBJECT->PREDICATE->OBJECT
            '("record_id" "knowledge_graph" "subject_name" "subject_id" "umls_category"
              "drugbank_fda_status" "rxnorm_id" "potential_therapeutic"
              "predicate" "predicate_sign" "target_object_name" "target_object_id" "number_of_pubmeds"
              "pubmed_urls"))
=======
                    (extract-name/curie-from-concept
                     (cdr query-ls)
                     (cons
                      (list db name id) els))])))))
          
          (displayln "HGNC-ID DERIVED CONCEPTS:")
          (newline)
          (pretty-print (extract-name/curie-from-concept gene-concept-ls '()))
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
          
          (define insert-at
            (lambda (pos elmt ls)
              (cond
                ((or (boolean? (car ls))
                     (void? (car ls)))
                 (insert-at
                  pos
                  elmt
                  (cdr ls)))
                ((= 0 pos)
                 (cons elmt ls))
                (else
                 (cons (car ls)
                       (insert-at
                        (- pos 1) elmt (cdr ls)))))))
<<<<<<< HEAD
          
=======
                    
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
          (define insert-therapeutic-drug-flag
            (lambda (ls)
              (if (or (not (equal? "NA" (list-ref ls 5)))
                      (not (equal? "NA" (list-ref ls 6))))
                  (insert-at 7 "YES" ls)
                  (insert-at 7 "ND" ls))))
<<<<<<< HEAD
                    
	  (define ALLc-->ALLp-->TARGET-CONCEPT/export-edges
=======
          
          (match-define
	   (list ALLc-->ALLp-->TARGET-CONCEPT=>concepts ALLc-->ALLp-->TARGET-CONCEPT=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (gene-concept-ls gene-concept-ls))
             ((ALL-> (find-predicates (list ""))))
	     (ALL ALL-> gene-concept-ls))))
       
	  (define ALLc-->ALLp-->TARGET-CONCEPT/edges (hash-ref ALLc-->ALLp-->TARGET-CONCEPT=>edges 'ALL->))
          (define ALLc-->ALLp-->TARGET-CONCEPT/concepts
            (remove-duplicates (hash-ref ALLc-->ALLp-->TARGET-CONCEPT=>concepts 'ALL)))

          (define COLUMN-HEADERS_SUBJECT->PREDICATE->OBJECT
            '("record_id" "knowledge_graph" "subject_name" "subject_id" "umls_category"
              "drugbank_fda_status" "rxnorm_id" "potential_therapeutic"
              "predicate" "predicate_sign" "target_object_name" "target_object_id" "number_of_pubmeds"
              "pubmed_urls"))
                    
	  (define ALL->ALLPRED->TARGET-CONCEPT/export-edges
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
	    (time
             (map insert-therapeutic-drug-flag
                  (remove-duplicates
                   (match-drug-pred-gene-edges
                    ALLc-->ALLp-->TARGET-CONCEPT/edges '() pmi-case-number-ls)))))           

          (export-column-headers
           COLUMN-HEADERS_SUBJECT->PREDICATE->OBJECT
           ALLc-->ALLp-->TARGET-CONCEPT/port
           ALLc-->ALLp-->TARGET-CONCEPT/path)

	  (outer-loop
<<<<<<< HEAD
           ALLc-->ALLp-->TARGET-CONCEPT/export-edges
           ALLc-->ALLp-->TARGET-CONCEPT/port)

          (match-define
	   (list TARGET-CONCEPT-->ALLp-->ALLc=>concepts TARGET-CONCEPT-->ALLp-->ALLc=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
              (gene-concept-ls gene-concept-ls))
             ((ALL-> (find-predicates (list ""))))
	     (gene-concept-ls ALL-> ALL))))
             
	  (define TARGET-CONCEPT-->ALLp-->ALLc/edges
            (hash-ref TARGET-CONCEPT-->ALLp-->ALLc=>edges 'ALL->))
          (define TARGET-CONCEPT-->ALLp-->ALLc/concepts
            (remove-duplicates (hash-ref TARGET-CONCEPT-->ALLp-->ALLc=>concepts 'ALL)))

          (define TARGET-CONCEPT-->ALLp-->ALLc/export-edges
            (time
             (map insert-therapeutic-drug-flag
                  (remove-duplicates
                   (match-drug-pred-gene-edges
                    TARGET-CONCEPT-->ALLp-->ALLc/edges '() pmi-case-number-ls)))))

            (export-column-headers
             COLUMN-HEADERS_SUBJECT->PREDICATE->OBJECT
             TARGET-CONCEPT-->ALLp-->ALLc/port
             TARGET-CONCEPT-->ALLp-->ALLc/path)

	  (outer-loop
           TARGET-CONCEPT-->ALLp-->ALLc/export-edges
           TARGET-CONCEPT-->ALLp-->ALLc/port)
=======
           ALL->ALLPRED->TARGET-CONCEPT/export-edges
           ALLc-->ALLp-->TARGET-CONCEPT/port) 
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4

          #|
          (newline)
          (displayln
           (format "~a PREPARED FOR AUTOMATED 1 & 2-HOP QUERIES" pmi-case-number-ls))
          (newline)          
          (displayln
           (format "SYMPTOM NAMES & CURIE-IDS FOR ~a:\n\nNAME(S): ~a\n\nCURIE(S): ~a" pmi-case-number-ls
                   symptom-name-ls symptom-curie-ls))          
          (newline)
          (displayln
           (format "MEDICATION NAMES & CURIE-IDS FOR ~a:\n\nNAME(S): ~a\n\nCURIE(S): ~a" pmi-case-number-ls
                   medication-name-ls medication-curie-ls))          
          (newline)          
          (newline)
          (displayln
           (format "DIAGNOSIS NAMES & CURIE-IDS FOR ~a:\n\nNAME(S): ~a\n\nCURIE(S): ~a" pmi-case-number-ls
                   diagnosis-name-ls diagnosis-curie-ls))
          (newline)
<<<<<<< HEAD
          
=======
          |#
          
          (newline) 
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
          (displayln
           (format "GENE VARIANT NAMES & CURIE-IDS FOR ~a:\n\nNAME(S): ~a \n\nCURIE(S): ~a" pmi-case-number-ls
                   genetic_variant-name-ls genetic_variant-curie-ls))
          (newline)
<<<<<<< HEAD
          |#
          
          #|
=======
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4

          (define ALLc-->ALLp-->TARGET-CONCEPT/xrefs
            (get-concept-xrefs
             (get-gene-concepts-ls/curie-or-string
              (xrefs-ls->hgnc-id
               (get-concept-xrefs
                ALLc-->ALLp-->TARGET-CONCEPT/concepts '()) '()) '()) '()))

          (define query-start/ALLc-->ALLp-->TARGET-CONCEPT
            (get-molecular-entity-concepts-from-hgnc
             ALLc-->ALLp-->TARGET-CONCEPT/xrefs '()))
          
          (displayln (format "~a HGNC-ID ~a OF ~a" (length query-start/ALLc-->ALLp-->TARGET-CONCEPT) filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)

          #|
          (newline)
          (displayln "query-start/ALLc-->ALLp-->TARGET-CONCEPT")
          (pretty-print query-start/ALLc-->ALLp-->TARGET-CONCEPT)
          |#

          #|
          (displayln (format "~a CONCEPTS FOUND FOR [~a] INHIBITORS OF ~a" (length query-start/molecular-entity-inhibitors-from-hgnc) filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)          
          (displayln (format "~a CONCEPTS FOUND FOR [~a] ACTIVATORS OF ~a" (length query-start/molecular-entity-activators-from-hgnc) filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)                                         
          |#

          (define xrefs-from-2HOP/ALLc-->ALLp-->TARGET-CONCEPT
            (remove-duplicates
             (prune-xrefs
              (get-concept-xrefs query-start/ALLc-->ALLp-->TARGET-CONCEPT '()) '())))

          (define gene-concept-ls-from-2HOP/ALLc-->ALLp-->TARGET-CONCEPT
            (remove-duplicates
             (get-gene-concepts-ls/from-curies
              xrefs-from-2HOP/ALLc-->ALLp-->TARGET-CONCEPT '())))

          #|
          (displayln (format "~a HGNC-ID DERIVED CONCEPTS FOUND FOR [~a] INHIBITORS OF ~a" (length gene-concepts-ls/molecular-entity-inhibitors/from-curies) filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)
          
          (displayln (format "~a HGNC-ID DERIVED CONCEPTS FOUND FOR [~a] ACTIVATORS OF ~a" (length gene-concepts-ls/molecular-entity-activators/from-curies) filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)
          |#
                    
          ;;; filter out concepts that down have hgnc-id
          (define extract-hgnc-gene-concepts-from-concept-or-edge
            (lambda (query-ls els)
              (cond
                ((null? query-ls) (set-union els))
                ((or (boolean? (car query-ls))
                     (void? (car query-ls)))
                 (extract-hgnc-gene-concepts-from-concept-or-edge
                  (cdr query-ls) els))
                (else 
                 (match (car query-ls)
                   [`(,db ,cui ,id ,name ,category ,properties-list)
                    (cond
                      ((regexp-match #rx"^HGNC:[0-9]+" id)
                       (extract-hgnc-gene-concepts-from-concept-or-edge
                        (cdr query-ls)
                        (set-union
                         (list id name) els)))
                      (else
                       (extract-hgnc-gene-concepts-from-concept-or-edge
                        (cdr query-ls)
                        els)))]
                   [`(,db ,edge-cui
                          (,subject-cui ,subject-id ,subject-name (,_ . ,subject-category) ,subject-props-assoc)
                          (,concept-cui ,concept-id ,concept-name (,_ . ,concept-category) ,concept-props-assoc)
                          (,_ . ,pred)
                          ,pred-props-assoc)
                    (cond
                      ((regexp-match #rx"^HGNC:[0-9]+" subject-id)
                       (extract-hgnc-gene-concepts-from-concept-or-edge
                        (cdr query-ls)
                        (set-union
                         (list subject-id subject-name) els)))
                      (else
                       (extract-hgnc-gene-concepts-from-concept-or-edge
                        (cdr query-ls)
                        els)))])))))
          
          (define xrefs-from-query-start/ALLc-->ALLp-->TARGET-CONCEPT
            (remove-duplicates
             (flatten
              (extract-hgnc-gene-concepts-from-concept-or-edge
               gene-concept-ls-from-2HOP/ALLc-->ALLp-->TARGET-CONCEPT '()))))
          
          #|
          (displayln "xrefs-from-query-start/ALLc-->ALLp-->TARGET-CONCEPT")
          (pretty-print xrefs-from-query-start/ALLc-->ALLp-->TARGET-CONCEPT)
          (newline)
          |#

          (newline)
          (displayln (format "GATHERING ALIASES/EXTERNAL-REFERENCES FROM HGNC-ID DERIVED CONCEPTS FOR [~a]" filtered-X-molecular_entity))
          (newline)

          (define ALLc-->ALLp-->TARGET-CONCEPT/hgnc-string-ids
            (query-hgnc-curie-for-hgnc-symbol
             xrefs-from-query-start/ALLc-->ALLp-->TARGET-CONCEPT '()))

          #|
          (displayln "ALLc-->ALLp-->TARGET-CONCEPT/hgnc-string-ids")
          (pretty-print ALLc-->ALLp-->TARGET-CONCEPT/hgnc-string-ids)
          (newline)
          |#
          
          (define ALLc-->ALLp-->TARGET-CONCEPT/hgnc-string-ids/umls-suffix 
            (get-hgnc-symbol-with-umls-suffix
             ALLc-->ALLp-->TARGET-CONCEPT/hgnc-string-ids '()))

          #|
          (displayln "ALLc-->ALLp-->TARGET-CONCEPT/hgnc-string-ids/umls-suffix")
          (pretty-print ALLc-->ALLp-->TARGET-CONCEPT/hgnc-string-ids/umls-suffix)
          (newline)
          |#

          (define gene-concept-ls/ALLc-->ALLp-->TARGET-CONCEPT/from-hgnc-symbol-string
            (get-gene-concepts-ls/from-hgnc-symbol-string
             ALLc-->ALLp-->TARGET-CONCEPT/hgnc-string-ids '()))
          
          #|
          (displayln "gene-concept-ls/ALLc-->ALLp-->TARGET-CONCEPT/from-hgnc-symbol-string")
          (pretty-print gene-concept-ls/ALLc-->ALLp-->TARGET-CONCEPT/from-hgnc-symbol-string)
          (newline)
          |#
          
          (define filtered-gene-concepts-from-fuzzy-string-search/ALLc-->ALLp-->TARGET-CONCEPT
            (filter-umls-string-concepts
             gene-concept-ls/ALLc-->ALLp-->TARGET-CONCEPT/from-hgnc-symbol-string
             ALLc-->ALLp-->TARGET-CONCEPT/hgnc-string-ids/umls-suffix
             '()))

          #|
          (displayln "filtered-gene-concepts-from-fuzzy-string-search/ALLc-->ALLp-->TARGET-CONCEPT")
          (pretty-print filtered-gene-concepts-from-fuzzy-string-search/ALLc-->ALLp-->TARGET-CONCEPT)
          (newline)
          |#          

          (define ALL-molecular-entity-regulator/concepts  
            (remove-duplicates
             (append filtered-gene-concepts-from-fuzzy-string-search/ALLc-->ALLp-->TARGET-CONCEPT
                     gene-concept-ls-from-2HOP/ALLc-->ALLp-->TARGET-CONCEPT)))
          
	  (match-define
	   (list ALLc->ALLp->GENEc->ALLp->TARGET-CONCEPT=>concepts ALLc->ALLp->GENEc->ALLp->TARGET-CONCEPT=>edges)
	   (time
	    (run/graph
	     ((ALL (find-categories (list ""))) 
	      (ALL-molecular-entity-regulator/concepts ALL-molecular-entity-regulator/concepts))
	     ((ALL-> (find-predicates (list ""))))
	     (ALL ALL-> ALL-molecular-entity-regulator/concepts))))

	  (define ALLc->ALLp->GENEc->ALLp->TARGET-CONCEPT/edges 
	    (hash-ref ALLc->ALLp->GENEc->ALLp->TARGET-CONCEPT=>edges 'ALL->))
          
          (define ALL->ALLPRED->ALL-molecular-entity-regulator/concepts 
            (remove-duplicates (hash-ref ALLc->ALLp->GENEc->ALLp->TARGET-CONCEPT=>concepts 'ALL)))          
          
	  (define ALLc->ALLp->GENEc->ALLp->TARGET-CONCEPT/export-edges
	    (time
             (map insert-therapeutic-drug-flag
                  (remove-duplicates
                   (match-drug-pred-gene-edges
                    ALLc->ALLp->GENEc->ALLp->TARGET-CONCEPT/edges '() pmi-case-number-ls)))))

          (export-column-headers
           COLUMN-HEADERS_SUBJECT->PREDICATE->OBJECT
           ALLc-->ALLp-->GENEc--ALLp-->TARGET-CONCEPT/port
           ALLc-->ALLp-->GENEc--ALLp-->TARGET-CONCEPT/path)

	  (outer-loop
           ALLc->ALLp->GENEc->ALLp->TARGET-CONCEPT/export-edges
           ALLc-->ALLp-->GENEc--ALLp-->TARGET-CONCEPT/port) 
	  
          #| #TARGET-GENE# --> ALL-PREDICATES --> ALL-CONCEPTS |#
 	  
	  (match-define
	   (list TARGET-CONCEPT->ALLp->ALLc=>concepts TARGET-CONCEPT->ALLp->ALLc=>edges)
	   (time
	    (run/graph
	     ((gene-concept-ls gene-concept-ls)
	      (ALL (find-categories (list ""))))
             ((->ALL (find-predicates (list ""))))
	     (gene-concept-ls ->ALL ALL))))
       
	  (define TARGET-CONCEPT->ALLp->ALLc/edges (hash-ref TARGET-CONCEPT->ALLp->ALLc=>edges '->ALL))
	  (define TARGET-CONCEPT->ALLp->ALLc/concepts 
	    (remove-duplicates (hash-ref TARGET-CONCEPT->ALLp->ALLc=>concepts 'ALL)))
          
	  (define TARGET-CONCEPT->ALLp->ALLc/export-edges
	    (time
             (map insert-therapeutic-drug-flag
                  (remove-duplicates
                   (match-drug-pred-gene-edges
                    TARGET-CONCEPT->ALLp->ALLc/edges '() pmi-case-number-ls)))))
         
          (export-column-headers
           COLUMN-HEADERS_SUBJECT->PREDICATE->OBJECT
           TARGET-CONCEPT-->ALLp-->ALLc/port
           TARGET-CONCEPT-->ALLp-->ALLc/path)

	  (outer-loop
           TARGET-CONCEPT->ALLp->ALLc/export-edges
           TARGET-CONCEPT-->ALLp-->ALLc/port)

          (define xrefs-from-TARGET-CONCEPT->ALLp->ALLc/concepts
            (get-concept-xrefs
             (get-gene-concepts-ls/curie-or-string
              (xrefs-ls->hgnc-id
               (get-concept-xrefs
                TARGET-CONCEPT->ALLp->ALLc/concepts '()) '()) '()) '()))

          (define query-start/xrefs-from-TARGET-CONCEPT->ALLp->ALLc/hgnc-curie-ls
            (get-molecular-entity-concepts-from-hgnc
             xrefs-from-TARGET-CONCEPT->ALLp->ALLc/concepts
             '()))
          
          (define xrefs-from-1hop-hgnc/TARGET-GENE-->ALLp-->ALLc
            (remove-duplicates
             (prune-xrefs
              (get-concept-xrefs
               query-start/xrefs-from-TARGET-CONCEPT->ALLp->ALLc/hgnc-curie-ls '()) '())))

          (define gene-concepts-ls/TARGET-GENE-->ALLp-->ALLc/from-curies
            (remove-duplicates
             (get-gene-concepts-ls/from-curies
              xrefs-from-1hop-hgnc/TARGET-GENE-->ALLp-->ALLc '())))

          (define xrefs-from-query-start/TARGET-GENE-->ALLp-->ALLc
            (remove-duplicates
             (flatten
              (extract-hgnc-gene-concepts-from-concept-or-edge
               query-start/xrefs-from-TARGET-CONCEPT->ALLp->ALLc/hgnc-curie-ls '()))))
          
          (define TARGET-GENE-->ALLp-->ALLc/hgnc-string-ids
            (query-hgnc-curie-for-hgnc-symbol
             xrefs-from-query-start/TARGET-GENE-->ALLp-->ALLc '()))

          (define TARGET-GENE-->ALLp-->ALLc/hgnc-string-ids/umls-suffix
            (get-hgnc-symbol-with-umls-suffix
             TARGET-GENE-->ALLp-->ALLc/hgnc-string-ids '()))

          (define gene-concepts-ls/TARGET-GENE-->ALLp-->ALLc/from-hgnc-symbol-string
            (get-gene-concepts-ls/from-hgnc-symbol-string
             TARGET-GENE-->ALLp-->ALLc/hgnc-string-ids '()))
          
          (define filtered-gene-concepts-from-fuzzy-string-search/TARGET-GENE-->ALLp-->ALLc
            (filter-umls-string-concepts
             gene-concepts-ls/TARGET-GENE-->ALLp-->ALLc/from-hgnc-symbol-string
             TARGET-GENE-->ALLp-->ALLc/hgnc-string-ids/umls-suffix
             '()))

          (define TARGET-CONCEPT->ALLp->GENEc/concepts
            (remove-duplicates
             (append filtered-gene-concepts-from-fuzzy-string-search/TARGET-GENE-->ALLp-->ALLc
                     gene-concepts-ls/TARGET-GENE-->ALLp-->ALLc/from-curies)))
          
	  (match-define
	   (list TARGET-CONCEPT->ALLp->GENEc=>concepts TARGET-CONCEPT->ALLp->GENEc=>edges)
	   (time
	    (run/graph
             ((TARGET-CONCEPT->ALLp->GENEc/concepts
               TARGET-CONCEPT->ALLp->GENEc/concepts)  
              (ALL (find-categories (list ""))))
             ((ALL-> (find-predicates (list ""))))
              (ALL ALL-> TARGET-CONCEPT->ALLp->GENEc/concepts))))

          (define gene->ALLPRED->ALL-molecular-entity-regulator/edges 
            (hash-ref TARGET-CONCEPT->ALLp->GENEc=>edges 'ALL->))
          (define gene->ALLPRED->ALL-molecular-entity-regulator/concepts 
            (hash-ref TARGET-CONCEPT->ALLp->GENEc=>concepts 'ALL))

	  (define gene->ALLPRED->ALL-molecular-entity-regulator<-ALLPRED-<ALL/export-edges
	    (time
             (map insert-therapeutic-drug-flag
                  (remove-duplicates
                   (match-drug-pred-gene-edges
                    gene->ALLPRED->ALL-molecular-entity-regulator/edges '() pmi-case-number-ls)))))
	  
	  (export-column-headers
           COLUMN-HEADERS_SUBJECT->PREDICATE->OBJECT
           TARGET-CONCEPT-->ALLp-->GENEc<--ALLp<--ALLc/port
           TARGET-CONCEPT-->ALLp-->GENEc<--ALLp<--ALLc/path)

	  (outer-loop
           gene->ALLPRED->ALL-molecular-entity-regulator<-ALLPRED-<ALL/export-edges
           TARGET-CONCEPT-->ALLp-->GENEc<--ALLp<--ALLc/port)
<<<<<<< HEAD
         |#

          
=======

>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
          (newline)
          (displayln (format "CASE COMPLETE:~a" pmi-case-number-ls))
          (newline)
          
	  ))))))

(start-function record-assoc-ls)

<<<<<<< HEAD


#|
(define hgnc-symbol/id-pair
            (lambda (ls1 ls2 els)
              (cond
                ((and (null? ls1)
                      (null? ls2))
                 els)
                (else
                 (hgnc-symbol/id-pair
                  (cdr ls1) (cdr ls2)
                  (cons
                   (cons (car ls1)
                         (car ls2)) els))))))
          
          (define hgnc-symbol/pair-from-input
            (hgnc-symbol/id-pair
             (list genetic_variant-name-ls)
             (list genetic_variant-curie-ls) '()))
 
          (displayln "HGNC SYMBOL/ID FROM INPUT FORM:")
          (pretty-print hgnc-symbol/pair-from-input)

          (define get-hgnc-symbol-string
            (lambda (ls)
              (cond 
                ((null? ls) '())
                ((or (boolean? (car ls))
                     (void? (car ls)))
                 (get-hgnc-symbol-string
                  (cdr ls)))
                (else 
                 (query-hgnc-curie-for-hgnc-symbol ls '())))))
          
          (define hgnc-symbol-string
            (get-hgnc-symbol-string
             (list genetic_variant-curie-ls)))

          (displayln "HGNC SYMBOL-STRING")
          (newline)
          (pretty-print hgnc-symbol-string)

          (define get-hgnc-symbol-with-umls-suffix
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (boolean? (car ls))
                     (void? (car ls)))
                 (get-hgnc-symbol-with-umls-suffix
                  (cdr ls) els))
                (else
                 (get-hgnc-symbol-with-umls-suffix
                  (cdr ls)
                  (set-union  
                   (flatten
                    (list
                     (map (lambda (ls)
                            (string-append ls umls-gene-concept-suffix))
                          ls)
                     (map (lambda (ls)
                            (string-append ls umls-protein-concept-suffix))
                          ls)
                     (map (lambda (ls)
                            (string-append ls umls-wt-Allele-concept-suffix))
                          ls))) els))))))

          (define hgnc-symbol-with-umls-suffix
            (get-hgnc-symbol-with-umls-suffix
             hgnc-symbol-string '()))
          
          (newline)
          (displayln "hgnc-symbol-with-umls-suffix")
          (pretty-print hgnc-symbol-with-umls-suffix)
          
          (define get-molecular-entity-concepts-from-hgnc
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (boolean? (car ls))
                     (void? (car ls)))
                 (get-molecular-entity-concepts-from-hgnc
                  (cdr ls) els))
                (else
                 (get-molecular-entity-concepts-from-hgnc
                  (cdr ls)
                  (set-union (find-concepts #t (list (car ls))) els))))))          
         
          
          (define query-start/hgnc
            (get-molecular-entity-concepts-from-hgnc
             (list genetic_variant-curie-ls) '()))
          
          (displayln "query-start/hgnc")
          (newline)
          (pretty-print query-start/hgnc)

          (define raw-concepts/hgnc
            (get-concept-xrefs query-start/hgnc '()))

          (define xrefs-from-hgnc
            (remove-duplicates
             (prune-xrefs
              (get-concept-xrefs query-start/hgnc '()) '())))
          
          (newline)
          (displayln "xrefs-from-hgnc")
          (pretty-print xrefs-from-hgnc)
          
          
          (define get-gene-concepts-ls/curie-or-string
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (boolean? (car ls))
                     (void? (car ls)))
                 (get-gene-concepts-ls/curie-or-string
                  (cdr ls) els))
                ((string-contains? (car ls) ":")
                 (get-gene-concepts-ls/curie-or-string
                  (cdr ls)
                  (set-union
                   (find-concepts #t (list (car ls))) els)))
                ((string-contains? (car ls) "Allele")
                 (get-gene-concepts-ls/curie-or-string
                  (cdr ls)
                  (set-union
                   (find-concepts/options #f #f 0 #f (list (car ls))) els)))
                (else
                 (get-gene-concepts-ls/curie-or-string
                  (cdr ls)
                  els)))))
          
          (define get-gene-concepts-ls/from-curies
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (void? (car ls))
                     (boolean? (car ls)))
                 (get-gene-concepts-ls/from-curies
                  (cdr ls)
                  els))
                (else
                 (get-gene-concepts-ls/from-curies
                  (cdr ls)
                  (set-union
                   (find-concepts #t (list (car ls))) els))))))

          (define gene-concepts-ls/from-curies
            (get-gene-concepts-ls/from-curies
             xrefs-from-hgnc '()))
          
          (define get-gene-concepts-ls/from-hgnc-symbol-string
            (lambda (ls els)
              (cond
                ((null? ls) els)
                ((or (void? (car ls))
                     (boolean? (car ls)))
                 (get-gene-concepts-ls/from-hgnc-symbol-string
                  (cdr ls) els))
                (else
                 (get-gene-concepts-ls/from-hgnc-symbol-string
                  (cdr ls)
                  (set-union 
                   (find-concepts/options #f #f 0 #f (list (car ls))) els))))))

          (define gene-concepts-ls/from-hgnc-symbol-string
            (get-gene-concepts-ls/from-hgnc-symbol-string
             hgnc-symbol-string '()))     
                 
          (define filtered-gene-concepts-from-fuzzy-string-search
            (filter-umls-string-concepts
             gene-concepts-ls/from-hgnc-symbol-string
             hgnc-symbol-with-umls-suffix
             '()))

          (define gene-concept-ls
            (append filtered-gene-concepts-from-fuzzy-string-search
                    gene-concepts-ls/from-curies))

          (define extract-name/curie-from-concept
            (lambda (query-ls els)
              (cond
                ((null? query-ls) els)
                ((or (void? (car query-ls))
                     (boolean? (car query-ls)))
                 (extract-name/curie-from-concept
                  (cdr query-ls) els))
                (else 
                 (match (car query-ls)
                   [`(,db ,cui ,id ,name ,category ,properties-list)
                    (extract-name/curie-from-concept
                     (cdr query-ls)
                     (cons
                      (list db name id) els))])))))
          
          (displayln "HGNC-ID DERIVED CONCEPTS:")
          (newline)
          (pretty-print (extract-name/curie-from-concept gene-concept-ls '()))

          |#
=======
>>>>>>> 6aae378a785a212b3ee3fa6c87217c4663182ee4
