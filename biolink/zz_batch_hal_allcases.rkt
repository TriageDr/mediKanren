#lang racket
(provide (all-defined-out)
         (all-from-out "common.rkt" "mk-db.rkt"))
(require "common.rkt" "mk-db.rkt")

(time
;;TODO: export, pmi-id with the table. 
(define pmi-ls
  '(PMI-19-168))

(define sym-hgnc-ls
  '(KCNN3))

(define hgnc-id-ls/num
  (map number->string
       '(6292)))

(define hgnc-id-ls
  (map (lambda (ls)
	 (string-append "HGNC:" ls))
       hgnc-id-ls/num))
 
#|
;; top5/outlier-up hgnc-list 
(define pmi-ls
  '("pmi_18_164"))
#|

(define sym-hgnc-ls
  "upregulated_genes_from_lung_biopsy")
|#


|#

#|
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
;;rucker's gene-list
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


(define hgnc-id-ls
  (map (lambda (ls)
	 (string-append "HGNC:" ls))
       hgnc-id-ls/num))
|#
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

(define export-path
  "/home/mjpatton/PhD/CaseReviews/case_registry/queries/pmi_19_95/")

#|
(define export-path
  "/home/mjpatton/PhD/CaseReviews/case_registry/queries/12_04_19_pmi_cases_puredrugfilter_x_pred_gene/")
|#
#|
(define export-path
  "/home/mjpatton/PhD/CaseReviews/case_registry/queries/pmi_18_137/")
|#

#|
;;for real run
(define export-path
  "/home/mjpatton/PhD/CaseReviews/case_registry/queries/pmi_18_137/")
|#

(define PUBMED_URL_PREFIX
  "https://www.ncbi.nlm.nih.gov/pubmed/")

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

(define union
  (lambda (ls1 ls2)
    (cond
      ((null? ls1) ls2)
      ((member? (car ls1) ls2)
       (union (cdr ls1) ls2))
      (else
       (cons (car ls1)
	     (union (cdr ls1) ls2))))))

(define depth
  (lambda (ls)
    (cond
      ((null? ls) 0)
      ((not (pair? ls)) 0)
      (else
       (add1 (depth (car ls)))))))

(define member?
  (lambda (x ls)
    (cond
      ((null? ls) #f)
      (else 
       (or (equal? x (car ls))
           (member? x (cdr ls)))))))

(define intersect?
  (lambda (ls1 ls2)
    (cond
      ((null? ls1) #f)
      ((member? (car ls1) ls2) #t)
      (else
       (intersect? (cdr ls1) ls2)))))

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

(define xrefs/NCBIGENE->NCBIGene
  (lambda (ls)
    (cond
      ((null? ls) '())
      ((void? (car ls))
       (xrefs/NCBIGENE->NCBIGene (cdr ls)))
      ((string-contains? (car ls) "NCBI")
       (cons 
        (string-replace (car ls) "NCBIGENE:" "NCBIGene:")
        (xrefs/NCBIGENE->NCBIGene (cdr ls))))
      (else
       (cons (car ls)
             (xrefs/NCBIGENE->NCBIGene (cdr ls)))))))

(define get-concept-xrefs
  (lambda (concept-ls els)
    (cond
      ((null? concept-ls) (set-union els))
      (else
       (match (car concept-ls)
              [`(,db ,cui ,id ,name ,category ,properties-list)
	       (get-concept-xrefs (cdr concept-ls)
				  (set-union
				   (list id name
					 (get-xrefs orange-concept-key/same-as properties-list)
					 (get-xrefs orange-concept-key/synonym properties-list)
					 (get-xrefs semmed-concept-key/xrefs properties-list)
					 (get-xrefs robokop-concept-key/eq-id properties-list)
					 (get-assoc-value semmed-concept-key/id properties-list)) els))])))))

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

 ;;todo remove duplicate edges 
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

;; real run 
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

#|
;; 1 to many, changed hgnc-id-ls from (car hgnc-id-ls) 
(define start-function
  (time 
   (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
     (cond
       ((null? pmi-ls) (void))
       (else
	(handle (car pmi-ls)  hgnc-id-ls (car sym-hgnc-ls))
	(start-function
	 (cdr pmi-ls) (cdr hgnc-id-ls) (cdr sym-hgnc-ls)))))))
|#

;; TODO, filter out genes for 2 hop based on UMLS type system
;; just like you use fda/status to 
(define handle
  (time
   (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
     (let* ((all-downregulator/path
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
	    (molecular_entity-dec/path
	     (format
	      "~a~a_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (molecular_entity-inc/path
	     (format
	      "~a~a_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (out-molecular_entity_dec
 	     (open-output-file molecular_entity-dec/path #:exists 'replace))
	    (out-molecular_entity_inc
 	     (open-output-file molecular_entity-inc/path #:exists 'replace))
	    (drug-dec-molecular_entity->inc->gene/path
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
	     (open-output-file drug-inc-molecular_entity->inc->gene/path #:exists 'replace))
	    (query-start/hgnc
	     (find-concepts #t (list hgnc-id-ls)))
	    (raw-concepts/hgnc
	     (get-concept-xrefs query-start/hgnc '()))
	    (xrefs-from-hgnc
	     (remove-duplicates
	      (xrefs/NCBIGENE->NCBIGene
	       (flatten (get-concept-xrefs query-start/hgnc '())))))
	    (gene-concept-ls
	     (time
	      (query-with-curie/str xrefs-from-hgnc '())))	    
	    (drugs
	     '((semmed 4 . "chemical_substance")
	       (rtx 0 . "chemical_substance")
	       (robokop 1 . "(\"named_thing\" \"chemical_substance\")")
	       (rtx 3 . "metabolite")
	       (orange 12 . "(\"food material\")")))
	    (filtered-X-drug "BIOLOGICAL-ENTITY, CHEMICAL-SUBSTANCE")
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
	      (rtx 3 . "metabolite")
	      (orange 15 . "(\"transcript\")")))
	    (filtered-X-molecular_entity "MOLECULAR ENTITY")
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
       (newline)
       (display (format "BATCH-QUERY START TIME: ~a" start-time))
       (newline)
       (displayln (format "BEGINNING RUN/GRAPH 1-HOP:\n~a-->DECREASES-->GENE" filtered-X-drug))
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
       (displayln (format "BEGINNING RUN/GRAPH 1-HOP:\n~a-->INCREASES-->GENE" filtered-X-drug))
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
       (displayln (format "MATCHING\n~a-->DECREASES-->GENE-EDGES" filtered-X-drug))
       (newline)

       (define x-dec-o/edge
	 (time
	  (remove-duplicates
	    (match-drug-pred-gene-edges
	     drug-dec-gene-list '()))))
    
       (newline)
       (displayln (format "MATCHING\n~a-->INCREASES-->GENE-EDGES" filtered-X-drug))
       (newline)
       
       (define x-inc-o/edge
	 (time
	  (remove-duplicates
	   (match-drug-pred-gene-edges
	    drug-inc-gene-list '()))))

       (define pure-drug-downregulator?
	 (lambda (ls)
	   (and (member? (list-ref ls 1) (flatten x-dec-o/edge))
		(not (member? (list-ref ls 1) (flatten x-inc-o/edge))))))
       
       (define pure-drug-upregulator?
	 (lambda (ls)
	   (and (member? (list-ref ls 1) (flatten x-inc-o/edge))
		(not (member? (list-ref ls 1) (flatten x-dec-o/edge))))))
      
       (newline)
       (displayln (format "BEGINNING RUN/GRAPH 1-HOP:\n~a-->DECREASES-->GENE" filtered-X-molecular_entity))
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
       (displayln (format "BEGINNING RUN/GRAPH 1-HOP:\n~a-->INCREASES-->GENE" filtered-X-molecular_entity))
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
       (displayln (format "MATCHING\n~a-->DECREASES-->GENE-EDGES" filtered-X-molecular_entity))
       (newline)

       (define mol_entity-dec-o/edge
	 (time
	  (remove-duplicates
	   (match-drug-pred-gene-edges
	    molecular_entity-dec-gene-list '()))))
      
       (newline)
       (displayln (format "MATCHING\n~a-->INCREASES-->GENE-EDGES" filtered-X-molecular_entity))
       (newline)
      
       (define mol_entity-inc-o/edge
	 (time
	  (remove-duplicates
	   (match-drug-pred-gene-edges
	    molecular_entity-inc-gene-list '()))))
       
       (define pure-gene-upregulator?
	 (lambda (ls)
	   (and (member? (list-ref ls 1) (flatten drug-inc-mol-entity/edge))
		(not (member? (list-ref ls 1) (flatten drug-dec-mol-entity/edge))))))
       
       (define pure-gene-downregulator?
	 (lambda (ls)
	   (and (member? (list-ref ls 1) (flatten drug-dec-mol-entity/edge))
		(not (member? (list-ref ls 1) (flatten drug-inc-mol-entity/edge))))))

       (newline)
       (displayln
	(format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->INCREASES-->~a-->INCREASES-->GENE" filtered-X-drug filtered-X-molecular_entity))
       (newline)

       (match-define
	(list b-inc-gene=>concepts b-inc-gene=>edges)
	(time
	 (run/graph
	  ((B drugs)
	   (molecular_entity-inc-gene-list molecular_entity-inc-gene-list))
	  ((B->inc increases))
	  (B B->inc molecular_entity-inc-gene-list))))

       (define drug-upregulators-of-molecular-entity-inc-gene-ls (hash-ref b-inc-gene=>edges 'B->inc))
       
       (newline)
       (displayln
	(format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->DECREASES-->~a-->INCREASES-->GENE" filtered-X-drug filtered-X-molecular_entity))
       (newline)
 
       (match-define
	(list j-dec-gene=>concepts j-dec-gene=>edges)
	(time
	 (run/graph
	  ((J drugs)
	   (molecular_entity-inc-gene-list molecular_entity-inc-gene-list))
	  ((J->dec decreases))
	  (J J->dec molecular_entity-inc-gene-list))))
       
       (define drug-downregulators-of-molecular-entity-inc-gene-ls (hash-ref j-dec-gene=>edges 'J->dec))

	(newline)
	(displayln
	 (format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->INCREASES-->~a-->DECREASES-->GENE" filtered-X-drug filtered-X-molecular_entity))
	(newline)

       (match-define
	(list d-inc-gene=>concepts d-inc-gene=>edges)
	(time
	 (run/graph
	  ((D drugs)
	   (molecular_entity-dec-gene-list molecular_entity-dec-gene-list))
	  ((D->inc increases))
	  (D D->inc molecular_entity-inc-gene-list))))

       (define drug-upregulators-of-molecular-entity-dec-gene-ls (hash-ref d-inc-gene=>edges 'D->inc))

       	(newline)
	(displayln
	(format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->DECREASES-->~a-->DECREASES-->GENE" filtered-X-drug filtered-X-molecular_entity))
	(newline)

	(match-define
	 (list f-dec-gene=>concepts f-dec-gene=>edges)
	 (time
	 (run/graph
	  ((F drugs)
	   (molecular_entity-dec-gene-list molecular_entity-dec-gene-list))
	  ((F->dec decreases))
	  (F F->dec molecular_entity-dec-gene-list))))

	(define drug-downregulators-of-molecular-entity-dec-gene-ls (hash-ref f-dec-gene=>edges 'F->dec))
	       
       (newline)
       (displayln
	(format "MATCHING:\n~a-->INCREASES-->~a-->INCREASES-->GENE" filtered-X-drug filtered-X-molecular_entity)
       (newline)

       (define drug-inc-mol-entity-inc-gene/edge
	 (time
	  (remove-duplicates
	   (match-drug-pred-gene-edges
	    drug-upregulators-of-molecular-entity-inc-gene-ls '()))))
       
       (newline)
       (displayln
	(format "MATCHING:\n~a-->DECREASES-->~a-->INCREASES-->GENE" filtered-X-drug filtered-X-molecular_entity)
	(newline)

	(define drug-dec-mol-entity-inc-gene/edge
	 (time
	  (remove-duplicates
	   (match-drug-pred-gene-edges
	    drug-downregulators-of-molecular-entity-inc-gene-ls '()))))

       
       (newline)
       (displayln (format "MATCHING\n~a-->INCREASES-->~a-->DECREASES-->GENE" filtered-X-drug filtered-X-molecular_entity))
       (newline)
 
       (define drug-inc-mol-entity-dec-gene/edge
	 (time
	  (remove-duplicates
	   (match-drug-pred-gene-edges
	    drug-upregulators-of-molecular-entity-dec-gene-ls '()))))
      
       (newline)
       (displayln (format "MATCHING\n~a-->DECREASES-->~a-->DECREASES-->GENE" filtered-X-drug filtered-X-molecular_entity))
       (newline)
      
       (define drug-dec-mol-entity-dec-gene/edge
	 (time
	  (remove-duplicates
	   (match-drug-pred-gene-edges
	    drug-downregulators-of-molecular-entity-dec-gene-ls '()))))
       
       (define pure-indirect-drug-upregulator?
	 (lambda (ls)
	   (and (member? (list-ref ls 1) (flatten drug-inc-mol-entity-inc-gene/edge))
		(member? (list-ref ls 1) (flatten drug-dec-mol-entity-dec-gene/edge))
		(not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-inc-gene/edge)))
		(not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-dec-gene/edge)))
        
       (define pure-indirect-drug-downregulator?
	 (lambda (ls)
	   (and (member? (list-ref ls 1) (flatten drug-inc-mol-entity-dec-gene/edge))
		(member? (list-ref ls 1) (flatten drug-dec-mol-entity-inc-gene/edge))
		(not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-inc-gene/edge)))
		(not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-dec-gene/edge))))))
       
       
       ;;loops for export
       (define outer-loop/dec
	 (lambda (ls port-mr port-pr port-indirect-pr)
	   (cond
	     ((null? ls)
	      (close-output-port port-mr)
	      (close-output-port port-pr port-indirect-pr))
	     ((pure-drug-downregulator? (car ls))
	      (inner-loop (car ls) port-pr)
	      (fprintf port-pr port-indirect-pr (format "~c" #\newline))
	      (outer-loop/dec (cdr ls) port-mr port-pr port-indirect-pr))
	     ((pure-indirect-drug-downregulator? (car ls))
	      (inner-loop (car ls) port-indirect-pr)
	      (fprintf port-indirect-pr (format "~c" #\newline))
	      (outer-loop/dec (cdr ls) port-mr port-pr port-indirect-pr))
	     (else
	      (inner-loop (car ls) port-mr)
	      (fprintf port-mr (format "~c" #\newline))
	      (outer-loop/dec (cdr ls) port-mr port-pr port-indirect-pr)))))

       (define outer-loop/inc
	 (lambda (ls port-mr port-pr port-indirect-pr)
	   (cond
	     ((null? ls)
	      (close-output-port port-mr)
	      (close-output-port port-pr port-indirect-pr))
	     ((pure-drug-upregulator? (car ls))
	      (inner-loop (car ls) port-pr)
	      (fprintf port-pr port-indirect-pr (format "~c" #\newline))
	      (outer-loop/inc (cdr ls) port-mr port-pr port-indirect-pr))
	     ((pure-indirect-drug-upregulator? (car ls))
	      (inner-loop (car ls) port-indirect-pr)
	      (fprintf port-indirect-pr (format "~c" #\newline))
	      (outer-loop/dec (cdr ls) port-mr port-pr port-indirect-pr))
	     (else
	      (inner-loop (car ls) port-mr)
	      (fprintf port-mr (format "~c" #\newline))
	      (outer-loop/inc (cdr ls) port-mr port-pr port-indirect-pr)))))
       
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
        
       (export-column-headers (list pmi-ls) out-dec/mr)
       (export-column-headers COLUMN_HEADERS out-dec/mr)
       
       (export-column-headers (list pmi-ls) out-dec/pr)
       (export-column-headers COLUMN_HEADERS out-dec/pr)
       
       (export-column-headers (list pmi-ls) out-dec/mr)
       (export-column-headers COLUMN_HEADERS out-dec/mr)
       
       (export-column-headers (list pmi-ls) out-inc/mr)
       (export-column-headers COLUMN_HEADERS out-inc/mr)
       
       (export-column-headers (list pmi-ls) out-inc/pr)
       (export-column-headers COLUMN_HEADERS out-inc/pr)

       (export-column-headers (list pmi-ls) out-dec/all)
       (export-column-headers COLUMN_HEADERS out-dec/all)

       (export-column-headers (list pmi-ls) out-inc/all)
       (export-column-headers COLUMN_HEADERS out-inc/all)

       (export-column-headers (list pmi-ls) out-molecular_entity_dec)
       (export-column-headers COLUMN_HEADERS_MOL out-molecular_entity_dec)

       (export-column-headers (list pmi-ls) out-molecular_entity_inc)
       (export-column-headers COLUMN_HEADERS_MOL out-molecular_entity_inc)

       (export-column-headers (list pmi-ls) out-drug-dec-molecular_entity->inc->gene)
       (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-dec-molecular_entity->inc->gene)
       
       (export-column-headers (list pmi-ls out-drug-inc-molecular_entity->dec->gene)
       (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-inc-molecular_entity->dec->gene)
       
       (export-column-headers (list pmi-ls) out-drug-dec-molecular_entity->dec->gene)
       (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-dec-molecular_entity->dec->gene)
       
       (export-column-headers (list pmi-ls) out-drug-inc-molecular_entity->inc->gene)
       (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-inc-molecular_entity->inc->gene)       
  
       (define export_pure_mixed_downregulators
	 (outer-loop/dec x-dec-o/edge out-dec/mr out-dec/pr))
       (define export_pure_mixed_upregulators
	 (outer-loop/inc x-inc-o/edge out-inc/mr out-inc/pr))
       ;;; changed outer-loop dec to take 3 args, return here in 10 
       (outer-loop/dec x-dec-o/edge out-dec/mr out-dec/pr)
       (outer-loop/dec x-dec-o/edge out-dec/mr out-dec/pr)

       (outer-loop/inc x-inc-o/edge out-inc/mr out-inc/pr)
       (outer-loop/inc x-inc-o/edge out-inc/mr out-inc/pr)



       
       (define export-x-dec-gene/edges
	 (outer-loop x-dec-o/edge out-dec/all))
       (define export-x-inc-gene/edges
	 (outer-loop x-inc-o/edge out-inc/all))

       (define export-mol-entity-dec-gene/edges
	 (outer-loop mol_entity-dec-o/edge out-molecular_entity_dec))
       (define export-mol-entity-inc-gene/edges
	 (outer-loop mol_entity-inc-o/edge out-molecular_entity_inc))

       (newline)
       (displayln (format "CASE ~s COMPLETE!" pmi-ls))
       (newline)
       
       ))))

(start-function pmi-ls hgnc-id-ls sym-hgnc-ls)


(newline)
(display (format "TOTAL RUN TIME:" ))
(newline))

#|
(define end-time (current-seconds))
(newline)
(newline)
(display (format "BATCH-QUERY FINISH TIME: ~a" end-time))
(newline)
(newline)
(display (format "TOTAL RUN TIME: ~a MILLISECONDS!" (- end-time start-time)))
(newline)
(newline)
|#



#|
;;for testing, removing handle
(define query-start/hgnc
  (find-concepts #t hgnc-id-ls))


(define all-downregulator/path
  (format
   "~a~a_all_drug_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define all-upregulator/path
  (format
   "~a~a_all_drug_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define mixed-downregulator/path
  (format
   "~a~a_mixed_drug_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define pure-downregulator/path
  (format
   "~a~a_pure_drug_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define mixed-upregulator/path
  (format
   "~a~a_mixed_drug_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define pure-upregulator/path
  (format
   "~a~a_pure_drug_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))

(define out-dec/all
  (open-output-file all-downregulator/path #:exists 'replace))
(define out-inc/all
  (open-output-file all-upregulator/path #:exists 'replace))
(define out-dec/mr
  (open-output-file mixed-downregulator/path #:exists 'replace))
(define out-inc/mr
  (open-output-file mixed-upregulator/path #:exists 'replace))
(define out-dec/pr
  (open-output-file pure-downregulator/path #:exists 'replace))
(define out-inc/pr
  (open-output-file pure-upregulator/path #:exists 'replace))

#|
;;old paths for combined dec/inc exports
(define drug-inc-genes/path
	 (format
	  "~a~a_drug_increases_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define drug-dec-genes/path
	 (format
	  "~a~a_drug_decreases_~a.tsv" export-path pmi-ls sym-hgnc-ls))
|#

(define raw-concepts/hgnc
	 (get-concept-xrefs query-start/hgnc '()))
(define xrefs-from-hgnc
	     (remove-duplicates
	      (xrefs/NCBIGENE->NCBIGene
	       (flatten (get-concept-xrefs query-start/hgnc '())))))
(define gene-concept-ls
	     (time
	      (query-with-curie/str xrefs-from-hgnc '())))	    
(define filtered-X (list "biological_entity" "chemical_substance"))
(define drugs (find-categories (list "biological_entity" "chemical_substance")))
	    

(newline)
(displayln "BEGINNING RUN/GRAPH X-->DECREASES-->GENE")
(newline)

(match-define
 (list x-dec-gene=>concepts x-dec-gene=>edges)
 (time
  (run/graph
   ((X drugs) 
    (gene-concept-ls gene-concept-ls))
   ((X->dec decreases))
   (X X->dec gene-concept-ls))))

(newline)
(displayln "BEGINNING RUN/GRAPH X-->INCREASES-->GENE")
(newline)

(match-define
 (list y-inc-gene=>concepts y-inc-gene=>edges)
	(time
	 (run/graph
	  ((Y drugs)
	   (gene-concept-ls gene-concept-ls))
	  ((Y->inc increases))
	  (Y Y->inc gene-concept-ls))))

(define drug-dec-gene-list (hash-ref x-dec-gene=>edges 'X->dec))
(define drug-inc-gene-list (hash-ref y-inc-gene=>edges 'Y->inc))

(newline)
(displayln "MATCHING X-->DECREASES-->GENE EDGES")
(newline)

(define x-dec-o/edge
  (time (match-drug-pred-gene-edges
	 drug-dec-gene-list '())))

(newline)
(displayln "MATCHING X-->INCREASES-->GENE EDGES")
(newline)

(define x-inc-o/edge
  (time (match-drug-pred-gene-edges
	 drug-inc-gene-list '())))

(define export_pure_mixed_downregulators
  (outer-loop/dec x-dec-o/edge out-dec/mr out-dec/pr))
(define export_pure_mixed_upregulators
  (outer-loop/inc x-inc-o/edge out-inc/mr out-inc/pr))
(define export-x-dec-gene/edges
  (outer-loop x-dec-o/edge out-dec/all))
(define export-x-inc-gene/edges
  (outer-loop x-inc-o/edge out-inc/all))

(newline)
(displayln (format "CASE ~a COMPLETE!" pmi-ls))
(newline)

|#



;;for real run 
#|
(define handle
  (time
   (lambda (hgnc-id-ls)
     (let* ((query-start/hgnc
	     (find-concepts #t hgnc-id-ls))
	    (drug-inc-genes/path
	     (format
	      "~a~a_drug_increases_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (drug-dec-genes/path
	     (format
	      "~a~a_drug_decreases_~a.tsv" export-path pmi-ls sym-hgnc-ls))
	    (raw-concepts/hgnc
	     (get-concept-xrefs query-start/hgnc '()))
	    (xrefs-from-hgnc
	     (remove-duplicates
	      (xrefs/NCBIGENE->NCBIGene
	       (flatten (get-concept-xrefs query-start/hgnc '())))))
	    (gene-concept-ls
	     (time
	      (query-with-curie/str xrefs-from-hgnc '())))
	    (filtered-X (list "biological_entity" "chemical_substance"))
	    (drugs (find-categories (list "biological_entity" "chemical_substance"))))
       
       (newline)
       (displayln "BEGINNING RUN/GRAPH X-->DECREASES-->GENE")
       (newline)
      
       (match-define
	(list x-dec-gene=>concepts x-dec-gene=>edges)
	(time
	 (run/graph
	  ((X drugs) 
	   (gene-concept-ls gene-concept-ls))
	  ((X->dec decreases))
	  (X X->dec gene-concept-ls))))

       (newline)
       (displayln "BEGINNING RUN/GRAPH X-->INCREASES-->GENE")
       (newline)
      
       (match-define
	(list y-inc-gene=>concepts y-inc-gene=>edges)
	(time
	 (run/graph
	  ((Y drugs)
	   (gene-concept-ls gene-concept-ls))
	  ((Y->inc increases))
	  (Y Y->inc gene-concept-ls))))
      
       (define drug-dec-gene-list (hash-ref x-dec-gene=>edges 'X->dec))
      
       (define drug-inc-gene-list (hash-ref y-inc-gene=>edges 'Y->inc))

       (newline)
       (displayln "MATCHING X-->DECREASES-->GENE EDGES")
       (newline)
      
       (define x-dec-o/edge
	 (time (match-drug-pred-gene-edges
		drug-dec-gene-list '())))
      
       (newline)
       (displayln "MATCHING X-->INCREASES-->GENE EDGES")
       (newline)
      
       (define x-inc-o/edge
	 (time (match-drug-pred-gene-edges
		drug-inc-gene-list '())))

       (define out-dec (open-output-file drug-dec-genes/path #:exists 'replace))
       (define out-inc (open-output-file drug-inc-genes/path #:exists 'replace))

       (define export-x-dec-gene/edges (outer-loop x-dec-o/edge out-dec))
       (define export-x-inc-gene/edges (outer-loop x-inc-o/edge out-inc))

       (newline)
       (displayln (format "CASE ~s COMPLETE!" pmi-ls))))))

(handle hgnc-id-ls)
|#



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
