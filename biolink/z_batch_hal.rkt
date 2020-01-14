#lang racket
(provide (all-defined-out)
         (all-from-out "common.rkt" "mk-db.rkt"))
(require "common.rkt" "mk-db.rkt")
(require racket/date)

#|
;;TODO: CREATE INPUT FILE STRUCTURE FOR DISEASE/MEDICATION/SYMPTOM/GENE-VARIANT QUERIES 
(define input-file (open-input-file "/home/mjpatton/PhD/CaseReviews/test_prototype_files/pmi_case_record_template.csv" ))

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
|#

#|
(define pmi-patient-record
  (parse-row-loop input-file/read-char '() '()))

(define pmi-case-number-ls
  (list (list-ref (list-ref pmi-patient-record 1) 0)))

(define curie-symbol-ls
  (list (list-ref (list-ref pmi-patient-record 1) 7)))

(define curie-id-ls
  (list (list-ref (list-ref pmi-patient-record 1) 8)))
|#


(define pmi-case-number-ls
  '(forOsborne))

(define curie-symbol-ls
  '(TREM2))

(define hgnc-id-ls/num
  (remove-duplicates
   (map number->string
	'(17761))))

(define curie-id-ls
  (map (lambda (ls)
	 (string-append "HGNC:" ls))
       hgnc-id-ls/num))

#|
alzheimer's disease
"UMLS:C0002395"
"OMIM:104300"
"MONDO:0004975"
"OMIA:000033"
"MONDO:0007088"
|#



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

(define set-difference
  (lambda (ls1 ls2)
    (cond
      ((null? ls1) '())
      ((member? (car ls1) ls2)
       (set-difference (cdr ls1) ls2))
      (else
       (cons (car ls1)
	     (set-difference (cdr ls1) ls2))))))

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
      ((string-contains? (car ls) "ClinVarVariant")
       (prune-xrefs (cdr ls) els))
      ((string-contains? (car ls) "MTH:NOCODE")
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

(define prune-xrefs/outliers
  (lambda (ls els)
    (cond
      ((null? ls) els)
      ((or
	(void? (car ls))
	(not (string-contains? (car ls) ":"))
	(string-contains? (car ls) "Genes")
	(string-contains? (car ls) "MTH:NOCODE")
	(string-contains? (car ls) "UMLS:C0017337"))
       (prune-xrefs/outliers (cdr ls) els))
      ((string-contains? (car ls) "HGNC:HGNC")
       (prune-xrefs/outliers
	(cdr ls)
	(cons (string-replace (car ls) "HGNC:HGNC:" "HGNC:")
	      els)))
      ((string-contains? (car ls) "NCBI")
       (prune-xrefs/outliers (cdr ls)
		    (cons 
		     (string-replace (car ls) "NCBIGENE:" "NCBIGene:") els)))
      (else
       (prune-xrefs/outliers (cdr ls) (cons (car ls) els))))))

(define extract-name/concept
  (lambda (query-ls els)
    (cond
      ((null? query-ls) (set-union els))
      (else 
       (match (car query-ls)
	      [`(,db ,cui ,id ,name ,category ,properties-list)
	       (extract-name/concept (cdr query-ls)
				  (set-union
				   (list name) els))]
	      [`(,db ,edge-cui
		     (,subject-cui ,subject-id ,subject-name (,_ . ,subject-category) ,subject-props-assoc)
		     (,concept-cui ,concept-id ,concept-name (,_ . ,concept-category) ,concept-props-assoc)
		     (,_ . ,pred)
		     ,pred-props-assoc)
	       (extract-name/concept (cdr query-ls)
				  (set-union
				   (list subject-name) els))])))))

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

(define get-concept-xrefs/2-hop
  (lambda (query-ls els)
    (cond
      ((null? query-ls) (set-union els))
      (else 
       (match (car query-ls)
	      [`(,db ,cui ,id ,name ,category ,properties-list)
	       (get-concept-xrefs/2-hop (cdr query-ls)
				  (set-union
				   (list id
					 (get-xrefs orange-concept-key/same-as properties-list)
					 (get-xrefs orange-concept-key/synonym properties-list)
					 (get-xrefs semmed-concept-key/xrefs properties-list)
					 (get-xrefs robokop-concept-key/eq-id properties-list)
					 (get-assoc-value semmed-concept-key/id properties-list)) els))])))))

(define get-concept-xrefs-from-edges
  (lambda (query-ls els)
    (cond
      ((null? query-ls) (set-union els))
      (else 
       (match (car query-ls)
	      [`(,db ,edge-cui
		     (,subject-cui ,subject-id ,subject-name (,_ . ,subject-category) ,subject-props-assoc)
		     (,concept-cui ,concept-id ,concept-name (,_ . ,concept-category) ,concept-props-assoc)
		     (,_ . ,pred)
		     ,pred-props-assoc)
	       (get-concept-xrefs-from-edges (cdr query-ls)
				  (set-union
				   (list subject-id
					 subject-name
					 (get-xrefs orange-concept-key/same-as subject-props-assoc)
					 (get-xrefs orange-concept-key/synonym subject-props-assoc)
					 (get-xrefs semmed-concept-key/xrefs subject-props-assoc)
					 (get-xrefs robokop-concept-key/eq-id subject-props-assoc)
					 (get-assoc-value semmed-concept-key/id subject-props-assoc)) els))]
	     [`(,edge-cui
		    (,subject-cui ,subject-id ,subject-name (,_ . ,subject-category) ,subject-props-assoc)
		    (,concept-cui ,concept-id ,concept-name (,_ . ,concept-category) ,concept-props-assoc)
		    (,_ . ,pred)
		    ,pred-props-assoc)
	      (get-concept-xrefs-from-edges (cdr query-ls)
				 (set-union
				  (list subject-id
					subject-name
					(get-xrefs orange-concept-key/same-as subject-props-assoc)
					(get-xrefs orange-concept-key/synonym subject-props-assoc)
					(get-xrefs semmed-concept-key/xrefs subject-props-assoc)
					(get-xrefs robokop-concept-key/eq-id subject-props-assoc)
					(get-assoc-value semmed-concept-key/id subject-props-assoc)) els))])))))

(define get-concept-xrefs-from-edges/2-hop
  (lambda (query-ls els curie-ls)
    (cond
      ((null? query-ls) (set-union els))
      (else 
       (match (car query-ls)
	      [`(,db ,edge-cui
		     (,subject-cui ,subject-id ,subject-name (,_ . ,subject-category) ,subject-props-assoc)
		     (,concept-cui ,concept-id ,concept-name (,_ . ,concept-category) ,concept-props-assoc)
		     (,_ . ,pred)
		     ,pred-props-assoc)
	       (cond
		 ((intersect?
		   (flatten
		    (list subject-id
			  (get-xrefs orange-concept-key/same-as subject-props-assoc)
			  (get-xrefs orange-concept-key/synonym subject-props-assoc)
			  (get-xrefs semmed-concept-key/xrefs subject-props-assoc)
			  (get-xrefs robokop-concept-key/eq-id subject-props-assoc)
			  (get-assoc-value semmed-concept-key/id subject-props-assoc)))
		   curie-ls)
		  (get-concept-xrefs-from-edges/2-hop (cdr query-ls)
						(set-union
						 (flatten
						  (list subject-id
							(get-xrefs orange-concept-key/same-as subject-props-assoc)
							(get-xrefs semmed-concept-key/xrefs subject-props-assoc)))
						 els) curie-ls))
		 (else 
		  (get-concept-xrefs-from-edges/2-hop (cdr query-ls) els curie-ls)))])))))

(define query-with-curie/str
  (lambda (ls els)
    (cond
      ((null? ls) (set-union els))
      ((atom? (car ls))
       (cond 
	 ((not (string-contains? (car ls) ":"))
	  (query-with-curie/str (cdr ls)
				(set-union
				 (find-concepts/options
				  #f #f 0 #f
				  (list (format "~a" (car ls))))
				 els)))
	 (else
	  (query-with-curie/str
	   (cdr ls)
	   (set-union (find-concepts #t (list (car ls))) els)))))
      (else
       (set-union 
	(query-with-curie/str (car ls) els)
	(query-with-curie/str (cdr ls) els))))))

(define suffix-ls
  '(" protein, human" " gene"))

;;test with string-append protein
(define query-with-curie/str/umls
  (lambda (ls els suffix-ls)
    (cond
      ((null? ls) (set-union els))
      ((atom? (car ls))
       (cond 
	 ((not (string-contains? (car ls) ":"))
	  (query-with-curie/str/umls (cdr ls)
				(set-union
				 (find-concepts/options
				   #f #f 0 #f
				   (list (format "~a" (car ls))))
				  (set-union 
				   (find-concepts/options
				    #f #f 0 #f
				    (list (string-append (format "~a" (car ls)) (car suffix-ls))))
				  (set-union 
				   (find-concepts/options
				    #f #f 0 #f
				    (list (string-append (format "~a" (car ls)) (cadr suffix-ls))))
				   els)))
				suffix-ls))
	 (else
	  (query-with-curie/str/umls (cdr ls)
				     (set-union (find-concepts #t (list (car ls))) els)
				     suffix-ls))))
      (else
       (set-union 
	(query-with-curie/str/umls (car ls) els suffix-ls)
	(query-with-curie/str/umls (cdr ls) els suffix-ls))))))


(define get-concept-xrefs/umls
  (lambda (query-ls els curie-ls)
    (cond
      ((null? query-ls) els)
      (else 
       (match (car query-ls)
	      [`(,db ,cui ,id ,name ,category ,properties-list)
	       (cond
		 ((intersect?
		  (flatten
		   (list id
			 (get-xrefs orange-concept-key/same-as properties-list)
			 (get-xrefs orange-concept-key/synonym properties-list)
			 (get-xrefs semmed-concept-key/xrefs properties-list)
			 (get-xrefs robokop-concept-key/eq-id properties-list)
			 (get-assoc-value semmed-concept-key/id properties-list)))
		  curie-ls)
		  (get-concept-xrefs/umls (cdr query-ls)
					  (set-union
					   (flatten
					    (list id
						  (get-xrefs orange-concept-key/same-as properties-list)
						  (get-xrefs semmed-concept-key/xrefs properties-list)))
					   els) curie-ls))
		 (else 
		  (get-concept-xrefs/umls (cdr query-ls) els curie-ls)))])))))


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

(define get-concept-xrefs/singleton
  (lambda (query)
    (match query
	   [`(,db ,cui ,id ,name ,category ,properties-list)
	    (list (get-xrefs orange-concept-key/same-as properties-list)
		  (get-xrefs orange-concept-key/synonym properties-list)
		  (get-xrefs semmed-concept-key/xrefs properties-list)
		  (get-xrefs robokop-concept-key/eq-id properties-list)
		  (get-assoc-value semmed-concept-key/id properties-list))])))

(define get-curies-from-concepts
  (lambda (ls)
    (match (ls)
	   [`(,db ,cui ,id ,name ,category ,properties-list)
	    (list id name)])))

(define get-hgnc-from-ls
  (lambda (ls els)
    (cond
      ((null? ls) els)
      ((or (boolean? (car ls))
	   (void? (car ls)))
       (get-hgnc-from-ls (cdr ls) els))
      ((and (equal? (regexp-match #rx"HGNC:[0-9]+" (car ls)) #f)
	    (equal? (regexp-match #rx"HGNC:HGNC:[0-9]+" (car ls)) #f))
       (get-hgnc-from-ls (cdr ls) els))
      (else
       (get-hgnc-from-ls (cdr ls)
			 (set-union (regexp-match #rx"HGNC:(.*)" (car ls)) els))))))

(newline)
(displayln "HELPER-FUNCTIONS LOADED, BEGINNING GENE-CONCEPT BUILDING")
(newline)

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

(define export-column-headers/csv
  (lambda (headers port path)
    (cond 
      ((= (file-size path) 0)
       (cond
	 ((null? headers)
	  (fprintf port "~c" #\newline))
	 (else
	  (fprintf port "~a~c" (car headers) #\,)
	  (export-column-headers/csv (cdr headers) port path))))
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
;; for large-batch
(define start-function
  (time 
   (lambda (pmi-case-number-ls curie-id-ls curie-symbol-ls)
     (cond
       ((null? curie-id-ls) (void))
       (else
	(handle pmi-case-number-ls (car curie-id-ls) curie-symbol-ls)
	(start-function pmi-case-number-ls (cdr curie-id-ls) curie-symbol-ls))))))
|#
;; for case-registry

(define start-function
  (time 
   (lambda (pmi-case-number-ls curie-id-ls curie-symbol-ls)
     (cond
       ((null? curie-id-ls) (void))
       (else
	(handle (car pmi-case-number-ls) (car curie-id-ls) (car curie-symbol-ls))
	(start-function (cdr pmi-case-number-ls) (cdr curie-id-ls) (cdr curie-symbol-ls)))))))

(define handle
  (time
   (lambda (pmi-case-number-ls curie-id-ls curie-symbol-ls)
     (cond 
       ((null? curie-id-ls) (void))
       (else
	(let* ((date (seconds->date (current-seconds)))
	       (export-date 
		(format "~a_~a_~a" 
			(number->string (date-month date))
			(number->string (date-day date))
			(number->string(date-year date))))
	       (export-path
		(cdr (assoc "automated_query_path" (config))))
	       (directory/path
		(format "~a~a_~a_~a/" export-path export-date pmi-case-number-ls curie-symbol-ls))
	       (make-export-directory
		(if (directory-exists? directory/path)
		    (error (format "ERROR IN EXPORT-DIRECTORY CREATION"))
		    (make-directory directory/path)))
	       (1-hop_molecular-entity-activators+inhibitors->target-gene/path
		(format			
		 "~a~a_1HOP_gene_activators_and_inhibitors_of_~a.tsv" directory/path pmi-case-number-ls curie-symbol-ls))
	       (1-hop_direct-drug-activators+inhibitors->target-gene/path
		(format			
		 "~a~a_1HOP_direct_drug_activators_and_inhibitors_of_~a.tsv" directory/path pmi-case-number-ls curie-symbol-ls))
	       (2-hop_indirect-drug-activators+inhibitors->target-gene/path
		(format			
		 "~a~a_2HOP_indirect_drug_activators_and_inhibitors_of_~a.tsv" directory/path pmi-case-number-ls curie-symbol-ls))
	       (2-hop_combined-direct+indirect_drug-activators+inhibitors->target-gene/path
		(format			
		 "~a~a_2HOP_combined_direct_and_indirect_drug_activators_and_inhibitors_~a.tsv" directory/path pmi-case-number-ls curie-symbol-ls))
	       (1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/path
		(format			
		 "~a~a_total_LOF_1_HOP_gene_up_and_down_regulated_by_~a.tsv" directory/path pmi-case-number-ls curie-symbol-ls))
	       (2-hop_total-loss-of-function_drugs->up/downregulate->genes-regulated-by-target-gene/path
		(format			
		 "~a~a_total_LOF_2_HOP_drug_up_and_downregulators_of_genes_regulated_by_~a.tsv"
		 directory/path pmi-case-number-ls curie-symbol-ls))
	       (1-hop_disease-assoc/inc->target-gene/path
		(format			
		 "~a~a_1HOP_diseases_associated_with_~a.tsv" directory/path pmi-case-number-ls curie-symbol-ls))
	       (1-hop_disease_dec_gene-list/path
		(format			
		 "~a~a_1HOP_disease_decreases_~a.tsv" directory/path pmi-case-number-ls curie-symbol-ls))
	       (1-hop_direct-drug-activators+inhibitors->target-gene/port		
		(open-output-file 1-hop_direct-drug-activators+inhibitors->target-gene/path #:exists 'append))
	       (1-hop_molecular-entity-activators+inhibitors->target-gene/port
		(open-output-file 1-hop_molecular-entity-activators+inhibitors->target-gene/path #:exists 'append))
	       (2-hop_indirect-drug-activators+inhibitors->target-gene/port		
		(open-output-file 2-hop_indirect-drug-activators+inhibitors->target-gene/path #:exists 'append))
	       (2-hop_combined-direct+indirect_drug-activators+inhibitors->target-gene/port		
		(open-output-file 2-hop_combined-direct+indirect_drug-activators+inhibitors->target-gene/path #:exists 'append))
	       (1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/port
		(open-output-file 1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/path #:exists 'append))
	       (2-hop_total-loss-of-function_drugs->up/downregulate->genes-regulated-by-target-gene/port
		(open-output-file 2-hop_total-loss-of-function_drugs->up/downregulate->genes-regulated-by-target-gene/path #:exists 'append))
	       (1-hop_disease-assoc/inc->target-gene/port
		(open-output-file 1-hop_disease-assoc/inc->target-gene/path #:exists 'append))
	       (1-hop_disease_dec_gene-list/port
		(open-output-file 1-hop_disease_dec_gene-list/path #:exists 'append))
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
	       (query-start/hgnc
		(find-concepts #t (list curie-id-ls)))
	       (raw-concepts/hgnc
		(get-concept-xrefs query-start/hgnc '()))
	       (xrefs-from-hgnc
		(remove-duplicates
		 (prune-xrefs
		  (flatten (get-concept-xrefs query-start/hgnc '())) '())))
	       (gene-concept-ls
		(find-concepts
		 #t
		 (prune-xrefs
		  (flatten
		   (get-concept-xrefs
		    (query-with-curie/str/umls xrefs-from-hgnc '() suffix-ls) '())) '()))))
	  
	  (define check-concept-to-edge-match
	    (lambda (edge-ls matched-edge-ls)
	      (if (= (length edge-ls) (length matched-edge-ls))
		  (displayln (format "\nALL EDGES SUCCESSFULLY MATCHED FOR EXPORT!\n"))
		  (displayln (format "\nEXPORTED EDGES MAY CONTAIN DUPLICATE ENTRIES!\n")))))

	  
	  

	  #|(gene-concept-ls
		(find-concepts #t
			       (remove-duplicates
				(prune-xrefs
				 (flatten 
				  (get-concept-xrefs
				   (find-concepts
				    #t
				    (prune-xrefs
				     (flatten
				      (get-concept-xrefs
				       (query-with-curie/str/umls xrefs-from-hgnc '() suffix-ls) '())) '()))
				   (prune-xrefs
				    (flatten
				     (get-concept-xrefs
				      (query-with-curie/str/umls
				       xrefs-from-hgnc
				       '()
				       suffix-ls)
	       '())) '()))) '()))))|#

 	  #|
	  (newline)
	  (displayln (format "LIST OF ~a ALIASES/EXTERNAL-IDS FROM CURIE-ID: ~a" curie-symbol-ls curie-id-ls))
	  (newline)
	  (pretty-print (remove-duplicates (prune-xrefs (flatten (get-concept-xrefs gene-concept-ls '())) '())))
	  |#
	  
	  (newline)
	  (displayln (format "LIST OF ~a CONCEPTS FOUND" curie-symbol-ls))
	  (newline)

	  (pretty-print gene-concept-ls)

	  #|--- attempting total LOF query ---|#


	  #|
	  (newline)
	  (displayln (format "BEGINNING 1-HOP TOTAL-LOSS-OF-FUNCTION QUERY FOR ~a:\n~a-->INHIBITS/DECREASES-->~a" curie-symbol-ls curie-symbol-ls filtered-X-molecular_entity))
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
	  (displayln (format "~a ~a-->INHIBITS/DECREASES-->~a EDGES FOUND!" (length total_LOF_gene-decreases-molecular_entity-list/edges) curie-symbol-ls filtered-X-molecular_entity))
	  (newline)
       
	  (newline)
	  (displayln (format "MATCHING EDGES:\n~a-->INHIBITS/DECREASES-->~a-EDGES" curie-symbol-ls filtered-X-molecular_entity))
	  (newline)

	  (define total_LOF_gene-decreases-molecular_entity-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       total_LOF_gene-decreases-molecular_entity-list/edges '()))))

	  (newline)
	  (displayln (format "BEGINNING 1-HOP TOTAL-LOSS-OF-FUNCTION QUERY FOR ~a:\n~a-->ACTIVATES/INCREASES-->~a" curie-symbol-ls curie-symbol-ls filtered-X-molecular_entity))
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
	  (displayln (format "~a ~a-->ACTIVATES/INCREASES-->~a EDGES FOUND!" (length total_LOF_gene-increases-molecular_entity-list/edges) curie-symbol-ls filtered-X-molecular_entity))
	  (newline)
       
	  (newline)
	  (displayln (format "MATCHING EDGES:\n~a-->ACTIVATES/INCREASES-->~a-EDGES" curie-symbol-ls filtered-X-molecular_entity))
	  (newline)

	  (define total_LOF_gene-increases-molecular_entity-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       total_LOF_gene-increases-molecular_entity-list/edges '()))))

	  (define total_LOF_target-gene->increases/decreases->molecular-entity/export-edges
	    (append total_LOF_gene-decreases-molecular_entity-list/export-edges total_LOF_gene-increases-molecular_entity-list/export-edges))


	  (export-column-headers COLUMN_HEADERS_TOTAL_LOF_1-HOP_GENE_REGULATORS
				 1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/port
				 1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/path)
	  
	  (outer-loop
	   total_LOF_target-gene->increases/decreases->molecular-entity/export-edges
	   1-hop_total-loss-of-function_target-gene-up/downregulates->molecular-entity/port)
	  

	  #|--BEGINNING 2-HOP DRUG->INC/DEC-->GENES AFFECTED BY TOTAL-LOF OF TARGET-GENE|#

	   
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
	   
	  |#
	  #|--- END OF TOTAL LOF QUERY ---|#	  
	               
	  (newline)
	  (displayln (format "BEGINNING 1-HOP QUERY FOR ~a:\n~a-->DECREASES-->~a" curie-symbol-ls filtered-X-molecular_entity curie-symbol-ls))
	  (newline)
	  
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
	  (displayln (format "~a ~a-->INHIBITS/DECREASES-->~a EDGES FOUND!" (length molecular_entity-dec-gene-list/edges) filtered-X-molecular_entity curie-symbol-ls))
	  (newline)
       
	  (newline)
	  (displayln (format "MATCHING EDGES:\n~a-->DECREASES-->~a-EDGES" filtered-X-molecular_entity curie-symbol-ls))
	  (newline)

	  (define mol_entity-dec-o/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       molecular_entity-dec-gene-list/edges '()))))
	  
	  (newline)
	  (displayln (format "~a ~a INHIBITS/DECREASES ~a EDGES MATCHED" (length mol_entity-dec-o/export-edges) filtered-X-molecular_entity curie-symbol-ls))
	  (newline)
       
	  (check-concept-to-edge-match
	   molecular_entity-dec-gene-list/edges
	   mol_entity-dec-o/export-edges)

	  (newline)
	  (displayln (format "BEGINNING RUN/GRAPH 1-HOP:\n~a-->INCREASES-->~a" filtered-X-molecular_entity curie-symbol-ls))
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
	  
	  (newline)
	  (displayln (format "~a ~a-->ACTIVATES/INCREASES-->~a EDGES FOUND!" (length molecular_entity-inc-gene-list/edges) filtered-X-molecular_entity curie-symbol-ls))
	  (newline)

	  (newline)
	  (displayln (format "MATCHING\n~a-->INCREASES-->~a-EDGES" filtered-X-molecular_entity curie-symbol-ls))
	  (newline)

	  ;; because i don't scrape the edge-CUI-ID, the duplicate edges are removed for final export 
	  (define mol_entity-inc-o/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       molecular_entity-inc-gene-list/edges '()))))
              
	  (newline)
	  (displayln
	   (format "~a ~a ACTIVATES/INCREASES ~a EDGES MATCHED" (length mol_entity-inc-o/export-edges) filtered-X-molecular_entity curie-symbol-ls))
	  (newline)
		 
	  (check-concept-to-edge-match
	   molecular_entity-inc-gene-list/edges
	   mol_entity-inc-o/export-edges)

	  (define mol_entity-up+down-regulators-for-target-gene/export-edges
	    (append (remove-duplicates mol_entity-dec-o/export-edges) (remove-duplicates mol_entity-inc-o/export-edges)))
	  
	  (export-column-headers
	   COLUMN_HEADERS_1-HOP_GENE_REGULATORS
	   1-hop_molecular-entity-activators+inhibitors->target-gene/port
	   1-hop_molecular-entity-activators+inhibitors->target-gene/path)
	  
	  (outer-loop mol_entity-up+down-regulators-for-target-gene/export-edges
		      1-hop_molecular-entity-activators+inhibitors->target-gene/port)
	  
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
	   (format "BEGINNING INDIRECT DRUG ACTIVATOR QUERY:\n~a-->DECREASE/DOWNREGULATE/INHIBIT-->~a-->DOWNREGULATE ~a" filtered-X-drug filtered-X-molecular_entity curie-symbol-ls))
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
	  (displayln
	   (format "MATCHING EDGES:\n~a-->DECREASE/DOWNREGULATE/INHIBIT-->~a-->DOWNREGULATE ~a" filtered-X-drug filtered-X-molecular_entity curie-symbol-ls))
	  (newline)

	  (define drug-dec-molecular-entity-inhibitors/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-dec-molecular-entity-inhibitors/edges '()))))
	  
	  (newline)
	  (displayln
	   (format "BEGINNING INDIRECT DRUG ACTIVATOR QUERY:\n~a-->INCREASE/UPREGULATE-->~a-->UPREGULATE ~a" filtered-X-drug filtered-X-molecular_entity curie-symbol-ls))
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
	  (displayln
	   (format "MATCHING EDGES:\n~a-->INCREASE/UPREGULATE-->~a-->UPREGULATE ~a" filtered-X-drug filtered-X-molecular_entity curie-symbol-ls))
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
	   (format "BEGINNING INDIRECT DRUG INHIBITOR QUERY:\n~a-->DECREASE/DOWNREGULATE/INHIBIT-->~a-->UPREGULATE ~a" filtered-X-drug filtered-X-molecular_entity curie-symbol-ls))
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
	   (format "MATCHING EDGES:\n~a-->DECREASE/DOWNREGULATE/INHIBIT-->~a-->UPREGULATE ~a" filtered-X-drug filtered-X-molecular_entity curie-symbol-ls))
	  (newline)

	  (define drug-dec-molecular-entity-activators/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-dec-molecular-entity-activators/edges '()))))
	  
	  (newline)
	  (displayln
	   (format "BEGINNING INDIRECT DRUG INHIBITOR QUERY:\n~a-->INCREASE/UPREGULATE-->~a-->DOWNREGULATE ~a" filtered-X-drug filtered-X-molecular_entity curie-symbol-ls))
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
	   (format "MATCHING EDGES:\n~a-->INCREASE/UPREGULATE-->~a-->DOWNREGULATE ~a" filtered-X-drug filtered-X-molecular_entity curie-symbol-ls))
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
	   (format "BEGINNING 1-HOP QUERY FOR DIRECT ~a INHIBITORS OF ~a:\n~a-->DECREASES-->~a" filtered-X-drug curie-symbol-ls filtered-X-drug curie-symbol-ls))
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
	  (displayln (format "~a ~a-->DECREASES/INHIBITS-->~a EDGES FOUND!" (length drug-dec-gene-list/edges) filtered-X-drug  curie-symbol-ls))
	  (newline)

	  (newline)
	  (displayln (format "MATCHING\n~a-->DECREASES/INHIBITS-->~a" filtered-X-drug curie-symbol-ls))
	  (newline)

	  (define drug-dec-o/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-dec-gene-list/edges '()))))

	  (newline)
	  (displayln (format "~a ~a-->DECREASES/INHIBITS-->~a EDGES MATCHED FOR EXPORT" (length drug-dec-o/export-edges) filtered-X-drug  curie-symbol-ls))
	  (newline)
       
	  (check-concept-to-edge-match drug-dec-gene-list/edges drug-dec-o/export-edges)

	  (newline)
	  (displayln (format "BEGINNING 1-HOP QUERY FOR ~a:\n~a-->INCREASES-->~a" curie-symbol-ls filtered-X-drug curie-symbol-ls))
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
	  (displayln (format "~a ~a-->INCREASES/UPREGUALTES-->~a EDGES FOUND!" (length drug-inc-gene-list/edges) filtered-X-drug  curie-symbol-ls))
	  (newline)

	  (newline)
	  (displayln (format "MATCHING\n~a-->INCREASES/UPREGAULTES-->~a EDGES" filtered-X-drug curie-symbol-ls))
	  (newline)
       
	  (define drug-inc-o/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       drug-inc-gene-list/edges '()))))

	  (newline)
	  (displayln (format "~a ~a ACTIVATES/INCREASES ~a EDGES MATCHED" (length drug-inc-gene-list/edges) filtered-X-drug  curie-symbol-ls))
	  (newline)

	  (check-concept-to-edge-match
	   drug-inc-gene-list/edges drug-inc-o/export-edges)

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
	  
	  (newline)
	  (displayln (format "BEGINNING DISEASE-GENE ASSOCIATION QUERY FOR ~a:\n~a-->ASSOCIATED-WITH/CAUSALLY RELATED TO-->~a" curie-symbol-ls filtered-X-disease curie-symbol-ls))
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
	  (displayln (format "~a ~a-->ASSOCIATED-WITH/CAUSES-->~a EDGES FOUND!" (length disease_associated_with_gene-list/edges) filtered-X-disease curie-symbol-ls))
	  (newline)

	  (newline)
	  (displayln (format "MATCHING\n~a-->ASSOCIATED-WITH/CAUSES-->~a EDGES" filtered-X-disease curie-symbol-ls))
	  (newline)
       
	  (define disease_associated_with_gene-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       disease_associated_with_gene-list/edges '()))))

	  (newline)
	  (displayln (format "~a ~a-->ASSOCIATED-WITH/CAUSES-->~a EDGES MATCHED" (length disease_associated_with_gene-list/edges) filtered-X-disease  curie-symbol-ls))
	  (newline)

	  (check-concept-to-edge-match
	   disease_associated_with_gene-list/edges
	   disease_associated_with_gene-list/export-edges)

	  (export-column-headers
	   COLUMN_HEADERS_1-HOP_disease->assoc->gene
	   1-hop_disease-assoc/inc->target-gene/port
	   1-hop_disease-assoc/inc->target-gene/path)
	  
	  (outer-loop
	   disease_associated_with_gene-list/export-edges
	   1-hop_disease-assoc/inc->target-gene/port)

	  (newline)
	  (displayln (format "BEGINNING DISEASE-GENE ASSOCIATION QUERY FOR ~a:\n~a-->DECREASES/INHIBITS-->~a" curie-symbol-ls filtered-X-disease curie-symbol-ls))
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
	  (displayln (format "~a ~a-->DECREASES/INHIBITS-->~a EDGES FOUND!" (length disease_dec_gene-list/edges) filtered-X-disease curie-symbol-ls))
	  (newline)

	  (newline)
	  (displayln (format "MATCHING\n~a-->DECREASES/INHIBITS-->~a EDGES" filtered-X-disease curie-symbol-ls))
	  (newline)
       
	  (define disease_dec_gene-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       disease_dec_gene-list/edges '()))))

	  (newline)
	  (displayln (format "~a ~a-->DECREASES/INHIBITS-->~a EDGES MATCHED" (length disease_dec_gene-list/edges) filtered-X-disease curie-symbol-ls))
	  (newline)

	  (check-concept-to-edge-match
	   disease_dec_gene-list/edges
	   disease_dec_gene-list/export-edges)

	  (export-column-headers
	   COLUMN_HEADERS_1-HOP_disease->assoc->gene
	   1-hop_disease_dec_gene-list/port
	   1-hop_disease_dec_gene-list/path)
	  
	  (outer-loop
	   disease_dec_gene-list/export-edges
	   1-hop_disease_dec_gene-list/port)

#|
	  #|[genes] --> causally-related-to --> Disease |#

	  (newline)
	  (displayln (format "BEGINNING GENE-TO-DISEASE ASSOCIATION QUERY FOR ~a:\n~a-->ASSOCIATED-WITH/CAUSALLY RELATED TO-->~a" filtered-X-disease filtered-X-molecular_entity filtered-X-disease))
	  (newline)
	  
	  (match-define
	   (list gene-associated-with-gene=>concepts gene-associated-with-gene=>edges)
	   (time
	    (run/graph
	     ((disease-concept0list  disease-concept-list)
	      (molecular-entity molecular-entity))
	     ((disease-1->associated-with increases))
	     (disease disease-1->associated-with gene-concept-ls))))
	  
	  (define disease_associated_with_gene-list/edges (hash-ref disease-associated-with-gene=>edges 'disease-1->associated-with))

	  (newline)
	  (displayln (format "~a ~a-->ASSOCIATED-WITH/CAUSES-->~a EDGES FOUND!" (length disease_associated_with_gene-list/edges) filtered-X-disease curie-symbol-ls))
	  (newline)

	  (newline)
	  (displayln (format "MATCHING\n~a-->ASSOCIATED-WITH/CAUSES-->~a EDGES" filtered-X-disease curie-symbol-ls))
	  (newline)
       
	  (define disease_associated_with_gene-list/export-edges
	    (time
	     (remove-duplicates
	      (match-drug-pred-gene-edges
	       disease_associated_with_gene-list/edges '()))))
|#
	  
	  ))))))

(start-function pmi-case-number-ls curie-id-ls curie-symbol-ls)


