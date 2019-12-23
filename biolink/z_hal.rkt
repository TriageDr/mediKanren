#lang racket
(provide (all-defined-out)
         (all-from-out "common.rkt" "mk-db.rkt"))
(require "common.rkt" "mk-db.rkt")

#|--- PMI-CASE-REGISTRY INPUT ---|#
(time
 (define pmi-ls
   '(test))

 (define sym-hgnc-ls
   '(POLR3K))

 (define hgnc-id-ls/num
   (map number->string
	'(14121)))

;; stopped 12/17/19 on ODC1 edges
#|
(define pmi-ls
  '(PMI-18-1
    PMI-18-10
    PMI-18-100
    PMI-18-101
    PMI-18-102
    PMI-18-103
    PMI-18-104
    PMI-18-105
    PMI-18-108
    PMI-18-109
    PMI-18-11
    PMI-18-111
    PMI-18-111
    PMI-18-116
    PMI-18-117
    PMI-18-12
    PMI-18-120
    PMI-18-120
    PMI-18-121
    PMI-18-123
    PMI-18-125
    PMI-18-125
    PMI-18-126
    PMI-18-126
    PMI-18-13
    PMI-18-131
    PMI-18-134
    PMI-18-134
    PMI-18-136
    PMI-18-138
    PMI-18-139
    PMI-18-14
    PMI-18-140
    PMI-18-141
    PMI-18-142
    PMI-18-144
    PMI-18-147
    PMI-18-148
    PMI-18-155
    PMI-18-156
    PMI-18-159
    PMI-18-160
    PMI-18-161
    PMI-18-164
    PMI-18-166
    PMI-18-167
    PMI-18-168
    PMI-18-169
    PMI-18-169
    PMI-18-171
    PMI-18-172
    PMI-18-172
    PMI-18-172
    PMI-18-173
    PMI-18-174
    PMI-18-179
    PMI-18-180-1
    PMI-18-180-2
    PMI-18-180-2
    PMI-18-181
    PMI-18-181
    PMI-18-182
    PMI-18-184
    PMI-18-185
    PMI-18-19
    PMI-18-2
    PMI-18-2
    PMI-18-20
    PMI-18-22
    PMI-18-23
    PMI-18-24
    PMI-18-26
    PMI-18-27
    PMI-18-28
    PMI-18-28
    PMI-18-29
    PMI-18-3 
    PMI-18-30
    PMI-18-30
    PMI-18-31
    PMI-18-32
    PMI-18-33
    PMI-18-33
    PMI-18-34
    PMI-18-36
    PMI-18-36
    PMI-18-36
    PMI-18-38
    PMI-18-4
    PMI-18-41
    PMI-18-42 
    PMI-18-43
    PMI-18-46
    PMI-18-47
    PMI-18-49
    PMI-18-53
    PMI-18-53
    PMI-18-55
    PMI-18-6
    PMI-18-60
    PMI-18-60
    PMI-18-64
    PMI-18-69
    PMI-18-74
    PMI-18-74
    PMI-18-79
    PMI-18-8
    PMI-18-82
    PMI-18-83
    PMI-18-83
    PMI-18-83
    PMI-18-88
    PMI-18-9
    PMI-18-91
    PMI-18-92
    PMI-18-92
    PMI-18-92
    PMI-18-93
    PMI-18-98
    PMI-18-99
    PMI-18-99
    PMI-18-99
    PMI-19-10
    PMI-19-10
    PMI-19-100
    PMI-19-102
    PMI-19-104
    PMI-19-105
    PMI-19-106
    PMI-19-111
    PMI-19-111
    PMI-19-111
    PMI-19-111
    PMI-19-111
    PMI-19-111
    PMI-19-114
    PMI-19-115
    PMI-19-116
    PMI-19-120
    PMI-19-121
    PMI-19-122
    PMI-19-123
    PMI-19-124
    PMI-19-125
    PMI-19-126 
    PMI-19-127
    PMI-19-130
    PMI-19-131
    PMI-19-131
    PMI-19-133
    PMI-19-134
    PMI-19-135
    PMI-19-135
    PMI-19-135
    PMI-19-135
    PMI-19-135
    PMI-19-135
    PMI-19-139
    PMI-19-14
    PMI-19-14
    PMI-19-14
    PMI-19-140
    PMI-19-141
    PMI-19-142
    PMI-19-143
    PMI-19-144
    PMI-19-145 
    PMI-19-146 
    PMI-19-15
    PMI-19-150
    PMI-19-151
    PMI-19-151
    PMI-19-152
    PMI-19-152
    PMI-19-157
    PMI-19-157
    PMI-19-159
    PMI-19-16
    PMI-19-161
    PMI-19-166
    PMI-19-167
    PMI-19-168
    PMI-19-17
    PMI-19-171
    PMI-19-173
    PMI-19-174
    PMI-19-174
    PMI-19-174
    PMI-19-174
    PMI-19-178
    PMI-19-178
    PMI-19-179
    PMI-19-180
    PMI-19-181
    PMI-19-181
    PMI-19-182
    PMI-19-182
    PMI-19-183
    PMI-19-184
    PMI-19-187
    PMI-19-20
    PMI-19-24
    PMI-19-24
    PMI-19-26
    PMI-19-26
    PMI-19-28
    PMI-19-29
    PMI-19-3
    PMI-19-37
    PMI-19-38
    PMI-19-39
    PMI-19-40
    PMI-19-42
    PMI-19-42
    PMI-19-43
    PMI-19-44
    PMI-19-46 
    PMI-19-47
    PMI-19-5
    PMI-19-5
    PMI-19-5
    PMI-19-53
    PMI-19-56
    PMI-19-58
    PMI-19-58
    PMI-19-58
    PMI-19-61
    PMI-19-65
    PMI-19-66
    PMI-19-68
    PMI-19-69
    PMI-19-70
    PMI-19-71
    PMI-19-74
    PMI-19-75
    PMI-19-77
    PMI-19-77
    PMI-19-77
    PMI-19-77
    PMI-19-78
    PMI-19-8
    PMI-19-80
    PMI-19-83
    PMI-19-87
    PMI-19-89
    PMI-19-93
    PMI-19-96
    PMI-19-96
    PMI-19-97
    PMI-19-99
    PMI-19-99
    ))

(define sym-hgnc-ls
  '(NTRK2
    SCN2A
    ACO2
    MEF2C
    KCNMA1
    ASXL2
    PPM1D
    SOX5
    EGFR
    SHANK3
    RARB 
    NYFC
    ZFHX3
    TRAF7
    HNRNPU
    ZMIZ1
    PURA
    RLIM
    POLG1
    JAK2 
    HCN1 
    SPG4
    USP9X 
    KAT6A
    CSNK2B
    MTM1
    DSC2
    SCN5A
    TMLHE
    KCNC1
    PRDX1
    GLDC
    STXBP1
    GRIN2B
    RPS6KA3
    IRF2BPL
    ODC1
    FLNA
    HADHA
    SETBP1
    ADCY5
    GPD1L
    WFS1
    UGDH
    GABRB2
    CACNA1A
    BICD2
    LIAS
    NGLY1
    TOR1A
    KRAS
    MFN2 
    PIGO
    POLR3A
    TBK1
    COL6A2
    PLA2G6
    PLA2G6
    NPHP3
    GRIN1
    GRIN2A
    KDM1A_LSD1 
    NGLY1
    HIVEP2
    MPP5_Pals1 
    SCN8A
    YWHAZ
    FKTN
    DHX30
    DCHS1
    ELP2
    COL3A1
    SMC1A
    UGDH
    UGDH
    SCN2A
    PTPRC
    IRF2BPL
    IRF2BPL 
    PTEN
    GRIN1
    CCDS1
    SLC6A8
    KCNQ3
    HDAC8
    CCDC22
    FANCD2
    CFTR
    CHAMP1
    MECP2
    MAPK8IP3
    NACC1
    BCOR
    TCF4
    MTMR8
    USP9X
    MECR
    MT_TL1
    PTPN11
    NLGN4X
    GLI2 
    RHOB
    PKAN
    KCNH5 
    RYR3
    CACNA1A
    PIGA
    ACOX1
    NFE2L2
    RANBP2
    SGSH
    DNM1L
    BRAF
    ADAR
    HCA2_GPR109A
    HCA1_GPR81
    HCA3_GPR109B
    GMPPA
    CDKL5
    INPP5E 
    PNKP
    VRK1
    LMNA
    SMAD7
    KCNT1
    HECW2
    MTHFR
    CLN2
    EP300
    COL5A2
    COL6A3
    COL9A1
    COL11A1
    GATA6
    RIN2
    RHOBTB2
    MEF2C
    LGI1
    SCN1A
    SCN1A
    KCNT1
    EPM2A
    FOXG1
    SCN1A
    ALDH7A1
    SCN1A
    SPAST
    KIAA2022
    RAC1
    FHL1
    SRD5A3
    ADSL
    AMT
    AMT
    ATP1A3
    ERCC6
    ZBTB24
    KCNQ2
    ALMS1
    PAK3
    SCN2A
    ARX
    AIMP1
    FLNA
    STXBP1
    STXBP1
    SCN1A
    SCN1A
    SLC10A2
    CACNA1A
    MFN2
    AARS
    MYO7A
    MYO7A
    MED13
    KCNV2
    ECHS1
    ADNP
    AIFM1
    NGLY1
    KMT2B
    KCNN3
    COL1A1
    GPX4
    NARFL
    TELO2
    EPHB4
    STK25
    STK25
    RAB3GAP2
    RAB3GAP2
    ANKRD26
    PPT1
    KCNQ3
    SYNGAP1
    FOXG1
    KNL1
    HNRNPH2
    SCN2A
    IQCB1
    NANS
    TBCD
    PTEN
    CHD5
    DOCK10
    EDA2R
    STXBP1
    FBXO11
    PSEN1
    CDC42
    DMD
    KCNQ2
    ERCC6L
    MET
    WDR35
    FIG4
    CDKL5
    RHOBTB2
    FLNA
    MT_ATP6
    PLOD1
    WISP3
    EHMT1
    ATM
    BTK
    CACNA1H
    MTOR
    DYRK1A
    RBM28
    RNASEH2B
    ANKRD11
    NALCN
    AP4M1
    Ppp2r1a 
    TNFRSF13C
    KCNB1
    NLRP1
    BAHCC1
    MLST8
    ATN1
    SCN1A
    Ppp2r1a
    GAN
    ZFYVE26
    GEMIN5
    TNFRSF1A
    ALMS1
    RPGRIP1L
    GABRB3
    SLC6A1
    CACNA1A
    ))
 
(define hgnc-id-ls/num
  (map number->string 
       '(8032
	 10588
	 118
	 6996
	 6284
	 23805
	 9277
	 11201
	 3236
	 14294
	 9865
	 7806
	 777
	 20456
	 5048
	 16493
	 9701
	 13429
	 9179
	 6192
	 4845
	 11233
	 12632
	 13013
	 2460
	 7448
	 3036
	 10593
	 18308
	 6233
	 9352
	 4313
	 11444
	 4586
	 10432
	 14282
	 8109
	 3754
	 4801
	 15573
	 236
	 28956
	 12762
	 12525
	 4082
	 1388
	 17208
	 16429
	 17646
	 3098
	 6407
	 16877
	 23215
	 30074
	 11584
	 2212
	 9039
	 9039
	 7907
	 4584
	 4585
	 29079
	 17646
	 4921
	 18669
	 10596
	 12855
	 3622
	 16716
	 13681
	 18248
	 2201
	 11111
	 12525
	 12525
	 10588
	 9666
	 14282
	 14282
	 9588
	 4584
	 11055
	 11055
	 6297
	 13315
	 28909
	 3585
	 1884
	 20311
	 6990
	 6884
	 20967
	 20893
	 11634
	 16825
	 12632
	 19691
	 7490
	 9644
	 14287
	 4318
	 668
	 15894
	 6254
	 10485
	 1388
	 8957
	 119
	 7782
	 9848
	 10818
	 2973
	 1097
	 225
	 24827
	 4532
	 16824
	 22923
	 11411
	 21474
	 9154
	 12718
	 6636
	 6773
	 18865
	 29853
	 7436
	 2073
	 3373
	 2210
	 2213
	 2217
	 2186
	 4174
	 18750
	 18756
	 6996
	 6572
	 10585
	 10585
	 18865
	 3413
	 3811
	 10585
	 877
	 10585
	 11233
	 29433
	 9801
	 3702
	 25812
	 291
	 473
	 473
	 801
	 3438
	 21143
	 6296
	 428
	 8592
	 10588
	 18060
	 10648
	 3754
	 11444
	 11444
	 10585
	 10585
	 10906
	 1388
	 16877
	 20
	 7606
	 7606
	 22474
	 19698
	 3151
	 15766
	 8768
	 17646
	 15840
	 6292
	 2197
	 4556
	 14179
	 29099
	 3395
	 11404
	 11404
	 17168
	 17168
	 29186
	 9325
	 6297
	 11497
	 3811
	 24054
	 5042
	 10588
	 28949
	 19237
	 11581
	 9588
	 16816
	 23479
	 17756
	 11444
	 13590
	 9508
	 1736
	 2928
	 6296
	 20794
	 7029
	 29250
	 16873
	 11411
	 18756
	 3754
	 7414
	 9081
	 12771
	 24650
	 795
	 1133
	 1395
	 3942
	 3091
	 21863
	 25671
	 21316
	 19082
	 574
	 9302
	 17755
	 6231
	 14374
	 29279
	 24825
	 3033
	 10585
	 9302
	 4137
	 20761
	 20043
	 11916
	 428
	 29168
	 4083
	 11042
	 1388
	 )))

(define hgnc-id-ls
  (map (lambda (ls)
	 (string-append "HGNC:" ls))
       hgnc-id-ls/num))
|# 
 
#|
 (define pmi-ls
   '(for_peyton_vw
     for_peyton_vw
     for_peyton_vw
     for_peyton_vw
     for_peyton_vw))

 (define sym-hgnc-ls
   '(JAGN1
     ARFGEF1
     ARFGEF2
     MIA3
     GBF1
     MIA2))

 (define hgnc-id-ls/num
   (map number->string
	'(26926
	  15772
	  15853
	  24008
	  4181
	  18432)))
