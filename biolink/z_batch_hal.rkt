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

(define input/path
  "/home/mjpatton/PhD/CaseReviews/test_prototype_files/pmi_case_record_template_test1.csv")

(define input-file
  (open-input-file "/home/mjpatton/PhD/CaseReviews/test_prototype_files/pmi_case_record_template_test1.csv"))

(define header-expected
  "pmi_id,symptom,symptom_id,medication,medication_id,diagnosis,diagnosis_id,genetic_variant,genetic_variant_id")

(define pmi-patient-record-headers
  '("pmi_id"
    "symptom"
    "symptom_id"
    "medication"
    "medication_id"
    "diagnosis"
    "diagnosis_id"
    "genetic_variant"
    "genetic_variant_id"))

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
                                       #;(index-of-field pmi-patient-record-headers header-name)
                                       index)))
         pmi-patient-record-headers (range (length pmi-patient-record-headers)))))

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
  (group-by pmi-assoc-ls "pmi_id"))

(define extract-symbol-name-from-concept-or-edge
  (lambda (query-ls els)
    (cond
      ((null? query-ls) (set-union els))
      (else 
       (match (car query-ls)
              [`(,db ,cui ,id ,name ,category ,properties-list)
               (extract-symbol-name-from-concept-or-edge (cdr query-ls)
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

(define (find-exact-categories names)
  (run* (cat) (fresh (db catid name)
                (membero name names)
                (== cat `(,db ,catid . ,name))
                (categoryo cat))))

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


#|COLUMN-HEADERS FOR EXPORT FILES|#
(define COLUMN_HEADERS_TOTAL_LOF_1-HOP_GENE_REGULATORS
  '("target_gene_name" "target_gene_id"
    "umls_category" "drugbank_fda_status" "rxnorm_id" 
    "predicate" "regulator_gene_name" "regulator_gene_id"
    "number_of_pubmeds" "pubmed_urls"))

(define COLUMN_HEADERS_TOTAL_LOF_2-HOP_GENE_REGULATORS
  '("drug_name" "drug_id"
    "umls_category" "drugbank_fda_status" "rxnorm_id" 
    "predicate" "regulator_gene_name" "regulator_gene_id"
    "number_of_pubmeds" "pubmed_urls"))

(define COLUMN_HEADERS_1-HOP_GENE_REGULATORS
  '("regulator_gene_name" "regulator_gene_id" "umls_category"
    "drugbank_fda_status" "rxnorm_id" 
    "predicate" "target_gene_name" "target_gene_id"
    "number_of_pubmeds" "pubmed_urls"))

(define COLUMN_HEADERS_1-HOP_target-gene->predicate->disease/phenotype
  '("target_gene_name" "target_gene_id" "umls_category"
    "drugbank_fda_status" "rxnorm_id" 
    "predicate" "disease/phenotype_name" "disease/phenotype_id"
    "number_of_pubmeds" "pubmed_urls"))

(define COLUMN_HEADERS_1-HOP
  '("drug_name" "drug_id" "umls_category"
    "drugbank_fda_status" "rxnorm_id" 
    "predicate" "target_gene_name" "target_gene_id"
    "number_of_pubmeds" "pubmed_urls"))

(define COLUMN_HEADERS_1-HOP_disease->assoc->gene
  '("disease_name" "disease_id" "umls_category"
    "drugbank_fda_status" "rxnorm_id" 
    "predicate" "target_gene_name" "target_gene_id"
    "number_of_pubmeds" "pubmed_urls"))


(define COLUMN_HEADERS_2-HOP
  '("drug_name" "drug_id" "umls_category"
    "drugbank_fda_status" "rxnorm_id" 
    "predicate" "gene_name" "gene_id"
    "number_of_pubmeds" "pubmed_urls"))

(define COLUMN_HEADERS
  '("drug_name" "drug_id" "umls_category"
    "drugbank_fda_status" "rxnorm_fda_formulations" 
    "predicate" "gene_name" "gene_id" "number_of_pubmeds"
    "pubmed_urls"))

(define COLUMN_HEADERS_MOL
  '("molecular_entity_name" "entity_id" "umls_category"
    "drugbank_fda_status" "rxnorm_fda_formulations" 
    "predicate" "gene_name" "gene_id" "number_of_pubmeds"
    "pubmed_urls"))

(define COLUMN_HEADERS_INDIRECT_DRUGS
  '("drug_name" "drug_id" "umls_category"
    "drugbank_fda_status" "rxnorm_fda_formulations" 
    "predicate" "gene_name" "gene_id" "number_of_pubmeds"
    "pubmed_urls"))

(define decreases
  (find-predicates
   '("negatively_regulates"
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
     "decreases_expression_of")))

(define increases
  (find-predicates
   '("positively_regulates"
     "produces"
     "causes"
     "causes_condition"
     "causally_related_to"
     "contributes_to"
     "gene_associated_with_condition"
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
     "increases_uptake_of")))

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
                  #f))))
      (else
       '()))))

(define atom?
  (lambda (x)
    (and (not (pair? x))
         (not (list? x)))))

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

#|
TODO: prune 2-hop concepts for indirect queries
log:

- if HGNC:#### exists, query #t and return HGNC symbol and HGNC:id, then 
 string append gene and human, protein onto HGNC symbol. requery for 
 umls ids. 

- if string item exists, query #f for HGNC concepts, return only if 
  string matches the hgnc symbol. 

- 
|#

(define prune-xrefs/2-hop-concepts
  (lambda (ls els)
    (cond
      ((null? ls) (flatten els))
      ((or (void? (car ls))
           (boolean? (car ls))
           (string-contains? (car ls) "MTH:NOCODE"))
       (prune-xrefs/2-hop-concepts (cdr ls) els))
      ((or (string-contains? (car ls) "HGNC:")
           (string-contains? (car ls) "NCBIGene:"))
       (prune-xrefs/2-hop-concepts (cdr ls)
                                   (cons (find-concepts #t (list (car ls))) els)))      
      ((string-contains? (car ls) "HGNC:HGNC:")
       (prune-xrefs/2-hop-concepts (cdr ls)
                                   (cons (find-concepts #t (list (string-replace (car ls) "HGNC:HGNC:" "HGNC:")) els))))
      ((string-contains? (car ls) "NCI_NCI-HGNC:HGNC:")
       (prune-xrefs/2-hop-concepts (cdr ls)
                                   (cons (find-concepts #t (list (string-replace (car ls) "NCI_NCI-HGNC:HGNC:" "HGNC:")) els))))
      ((string-contains? (car ls) "NCBI:GENE")
       (prune-xrefs/2-hop-concepts (cdr ls)
                                   (cons (find-concepts #t (list (string-replace (car ls) "NCBIGene:")) els))))
      (else
       (prune-xrefs/2-hop-concepts (cdr ls) (cons (car ls) els))))))
  
(define get-concept-xrefs
  (lambda (query-ls els)
    (cond
      ((null? query-ls) (set-union els))
      (else 
       (match (car query-ls)
              [`(,db ,cui ,id ,name ,category ,properties-list)
               (get-concept-xrefs (cdr query-ls)
                                  (set-union
                                   (list id name
                                         (get-xrefs orange-concept-key/same-as properties-list)
                                         (get-xrefs orange-concept-key/synonym properties-list)
                                         (get-xrefs semmed-concept-key/xrefs properties-list)
                                         (get-xrefs robokop-concept-key/eq-id properties-list)
                                         (get-assoc-value semmed-concept-key/id properties-list)) els))])))))

(define get-rxnorm
  (lambda (ls els)
    (cond
      ((null? ls) (set-union els))
      ((or (boolean? (car ls))
           (void? (car ls)))
       (get-rxnorm (cdr ls) els))
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
       (substitute ls '() "N/A"))
      (else 
       (if (symbol? (car ls))
           (string-join (map symbol->string ls) " ")
           (string-join ls " "))))))

(define match-drug-pred-gene-edges
  (lambda (edges-ls els)
    (cond
      ((null? edges-ls) els)
      (else 
       (match (car edges-ls)
              [`(,db ,edge-cui (,drug-cui ,drug-id ,drug-name (,_ . ,drug-category) ,drug-props-assoc)
                     (,gene-cui ,gene-id ,gene-name (,_ . ,gene-category) ,gene-props-assoc)
                     (,_ . ,pred) ,pred-props-assoc)
               (match-drug-pred-gene-edges
                (cdr edges-ls)
                (cons (substitute
                       (list drug-name
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
                                  (flatten
                                   (list drug-name
                                         drug-id
                                         (get-xrefs semmed-concept-key/xrefs drug-props-assoc)
                                         (get-xrefs orange-concept-key/same-as drug-props-assoc)
                                         (get-xrefs orange-concept-key/synonym drug-props-assoc)
                                         (get-xrefs robokop-concept-key/eq-id drug-props-assoc)
                                         (get-assoc-value semmed-concept-key/id drug-props-assoc)))) '())) '()))
                            pred
                            gene-name
                            gene-id
                            (length (pubmed-ids-from-edge-props pred-props-assoc))
                            (string-join
                             (map (lambda (pubmed)
                                   (string-append PUBMED_URL_PREFIX (~a pubmed)))
                                 (pubmed-ids-from-edge-props pred-props-assoc)) " ")) '() "N/A") els))]))))) 


(newline)
(displayln "HELPER-FUNCTIONS LOADED, BEGINNING GENE-CONCEPT BUILDING")
(newline)

;;tab

(define filter-umls-string-concepts
  (lambda (ls-query suffix els)
    (cond
      ((null? ls-query)
       els)
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
 
#|

#|COMMA DELIMITED EXPORT HELPER FUNCTIONS |#

(define inner-loop
  (lambda (ls port)
    (cond
      ((null? ls) (void))
      (else
       (fprintf port "~a~c" (car ls) #\,)
       (inner-loop (cdr ls) port)))))

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

#|
(define start-function
  (time 
   (lambda (pmi-case-number-ls
            genetic_variant-curie-ls genetic_variant-name-ls
            diagnosis-curie-ls diagnosis-name-ls)
     (cond
       ((null? genetic_variant-curie-ls) (void))
       (else
	(handle
         (car pmi-case-number-ls)
         (car genetic_variant-curie-ls) (car genetic_variant-name-ls)
         (car diagnosis-curie-ls) (car diagnosis-name-ls))
	(start-function
         (cdr pmi-case-number-ls)
         (cdr genetic_variant-curie-ls) (cdr genetic_variant-name-ls)
         (cdr diagnosis-curie-ls) (cdr diagnosis-name-ls)))))))
|#

;;TODO, 1/20/2020 DEBUG START FUNCTION 

(define remove-item
  (lambda (x ls els)
    (cond
      ((null? ls) (reverse els))
      ((equal? x (car ls))
       (remove-item x (cdr ls) els))
      (else
       (remove-item x (cdr ls)
                    (cons (car ls) els))))))

(define start-function
  (time 
   (lambda (record-assoc-ls)
     (cond
       ((null? record-assoc-ls)
        (void))
       (else
	(handle
         (car record-assoc-ls))
        (start-function
         (cdr record-assoc-ls)))))))

(define handle
  (time
   (lambda (record-assoc-ls)
     (cond 
       ((null? record-assoc-ls) (void))
       (else
	(let* ((date (seconds->date (current-seconds)))
	       (export-date 
		(format "~a_~a_~a" 
			(number->string (date-month date))
			(number->string (date-day date))
			(number->string (date-year date))))
	       (export-path
                (cdr (assoc "automated_query_export_path" (config))))
	       (drugs
		'((semmed 4 . "chemical_substance")
		  (rtx 0 . "chemical_substance")
		  (robokop 1 . "(\"named_thing\" \"chemical_substance\")")
		  (rtx 3 . "metabolite")
		  (semmed 0 ."biological_entity")
		  (orange 12 . "(\"food material\")")))
	       (filtered-X-drug "BIOLOGICAL/CHEMICAL-SUBSTANCE")
	       (molecular_entity
		'((semmed 2 . "gene")
		  (orange 6 . "(\"gene\")")
		  (orange 19 . "(\"genomic entity\" \"gene\")")
		  (orange 23 . "(\"gene\" \"genomic entity\")")
		  (robokop 0 . "(\"named_thing\" \"gene\")")	      
		  (robokop 11 . "(\"named_thing\" \"gene_family\")")
		  (semmed 6 . "protein")
		  (rtx 1 . "protein")
		  (orange 28 . "(\"genome\")")
		  (orange 22 . "(\"genomic entity\")")
		  (semmed 9 . "genomic_entity")
		  (rtx 2 . "microRNA")
		  (orange 15 . "(\"transcript\")")
		  (rtx 3 . "metabolite")
		  (semmed 0 ."biological_entity")
		  (orange 12 . "(\"food material\")")))
	       (filtered-X-molecular_entity "MOLECULAR-ENTITY")
	       (disease
		'((semmed 7 . "disease_or_phenotypic_feature")
		  (orange 5 . "(\"disease\")")
		  (robokop 3 . "(\"named_thing\" \"disease\")")
		  (rtx 6 . "disease")
		  (robokop 4 . "(\"named_thing\" \"genetic_condition\" \"disease\")")
		  (orange 0 . "(\"phenotypic feature\")")
		  (rtx 8 . "phenotypic_feature")
		  (robokop 12 . "(\"anatomical_entity\" \"named_thing\" \"cell\")")
		  (orange 25 . "(\"haplotype\")")
		  (robokop 16 . "(\"named_thing\" \"pathway\")")
		  (semmed 5 . "anatomical_entity")
		  (semmed 8 . "gross_anatomical_structure")
		  (semmed 11 . "activity_and_behavior")
		  (robokop 2 . "(\"named_thing\" \"biological_process_or_activity\")")
		  (semmed 12 . "phenotypic_feature")
		  (rtx 4 . "pathway")
		  (orange 13 . "(\"anatomical entity\")")
		  (robokop 6 . "(\"named_thing\" \"phenotypic_feature\")")
		  (rtx 8 . "phenotypic_feature")
		  (orange 14 . "(\"connected anatomical structure\")")
		  (robokop 7 . "(\"anatomical_entity\" \"named_thing\")")
		  (rtx 7 . "anatomical_entity")
		  (robokop
		   10
		   .
		   "(\"named_thing\" \"genetic_condition\" \"disease\" \"phenotypic_feature\")")
		  (robokop 14 . "(\"named_thing\" \"disease\" \"phenotypic_feature\")")))
	       (filtered-X-disease "SYMPTOM/DISEASE")
               (umls-suffix-ls
                '(" protein, human" " gene"))
               (umls-protein-concept-suffix
                " protein, human")
               (umls-gene-concept-suffix
                " gene"))

          (newline)
          (displayln "HANDLE-BEGIN:")
          (pretty-print record-assoc-ls)
          
          (define pmi-case-number-ls/from-assoc
            (remove-item "_" (map (lambda (ls) (lookup-field ls "pmi_id")) record-assoc-ls) '()))
                                  
          (define symptom-name-ls
            (remove-item "_" (map (lambda (ls) (lookup-field ls "symptom")) record-assoc-ls) '()))
          
          (define symptom-curie-ls
            (remove-item "_" (map (lambda (ls) (lookup-field ls "symptom_id"))  record-assoc-ls) '()))

          (define diagnosis-name-ls
            (remove-item "_" (map (lambda (ls) (lookup-field ls "diagnosis")) record-assoc-ls) '()))
          
          (define diagnosis-curie-ls
            (remove-item "_" (map (lambda (ls) (lookup-field ls "diagnosis_id")) record-assoc-ls) '()))
          
          (define medication-name-ls
            (remove-item "_" (map (lambda (ls) (lookup-field ls "medication")) record-assoc-ls) '()))
          
          (define medication-curie-ls
            (remove-item "_" (map (lambda (ls) (lookup-field ls "medication_id")) record-assoc-ls) '()))
          
          (define genetic_variant-name-ls/from-assoc
            (remove-item "_" (map (lambda (ls) (lookup-field ls "genetic_variant")) record-assoc-ls) '()))
          
          (define genetic_variant-curie-ls/from-assoc
            (remove-item "_" (map (lambda (ls) (lookup-field ls "genetic_variant_id")) record-assoc-ls) '()))

          #|FOR PRINT/EXPORT STATEMENTS|#
          (define pmi-case-number-ls
            (car (remove-item "_" (map (lambda (ls) (lookup-field ls "pmi_id")) record-assoc-ls) '())))
          
          (define genetic_variant-name-ls
            (car (remove-item "_" (map (lambda (ls) (lookup-field ls "genetic_variant")) record-assoc-ls) '())))

          (define genetic_variant-curie-ls
            (car (remove-item "_" (map (lambda (ls) (lookup-field ls "genetic_variant_id")) record-assoc-ls) '())))

          #|CREATE EXPORT DIRECTORY|#
          
          (define directory/path
            (format "~a~a_~a_~a/" export-path export-date pmi-case-number-ls genetic_variant-name-ls))
          
          (define make-export-directory
            (if (directory-exists? directory/path)
                (error (format "ERROR IN EXPORT-DIRECTORY CREATION"))
                (make-directory directory/path)))
           
          (define 1-hop_molecular-entity-activators+inhibitors->target-gene/path
            (format			
             "~a~a_1HOP_[molecular_entity_or_gene]_activators_and_inhibitors_of_~a.csv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))
          
          (define 1-hop_direct-drug-activators+inhibitors->target-gene/path
            (format			
             "~a~a_1HOP_[direct_drug]_activators_and_inhibitors_of_~a.csv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))
          
          (define 2-hop_indirect-drug-activators+inhibitors->target-gene/path
            (format			
             "~a~a_2HOP_[indirect_drug]_activators_and_inhibitors_of_~a.csv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))
          
          (define 2-hop_combined-direct+indirect_drug-activators+inhibitors->target-gene/path
            (format			
             "~a~a_2HOP_[combined_direct_and_indirect_drug]_activators_and_inhibitors_~a.csv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))
          
          (define 1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/path
            (format			
             "~a~a_1HOP_~a_upregulates_and_downregulates_[molecular_entity_or_gene].csv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))
          
          (define 2-hop_total-loss-of-function_drugs->up/downregulate->genes-regulated-by-target-gene/path
            (format			
             "~a~a_2HOP_[drug]_activators_and_inhibitors_of_genes_regulated_by_~a.csv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))
           
          (define 1-hop_disease->assoc/inc_decreases->target-gene/path
            (format			
             "~a~a_1HOP_[disease_or_phenotype]_associated_with_and_downregulates_~a.csv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))
          
          (define 1-hop_target-gene_associated-with_and_decreases/prevents_disease-list/path
            (format			
             "~a~a_1HOP_~a_associated_with_and_downregulates_[disease_or_phenotype].csv"
             directory/path pmi-case-number-ls genetic_variant-name-ls))

          (define 1-hop_molecular-entity-activators+inhibitors->target-gene/port
            (open-output-file 1-hop_molecular-entity-activators+inhibitors->target-gene/path #:exists 'can-update))

          (define 2-hop_indirect-drug-activators+inhibitors->target-gene/port		
            (open-output-file 2-hop_indirect-drug-activators+inhibitors->target-gene/path #:exists 'can-update))

          (define 2-hop_combined-direct+indirect_drug-activators+inhibitors->target-gene/port		
            (open-output-file 2-hop_combined-direct+indirect_drug-activators+inhibitors->target-gene/path #:exists 'can-update))
          
          (define 1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/port
            (open-output-file 1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/path #:exists 'can-update))
       
          (define 2-hop_total-loss-of-function_drugs->up/downregulate->genes-regulated-by-target-gene/port
            (open-output-file 2-hop_total-loss-of-function_drugs->up/downregulate->genes-regulated-by-target-gene/path #:exists 'can-update))          
          (define 1-hop_disease->assoc/inc_decreases->target-gene/port
            (open-output-file 1-hop_disease->assoc/inc_decreases->target-gene/path #:exists 'can-update))
          
          (define 1-hop_direct-drug-activators+inhibitors->target-gene/port		
            (open-output-file 1-hop_direct-drug-activators+inhibitors->target-gene/path #:exists 'can-update))

          (define 1-hop_target-gene_associated-with_and_decreases/prevents_disease-list/port
            (open-output-file 1-hop_target-gene_associated-with_and_decreases/prevents_disease-list/path #:exists 'can-update))
          


          #|
          (1-hop_gene_associated-with_diagnosis-list/port
          (open-output-file 1-hop_gene_associated-with_diagnosis-list/path #:exists 'can-update))

          (define 1-hop_gene_associated-with_diagnosis-list/path
          (format			
          "~a~a_1HOP_[molecular_entity_or_gene]_associated_with_patient_diagnsosis_list.csv" directory/path pmi-case-number-ls))          
          |#

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

          (define get-hgnc-symbol-string
            (lambda (ls)
            (query-hgnc-curie-for-hgnc-symbol
             (list ls) '())))
          
          (define hgnc-symbol-string
            (get-hgnc-symbol-string genetic_variant-curie-ls))

          (define hgnc-symbol-with-umls-suffix
            (flatten
             (list
              (map (lambda (ls)
                     (string-append ls umls-gene-concept-suffix))
                   hgnc-symbol-string)
                   (map (lambda (ls)
                          (string-append ls umls-protein-concept-suffix))
                        hgnc-symbol-string))))

          (define query-start/hgnc
            (find-concepts #t (list genetic_variant-curie-ls)))

          (define raw-concepts/hgnc
            (get-concept-xrefs query-start/hgnc '()))

          (define xrefs-from-hgnc
                 (remove-duplicates
                  (prune-xrefs
                   (flatten (get-concept-xrefs query-start/hgnc '())) '())))

          (define gene-concepts-ls/from-curies
                 (find-concepts #t xrefs-from-hgnc))

          (define gene-concepts-ls/from-hgnc-symbol-string
                 (find-concepts/options #f #f 0 #f hgnc-symbol-string))

          (define filtered-gene-concepts-from-fuzzy-string-search
                 (filter-umls-string-concepts
                  gene-concepts-ls/from-hgnc-symbol-string
                  hgnc-symbol-with-umls-suffix '()))

          (define gene-concept-ls
            (append filtered-gene-concepts-from-fuzzy-string-search
                    gene-concepts-ls/from-curies))
          
          (newline)
          (displayln
           (format "~a PREPARED FOR AUTOMATED 1 & 2-HOP QUERIES" pmi-case-number-ls))
          (newline)

          (newline)
          (displayln
           (format "SYMPTOM NAMES & CURIE-IDS FOR ~a:\n\nNAME(S): ~a \n\nCURIE(S): ~a" pmi-case-number-ls
                   symptom-name-ls symptom-curie-ls))
          (newline)

          (newline)
          (displayln
           (format "MEDICATION NAMES & CURIE-IDS FOR ~a:\n\nNAME(S): ~a \n\nCURIE(S): ~a" pmi-case-number-ls
                   medication-name-ls medication-curie-ls))
          (newline)

          (newline)
          (displayln
           (format "DIAGNOSIS NAMES & CURIE-IDS FOR ~a:\n\nNAME(S): ~a \n\nCURIE(S): ~a" pmi-case-number-ls
                   diagnosis-name-ls diagnosis-curie-ls))
          (newline)
          
          (newline)
          (displayln
           (format "GENE VARIANT NAMES & CURIE-IDS FOR ~a:\n\nNAME(S): ~a \n\nCURIE(S): ~a" pmi-case-number-ls
                   genetic_variant-name-ls genetic_variant-curie-ls))
          (newline)
          
	  (newline)
	  (displayln (format "BEGINNING 1-HOP QUERY FOR ~a:\n[~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a" genetic_variant-name-ls filtered-X-molecular_entity genetic_variant-name-ls))
          
	  (match-define
	   (list w-dec-gene=>concepts w-dec-gene=>edges)
	   (time
	    (run/graph
	     ((W molecular_entity) 
	      (gene-concept-ls gene-concept-ls))
	     ((W->dec decreases))
	     (W W->dec gene-concept-ls))))
       
	  (define molecular_entity-dec-gene-list/edges (hash-ref w-dec-gene=>edges 'W->dec))
	  (define molecular_entity-dec-gene-list/concepts-from-query (hash-ref w-dec-gene=>concepts 'W))
	  
	  (newline)
	  (displayln (format "~a [~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a EDGES FOUND" (length molecular_entity-dec-gene-list/edges) filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)
       
	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n[~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a" filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (define mol_entity-dec-o/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       molecular_entity-dec-gene-list/edges '()))))

	  (newline)
	  (displayln (format "BEGINNING 1-HOP QUERY FOR ~a:\n[~a] --> ACTIVATES/INCREASES EXPRESSION OF --> ~a" genetic_variant-name-ls filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)
      
	  (match-define
	   (list z-inc-gene=>concepts z-inc-gene=>edges)
	   (time
	    (run/graph
	     ((Z molecular_entity)
	      (gene-concept-ls gene-concept-ls))
	     ((Z->inc increases))
	     (Z Z->inc gene-concept-ls))))
            
	  (define molecular_entity-inc-gene-list/edges (hash-ref z-inc-gene=>edges 'Z->inc))
	  (define molecular_entity-inc-gene-list/concepts-from-query (hash-ref z-inc-gene=>concepts 'Z))

          (displayln "CONCEPTS FROM P53 [GENE] --> PREDICATE --> P53")
          (newline)
          
	  
	  (newline)
	  (displayln (format "~a [~a] --> ACTIVATES/INCREASES EXPRESSION OF --> ~a EDGES FOUND" (length molecular_entity-inc-gene-list/edges) filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n[~a] --> ACTIVATES/INCREASES EXPRESSION OF --> ~a" filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  ;; because i don't scrape the edge-CUI-ID, the duplicate edges are removed for final export 
	  (define mol_entity-inc-o/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       molecular_entity-inc-gene-list/edges '()))))
		 
	  (define mol_entity-up+down-regulators-for-target-gene/export-edges
	    (append (remove-duplicates mol_entity-dec-o/export-edges)
                    (remove-duplicates mol_entity-inc-o/export-edges)))
	  
	  (export-column-headers
	   COLUMN_HEADERS_1-HOP_GENE_REGULATORS
	   1-hop_molecular-entity-activators+inhibitors->target-gene/port
	   1-hop_molecular-entity-activators+inhibitors->target-gene/path)
	  
	  (outer-loop mol_entity-up+down-regulators-for-target-gene/export-edges
		      1-hop_molecular-entity-activators+inhibitors->target-gene/port)

          
          #|GATHER CONCEPTS FROM [GENE/MOLECULAR ENTITY] --> INCREASES & DECREASES --> TARGET-GENE FOR PRUNING|#

          ;;TODO: and a harsher prune function here to eliminate "the bomb" concepts for 2-hop query

          ;;drug --> increases --> molecular-entity ---> increases ---> curie-id

          
          #|

          (define 2-hop/prune
            (lambda (ls els)
              (cond
                ((null? ls) (remove-duplicates els))
                ((string-contains? (car ls) "HGNC:")
                 (2-hop/prune (cdr ls) (cons (car ls) els)))
                (else
                 (2-hop/prune (cdr ls) els)))))
          
          (define molecular-entity-inhibitors/for-intersection
            (2-hop/prune
             (map (lambda (ls) (string-replace ls "NCI_NCI-HGNC:HGNC:" "HGNC:")) 
                  (flatten
                   (get-concept-xrefs
                    (remove-duplicates molecular_entity-dec-gene-list/concepts-from-query) '()))) '()))
          
          #|
          cpu time: 378 real time: 378 gc time: 9
          map: all lists must have same size    ; ; ; ; ;
          first list length: 13254          
          other list length: 0
          procedure: #<procedure:.../z_batch_hal.rkt:999:23> ; ;
          [,bt for context]
          |#

          (define molecular-entity-activators/for-intersection
            (2-hop/prune
             (map (lambda (ls) (string-replace ls "HGNC:HGNC:" "HGNC:"))
                  (map (lambda (ls) (string-replace ls "NCI_NCI-HGNC:HGNC:" "HGNC:")) 
                       (flatten
                        (get-concept-xrefs
                         (remove-duplicates molecular_entity-inc-gene-list/concepts-from-query) '())) '())) '()))
          
          (define molecular-entity-inhibitors/hgnc-string-ids
            (get-hgnc-symbol-string
             molecular-entity-inhibitors/for-intersection))

          (define get-hgnc-symbol-with-umls-suffix
            (lambda (ls1)
              (flatten
               (list
                (map (lambda (ls)
                       (string-append ls umls-gene-concept-suffix))
                     ls1)
                (map (lambda (ls)
                       (string-append ls umls-protein-concept-suffix))
                     ls1)))))

          (define molecular-entity-inhibitors/hgnc-string-ids/umls-suffix
            (get-hgnc-symbol-with-umls-suffix molecular-entity-inhibitors/hgnc-string-ids))

          (displayln "molecular-entity-inhibitors/hgnc-string-ids/umls-suffix")
          (newline)
          (pretty-print molecular-entity-inhibitors/hgnc-string-ids/umls-suffix)
          
          
          (define query-start/molecular-entity-inhibitors-from-hgnc
            (find-concepts #t molecular-entity-activators/for-intersection))

          (newline)
          (displayln "query-start/molecular-entity-inhibitors-from-hgnc")
          (pretty-print query-start/molecular-entity-inhibitors-from-hgnc)

          (define raw-concepts/molecular-entity-inhibitors-from-hgnc
            (get-concept-xrefs query-start/molecular-entity-inhibitors-from-hgnc '()))

          (newline)
          (displayln "raw-concepts/molecular-entity-inhibitors-from-hgnc")
          (pretty-print raw-concepts/molecular-entity-inhibitors-from-hgnc)

          (define molecular-entity-inhibitors/xrefs-from-hgnc
            (remove-duplicates
             (prune-xrefs
              (flatten (get-concept-xrefs query-start/molecular-entity-inhibitors-from-hgnc '())) '())))

          (newline)
          (displayln "molecular-entity-inhibitors/xrefs-from-hgnc")
          (pretty-print molecular-entity-inhibitors/xrefs-from-hgnc)

          (define gene-concepts-ls/molecular-entity-inhibitors/from-curies
            (find-concepts #t molecular-entity-inhibitors/xrefs-from-hgnc))

          (define gene-concepts-ls/molecular-entity-inhibitors/from-hgnc-symbol-string
            (find-concepts/options #f #f 0 #f molecular-entity-inhibitors/hgnc-string-ids))
          
          (define filtered-gene-concepts-from-fuzzy-string-search/molecular-entity-inhibitors
            (filter-umls-string-concepts
             molecular-entity-inhibitors/hgnc-string-ids
             molecular-entity-inhibitors/hgnc-string-ids/umls-suffix '()))
         

          (define gene-concept-ls/molecular-entity-inhibitors
            (append filtered-gene-concepts-from-fuzzy-string-search/molecular-entity-inhibitors
                    gene-concepts-ls/molecular-entity-inhibitors/from-curies))
          |#
          
          
          ;;(pretty-print molecular-entity-activators/for-intersection)
          
          ;;TODO: see above!

          (define molecular-entity-inhibitors/for-intersection
	    (prune-xrefs
	     (flatten
	      (get-concept-xrefs
	       (remove-duplicates molecular_entity-dec-gene-list/concepts-from-query) '())) '()))

          (define molecular-entity-activators/for-intersection
	    (prune-xrefs
	     (flatten
	      (get-concept-xrefs
	       (remove-duplicates molecular_entity-inc-gene-list/concepts-from-query) '())) '()))

	  (define molecular-entity-inhibitors/concepts
	    (find-concepts
	     #t
	     molecular-entity-inhibitors/for-intersection))

	  (define molecular-entity-activators/concepts
	    (find-concepts
	     #t
	     molecular-entity-activators/for-intersection))
          
	  (newline)
	  (displayln
	   (format "BEGINNING INDIRECT DRUG ACTIVATOR QUERY FOR ~a:\n[[~a]] --> INHIBITS/DECREASES EXPRESSION OF --> [~a] --> INHIBITS/DECREASES EXPRESSION OF ~a" genetic_variant-name-ls filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (match-define
	   (list drug-dec-mol-entity-inhibitors=>concepts drug-dec-mol-entity-inhibitors=>edges)
	   (time
	    (run/graph
	     ((K drugs) 
	      (molecular-entity-inhibitors/concepts molecular-entity-inhibitors/concepts))
	     ((K->dec decreases))
	     (K K->dec molecular-entity-inhibitors/concepts))))

	  (define drug-dec-molecular-entity-inhibitors/edges
	    (hash-ref drug-dec-mol-entity-inhibitors=>edges 'K->dec))

          (newline)
	  (displayln (format "~a [[~a]] --> INHIBITS/DECREASES EXPRESSION OF --> [~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a EDGES FOUND" (length drug-dec-molecular-entity-inhibitors/edges) filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)
       
	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n[[~a]] --> INHIBITS/DECREASES EXPRESSION OF --> [~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a" filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)
          
	  (define drug-dec-molecular-entity-inhibitors/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-dec-molecular-entity-inhibitors/edges '()))))          
	  
	  (newline)
	  (displayln
	   (format "BEGINNING INDIRECT DRUG ACTIVATOR QUERY:\n~a-->INCREASE/UPREGULATE-->~a-->UPREGULATE ~a" filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (match-define
	   (list drug-inc-mol-entity-activators=>concepts drug-inc-mol-entity-activators=>edges)
	   (time
	    (run/graph
	     ((T drugs) 
	      (molecular-entity-activators/concepts molecular-entity-activators/concepts))
	     ((T->inc increases))
	     (T T->inc molecular-entity-activators/concepts))))

	  (define drug-inc-molecular-entity-activators/edges (hash-ref drug-inc-mol-entity-activators=>edges 'T->inc))

          (newline)
          (displayln (format "~a ~a-->ACTIVATES/INCREASES-EXPRESSION-OF-->~a-->ACTIVATES/INCREASES-EXPRESSION-OF-->~a EDGES FOUND" (length drug-inc-molecular-entity-activators/edges) filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)

	  (newline)
          (displayln (format "PATTERN-MATCHING EDGES:\n~a-->ACTIVATES/INCREASES-EXPRESSION-OF-->~a-->ACTIVATES/INCREASES-EXPRESSION-OF-->~a EDGES FOUND" filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (define drug-inc-molecular-entity-activators/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-inc-molecular-entity-activators/edges '()))))

	  (define indirect-drug-activators/edges
	    (append
	     (remove-duplicates drug-dec-molecular-entity-inhibitors/edges)
	     (remove-duplicates drug-inc-molecular-entity-activators/edges)))	  

	  (define indirect-drug-activators/export-edges
	    (append
	     (remove-duplicates drug-dec-molecular-entity-inhibitors/export-edges)
	     (remove-duplicates drug-inc-molecular-entity-activators/export-edges)))

	  (define indirect-drug-activators/export-edges/for-intersection
	    (flatten indirect-drug-activators/export-edges))

	  (newline)
	  (displayln
	   (format "BEGINNING INDIRECT DRUG INHIBITOR QUERY:\n[[~a]] --> INHIBITS/DECREASES EXPRESSION OF --> [~a] --> ACTIVATES/INCREASES EXPRESSION OF --> ~a" filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (match-define
	   (list drug-dec-mol-entity-activators=>concepts drug-dec-mol-entity-activators=>edges)
	   (time
	    (run/graph
	     ((Q drugs) 
	      (molecular-entity-activators/concepts molecular-entity-activators/concepts))
	     ((Q->dec decreases))
	     (Q Q->dec molecular-entity-activators/concepts))))

	  (define drug-dec-molecular-entity-activators/edges (hash-ref drug-dec-mol-entity-activators=>edges 'Q->dec))
          
	  (newline)
	  (displayln
	   (format "~a [[~a]] --> INHIBITS/DECREASES EXPRESSION OF --> [~a] --> ACTIVATES/INCREASES EXPRESSION OF --> ~a EDGES FOUND" (length drug-dec-molecular-entity-activators/edges) filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (newline)
	  (displayln
	   (format "PATTERN-MATCHING EDGES:\n[[~a]] --> INHIBITS/DECREASES EXPRESSION OF --> [~a] --> ACTIVATES/INCREASES EXPRESSION OF --> ~a" filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (define drug-dec-molecular-entity-activators/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-dec-molecular-entity-activators/edges '()))))
	  
	  (newline)
	  (displayln
	   (format "BEGINNING INDIRECT DRUG INHIBITOR QUERY:\n[[~a]] --> ACTIVATES/INCREASES EXPRESSION OF --> [~a] --> INHIBIT/DECREASES EXPRESSION OF --> ~a" filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (match-define
	   (list drug-inc-mol-entity-inhibitors=>concepts drug-inc-mol-entity-inhibitors=>edges)
	   (time
	    (run/graph
	     ((H drugs) 
	      (molecular-entity-inhibitors/concepts molecular-entity-inhibitors/concepts))
	     ((H->inc increases))
	     (H H->inc molecular-entity-inhibitors/concepts))))

	  (define drug-inc-molecular-entity-inhibitors/edges (hash-ref drug-inc-mol-entity-inhibitors=>edges 'H->inc))

          (newline)
	  (displayln
	   (format "~a [[~a]] --> ACTIVATES/INCREASES EXPRESSION OF --> [~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a EDGES FOUND" (length drug-inc-molecular-entity-inhibitors/edges) filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)
	  
	  (newline)
	  (displayln
	   (format "PATTERN-MATCHING EDGES:\n[[~a]] --> ACTIVATES/INCREASES EXPRESSION OF --> [~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a" filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
	  (newline)

	  (define drug-inc-molecular-entity-inhibitors/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-inc-molecular-entity-inhibitors/edges '()))))

	  (define indirect-drug-inhibitors/edges
	    (append
	     (remove-duplicates drug-dec-molecular-entity-activators/edges)
	     (remove-duplicates drug-inc-molecular-entity-inhibitors/edges)))

	  ;; list of trimmed export edges for indirect drug inhibitors
	  (define indirect-drug-inhibitors/export-edges
	    (append
	     (remove-duplicates drug-dec-molecular-entity-activators/export-edges)
	     (remove-duplicates drug-inc-molecular-entity-inhibitors/export-edges)))

	  (define indirect-drug-inhibitors/export-edges/for-intersection
	    (flatten indirect-drug-inhibitors/export-edges))
	  
	  (define indirect-drug-activators/inhibitors-of-target-gene/export-edges
	    (append
	     (remove-duplicates indirect-drug-activators/export-edges)
	     (remove-duplicates indirect-drug-inhibitors/export-edges)))
	  
	  (export-column-headers
	   COLUMN_HEADERS_2-HOP
	   2-hop_indirect-drug-activators+inhibitors->target-gene/port
	   2-hop_indirect-drug-activators+inhibitors->target-gene/path)
	  
	  (outer-loop
	   indirect-drug-activators/inhibitors-of-target-gene/export-edges
	   2-hop_indirect-drug-activators+inhibitors->target-gene/port)
	  
	  (newline)
	  (displayln
	   (format "BEGINNING 1-HOP QUERY FOR DIRECT ~a INHIBITORS OF ~a:\n[~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a" filtered-X-drug genetic_variant-name-ls filtered-X-drug genetic_variant-name-ls))
	  (newline)
       
	  (match-define
	   (list drug-dec-gene=>concepts drug-dec-gene=>edges)
	   (time
	    (run/graph
	     ((B drugs) 
	      (gene-concept-ls gene-concept-ls))
	     ((B->dec decreases))
	     (B B->dec gene-concept-ls))))

	  (define drug-dec-gene-list/edges (hash-ref drug-dec-gene=>edges 'B->dec))

	  (newline)
	  (displayln (format "~a [~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a EDGES FOUND" (length drug-dec-gene-list/edges) filtered-X-drug  genetic_variant-name-ls))
	  (newline)

	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n[~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a" filtered-X-drug genetic_variant-name-ls))
	  (newline)

	  (define drug-dec-o/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-dec-gene-list/edges '()))))

	  (newline)
	  (displayln (format "BEGINNING 1-HOP QUERY FOR ~a:\n [~a] --> ACTIVATES/INCREASES EXPRESSION OF --> ~a" genetic_variant-name-ls filtered-X-drug genetic_variant-name-ls))
	  (newline)
      
	  (match-define
	   (list y-inc-gene=>concepts y-inc-gene=>edges)
	   (time
	    (run/graph
	     ((Y drugs)
	      (gene-concept-ls gene-concept-ls))
	     ((Y->inc increases))
	     (Y Y->inc gene-concept-ls))))
      
	  (define drug-inc-gene-list/edges (hash-ref y-inc-gene=>edges 'Y->inc))
	  
	  (newline)
	  (displayln (format "~a [~a] --> ACTIVATES/INCREASES EXPRESSION OF --> ~a EDGES FOUND" (length drug-inc-gene-list/edges) filtered-X-drug  genetic_variant-name-ls))
	  (newline)

	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n[~a] --> ACTIVATES/INCREASES EXPRESSION OF --> ~a" filtered-X-drug genetic_variant-name-ls))
	  (newline)
       
	  (define drug-inc-o/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-inc-gene-list/edges '()))))

	  (define direct-drug-activators/inhibitors-of-target-gene
	    (append (remove-duplicates drug-dec-o/export-edges) (remove-duplicates drug-inc-o/export-edges)))

	  (define drug-dec-o/export-edges/for-intersection
	    (flatten drug-dec-o/export-edges))

	  (define drug-inc-o/export-edges/for-intersection
	    (flatten drug-inc-o/export-edges))
	  
	  #|combined direct+indirect drug regulator logic|#
	  (define combined_direct+indirect-drug-upregulator?
	    (lambda (ls)
	      (and (member? (list-ref ls 1) drug-inc-o/export-edges/for-intersection)
		   (member? (list-ref ls 1) indirect-drug-activators/export-edges/for-intersection))))
 
	  (define combined_direct+indirect-drug-downregulator?
	    (lambda (ls)
	      (and (member? (list-ref ls 1) drug-dec-o/export-edges/for-intersection)
		   (member? (list-ref ls 1) indirect-drug-inhibitors/export-edges/for-intersection))))
	  
	  #|indirect drug regulator logic|#
	  
	  (define indirect-drug-upreglator?
	    (lambda (ls)
	      (member? (list-ref ls 1) indirect-drug-activators/export-edges/for-intersection)))
	  
	  (define indirect-drug-downregulator?
	    (lambda (ls)
	      (member? (list-ref ls 1) indirect-drug-inhibitors/export-edges/for-intersection)))

	  #|direct drug regulator logic|#
	
	  (define direct-drug-upregulator?
	    (lambda (ls)
	      (member? (list-ref ls 1) drug-inc-o/export-edges/for-intersection)))
		
	  (define direct-drug-downregulator?
	    (lambda (ls)
	      (member? (list-ref ls 1) drug-dec-o/export-edges/for-intersection)))
	  
	  (define combined_direct+indirect-drug-up/downregulator?
	    (lambda (ls)
	      (or 
	       (and (member? (list-ref ls 1) drug-inc-o/export-edges/for-intersection)
		    (member? (list-ref ls 1) indirect-drug-activators/export-edges/for-intersection))
	       (and (member? (list-ref ls 1) drug-dec-o/export-edges/for-intersection)
		    (member? (list-ref ls 1) indirect-drug-inhibitors/export-edges/for-intersection)))))

	  (define outer-loop/combined-direct/indirect-drugs-ls
	    (lambda (ls els-pr)
	      (cond
		((null? ls)
		 (remove-duplicates els-pr))
		((combined_direct+indirect-drug-up/downregulator? (car ls))
		 (outer-loop/combined-direct/indirect-drugs-ls
		  (cdr ls)
		  (cons (car ls) els-pr)))
		(else
		 (outer-loop/combined-direct/indirect-drugs-ls (cdr ls) els-pr)))))
	  
	  (define direct/indirect-drug-edges-export
	    (append direct-drug-activators/inhibitors-of-target-gene
		    indirect-drug-activators/inhibitors-of-target-gene/export-edges))

	  (define filtered-direct/indirect-drug-edges-export
	    (outer-loop/combined-direct/indirect-drugs-ls direct/indirect-drug-edges-export '()))

	  (export-column-headers
	   COLUMN_HEADERS_2-HOP
	   2-hop_combined-direct+indirect_drug-activators+inhibitors->target-gene/port
	   2-hop_combined-direct+indirect_drug-activators+inhibitors->target-gene/path)
	  
	  (outer-loop
	   filtered-direct/indirect-drug-edges-export
	   2-hop_combined-direct+indirect_drug-activators+inhibitors->target-gene/port)
	  
	  (export-column-headers
	   COLUMN_HEADERS_1-HOP
	   1-hop_direct-drug-activators+inhibitors->target-gene/port
	   1-hop_direct-drug-activators+inhibitors->target-gene/path)

	  (outer-loop
	   direct-drug-activators/inhibitors-of-target-gene
	   1-hop_direct-drug-activators+inhibitors->target-gene/port)

	  #|--- [disease/phenotype] --> predicate --> target-gene ---|#
	  
	  (newline)
	  (displayln (format "BEGINNING 1-HOP DISEASE-TO-GENE ASSOCIATION QUERY FOR ~a:\n[~a] --> ASSOCIATED-WITH/INCREASES EXPRESSION OF --> ~a" genetic_variant-name-ls filtered-X-disease genetic_variant-name-ls))
	  (newline)
	  
	  (match-define
	   (list disease-associated-with-gene=>concepts disease-associated-with-gene=>edges)
	   (time
	    (run/graph
	     ((gene-concept-ls gene-concept-ls)
	      (disease disease))
	     ((disease-1->associated-with increases))
	     (disease disease-1->associated-with gene-concept-ls))))
	  
	  (define disease_associated_with_gene-list/edges (hash-ref disease-associated-with-gene=>edges 'disease-1->associated-with))

	  (newline)
	  (displayln (format "~a [~a] --> ASSOCIATED-WITH/INCREASES EXPRESSION OF --> ~a EDGES FOUND" (length disease_associated_with_gene-list/edges) filtered-X-disease genetic_variant-name-ls))
	  (newline)

	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n[~a] --> ASSOCIATED-WITH/INCREASES EXPRESSION OF --> ~a EDGES" filtered-X-disease genetic_variant-name-ls))
	  (newline)
       
	  (define disease_associated_with_gene-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       disease_associated_with_gene-list/edges '()))))

	  (newline)
	  (displayln (format "BEGINNING DISEASE-TO-GENE ASSOCIATION QUERY FOR ~a:\n[~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a" genetic_variant-name-ls filtered-X-disease genetic_variant-name-ls))
	  (newline)
	  
	  (match-define
	   (list disease-dec-gene=>concepts disease-dec-gene=>edges)
	   (time
	    (run/graph
	     ((gene-concept-ls gene-concept-ls)
	      (disease disease))
	     ((disease-1->dec decreases))
	     (disease disease-1->dec gene-concept-ls))))
	  
	  (define disease_dec_gene-list/edges (hash-ref disease-dec-gene=>edges 'disease-1->dec))

	  (newline)
	  (displayln (format "~a ~a-->DECREASES/INHIBITS-->~a EDGES FOUND" (length disease_dec_gene-list/edges) filtered-X-disease genetic_variant-name-ls))
	  (newline)

	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n[~a] --> INHIBITS/DECREASES EXPRESSION OF --> ~a" filtered-X-disease genetic_variant-name-ls))
	  (newline)
       
	  (define disease_dec_gene-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       disease_dec_gene-list/edges '()))))

	  (define disease_associated_with_and_inhibits_target-gene/export-edges
	    (append disease_associated_with_gene-list/export-edges
		    disease_dec_gene-list/export-edges))

	  (export-column-headers
	   COLUMN_HEADERS_1-HOP_disease->assoc->gene
	   1-hop_disease->assoc/inc_decreases->target-gene/port
	   1-hop_disease->assoc/inc_decreases->target-gene/path)
	  
	  (outer-loop
	   disease_associated_with_and_inhibits_target-gene/export-edges
	   1-hop_disease->assoc/inc_decreases->target-gene/port)


          #| #TARGET-GENE# --> INHIBITS/DECREASES --> [ GENE/MOLECULAR-ENTITY ] |#

          (newline)
	  (displayln (format "BEGINNING 1-HOP QUERY FOR ~a:\n~a --> INHIBITS/DECREASES EXPRESSION OF --> [~a]" genetic_variant-name-ls genetic_variant-name-ls filtered-X-molecular_entity))
	  (newline)
	  
	  (match-define
	   (list g1-dec-gene=>concepts g1-dec-gene=>edges)
	   (time
	    (run/graph
	     ((gene-concept-ls gene-concept-ls)
	      (G1 molecular_entity))
	     ((G1->dec decreases))
	     (gene-concept-ls G1->dec G1))))
       
	  (define total_LOF_gene-decreases-molecular_entity-list/edges (hash-ref g1-dec-gene=>edges 'G1->dec))
	  (define total_LOF_gene-decreases-molecular_entity-list/concepts-from-query
	    (remove-duplicates (hash-ref g1-dec-gene=>concepts 'G1)))
	  
	  (newline)
	  (displayln (format "~a ~a --> INHIBITS/DECREASES EXPRESSION OF --> ~a EDGES FOUND" (length total_LOF_gene-decreases-molecular_entity-list/edges) genetic_variant-name-ls filtered-X-molecular_entity))
	  (newline)
       
	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n~a --> INHIBITS/DECREASES EXPRESSION OF --> [~a]" genetic_variant-name-ls filtered-X-molecular_entity))
	  (newline)
          	  	  
	  (define total_LOF_gene-decreases-molecular_entity-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       total_LOF_gene-decreases-molecular_entity-list/edges '()))))

	  (newline)
	  (displayln (format "BEGINNING 1-HOP QUERY FOR ~a:\n~a --> ACTIVATES/INCREASES EXPRESSION OF --> [~a]" genetic_variant-name-ls genetic_variant-name-ls filtered-X-molecular_entity))
	  (newline)
	  
	  (match-define
	   (list g2-inc-gene=>concepts g2-inc-gene=>edges)
	   (time
	    (run/graph
	     ((gene-concept-ls gene-concept-ls)
	      (G2 molecular_entity))
	     ((G2->inc increases))
	     (gene-concept-ls G2->inc G2))))
	  
	  (define total_LOF_gene-increases-molecular_entity-list/edges (hash-ref g2-inc-gene=>edges 'G2->inc))
	  (define total_LOF_gene-increases-molecular_entity-list/concepts-from-query
	    (remove-duplicates (hash-ref g2-inc-gene=>concepts 'G2)))
	  
	  (newline)
	  (displayln (format "~a ~a --> ACTIVATES/INCREASES EXPRESSION OF --> ~a EDGES FOUND" (length total_LOF_gene-increases-molecular_entity-list/edges) genetic_variant-name-ls filtered-X-molecular_entity))
	  (newline)
       
	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n~a --> ACTIVATES/INCREASES EXPRESSION OF --> [~a]" genetic_variant-name-ls filtered-X-molecular_entity))
	  (newline)

	  (define total_LOF_gene-increases-molecular_entity-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       total_LOF_gene-increases-molecular_entity-list/edges '()))))

	  (define total_LOF_target-gene->increases/decreases->molecular-entity/export-edges
	    (append total_LOF_gene-decreases-molecular_entity-list/export-edges
		    total_LOF_gene-increases-molecular_entity-list/export-edges))

	  (export-column-headers
	   COLUMN_HEADERS_TOTAL_LOF_1-HOP_GENE_REGULATORS
	   1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/port
	   1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/path)
	  
	  (outer-loop
	   total_LOF_target-gene->increases/decreases->molecular-entity/export-edges
	   1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/port)

	  #|--BEGINNING 2-HOP DRUG->INC/DEC-->GENES AFFECTED BY TOTAL-LOF OF TARGET-GENE|#

          (newline)
          (displayln (format "BEGINNING 2-HOP QUERY FOR ~a\n[[~a]] --> ACTIVATES/INCREASES EXPRESSION OF --> [~a] --> ACTIVATED/UP-REGULATED BY ~a\n[[~a]] --> INHIBITS/DECREASES EXPRESSION OF --> [~a] --> INHIBITED/DOWN-REGULATED BY ~a" genetic_variant-name-ls filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)
          
	  (match-define
	   (list D-1-inc-gene=>concepts D-1-inc-gene=>edges)
	   (time
	    (run/graph
	     ((total_LOF_gene-increases-molecular_entity-list/concepts-from-query
	       total_LOF_gene-increases-molecular_entity-list/concepts-from-query)
	      (D-1 drugs))
	     ((D-1->inc increases))
	     (D-1 D-1->inc total_LOF_gene-increases-molecular_entity-list/concepts-from-query))))
	  
	  (define drug->increases->molecular_entity->increased-by-target-gene/edges (hash-ref D-1-inc-gene=>edges 'D-1->inc))

          (newline)
          (displayln (format "~a [[~a]] --> ACTIVATES/INCREASES EXPRESSION OF --> [~a] --> ACTIVATED/UP-REGULATED BY --> ~a EDGES FOUND" (length drug->increases->molecular_entity->increased-by-target-gene/edges) filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)

          (newline)
          (displayln (format "PATTERN-MATCHING EDGES:\n [[~a]] --> ACTIVATES/INCREASES EXPRESSION OF --> [~a] --> ACTIVATED/UP-REGULATED BY --> ~a EDGES FOUND"  filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)

	  (define drug->increases->molecular_entity->increased-by-target-gene/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug->increases->molecular_entity->increased-by-target-gene/edges '()))))
	  	   
	  (match-define
	   (list D-2-dec-gene=>concepts D-2-dec-gene=>edges)
	   (time
	    (run/graph
	     ((total_LOF_gene-decreases-molecular_entity-list/concepts-from-query
	       total_LOF_gene-decreases-molecular_entity-list/concepts-from-query)
	      (D-2 drugs))
	     ((D-2->dec decreases))
	     (D-2 D-2->dec total_LOF_gene-decreases-molecular_entity-list/concepts-from-query))))
	  
	  (define drug->decreases->molecular_entity->decreased-by-target-gene/edges (hash-ref D-2-dec-gene=>edges 'D-2->dec))

          (newline)
          (displayln (format "~a [[~a]] --> INHIBITS/DECREASES EXPRESSION OF --> [~a] --> INHIBITED/DOWN-REGULATED BY --> ~a EDGES FOUND" (length drug->decreases->molecular_entity->decreased-by-target-gene/edges) filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)

          (newline)
          (displayln (format "PATTERN-MATCHING EDGES:\n [[~a]] --> INHIBITS/DECREASES EXPRESSION OF --> [~a] --> INHIBITED/DOWN-REGULATED BY --> ~a EDGES FOUND" filtered-X-drug filtered-X-molecular_entity genetic_variant-name-ls))
          (newline)


	  (define drug->decreases->molecular_entity->decreased-by-target-gene/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug->decreases->molecular_entity->decreased-by-target-gene/edges '()))))

	  (define drug->increases/decreases->genes-regulated-by-target-gene/export-edges
	    (append drug->decreases->molecular_entity->decreased-by-target-gene/export-edges
		    drug->increases->molecular_entity->increased-by-target-gene/export-edges))
	  
	  
	  (export-column-headers
	   COLUMN_HEADERS_TOTAL_LOF_2-HOP_GENE_REGULATORS
	   2-hop_total-loss-of-function_drugs->up/downregulate->genes-regulated-by-target-gene/port
	   2-hop_total-loss-of-function_drugs->up/downregulate->genes-regulated-by-target-gene/path)

	  (outer-loop
	   drug->increases/decreases->genes-regulated-by-target-gene/export-edges
	   2-hop_total-loss-of-function_drugs->up/downregulate->genes-regulated-by-target-gene/port)


	  #|--- target-gene --> predicate --> [disease/phenotype] ---|#
	  	  
	  (newline)
	  (displayln (format "BEGINNING GENE ASSOCIATED-WITH DISEASE/PHENOTYPE QUERY FOR ~a:\n~a --> ASSOCIATED-WITH/CAUSES --> [~a]" genetic_variant-name-ls genetic_variant-name-ls filtered-X-disease))
	  (newline)
	  
	  (match-define
	   (list gene-associated-with-disease=>concepts gene-associated-with-disease=>edges)
	   (time
	    (run/graph
	     ((gene-concept-ls gene-concept-ls)
	      (disease disease))
	     ((gene-1->associated-with increases))
	     (gene-concept-ls gene-1->associated-with disease))))
	  
	  (define gene_associated_with_disease-list/edges (hash-ref gene-associated-with-disease=>edges 'gene-1->associated-with))

	  (newline)
	  (displayln (format "~a ~a --> ASSOCIATED-WITH/CAUSES --> [~a] EDGES FOUND" (length gene_associated_with_disease-list/edges) genetic_variant-name-ls filtered-X-disease))
	  (newline)

	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n~a --> ASSOCIATED-WITH/CAUSES --> [~a]" genetic_variant-name-ls filtered-X-disease))
	  (newline)
       
	  (define gene_associated_with_disease-list/export-edges 
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       gene_associated_with_disease-list/edges '()))))

	  (newline)
	  (displayln (format "BEGINNING DISEASE/SYMPTOM QUERY FOR ~a:\n~a --> DECREASES/PREVENTS/TREATS --> [~a]" genetic_variant-name-ls genetic_variant-name-ls filtered-X-disease))
	  (newline)
	  
	  (match-define
	   (list gene-decreases/prevents-disease=>concepts gene-decreases/prevents-disease=>edges)
	   (time
	    (run/graph
	     ((gene-concept-ls gene-concept-ls)
	      (disease disease))
	     ((gene-1->decreases/prevents decreases))
	     (gene-concept-ls gene-1->decreases/prevents disease))))
	  
	  (define gene_decreases/prevents_disease-list/edges (hash-ref gene-decreases/prevents-disease=>edges 'gene-1->decreases/prevents))

	  (newline)
	  (displayln (format "~a ~a --> DECREASES/PREVENTS/TREATS --> [~a] EDGES FOUND" (length gene_decreases/prevents_disease-list/edges) genetic_variant-name-ls filtered-X-disease))
	  (newline)

	  (newline)
	  (displayln (format "PATTERN-MATCHING EDGES:\n~a --> DECREASES/PREVENTS/TREATS --> [~a] EDGES" genetic_variant-name-ls filtered-X-disease))
	  (newline)
       
	  (define gene_decreases/prevents_disease-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       gene_decreases/prevents_disease-list/edges '()))))


	  (define gene_associated-with_and_decreases/prevents_disease-list/export-edges
	    (append gene_decreases/prevents_disease-list/export-edges
		    gene_associated_with_disease-list/export-edges))

	  (export-column-headers
	   COLUMN_HEADERS_1-HOP_target-gene->predicate->disease/phenotype
	   1-hop_target-gene_associated-with_and_decreases/prevents_disease-list/port
	   1-hop_target-gene_associated-with_and_decreases/prevents_disease-list/path)
	  
	  (outer-loop
	   gene_associated-with_and_decreases/prevents_disease-list/export-edges
	   1-hop_target-gene_associated-with_and_decreases/prevents_disease-list/port)
	   
	  
	  #|--- END OF TOTAL LOF QUERY ---|#	  

         
          #|[genes] --> causally-related-to --> Disease |#
          
#|
         
          (newline)
	  (displayln (format "BEGINNING GENE-TO-DISEASE ASSOCIATION QUERY FOR ~a:\n~a-->ASSOCIATED-WITH/CAUSALLY RELATED TO-->~a" filtered-X-disease filtered-X-molecular_entity filtered-X-disease))
	  (newline)
	  
	  (match-define
	   (list gene-associated-with-disease=>concepts gene-associated-with-disease=>edges)
	   (time
	    (run/graph
             ((disease-concept-list diagnosis-curie-ls)
	      (molecular-entity molecular-entity))
	     ((disease-1->associated-with increases))
	     (molecular-entity disease-1->associated-with disease-concept-list))))
	  
	  (define molecular-entity-associated-with-disease-list/edges (hash-ref gene-associated-with-disease=>edges 'disease-1->associated-with))

	  (newline)
	  (displayln (format "~a ~a-->ASSOCIATED-WITH/CAUSES-->~a EDGES FOUND" (length molecular-entity-associated-with-disease-list/edges) filtered-X-molecular_entity diagnosis-name-ls))
	  (newline)

	  (newline)
	  (displayln (format "PATTERN-MATCHING\n~a-->ASSOCIATED-WITH/CAUSES-->~a EDGES" filtered-X-molecular_entity diagnosis-name-ls))
	  (newline)
       
	  (define molecular-entity-associated-with-disease-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
          molecular-entity-associated-with-disease-list/edges '()))))
          
|#          
          (newline)
          (displayln (format "CASE COMPLETE:~a" pmi-case-number-ls))
          (newline)
          
	  ))))))

(start-function
 record-assoc-ls)


#|
(define outer-loop/csv
  (lambda (ls port)
    (cond
      ((null? ls)
       (close-output-port port))
      (else
       (inner-loop (car ls) port)
       (fprintf port (format "~c" #\newline))
-loop (cdr ls) port)))))

(define inner-loop/csv
  (lambda (ls port)
    (cond
      ((null? ls) (void))
      (else
       (fprintf port "~a~c" (car ls) #\,)
       (inner-loop (cdr ls) port)))))

(define input-file/port
  (find-system-path 'home-dir))

(define input-file/path
  (format "~a/automated_mk_query_input_file/" (path->string input/port)))

(define make-input-file-directory
  (if (directory-exists? input-file/path)
      (error (format "AUTOMATED-MEDIKANREN-INUPUT-FILE DIRECTORY ALREADY EXISTS:~a" input-file/path))
      (make-directory input-file/path)))

(define make-input-file
  (open-output-file input-file/path
|#




#|
(define build-concepts/inner-loop
  (lambda (ls)
    (list
     (cons
      (list-ref pmi-patient-record-headers 0)
      (list-ref ls 0))
     (cons
      (list-ref pmi-patient-record-headers 1)
      (list-ref ls 1))
     (cons
      (list-ref pmi-patient-record-headers 2)
      (list-ref ls 2))
     (cons
      (list-ref pmi-patient-record-headers 3)
      (list-ref ls 3))
     (cons
      (list-ref pmi-patient-record-headers 4)
      (list-ref ls 4))
     (cons
      (list-ref pmi-patient-record-headers 5)
      (list-ref ls 5))
     (cons
      (list-ref pmi-patient-record-headers 6)
      (list-ref ls 6))
     (cons
      (list-ref pmi-patient-record-headers 7)
      (list-ref ls 7))
     (cons
      (list-ref pmi-patient-record-headers 8)
      (list-ref ls 8)))))

(define build-concepts
  (lambda (ls els)
    (cond
      ((null? ls) (reverse els))
      (else 
       (build-concepts
        (cdr ls)
        (cons (build-concepts/inner-loop (car ls)) els))))))


(define build-curie
  (lambda (ls assoc-key)    
    (remove-item
     "_"
     (map cdr (map (lambda (ls) (assoc assoc-key ls)) ls)) '())))
 
#|CONVERTS ROWS OF INPUT FILE INTO ASSOCIATION LIST FOR EACH PAITENT RECORD|#

(define pmi-patient-concept-association-ls
  (build-concepts
   pmi-records
   '()))

(define record-id-ls
  (map (lambda (ls)
         (assoc "pmi_id" ls)) pmi-patient-concept-association-ls))

(define pmi-case-number-ls
  (build-curie pmi-patient-concept-association-ls "pmi_id"))
(define symptom-name-ls
  (build-curie pmi-patient-concept-association-ls "symptom"))
(define symptom-curie-ls
  (build-curie pmi-patient-concept-association-ls "symptom_id"))
(define diagnosis-name-ls
  (build-curie pmi-patient-concept-association-ls "diagnosis"))
(define diagnosis-curie-ls
  (build-curie pmi-patient-concept-association-ls "diagnosis_id"))
(define medication-name-ls
  (build-curie pmi-patient-concept-association-ls "medication"))
(define medication-curie-ls
  (build-curie pmi-patient-concept-association-ls "medication_id"))
(define genetic_variant-name-ls
  (build-curie pmi-patient-concept-association-ls "genetic_variant"))
(define genetic_variant-curie-ls
  (build-curie pmi-patient-concept-association-ls "genetic_variant_id"))



|#

#|
read-tsv 

(define port->list/read-char
  (lambda (port els)
    (let ((next-char (read-char port)))
      (if (eof-object? next-char)
          els
          (port->list/read-char
           port
           (cons next-char els))))))

(define input-file/read-char
  (reverse (port->list/read-char input-file '())))

(define parse-row-loop
  (lambda (char-ls els-element els-row)
    (cond
      ((null? char-ls)
       (reverse els-row))
      ((not (equal? (car char-ls) #\newline))
       (parse-row-loop
        (cdr char-ls)
        (cons (car char-ls) els-element)
        els-row))
      (else
       (parse-row-loop
        (cdr char-ls)
        '()
        (cons (string-split (list->string (reverse els-element)) "\t") els-row))))))
 
(define pmi-records
  (parse-row-loop input-file/read-char '() '()))

(define check/convert-input-record-format
  (lambda (in-ls)
    (if (equal? (car in-ls) pmi-patient-record-headers)
        (cdr in-ls)
        (error (format "INPUT-FILE FORMAT ERROR AT ~a" (car in-ls))))))

(define pmi-patient-concepts-for-query
  (check/convert-input-record-format pmi-patient-record))
|#

#|
(define pmi-patient-concept-association-ls
  (build-concepts
   pmi-patient-concepts-for-query
   '()))
|#





#|
;; Greg's code on csv reading
(define *field-separator* #\,)
 
(define (set-field-separator! ch) (set! *field-separator* ch))

(define end-of-record?!
  (lambda (in)
    (define ch (peek-char in))
    (or (and (char=? #\return ch)
             (or (and (char=? #\newline (peek-char in 1)) (read-string 2 in) #t)
                 (and (read-char in) #t)))
        (and (char=? #\newline ch) (read-char in) #t)
        (eof-object? ch))))

(define (field-separator?! in)
  (define ch (peek-char in))
  (and (char=? *field-separator* ch) (read-char in) #t))

(define (end-of-field?! in)
  (define ch (peek-char in))
  (or (char=? *field-separator* ch)
      (char=? #\return ch) (char=? #\newline ch) (eof-object? ch)))

(define (field-quoted-begin?! in)
  (define ch (peek-char in))
  (and (char=? #\" ch) (read-char in) #t))

(define (field-quoted-end?! in)
  (define ch (peek-char in))
  (and (char=? #\" ch) (read-char in) (not (char=? #\" (peek-char in)))))


(define (csv-records in)
  (define (next-record)
    (and (not (eof-object? (peek-char in)))
         (let record ((continue? #t))
           (if continue?
             (cons (list->string
                     (let field ()
                       (cond ((end-of-field?! in) '())
                             ((field-quoted-begin?! in)
                              (let field-quoted ()
                                (if (field-quoted-end?! in) (field)
                                  (cons (read-char in) (field-quoted)))))
                             (else (cons (read-char in) (field))))))
                   (record (field-separator?! in)))
             (if (end-of-record?! in) '() (error "malformed csv"))))))
  (define current #f)
  (lambda (request)
    (case request
      ((current) current)
      ((next) (set! current (next-record)) current)
      (else (error "invalid csv-records request:" request)))))
|#