|#

 (define hgnc-id-ls
   (map (lambda (ls)
	  (string-append "HGNC:" ls))
	hgnc-id-ls/num)) 
 
 
 #|--- KEY-VALUES ---|#

;;15 orange predicates
;;88 robokop predicates
;;16 rtx predicates
;;18 semmed predicates 

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
	   (number? (car ls))
	   (regexp-match #rx":[Nn][Oo][Cc][Oo][Dd][Ee]" (car ls))
	   (regexp-match #rx"^UMLS:C0017337$" (car ls))
	   (regexp-match #rx"ClinVarVariant:+" (car ls))
	   (regexp-match #rx"^N[MCPG]_[0-9]+" (car ls)))
	   #|(regexp-match #rx"^Genes$" (car ls))|#
       (prune-xrefs (cdr ls) els))
      ((string-contains? (car ls) "NCBI")
       (prune-xrefs (cdr ls)
	(cons 
	 (string-replace (car ls) "NCBIGENE:" "NCBIGene:") els)))
      (else
       (prune-xrefs (cdr ls) (cons (car ls) els))))))

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
#|
(define query-with-curie/str
  (lambda (ls els)
    (cond
      ((null? ls) (set-union els))
      ((atom? (car ls))
       (cond 
	 ((not (string-contains? (car ls) ":"))
	  (query-with-curie/str (cdr ls)
				(set-union (find-concepts/options #f #f 0 #f
								  (list (format "~a" (car ls)))) els)))
	 (else
	  (query-with-curie/str (cdr ls)
				(set-union (find-concepts #t (list (car ls))) els)))))
      (else
       (set-union 
	(query-with-curie/str (car ls) els)
	(query-with-curie/str (cdr ls) els))))))
|#

(define query-with-curie/str
  (lambda (ls els)
    (cond
      ((null? ls) (set-union els))
      ((atom? (car ls))
       (cond 
	 ((not (string-contains? (car ls) ":"))
	  (query-with-curie/str (cdr ls)
				(set-union (find-concepts/options #f #f 0 #f
								  (list (format "~a" (car ls)))) els)))
	 (else
	  (query-with-curie/str (cdr ls)
				(set-union (find-concepts #t (list (car ls))) els)))))
      (else
       (set-union 
	(query-with-curie/str (car ls) els)
	(query-with-curie/str (cdr ls) els))))))


(define get-rxnorm
  (lambda (ls els)
    (cond
      ((null? ls) (set-union els))
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
		(cons (list drug-name
			    drug-id
			    (flatten
			     (list
			     (get-xrefs umls-type-label/key drug-props-assoc)
			     (get-xrefs umls-type/key drug-props-assoc)))
			    (list 
			     (get-xrefs drug-bank/key drug-props-assoc)
			     (assoc drug-bank/withdrawn/key drug-props-assoc)
			     (assoc drug-bank/approved/key drug-props-assoc)
			     (assoc drug-bank/therapeutic/key drug-props-assoc)
			     (assoc drug-bank/investigational/key drug-props-assoc))
			    (get-rxnorm
			     (flatten
			       (get-concept-xrefs 
				(query-with-curie/str 
				 (flatten
				  (list drug-name
					drug-id
					(get-xrefs semmed-concept-key/xrefs drug-props-assoc)
					(get-xrefs orange-concept-key/same-as drug-props-assoc)
					(get-xrefs orange-concept-key/synonym drug-props-assoc)
					(get-xrefs robokop-concept-key/eq-id drug-props-assoc)
					(get-assoc-value semmed-concept-key/id drug-props-assoc))) '()) '())) '())
			    pred
			    gene-name
			    gene-id
			    (length (pubmed-ids-from-edge-props pred-props-assoc))
			    (map (lambda (pubmed)
				   (string-append PUBMED_URL_PREFIX (~a pubmed)))
				 (pubmed-ids-from-edge-props pred-props-assoc))) els))]))))) 

(define export-column-headers
  (lambda (headers port)
    (cond
      ((null? headers)
       (fprintf port "~c" #\newline))
      (else
       (fprintf port "~a~c" (car headers) #\tab)
       (export-column-headers (cdr headers) port)))))


(define export-path
  "/home/mjpatton/PhD/CaseReviews/")

(newline)
(displayln "HELPER-FUNCTIONS LOADED, BEGINNING GENE-CONCEPT BUILDING")
(newline)

(define start-function
  (time 
   (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
     (cond
       ((null? pmi-ls) (void))
       (else
	(handle (car pmi-ls) (car hgnc-id-ls) (car sym-hgnc-ls))
	(start-function
	 (cdr pmi-ls) (cdr hgnc-id-ls) (cdr sym-hgnc-ls)))))))

(define handle
  (time
   (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
     (let* (#|(export-path
	     (path->string (find-system-path 'desk-dir)))|#
	    (all-downregulator/path
	    (format
	    "~a~a_all_drug_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (all-upregulator/path
	     (format
	      "~a~a_all_drug_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (mixed-downregulator/path
	     (format
	      "~a~a_mixed_drug_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (pure-downregulator/path
	     (format
	      "~a~a_pure_drug_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (mixed-upregulator/path
	     (format
	      "~a~a_mixed_drug_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (pure-upregulator/path
	     (format
	      "~a~a_pure_drug_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (out-dec/all
	     (open-output-file all-downregulator/path #:exists 'replace))
	    (out-inc/all
	     (open-output-file all-upregulator/path #:exists 'replace))
	    (out-dec/mr
	     (open-output-file mixed-downregulator/path #:exists 'replace))
	    (out-inc/mr
	     (open-output-file mixed-upregulator/path #:exists 'replace))
	    (out-dec/pr
	     (open-output-file pure-downregulator/path #:exists 'replace))
	    (out-inc/pr
 	     (open-output-file pure-upregulator/path #:exists 'replace))
	    (all_molecular_entity-dec/path
	     (format
	      "~a~a_all_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (all_molecular_entity-inc/path
	     (format
	      "~a~a_all_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (pure_molecular_entity-inc/path
	     (format
	      "~a~a_pure_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (pure_molecular_entity-dec/path
	     (format
	      "~a~a_pure_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	     (mixed_molecular_entity-inc/path
	      (format
	       "~a~a_mixed_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	     (mixed_molecular_entity-dec/path
	      (format
	       "~a~a_mixed_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	     (out-all_molecular_entity_dec
 	      (open-output-file all_molecular_entity-dec/path #:exists 'replace))
	     (out-all_molecular_entity_inc
 	      (open-output-file all_molecular_entity-inc/path #:exists 'replace))
	     (out-pure_molecular_entity_dec
 	      (open-output-file pure_molecular_entity-dec/path #:exists 'replace))
	     (out-pure_molecular_entity_inc
 	      (open-output-file pure_molecular_entity-inc/path #:exists 'replace))
	     (out-mixed_molecular_entity_dec
 	      (open-output-file mixed_molecular_entity-dec/path #:exists 'replace))
	     (out-mixed_molecular_entity_inc
 	      (open-output-file mixed_molecular_entity-inc/path #:exists 'replace))
	     #|(drug-dec-molecular_entity->inc->gene/path
	      (format "~a~a_drug_dec_molecular_entity_upregulates_~a" export-path pmi-ls sym-hgnc-ls))
	     (drug-inc-molecular_entity->dec->gene/path
	      (format "~a~a_drug_inc_molecular_entity_downregulates_~a" export-path pmi-ls sym-hgnc-ls))
	     (drug-dec-molecular_entity->dec->gene/path
	      (format "~a~a_drug_dec_molecular_entity_downregulates_~a" export-path pmi-ls sym-hgnc-ls))
	     (drug-inc-molecular_entity->inc->gene/path
	      (format "~a~a_drug_inc_molecular_entity_upregulates_~a" export-path pmi-ls sym-hgnc-ls))
 	     (out-drug-dec-molecular_entity->inc->gene
	      (open-output-file drug-dec-molecular_entity->inc->gene/path #:exists 'replace))
	     (out-drug-inc-molecular_entity->dec->gene
	      (open-output-file drug-inc-molecular_entity->dec->gene/path #:exists 'replace))
	     (out-drug-dec-molecular_entity->dec->gene
	      (open-output-file drug-dec-molecular_entity->dec->gene/path #:exists 'replace))
	     (out-drug-inc-molecular_entity->inc->gene
	      (open-output-file drug-inc-molecular_entity->inc->gene/path #:exists 'replace))|#
	     (query-start/hgnc
	      (find-concepts #t (list hgnc-id-ls)))
	     (raw-concepts/hgnc
	      (get-concept-xrefs query-start/hgnc '()))
	     (xrefs-from-hgnc
	      (remove-duplicates
	       (prune-xrefs
		(flatten (get-concept-xrefs query-start/hgnc '())) '())))
	     ;;test with xref-from-hgnc
	     (gene-concept-ls
	      (find-concepts #t xrefs-from-hgnc))
	     (gene-concept-ls
	      (time
	       (query-with-curie/str xrefs-from-hgnc '())))
	     (drugs
	      '((semmed 4 . "chemical_substance")
		(rtx 0 . "chemical_substance")
		(robokop 1 . "(\"named_thing\" \"chemical_substance\")")
		(rtx 3 . "metabolite")
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
		(orange 15 . "(\"transcript\")")))
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
	     (filtered-X-disease "SYMPTOM/DISEASE"))
       
       (define start-time (current-seconds))

       (displayln (format "LIST OF ~a ALIASES/EXTERNAL-IDS FROM HGNC:ID" sym-hgnc-ls))
       (pretty-print xrefs-from-hgnc)
       
       (displayln (format "LIST OF ~a ALIASES/EXTERNAL-IDS FROM CURIE/STR FUNCTION" sym-hgnc-ls))
       (pretty-print
	(remove-duplicates
	 (prune-xrefs
	  (flatten
	   (get-concept-xrefs gene-concept-ls '())) '())))
	    
	    (define check-concept-to-edge-match
	      (lambda (edge-ls matched-edge-ls)
		(if (= (length edge-ls) (length matched-edge-ls))
		    (displayln (format "\nEDGES SUCCESSFULLY MATCHED FOR EXPORT!\n"))
		    (displayln (format "\nEXPORTED EDGES MAY CONTAIN DUPLICATE ENTRIES!\n")))))
	    
	    (newline)
	    (display
	     (format "BATCH-QUERY START TIME: ~a" start-time))
	    (newline)
	    (newline)
	    (displayln
	     (format "BEGINNING RUN/GRAPH 1-HOP:\n~a-->DECREASES-->~a" filtered-X-drug sym-hgnc-ls))
	    (newline)
       
	    (match-define
	     (list x-dec-gene=>concepts x-dec-gene=>edges)
	     (time
	      (run/graph
	       ((X drugs) 
		(gene-concept-ls gene-concept-ls))
	       ((X->dec decreases))
	       (X X->dec gene-concept-ls))))

	    (define drug-dec-gene-list (hash-ref x-dec-gene=>edges 'X->dec))

	    (newline)
	    (displayln (format "~a ~a INHIBITS/DECREASES ~a EDGES FOUND" (length drug-dec-gene-list) filtered-X-drug  sym-hgnc-ls))
	    (newline)

	    (displayln "DRUG->dec->gene-xrefs!")
	    (pretty-print
	     (remove-duplicates
	      (prune-xrefs
	       (flatten
 		(get-concept-xrefs-from-edges drug-dec-gene-list '())) '())))
       
	    
	    (newline)
	    (displayln (format "MATCHING\n~a-->DECREASES-->~a" filtered-X-drug sym-hgnc-ls))
	    (newline)

	    (define x-dec-o/edge
	      (time
	       (remove-duplicates
		(match-drug-pred-gene-edges
		 drug-dec-gene-list '()))))

	    (newline)
	    (displayln (format "~a ~a INHIBITS/DECREASES ~a EDGES MATCHED" (length x-dec-o/edge) filtered-X-drug  sym-hgnc-ls))
	    (newline)
	    (check-concept-to-edge-match drug-dec-gene-list x-dec-o/edge)

	    (newline)
	    (displayln (format "BEGINNING RUN/GRAPH 1-HOP:\n~a-->INCREASES-->~a" filtered-X-drug sym-hgnc-ls))
	    (newline)
      
	    (match-define
	     (list y-inc-gene=>concepts y-inc-gene=>edges)
	     (time
	      (run/graph
	       ((Y drugs)
		(gene-concept-ls gene-concept-ls))
	       ((Y->inc increases))
	       (Y Y->inc gene-concept-ls))))
      
	    (define drug-inc-gene-list (hash-ref y-inc-gene=>edges 'Y->inc))

	    (newline)
	    (displayln (format "~a ~a ACTIVATES/INCREASES ~a EDGES FOUND" (length drug-inc-gene-list) filtered-X-drug  sym-hgnc-ls))
	    (newline)

	    (displayln "DRUG->inc->gene-xrefs!")
	    (pretty-print
	     (remove-duplicates
	      (prune-xrefs
	       (flatten
 		(get-concept-xrefs-from-edges drug-inc-gene-list '())) '())))

      
	    (newline)
	    (displayln (format "MATCHING\n~a-->INCREASES-->~a-EDGES" filtered-X-drug sym-hgnc-ls))
	    (newline)
       
	    (define x-inc-o/edge
	      (time
	       (remove-duplicates
		(match-drug-pred-gene-edges
		 drug-inc-gene-list '()))))
       
	    (newline)
	    (displayln (format "~a ~a ACTIVATES/INCREASES ~a EDGES MATCHED" (length drug-inc-gene-list) filtered-X-drug  sym-hgnc-ls))
	    (newline)

	    (check-concept-to-edge-match
	     drug-inc-gene-list x-inc-o/edge)

	    (define pure-drug-downregulator?
	      (lambda (ls)
		(and (member? (list-ref ls 1) (flatten x-dec-o/edge))
		     (not (member? (list-ref ls 1) (flatten x-inc-o/edge))))))
       
	    (define pure-drug-upregulator?
	      (lambda (ls)
		(and (member? (list-ref ls 1) (flatten x-inc-o/edge))
		     (not (member? (list-ref ls 1) (flatten x-dec-o/edge))))))
      
	    (newline)
	    (displayln (format "BEGINNING RUN/GRAPH 1-HOP:\n~a-->DECREASES-->~a" filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)
       
	    (match-define
	     (list w-dec-gene=>concepts w-dec-gene=>edges)
	     (time
	      (run/graph
	       ((W molecular_entity) 
		(gene-concept-ls gene-concept-ls))
	       ((W->dec decreases))
	       (W W->dec gene-concept-ls))))
       
	    (define molecular_entity-dec-gene-list (hash-ref w-dec-gene=>edges 'W->dec))
       
	    (newline)
	    (displayln (format "~a ~a INHIBITS/DECREASES ~a EDGES FOUND" (length molecular_entity-dec-gene-list) filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)
       
	    (newline)
	    (displayln (format "MATCHING\n~a-->DECREASES-->~a-EDGES" filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)

	    ;; because i don't scrape the edge-CUI-ID, the duplicate edges are removed for final export 
	    (define mol_entity-dec-o/edge
	      (time
	       (remove-duplicates
		(match-drug-pred-gene-edges
		 molecular_entity-dec-gene-list '()))))
     
	    (newline)
	    (displayln (format "~a ~a INHIBITS/DECREASES ~a EDGES MATCHED" (length mol_entity-dec-o/edge) filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)
       
	    (check-concept-to-edge-match
	     molecular_entity-dec-gene-list mol_entity-dec-o/edge)

	    (newline)
	    (displayln (format "BEGINNING RUN/GRAPH 1-HOP:\n~a-->INCREASES-->~a" filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)
      
	    (match-define
	     (list z-inc-gene=>concepts z-inc-gene=>edges)
	     (time
	      (run/graph
	       ((Z molecular_entity)
		(gene-concept-ls gene-concept-ls))
	       ((Z->inc increases))
	       (Z Z->inc gene-concept-ls))))
            
	    (define molecular_entity-inc-gene-list (hash-ref z-inc-gene=>edges 'Z->inc))
       
	    (newline)
	    (displayln (format "~a ~a ACTIVATES/INCREASES ~a EDGES FOUND" (length molecular_entity-inc-gene-list) filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)

	    (newline)
	    (displayln (format "MATCHING\n~a-->INCREASES-->~a-EDGES" filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)

	    ;; because i don't scrape the edge-CUI-ID, the duplicate edges are removed for final export 
	    (define mol_entity-inc-o/edge
	      (time
	       (remove-duplicates
		(match-drug-pred-gene-edges
		 molecular_entity-inc-gene-list '()))))
              
	    (newline)
	    (displayln
	     (format "~a ~a ACTIVATES/INCREASES ~a EDGES MATCHED" (length mol_entity-inc-o/edge) filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)
		 
	    (check-concept-to-edge-match
	     molecular_entity-inc-gene-list
	     mol_entity-inc-o/edge)

	    (newline)
	    (displayln
	     (format "1-HOP QUERIES COMPLETE:\n~a->INCREASES->~a\n~a->DECREASES->~a\n~a->INCREASES->~a\n~a->DECREASES->~a"
		     filtered-X-drug
		     sym-hgnc-ls
		     filtered-X-drug
		     sym-hgnc-ls
		     filtered-X-molecular_entity
		     sym-hgnc-ls
		     filtered-X-molecular_entity
		     sym-hgnc-ls))
	    (newline)
	    #|
	    (newline)
	    (displayln (format "GATHERING ALIASES & EXTERNAL-REFERENCES\nFOR ~a REGULATORS OF ~a" filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)

	    ;; CHECKING FOR META-IDENTIFIER STRINGS LIKE GENES
	   (displayln "MOL_ENTITY->dec->gene-xrefs!")
	    (pretty-print
	     (remove-duplicates
	      (prune-xrefs
	       (flatten
 		(get-concept-xrefs-from-edges molecular_entity-dec-gene-list '())) '())))
       
	    (define mol_entity-dec-o-xrefs
	      (time
	       (query-with-curie/str
		(remove-duplicates
		 (prune-xrefs
		  (flatten
		   (get-concept-xrefs-from-edges molecular_entity-dec-gene-list '())) '())) '())))
        
	    ;; test to see what goes into the query
	    (displayln "MOL_ENTITY->inc->gene-xrefs!")
	    (pretty-print
	     (remove-duplicates
	      (prune-xrefs
	       (flatten
		(get-concept-xrefs-from-edges molecular_entity-inc-gene-list '())) '())))
       
	    (define mol_entity-inc-o-xrefs
	      (time
	       (query-with-curie/str
		(remove-duplicates
		 (prune-xrefs 
		  (flatten
		   (get-concept-xrefs-from-edges molecular_entity-inc-gene-list '())) '())) '())))
       |#
	    (define pure-gene-upregulator?
	      (lambda (ls)
		(and (member? (list-ref ls 1) (flatten mol_entity-inc-o/edge))
		     (not (member? (list-ref ls 1) (flatten mol_entity-dec-o/edge))))))
       
	    (define pure-gene-downregulator?
	      (lambda (ls)
		(and (member? (list-ref ls 1) (flatten mol_entity-dec-o/edge))
		     (not (member? (list-ref ls 1) (flatten mol_entity-inc-o/edge))))))
       
	    ;;loops for export
	    (define outer-loop/dec
	      (lambda (ls port-mr port-pr)
		(cond
		  ((null? ls)
		   (close-output-port port-mr)
		   (close-output-port port-pr))
		  ((or (pure-drug-downregulator? (car ls))
		       (pure-gene-downregulator? (car ls)))
		   (inner-loop (car ls) port-pr)
		   (fprintf port-pr (format "~c" #\newline))
		   (outer-loop/dec (cdr ls) port-mr port-pr))
		  (else
		   (inner-loop (car ls) port-mr)
		   (fprintf port-mr (format "~c" #\newline))
		   (outer-loop/dec (cdr ls) port-mr port-pr)))))

	    (define outer-loop/inc
	      (lambda (ls port-mr port-pr)
		(cond
		  ((null? ls)
		   (close-output-port port-mr)
		   (close-output-port port-pr))
		  ((or (pure-drug-upregulator? (car ls))
		       (pure-gene-upregulator? (car ls)))
		   (inner-loop (car ls) port-pr)
		   (fprintf port-pr (format "~c" #\newline))
		   (outer-loop/inc (cdr ls) port-mr port-pr))
		  (else
		   (inner-loop (car ls) port-mr)
		   (fprintf port-mr (format "~c" #\newline))
		   (outer-loop/inc (cdr ls) port-mr port-pr)))))
       
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

	    #|--- DRUG->INC/DEC->GENE 1-HOP EXPORT: COLUMN HEADERS & DATA ---|#

	    (export-column-headers (list pmi-ls) out-dec/all)
	    (export-column-headers COLUMN_HEADERS out-dec/all)
	    (export-column-headers (list pmi-ls) out-inc/all)
	    (export-column-headers COLUMN_HEADERS out-inc/all)
	    (export-column-headers (list pmi-ls) out-dec/mr)
	    (export-column-headers COLUMN_HEADERS out-dec/mr)
	    (export-column-headers (list pmi-ls) out-dec/pr)
	    (export-column-headers COLUMN_HEADERS out-dec/pr)
	    (export-column-headers (list pmi-ls) out-inc/mr)
	    (export-column-headers COLUMN_HEADERS out-inc/mr)
	    (export-column-headers (list pmi-ls) out-inc/pr)
	    (export-column-headers COLUMN_HEADERS out-inc/pr)

	    (define export-drug-dec-gene/edges
	      (outer-loop x-dec-o/edge out-dec/all))
	    (define export-drug-inc-gene/edges
	      (outer-loop x-inc-o/edge out-inc/all))
	    (define export_pure_mixed_drug_downregulators
	      (outer-loop/dec x-dec-o/edge out-dec/mr out-dec/pr))
	    (define export_pure_mixed_drug_upregulators
	      (outer-loop/inc x-inc-o/edge out-inc/mr out-inc/pr))

       
	    #|--- MOLECULAR-ENTITY->INC/DEC->GENE 1-HOP EXPORT: COLUMN HEADERS & DATA ---|#

       	    (export-column-headers (list pmi-ls) out-all_molecular_entity_dec)
	    (export-column-headers COLUMN_HEADERS_MOL out-all_molecular_entity_dec)
	    
	    (export-column-headers (list pmi-ls) out-all_molecular_entity_inc)
	    (export-column-headers COLUMN_HEADERS_MOL out-all_molecular_entity_inc)
	    
	    (export-column-headers (list pmi-ls) out-mixed_molecular_entity_dec)
	    (export-column-headers COLUMN_HEADERS_MOL out-mixed_molecular_entity_dec)
	    
	    (export-column-headers (list pmi-ls) out-pure_molecular_entity_dec)
	    (export-column-headers COLUMN_HEADERS_MOL out-pure_molecular_entity_dec)
	    
	    (export-column-headers (list pmi-ls) out-pure_molecular_entity_inc)
	    (export-column-headers COLUMN_HEADERS_MOL out-pure_molecular_entity_inc)
	    
	    (export-column-headers (list pmi-ls) out-mixed_molecular_entity_inc)
	    (export-column-headers COLUMN_HEADERS_MOL out-mixed_molecular_entity_inc)

	    (define export-mol-entity-dec-gene/edges
	      (outer-loop mol_entity-dec-o/edge out-all_molecular_entity_dec))
	    (define export-mol-entity-inc-gene/edges
	      (outer-loop mol_entity-inc-o/edge out-all_molecular_entity_inc))
	    
	    (define export_pure_mixed_gene_downregulators
	      (outer-loop/dec mol_entity-dec-o/edge out-mixed_molecular_entity_dec out-pure_molecular_entity_dec))
	    (define export_pure_mixed_gene_upregulators
	      (outer-loop/inc mol_entity-inc-o/edge out-mixed_molecular_entity_inc out-pure_molecular_entity_inc))

	    #|


       ;;CODE FOR 2-HOP LOOKUPS		
	    ;;NEED TO PRUNE OUT META IDENTIFIERS LIKE "GENE" FROM XREF-GATHERED LIST, 8 hr run didnt get past drug inc
	    ;; gene inc gene....

	    
	    (newline)
	    (displayln (format "~a ALIASES/EXTERNAL-IDENTIFIERS FOUND\n~a ACTIVATORS OF ~a" (length mol_entity-inc-o-xrefs) filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)
	    
	    (newline)
	    (displayln (format "~a ALIASES/EXTERNAL-IDENTIFIERS FOUND\n~a INHIBITORS OF ~a" (length mol_entity-dec-o-xrefs) filtered-X-molecular_entity sym-hgnc-ls))
	    (newline)
	    				
	    (newline)			 
	    (displayln			 
	    (format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->INCREASES-->~a-->INCREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls))  
	    (newline)			 
					 
	    (match-define		 
	     (list b-inc-gene=>concepts b-inc-gene=>edges)    
	     (time					      
	      (run/graph				      
	       ((B drugs)				      
		(mol_entity-inc-o-xrefs mol_entity-inc-o-xrefs))  
	       ((B->inc increases))				  
	       (B B->inc mol_entity-inc-o-xrefs))))  
					 
	    (define drug-upregulators-of-molecular-entity-inc-gene-ls (hash-ref b-inc-gene=>edges 'B->inc))

	    (newline)
	    (displayln (format "~a INDIRECT ACTIVATORS EDGES FOUND! " (length drug-upregulators-of-molecular-entity-inc-gene-ls)))
	    (newline)

	    ;; consider pruning down these edges based on whether they contain
	    ;; drugs that are not FDA approved at the point of edge collection
	    ;; function idea --> edge-pruner, if edge doesnt contain umls status/drug-bank status/rx-norm status
	    ;; then discard it.
	    ;; if edge concept exists on a drug->inc-gene or drug-dec-gene list already, keep it.
	    ;; if drug is a down-regulator of genes that upregulate gene and a downregulate of the target gene
	    ;; we can give it "super downregulator" status. 

	    #|(displayln "drug->inc->MOL_ENTITY->inc->gene-xrefs!")
	    (pretty-print
	     (remove-duplicates
	      (prune-xrefs
	       (flatten
 		(get-concept-xrefs-from-edges drug-upregulators-of-molecular-entity-inc-gene-ls '())) '())))|#
					 
	    (newline)			 
	    (displayln			 
	    (format "MATCHING:\n~a-->INCREASES-->~a-->INCREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls))  
	    (newline)			 
					 
	    (define drug-inc-mol-entity-inc-gene/edge  
	      (time				       
	       (remove-duplicates		       
		(match-drug-pred-gene-edges	       
		 drug-upregulators-of-molecular-entity-inc-gene-ls '()))))
	    
					 
	    (newline)			 
	    (displayln			 
	    (format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->DECREASES-->~a-->INCREASES-->GENE" filtered-X-drug filtered-X-molecular_entity))  
	    (newline)			 
 					 
	    (match-define		 
	     (list j-dec-gene=>concepts j-dec-gene=>edges)    
	     (time					      
	      (run/graph				      
	       ((J drugs)				      
		(mol_entity-inc-o-xrefs mol_entity-inc-o-xrefs))  
	       ((J->dec decreases))				  
	       (J J->dec mol_entity-inc-o-xrefs))))  
       					 
	    (define drug-downregulators-of-molecular-entity-inc-gene-ls (hash-ref j-dec-gene=>edges 'J->dec))

	    (displayln "drug->dec->MOL_ENTITY->inc->gene-xrefs!")
	    (pretty-print
	     (remove-duplicates
	      (prune-xrefs
	       (flatten
 		(get-concept-xrefs-from-edges drug-downregulators-of-molecular-entity-inc-gene-ls '())) '())))

       					 
	    (newline)			 
	    (displayln			 
	    (format "MATCHING:\n~a-->DECREASES-->~a-->INCREASES-->GENE" filtered-X-drug filtered-X-molecular_entity))  
	    (newline)			 
       					 
	    (define drug-dec-mol-entity-inc-gene/edge  
	      (time				       
	       (remove-duplicates		       
		(match-drug-pred-gene-edges	       
		 drug-downregulators-of-molecular-entity-inc-gene-ls '()))))  
       					 
					 
	    (newline)			 
	    (displayln			 
	    (format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->INCREASES-->~a-->DECREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls))  
	    (newline)			 
					 
	    (match-define		 
	    (list d-inc-gene=>concepts d-inc-gene=>edges)  
	    (time			 
	    (run/graph			 
	    ((D drugs)			 
	    (mol_entity-dec-o-xrefs mol_entity-dec-o-xrefs))  
	    ((D->inc increases))	 
	    (D D->inc mol_entity-dec-o-xrefs))))  
					 
	    (define drug-upregulators-of-molecular-entity-dec-gene-ls (hash-ref d-inc-gene=>edges 'D->inc))  
					 
       					 
	    (newline)			 
	    (displayln (format "MATCHING\n~a-->INCREASES-->~a-->DECREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls))  
	    (newline)			 
       					 
	    (define drug-inc-mol-entity-dec-gene/edge  
	      (time				       
	       (remove-duplicates		       
		(match-drug-pred-gene-edges	       
		 drug-upregulators-of-molecular-entity-dec-gene-ls '()))))  
       					 
	    (newline)			 
	    (displayln			 
	    (format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->DECREASES-->~a-->DECREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls))  
	    (newline)			 
       					 
	    (match-define		 
	     (list f-dec-gene=>concepts f-dec-gene=>edges)    
	     (time					      
	      (run/graph				      
	       ((F drugs)				      
		(mol_entity-dec-o-xrefs mol_entity-dec-o-xrefs))  
	       ((F->dec decreases))				  
	       (F F->dec mol_entity-dec-o-xrefs))))  
       					 
	    (define drug-downregulators-of-molecular-entity-dec-gene-ls (hash-ref f-dec-gene=>edges 'F->dec))  
       					 
	    (newline)			 
	    (displayln (format "MATCHING\n~a-->DECREASES-->~a-->DECREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls))  
	    (newline)			 
       					 
	    (define drug-dec-mol-entity-dec-gene/edge  
	      (time				       
	       (remove-duplicates		       
		(match-drug-pred-gene-edges	       
		 drug-downregulators-of-molecular-entity-dec-gene-ls '()))))  
       					 
	    (newline)			 
	    (displayln "MATCHING COMPLETE!\n BEGINNING EDGE EXPORT")  
	    (newline)			 
       					 
	    (define drug-dec-mol-entitiy-dec-gene-pure-indirect-upregulator?  
	      (lambda (ls)		 
		(and (member? (list-ref ls 1) (flatten drug-dec-mol-entity-dec-gene/edge))  
		     (not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-inc-gene/edge)))  
		     (not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-dec-gene/edge))))))  
					 
	    (define drug-inc-mol-entity-inc-gene-pure-indirect-upregulator?  
	      (lambda (ls)		 
		(and (member? (list-ref ls 1) (flatten drug-inc-mol-entity-inc-gene/edge))  
		     (not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-inc-gene/edge)))  
		     (not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-dec-gene/edge))))))  
					 
	    (define drug-inc-mol-entity-dec-gene-pure-indirect-downregulator?  
	      (lambda (ls)		 
		(and (member? (list-ref ls 1) (flatten drug-inc-mol-entity-dec-gene/edge))  
		     (not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-inc-gene/edge)))  
		     (not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-dec-gene/edge))))))  
       					 
	    (define drug-dec-mol-entity-inc-gene-pure-indirect-downregulator?  
	      (lambda (ls)		 
		(and (member? (list-ref ls 1) (flatten drug-dec-mol-entity-inc-gene/edge))  
		     (not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-inc-gene/edge)))  
		     (not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-dec-gene/edge))))))  
					 
       					
       ;;; indirect downregulators	
       ;; port1 = out-drug-inc-molecular_entity->dec->gene 
       ;; drug-inc-mol-entity-dec-gene-pure-indirect-downregulator? 
       ;;       = out-drug-dec-molecular_entity->inc->gene 
       ;; drug-dec-mol-entity-inc-gene-pure-indirect-downregulator? 
       					
       ;;; indirect upregulators	
       ;; port2 = out-drug-inc-molecular_entity->inc->gene 
       ;; drug-inc-mol-entity-inc-gene-pure-indirect-upregulator? 
       ;;       = out-drug-dec-molecular_entity->dec->gene 
       ;; drug-dec-mol-entitiy-dec-gene-pure-indirect-upregulator? 
					
	    (define outer-loop/indirect-regulators	    
	      (lambda (ls port1 port2 port3 port4)	    
		(cond					    
		  ((null? ls)				    
		   (close-output-port port1)		    
		   (close-output-port port2)		    
		   (close-output-port port3)		    
		   (close-output-port port4))		    
		  ((not (pure-drug-upregulator? (car ls)))  
		   (cond				    
		     ((drug-inc-mol-entity-dec-gene-pure-indirect-downregulator? (car ls))  
		      (inner-loop (car ls) port1)	       
		      (fprintf port1 (format "~c" #\newline))  
		      (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4))  
		     ((drug-dec-mol-entity-inc-gene-pure-indirect-downregulator? (car ls))  
		      (inner-loop (car ls) port2)	       
		      (fprintf port2 (format "~c" #\newline))  
		      (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4))  
		     (else		 
		      (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4))))  
		  ((not (pure-drug-downregulator? (car ls)))  
		   (cond				      
		     ((drug-inc-mol-entity-inc-gene-pure-indirect-upregulator? (car ls))  
		      (inner-loop (car ls) port3)	       
		      (fprintf port3 (format "~c" #\newline))  
		      (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4))  
		     ((drug-dec-mol-entitiy-dec-gene-pure-indirect-upregulator? (car ls))  
		      (inner-loop (car ls) port4)  
		      (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4))))  
		  (else			 
		   (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4)))))  
					 
					 
					 
	    (export-column-headers (list pmi-ls) out-drug-dec-molecular_entity->inc->gene)  
	    (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-dec-molecular_entity->inc->gene)  
       					 
	    (export-column-headers (list pmi-ls) out-drug-inc-molecular_entity->dec->gene)  
	    (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-inc-molecular_entity->dec->gene)  
       					 
	    (export-column-headers (list pmi-ls) out-drug-dec-molecular_entity->dec->gene)  
	    (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-dec-molecular_entity->dec->gene)  
       					 
	    (export-column-headers (list pmi-ls) out-drug-inc-molecular_entity->inc->gene)  
	    (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-inc-molecular_entity->inc->gene)  
					 
              				 
	    (define export_pure_indirect_upregulators_drug->inc->mol-entity->inc->gene  
	      (outer-loop/indirect-regulators	        
	       drug-inc-mol-entity-inc-gene/edge        
	       out-drug-inc-molecular_entity->dec->gene  
	       out-drug-dec-molecular_entity->inc->gene  
	       out-drug-inc-molecular_entity->inc->gene  
	       out-drug-dec-molecular_entity->dec->gene))  
       					 
	    (define export_pure_indirect_upregulators_drug->dec->mol-entity->dec-gene  
	      (outer-loop/indirect-regulators	        
	       drug-dec-mol-entity-dec-gene/edge        
	       out-drug-inc-molecular_entity->dec->gene  
	       out-drug-dec-molecular_entity->inc->gene  
	       out-drug-inc-molecular_entity->inc->gene  
	       out-drug-dec-molecular_entity->dec->gene))  
					 
	    (define export_pure_indirect_downregulators_drug->dec->mol-entity->inc->gene  
	      (outer-loop/indirect-regulators	        
	       drug-dec-mol-entity-inc-gene/edge        
	       out-drug-inc-molecular_entity->dec->gene  
	       out-drug-dec-molecular_entity->inc->gene  
	       out-drug-inc-molecular_entity->inc->gene  
	       out-drug-dec-molecular_entity->dec->gene))  
					 
	    (define export_pure_indirect_downregulators_drug->inc->mol-entity->dec-gene  
	      (outer-loop/indirect-regulators	        
	       drug-inc-mol-entity-dec-gene/edge        
	       out-drug-inc-molecular_entity->dec->gene  
	       out-drug-dec-molecular_entity->inc->gene  
	       out-drug-inc-molecular_entity->inc->gene  
	       out-drug-dec-molecular_entity->dec->gene))  
   		       
	    
|#
	    (newline)
	    (displayln (format "CASE ~s COMPLETE!" pmi-ls))
	    (newline)))))

(start-function pmi-ls hgnc-id-ls sym-hgnc-ls)

#|
  (newline)
  (displayln "1-HOP & 2-HOP QUERIES COMPLETE!")
  (newline)
|#
  (newline)
  (display (format "TOTAL RUN TIME:" ))
  (newline))


#|
((semmed 0 . "biological_entity")
  (semmed 1 . "biological_process_or_activity")
  (semmed 2 . "gene")
  (orange 0 . "(\"phenotypic feature\")")
  (semmed 3 . "cell")
  (semmed 4 . "chemical_substance")
  (orange 1 . "(\"All\")")
  (semmed 5 . "anatomical_entity")
  (semmed 6 . "protein")
  (orange 2 . "(\"named thing\")")
  (robokop 0 . "(\"named_thing\" \"gene\")")
  (semmed 7 . "disease_or_phenotypic_feature")
  (semmed 8 . "gross_anatomical_structure")
  (orange 3 . "(\"biological process\")")
  (semmed 9 . "genomic_entity")
  (rtx 0 . "chemical_substance")
  (semmed 10 . "cell_component")
  (orange 4 . "(\"cellular component\")")
  (robokop 1 . "(\"named_thing\" \"chemical_substance\")")
  (semmed 11 . "activity_and_behavior")
  (semmed 12 . "phenotypic_feature")
  (orange 5 . "(\"disease\")")
  (rtx 1 . "protein")
  (orange 6 . "(\"gene\")")
  (robokop 2 . "(\"named_thing\" \"biological_process_or_activity\")")
  (orange 7 . "(\"quality\")")
  (rtx 2 . "microRNA")
  (orange 8 . "(\"entity\")")
  (robokop 3 . "(\"named_thing\" \"disease\")")
  (orange 9 . "(\"cell\")")
  (rtx 3 . "metabolite")
  (orange 10 . "(\"shape\")")
  (robokop 4 . "(\"named_thing\" \"genetic_condition\" \"disease\")")
  (orange 11 . "(\"region\")")
  (rtx 4 . "pathway")
  (orange 12 . "(\"food material\")")
  (robokop
   5
   .
   "(\"anatomical_entity\" \"named_thing\" \"cellular_component\" \"cell\")")
  (orange 13 . "(\"anatomical entity\")")
  (rtx 5 . "cellular_component")
  (orange 14 . "(\"connected anatomical structure\")")
  (robokop 6 . "(\"named_thing\" \"phenotypic_feature\")")
  (orange 15 . "(\"transcript\")")
  (rtx 6 . "disease")
  (orange 16 . "(\"has affected feature\")")
  (robokop 7 . "(\"anatomical_entity\" \"named_thing\")")
  (orange 17 . "(\"NCBITaxon:29960\")")
  (rtx 7 . "anatomical_entity")
  (orange 18 . "(\"NCBITaxon:85552\")")
  (robokop
   8
   .
   "(\"anatomical_entity\" \"named_thing\" \"cellular_component\")")
  (orange 19 . "(\"genomic entity\" \"gene\")")
  (rtx 8 . "phenotypic_feature")
  (orange 20 . "(\"occurrent\")")
  (robokop 9 . "(\"named_thing\" \"cellular_component\")")
  (orange 21 . "(\"NCBITaxon:6690\")")
  (rtx 9 . "biological_process")
  (orange 22 . "(\"genomic entity\")")
  (robokop
   10
   .
   "(\"named_thing\" \"genetic_condition\" \"disease\" \"phenotypic_feature\")")
  (orange 23 . "(\"gene\" \"genomic entity\")")
  (rtx 10 . "molecular_function")
  (orange 24 . "(\"has qualifier\")")
  (robokop 11 . "(\"named_thing\" \"gene_family\")")
  (orange 25 . "(\"haplotype\")")
  (robokop 12 . "(\"anatomical_entity\" \"named_thing\" \"cell\")")
  (orange 26 . "(\"obsolete\")")
  (robokop 13 . "(\"named_thing\" \"cell\")")
  (orange 27 . "(\"obsolete class\")")
  (robokop 14 . "(\"named_thing\" \"disease\" \"phenotypic_feature\")")
  (orange 28 . "(\"genome\")")
  (robokop 15 . "(\"named_thing\" \"cellular_component\" \"cell\")")
  (orange 29 . "(\"sequence variant\")")
  (robokop 16 . "(\"named_thing\" \"pathway\")"))
|#




#|
;; top5/outlier-up hgnc-list 
(define pmi-lsV
  '("pmi_18_168"))
#|

(define sym-hgnc-ls
  "upregulated_genes_from_lung_biopsy")
|#


|#

#|
list of fibrosarcoma concepts
(define hgnc-id-ls
  '("UMLS:C1336021"
    "UMLS:C0016057"
    "UMLS:C0855054"
    "HP:0100244"
    "MONDO:0002678"
    "MONDO:0005164"
    "MONDO:0002619"    
    "DOID:3354"
    "DOID:3520"
    "DOID:35198"
    "DOID:3520"
    ))
|#
 
#|
;;gene-list RC
(define hgnc-id-ls/num
  (map number->string
'(38
14899
943
320

19990
489
490
2013
638
14103
15607
14872
974
24176
14343
1325
1389
1537
26295
1705
20455
2174
2191
22990
2333
24292
2498
2530
20348
2907
2908
2926
3010
3016
32188
19087
3154
27234
27683
30114
34236
3603
13590

3761
3800
3801
3817
25491
4092
4122
4131
4882
5141
17087
5466
25251
23236
48664
6617
6664
16895
17200
14575
17082
7159
7171
7514
7614
29832
13395
7746
7775
16191
19321
27106
7909
41983
7952
8126
8134
19316
8604
17270
16068
14180
27559
8890
8906
30065
19255
29037
14683

26303
20331
688
20457
13441
13655
24188
32455
18386
18387
10798
10799
10801
10802
10803
16192
11046
11049
11073
16698
15592
18065
15885
11568
11581
11595
20329
27916
11950
30887
20670
29315
15466
12769
19221
16804
13083
)))
       

(define hgnc-sym-ls
'(ABCA8
ADAMTS14
ADGRB1
AGER
ENSG00000257310
ANAPC4
ANGPTL1
ANGPTL2
AP3S1
AQP5
ARHGEF10
ARHGEF7
ASPN
BCAS1
BTNL9
C1QTNF6
C4BPA
CACNA1B
CBFA2T3
CCDC102B
CD86
CHFR
CNTN4
COL14A1
COL23A1
CPZ
CSGALNACT2
CTDP1
CTSE
DIO3OS
DLK1
DLL1
DMBT1
DPP6
DPYSL4
DUXAP9
EBF3
ECM2
ERICH1
ALKAL2
FAM156A
SHISAL2B
FBN1
FBXO11
FLJ16779
FLRT2
FOXC1
FOXC2
FOXL1
FRMD4A
GAD1
GALNS
GALNT9
HEYL
HP
ICOSLG
IGF2
IQCG
KCTD10
PRDM16-DT
LIPA
LOX
LRRC17
LRRN3
MEG3
MLC1
MMP13
MMP23B
MUC4
MYOM2
NADSYN1
NAPSA
NEK3
NFATC1
NKAIN4
NKX6-2
NOTUM
NPIPA1
NPIPA8
NPTX1
OGN
OMD
P3H1
PAPSS2
PASK
PCNT
PDIA2
PDXDC2P
PGC
PGM2
PKD1P1
PLAC9
PLCH2
POFUT2
PP7080
PXYLP1
RASA3
RHOJ
RNF144A
SCUBE1
SCUBE3
SDF4
SDHAP1
SFTA2
SFTA3
SFTPA1
SFTPA2
SFTPB
SFTPC
SFTPD
SLC17A9
SLC6A13
SLC6A3
SLC9A3
SORCS2
SS18L1
STARD5
SYNDIG1
TARBP1
TBCD
TBX18
TMCO3
TMEM52
TNNT3
TRAPPC2L
TWIST2
VAT1L
WFDC1
CCN4
WSB1
WWP2
ZBTB21
))


(define hgnc-id-ls
  (map (lambda (ls)
	 (string-append "HGNC:" ls))
       hgnc-id-ls/num))
|#



 #|
Queries I'm interested in 
 '(for-peyton)
 '(26926)
'(JAGN1)


 |#
