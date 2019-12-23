#lang racket
(provide (all-defined-out)
         (all-from-out "common.rkt" "mk-db.rkt"))
(require "common.rkt" "mk-db.rkt")


(define export-path
  "/home/mjpatton/PhD/CaseReviews/18_50_PMICase/")

;;pmi 18-50 ch12 dup-inv
(define pmi-ls
  '("PMI-18-50"))

(define sym-hgnc-ls
  '("chr12_duplication_inversion_21q.13.13.21q"))

(define hgnc-id-ls/num
  (remove-duplicates
   (map number->string
	'(9940
	  9909
	  9908
	  9866
	  9857
	  9804
	  9784
	  9680
	  9665
	  962
	  9461
	  9369
	  9286
	  9224
	  895
	  8869
	  8775
	  8648
	  858
	  8563
	  8550
	  8421
	  842
	  8355
	  830
	  8078
	  7980
	  792
	  7901
	  7878
	  783
	  7780
	  7629
	  7627
	  7595
	  7587
	  7165
	  7133
	  7103
	  7030
	  6973
	  6960
	  6898
	  6851
	  6740
	  6692
	  6504
	  6463
	  6462
	  6461
	  6460
	  6459
	  6458
	  6446
	  6445
	  6444
	  6443
	  6442
	  6441
	  6440
	  6439
	  6430
	  6412
	  639
	  638
	  634
	  6323
	  6289
	  6252
	  6162
	  615
	  6143
	  6141
	  6068
	  5475
	  5438
	  54352
	  54075
	  54017
	  53990
	  53976
	  53973
	  53942
	  53387
	  53380
	  53374
	  53356
	  53351
	  53350
	  53337
	  53330
	  53322
	  53316
	  53315
	  53308
	  53307
	  53304
	  53299
	  53295
	  53100
	  52649
	  52643
	  52345
	  51851
	  51811
	  51694
	  51614
	  51552
	  51540
	  51399
	  5130
	  5129
	  5128
	  5127
	  5126
	  5125
	  5124
	  5123
	  5122
	  51123
	  50493
	  50414
	  5031
	  50160
	  5009
	  50063
	  50062
	  50060
	  50038
	  49931
	  49626
	  49607
	  49426
	  49150
	  48910
	  48887
	  48882
	  48875
	  48874
	  48800
	  48799
	  48756
	  48741
	  48735
	  48734
	  48633
	  4862
	  48425
	  48236
	  48056
	  48046
	  47972
	  47913
	  47842
	  47834
	  47797
	  47732
	  47558
	  47537
	  47362
	  47306
	  47296
	  47242
	  47201
	  47162
	  47129
	  47050
	  47001
	  46956
	  46941
	  46825
	  46820
	  46760
	  46692
	  46535
	  465
	  46406
	  4640
	  46013
	  45890
	  45789
	  4535
	  45278
	  45263
	  45189
	  4504
	  4455
	  44532
	  44508
	  4422
	  44113
	  43910
	  43892
	  43753
	  43751
	  43750
	  43749
	  43729
	  43629
	  43262
	  4317
	  43004
	  42650
	  4254
	  42529
	  4216
	  4200
	  41975
	  41766
	  41521
	  4128
	  4117
	  40019
	  39873
	  39559
	  39423
	  38953
	  38929
	  38884
	  38743
	  37923
	  37870
	  37841
	  37811
	  37801
	  37682
	  37005
	  36944
	  36918
	  36755
	  36732
	  36693
	  36498
	  36480
	  36297
	  36214
	  36061
	  36027
	  35813
	  35752
	  35655
	  35619
	  35600
	  35569
	  35543
	  35357
	  35286
	  35146
	  35085
	  34714
	  34502
	  34359
	  3431
	  34136
	  34135
	  34100
	  33942
	  33928
	  33510
	  33371
	  3308
	  32970
	  32872
	  32871
	  3285
	  32800
	  32723
	  32680
	  32441
	  31761
	  31611
	  31568
	  31486
	  31416
	  31384
	  31306
	  31305
	  31304
	  31303
	  31302
	  31301
	  31300
	  31299
	  31298
	  31297
	  31296
	  31295
	  31294
	  31293
	  31292
	  31235
	  31036
	  30991
	  3093
	  30748
	  30688
	  30588
	  30275
	  30258
	  30198
	  30197
	  30196
	  30195
	  30149
	  29958
	  29917
	  29914
	  29836
	  29823
	  29674
	  29570
	  29534
	  29452
	  29321
	  29306
	  29284
	  29177
	  29167
	  29164
	  29109
	  29014
	  29001
	  28932
	  28930
	  28929
	  28928
	  28927
	  28926
	  28887
	  28779
	  2865
	  2849
	  28423
	  28412
	  28362
	  28328
	  28276
	  28229
	  28216
	  28156
	  28044
	  27474
	  27468
	  27465
	  27463
	  27375
	  2726
	  2712
	  27056
	  27050
	  26980
	  26967
	  26918
	  2684
	  26614
	  26565
	  26517
	  26515
	  26364
	  26316
	  2606
	  25920
	  25893
	  25802
	  25694
	  25679
	  25605
	  25296
	  25139
	  25031
	  24936
	  24859
	  24636
	  24581
	  24550
	  24528
	  24457
	  24432
	  24431
	  24430
	  24320
	  24257
	  24241
	  2422
	  24029
	  23786
	  23749
	  23698
	  23316
	  2311
	  22804
	  2274
	  2243
	  21589
	  21166
	  20864
	  20854
	  20768
	  20766
	  20692
	  20633
	  20502
	  20445
	  20411
	  20406
	  20264
	  20074
	  19737
	  19632
	  19631
	  19414
	  19402
	  18966
	  18809
	  18708
	  18707
	  18650
	  18583
	  18401
	  18268
	  18263
	  18081
	  18023
	  1773
	  1771
	  17590
	  17521
	  175
	  17382
	  17321
	  172
	  17196
	  17148
	  17119
	  17105
	  17077
	  17067
	  17020
	  16994
	  16971
	  16921
	  1692
	  16856
	  16508
	  16430
	  1615
	  16049
	  16037
	  16006
	  1555
	  15488
	  15437
	  15436
	  15378
	  15340
	  15339
	  15338
	  15335
	  15332
	  15329
	  14900
	  14669
	  14470
	  14271
	  14188
	  14130
	  13871
	  13802
	  13788
	  13708
	  13666
	  13530
	  13529
	  13287
	  13179
	  12826
	  12676
	  12613
	  12367
	  12327
	  11855
	  11813
	  11748
	  11723
	  11584
	  11569
	  11521
	  11460
	  11368
	  11363
	  11205
	  11178
	  11106
	  11105
	  11034
	  10928
	  10908
	  10880
	  10852
	  10596
	  10539
	  1053
	  10414
	  10354
	  10210
	  100
	  ))))

#|

;;pmi18-137 ch16 del

(define pmi-ls
  '("PMI-18-137"))

(define sym-hgnc-ls
  '("16p13.3deletion"))

(define hgnc-id-ls/num
  (remove-duplicates
   (map number->string
       '(14121
	 14161
	 20561
	 7211
	 14124
	 4835
	 4826
	 4824
	 4823
	 4833
	 6723
	 14163
	 9993
	 680
	 14180
	 903
	 14484
	 17205

	 7852
	 2754
	 17224
	 14138
	 11182
	 43508
	 38345
	 14139
	 26700
	 14135
	 18285
	 30912
	 14141
	 14142

	 26960
	 21169
	 10007

	 11427
	 14148
	 20852
	 14150
	 14151
	 14152
	 14153
	 14177
	 14179
	 7371
	 32918
	 14173
	 18435
	 14131
	 37230
	 14154
	 50469
	 11203
	 26502
	 11334
	 31374
	 1395
	 14134
	 14120
	 12019
	 14118
	 12485
	 948
	 14175
	 23026
	 14184
	 27558
	 34454
	 2025
	 14171
	 29099
	 29077
	 14158

	 14122
	 14137
	 6884
	 38364
	 7851
	 16618
	 27289
	 30629
	 8042
	 5468
	 4805
	 14169
	 28569
	 14160
	 14178
	 14133
	 10351
	 7696
	 10404
	 32598
	 10221
	 33102
	 32664
	 23235
	 11587
	 19404
	 4236
	 11501
	 28079
	 30509
	 11076
	 8028
	 12363
	 9008
	 33931

	 50228
	 41617
	 38969
	 14259
	 49574
	 10217
	 20456
	 20879
	 24825
	 28309
	 8909
	 3121
	 2958
	 2703
	 10080

	 38932
	 33683
	 41571
	 33
	 32972
	 1591
	 50133
	 25849
	 50264

	 8030
	 29203
	 855
	 24262
	 32553
	 38381
	 8816


	 27548
	 21423
	 15475
	 44162
	 16639
	 11619
	 30405
	 30715
	 9485
	 30456
	 28753
	 14368
	 25178
	 25404
	 18797
	 26386
	 29650
	 27549

	 2051
	 2048
	 18152
	 21198
	 28369
	 33584

	 14246
	 51372
	 16830
	 12997
	 28586
	 12996
	 50505
	 13005
	 27290
	 8194
	 8196
	 12993
	 6998
	 26830
	 13056
	 18331
	 13146
	 8242
	 37161
	 20812
	 12963
	 26573
	 25875
	 50099
	 34455
	 19009
	 29889
	 23845
	 2956
	 16264
	 2348
	 54406
	 240
	 11295
	 51380
	 11745
	 29450
	 51381
	 29679
	 44424
	 26161
	 18517
	 11808
	 24987
	 5014
	 13234
	 40031
	 29576
	 20254
	 50079
	 28154
	 29422
	 25081
	 23716
	 48329
	 29478
	 24434
	 12506
	 9273
	 29032
	 17378
	 44184
	 28687
	 18294
	 32221
	 51382
	 49959
	 18222
	 33227
	 28368
	 23
	 24530
	 9115
	 17150
	 12630
	 30103
	 53039
	 49549
	 49550
	 4585
	 20397
	 3334
	 26554
	 8041
	 20398
	 7067
	 13267
	 29013
	 19383
	 11952
	 13732
	 9448
	 9447
	 35343

	 28349

	 16841
	 11149
	 28030
	 30959
	 22170
	 24534
	 4621
	 11913
	 30542
	 25632
	 41900
	 37231
	 3436
	 53047
	 53048
	 29819
	 51945
	 32087
	 33692
	 52989
	 8609
	 17613
	 9029
	 41978
	 41979
	 33353
	 30060
	 38353
	 38997
	 38382

	 50119
	 50223
	 7909
	 28995
	 37060
	 29909
	 30346


	 50230
	 38920
	 41980
	 26827
	 19213
	 29562
	 50158
	 17619
	 32341
	 7569
	 26435
	 51
	 57))))
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
  (remove-duplicates
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
	 ))))
|#

(define hgnc-id-ls
  (map (lambda (ls)
	 (string-append "HGNC:" ls))
       hgnc-id-ls/num))

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
	   #|(number? (car ls))|#
	   (regexp-match #rx":[Nn][Oo][Cc][Oo][Dd][Ee]" (car ls))
	   #|(regexp-match #rx"^UMLS:C0017337$" (car ls))
	   (regexp-match #rx"ClinVarVariant:+" (car ls))
	   (regexp-match #rx"^N[MCPG]_[0-9]+" (car ls)))
	   (regexp-match #rx"^Genes$" (car ls))|#)
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

#|(define query-with-curie/str
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
	(query-with-curie/str (cdr ls) els))))))|#

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

(define get-hgnc-from-ls
  (lambda (ls els)
    (cond
      ((null? ls) els)
      ((equal? (regexp-match #rx"HGNC:[0-9]+" (car ls)) #f)
       (get-hgnc-from-ls (cdr ls) els))
      (else
       (get-hgnc-from-ls (cdr ls)
			 (set-union (regexp-match #rx"HGNC:[0-9]+" (car ls)) els))))))
       
(define loop-str-query
  (lambda (ls els curie-ls)
    (cond
      ((null? ls) els)
      (else
       (let ((str-concept-ls
	      (find-concepts/options
	       #f #f 0 #f
	       (list (format "~a" (car ls))))))
	 (cond
	   ((null? str-concept-ls) els)
	   ((intersect?
	     curie-ls
	     (get-hgnc-from-ls (flatten (get-concept-xrefs/singleton (car str-concept-ls))) '()))
	    (loop-str-query (cdr str-concept-ls)
			    (set-union (flatten (get-concept-xrefs/singleton (car str-concept-ls))) els)
			    curie-ls))
	   (else
	    (loop-str-query (cdr str-concept-ls) els curie-ls))))))))
       
(define get-external-str-ids-from-curie
  (lambda (ls els curie-ls)
    (cond
      ((null? ls) els)
      ((not (string-contains? (car ls) ":"))
       (get-external-str-ids-from-curie
	(cdr ls) (set-union (loop-str-query ls '() curie-ls) els) curie-ls))
      (else
       (get-external-str-ids-from-curie
	(cdr ls) (cons (car ls) els) curie-ls)))))

#|(export-path
(path->string (find-system-path 'desk-dir)))|#

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

(define start-function
  (time 
   (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
     (cond
       ((null? hgnc-id-ls) (void))
       (else
	(handle pmi-ls (car hgnc-id-ls) sym-hgnc-ls)
	(start-function pmi-ls (cdr hgnc-id-ls) sym-hgnc-ls))))))

(define handle
  (time
   (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
     (cond 
       ((null? hgnc-id-ls) (void))
       (else
	(let* ((all-downregulator/path
		(format		;	;
	       "~a~a_all_drug_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (all-upregulator/path ;	;
	       (format		;	;
	       "~a~a_all_drug_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (mixed-downregulator/path ; ;
	       (format		;	;
	       "~a~a_mixed_drug_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (pure-downregulator/path ; ;
	       (format		;	;
	       "~a~a_pure_drug_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (mixed-upregulator/path ; ;
	       (format		;	;
	       "~a~a_mixed_drug_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (pure-upregulator/path ;	;
	       (format		;	;
	       "~a~a_pure_drug_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (out-dec/all	;	;
	       (open-output-file all-downregulator/path #:exists 'append)) ; ;
	       (out-inc/all	;	;
	       (open-output-file all-upregulator/path #:exists 'append)) ; ;
	       (out-dec/mr	;	;
	       (open-output-file mixed-downregulator/path #:exists 'append)) ; ;
	       (out-inc/mr	;	;
	       (open-output-file mixed-upregulator/path #:exists 'append)) ; ;
	       (out-dec/pr	;	;
	       (open-output-file pure-downregulator/path #:exists 'append)) ; ;
	       (out-inc/pr	;	;
 	       (open-output-file pure-upregulator/path #:exists 'append)) ; ;
	       (all_molecular_entity-dec/path ; ;
	       (format		;	;
	       "~a~a_all_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (all_molecular_entity-inc/path ; ;
	       (format		;	;
	       "~a~a_all_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (pure_molecular_entity-inc/path ; ;
	       (format		;	;
	       "~a~a_pure_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (pure_molecular_entity-dec/path ; ;
	       (format		;	;
	       "~a~a_pure_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (mixed_molecular_entity-inc/path ; ;
	       (format		;	;
	       "~a~a_mixed_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (mixed_molecular_entity-dec/path ; ;
	       (format		;	;
	       "~a~a_mixed_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls)) ; ;
	       (out-all_molecular_entity_dec ; ;
 	       (open-output-file all_molecular_entity-dec/path #:exists 'append)) ; ;
	       (out-all_molecular_entity_inc ; ;
 	       (open-output-file all_molecular_entity-inc/path #:exists 'append)) ; ;
	       (out-pure_molecular_entity_dec ; ;
 	       (open-output-file pure_molecular_entity-dec/path #:exists 'append)) ; ;
	       (out-pure_molecular_entity_inc ; ;
 	       (open-output-file pure_molecular_entity-inc/path #:exists 'append)) ; ;
	       (out-mixed_molecular_entity_dec ; ;
 	       (open-output-file mixed_molecular_entity-dec/path #:exists 'append)) ; ;
	       (out-mixed_molecular_entity_inc ; ;
 	       (open-output-file mixed_molecular_entity-inc/path #:exists 'append))
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
	       (filtered-X-disease "SYMPTOM/DISEASE")
	       (query-start/hgnc
		(find-concepts #t (list hgnc-id-ls)))
	       (raw-concepts/hgnc
		(get-concept-xrefs query-start/hgnc '()))
	       (xrefs-from-hgnc
		(remove-duplicates
		 (prune-xrefs
		  (flatten (get-concept-xrefs query-start/hgnc '())) '())))
	       (xrefs-from-str/curie
		(remove-duplicates
		 (prune-xrefs
		  (flatten 
		   (get-external-str-ids-from-curie
		    xrefs-from-hgnc '() xrefs-from-hgnc)) '())))
	       (gene-concept-ls
		(find-concepts #t xrefs-from-str/curie)))	  
       
	  (define check-concept-to-edge-match
	    (lambda (edge-ls matched-edge-ls)
	      (if (= (length edge-ls) (length matched-edge-ls))
		  (displayln (format "\nEDGES SUCCESSFULLY MATCHED FOR EXPORT!\n"))
		  (displayln (format "\nEXPORTED EDGES MAY CONTAIN DUPLICATE ENTRIES!\n")))))

	  #|
	  (displayln (format "LIST OF ~a ALIASES/EXTERNAL-IDS FROM HGNC:ID" sym-hgnc-ls))
	  (newline)
	  (pretty-print xrefs-from-hgnc)
	  (newline)
	  |#
	  #|
	  (displayln (format "LIST OF ~a ALIASES/EXTERNAL-IDS FROM CURIE/STR FUNCTION" sym-hgnc-ls))
	  (newline)
	  (pretty-print xrefs-from-str/curie)
	  (newline)
	  |#

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

	  #|(newline)
	  (displayln "DRUG->dec->gene-xrefs!")
	  (pretty-print
	   (remove-duplicates
	    (prune-xrefs
	     (flatten
 	      (get-concept-xrefs-from-edges drug-dec-gene-list '())) '())))|#
	    
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
	    
	  #|(displayln "DRUG->inc->gene-xrefs!")
	  (pretty-print
	   (remove-duplicates
	    (prune-xrefs
	     (flatten
 	      (get-concept-xrefs-from-edges drug-inc-gene-list '())) '())))|#
      
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
       
	  (define pure-gene-upregulator?
	    (lambda (ls)
	      (and (member? (list-ref ls 1) (flatten mol_entity-inc-o/edge))
		   (not (member? (list-ref ls 1) (flatten mol_entity-dec-o/edge))))))
       
	  (define pure-gene-downregulator?
	    (lambda (ls)
	      (and (member? (list-ref ls 1) (flatten mol_entity-dec-o/edge))
		   (not (member? (list-ref ls 1) (flatten mol_entity-inc-o/edge))))))


	  (define (string-join strings delimiter)
	    (if (null? strings)
		""
		(parameterize ((current-output-port (open-output-string)))
		  (write-string (car strings))
		  (for-each (lambda (s)
			      (write-string delimiter)
			      (write-string s))
			    (cdr strings))
		  (get-output-string (current-output-port)))))

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
	  
	  (export-column-headers pmi-ls out-dec/all all-downregulator/path) ; ;
	  (export-column-headers COLUMN_HEADERS out-dec/all all-downregulator/path) ; ;
	  (export-column-headers pmi-ls out-inc/all all-upregulator/path) ; ;
	  (export-column-headers COLUMN_HEADERS out-inc/all all-upregulator/path) ; ;
	  (export-column-headers pmi-ls out-dec/mr mixed-downregulator/path) ; ;
	  (export-column-headers COLUMN_HEADERS out-dec/mr mixed-downregulator/path) ; ;
	  (export-column-headers pmi-ls out-dec/pr pure-downregulator/path) ; ;
	  (export-column-headers COLUMN_HEADERS out-dec/pr pure-downregulator/path) ; ;
	  (export-column-headers pmi-ls out-inc/mr mixed-upregulator/path) ; ;
	  (export-column-headers COLUMN_HEADERS out-inc/mr mixed-downregulator/path) ; ;
	  (export-column-headers pmi-ls out-inc/pr pure-upregulator/path) ; ;
	  (export-column-headers COLUMN_HEADERS out-inc/pr pure-upregulator/path) ; ;
	  
	  (define export-drug-dec-gene/edges
	    (outer-loop x-dec-o/edge out-dec/all))
	  (define export-drug-inc-gene/edges
	    (outer-loop x-inc-o/edge out-inc/all))
	  (define export_pure_mixed_drug_downregulators
	    (outer-loop/dec x-dec-o/edge out-dec/mr out-dec/pr))
	  (define export_pure_mixed_drug_upregulators
	    (outer-loop/inc x-inc-o/edge out-inc/mr out-inc/pr))

	  #|--- MOLECULAR-ENTITY->INC/DEC->GENE 1-HOP EXPORT: COLUMN HEADERS & DATA ---|#
	  
	  (export-column-headers pmi-ls out-all_molecular_entity_dec all_molecular_entity-dec/path) ; ;
	  (export-column-headers COLUMN_HEADERS_MOL out-all_molecular_entity_dec all_molecular_entity-dec/path) ; ;
	    				; ;
	  (export-column-headers pmi-ls out-all_molecular_entity_inc all_molecular_entity-inc/path) ; ;
	  (export-column-headers COLUMN_HEADERS_MOL out-all_molecular_entity_inc all_molecular_entity-inc/path) ; ;
	    				; ;
	  (export-column-headers pmi-ls out-mixed_molecular_entity_dec mixed_molecular_entity-dec/path)  ; ;
	  (export-column-headers COLUMN_HEADERS_MOL out-mixed_molecular_entity_dec mixed_molecular_entity-dec/path) ; ;
	    				; ;
	  (export-column-headers pmi-ls out-pure_molecular_entity_dec pure_molecular_entity-dec/path) ; ;
	  (export-column-headers COLUMN_HEADERS_MOL out-pure_molecular_entity_dec pure_molecular_entity-dec/path) ; ;
	    				; ;
	  (export-column-headers pmi-ls out-pure_molecular_entity_inc pure_molecular_entity-inc/path) ; ;
	  (export-column-headers COLUMN_HEADERS_MOL out-pure_molecular_entity_inc pure_molecular_entity-inc/path) ; ;
	    				; ;
	  (export-column-headers pmi-ls out-mixed_molecular_entity_inc mixed_molecular_entity-inc/path) ; ;
	  (export-column-headers COLUMN_HEADERS_MOL out-mixed_molecular_entity_inc mixed_molecular_entity-inc/path) ; ;
	  
	  (define export-mol-entity-dec-gene/edges
	    (outer-loop mol_entity-dec-o/edge out-all_molecular_entity_dec))
	  (define export-mol-entity-inc-gene/edges
	    (outer-loop mol_entity-inc-o/edge out-all_molecular_entity_inc))
	    
	  (define export_pure_mixed_gene_downregulators
	    (outer-loop/dec mol_entity-dec-o/edge out-mixed_molecular_entity_dec out-pure_molecular_entity_dec))
	  (define export_pure_mixed_gene_upregulators
	    (outer-loop/inc mol_entity-inc-o/edge out-mixed_molecular_entity_inc out-pure_molecular_entity_inc))
       
	  (newline)
	  (displayln (format "CASE ~s COMPLETE!" pmi-ls))
	  (newline)
	  ))))))

(start-function pmi-ls hgnc-id-ls sym-hgnc-ls)



#|
  (newline)
  (displayln "1-HOP & 2-HOP QUERIES COMPLETE!")
  (newline)
(newline)
(display (format "TOTAL RUN TIME:" ))
(newline)
|#



#|
as state-machine

(define handle
  (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
    (cond
      ((null? hgnc-id-ls) (void))
      (else
       (letrec ((handle-case
		 (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
		   (cond
		     ((null? hgnc-id-ls)
		      (void))
		     (else
		      (handle-patient-id pmi-ls hgnc-id-ls sym-hgnc-ls)))))		
		(handle-patient-id
		 (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
		   (cond
		     ((null? hgnc-id-ls)
		      (handle-case pmi-ls))
		     (else
		      (let* (#|(all-downregulator/path
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
 			      (open-output-file mixed_molecular_entity-inc/path #:exists 'replace)))
			
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
			(export-column-headers COLUMN_HEADERS_MOL out-mixed_molecular_entity_inc)|#)
			
			(newline)
			(displayln (format "~a EXPORT FILES CREATED!" pmi-ls))
			(newline)
			
			(handle-queries pmi-ls hgnc-id-ls sym-hgnc-ls))))))
		
		(handle-queries
		 (time
		  (lambda (pmi-ls hgnc-id-ls sym-hgnc-ls)
		    (cond 
		      ((null? hgnc-id-ls)
		       (handle-case pmi-ls))
		      (else
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
			      (out-dec/all
			      (open-output-file all-downregulator/path #:exists 'append))
			     (out-inc/all
			      (open-output-file all-upregulator/path #:exists 'append))
			     (out-dec/mr
			      (open-output-file mixed-downregulator/path #:exists 'append))
			     (out-inc/mr
			      (open-output-file mixed-upregulator/path #:exists 'append))
			     (out-dec/pr
			      (open-output-file pure-downregulator/path #:exists 'append))
			     (out-inc/pr
			      (open-output-file pure-upregulator/path #:exists 'append))
			     (out-all_molecular_entity_dec
			      (open-output-file all_molecular_entity-dec/path #:exists 'append))
			     (out-all_molecular_entity_inc
 			      (open-output-file all_molecular_entity-inc/path #:exists 'append))
			     (out-pure_molecular_entity_dec
 			      (open-output-file pure_molecular_entity-dec/path #:exists 'append))
			     (out-pure_molecular_entity_inc
 			      (open-output-file pure_molecular_entity-inc/path #:exists 'append))
			     (out-mixed_molecular_entity_dec
 			      (open-output-file mixed_molecular_entity-dec/path #:exists 'append))
			     (out-mixed_molecular_entity_inc
 			      (open-output-file mixed_molecular_entity-inc/path #:exists 'append))
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
			      (filtered-X-disease "SYMPTOM/DISEASE")
			      (query-start/hgnc
			       (find-concepts #t (list hgnc-id-ls)))
			      (raw-concepts/hgnc
			       (get-concept-xrefs query-start/hgnc '()))
			      (xrefs-from-hgnc
			       (remove-duplicates
				(prune-xrefs
				 (flatten (get-concept-xrefs query-start/hgnc '())) '())))
			      (xrefs-from-str/curie
			       (remove-duplicates
				(prune-xrefs
				 (flatten 
				  (get-external-str-ids-from-curie
				   xrefs-from-hgnc '() xrefs-from-hgnc)) '())))
			      (gene-concept-ls
			       (find-concepts #t xrefs-from-str/curie)))	  
       
			 (define check-concept-to-edge-match
			   (lambda (edge-ls matched-edge-ls)
			     (if (= (length edge-ls) (length matched-edge-ls))
				 (displayln (format "\nEDGES SUCCESSFULLY MATCHED FOR EXPORT!\n"))
				 (displayln (format "\nEXPORTED EDGES MAY CONTAIN DUPLICATE ENTRIES!\n")))))

       
			 (displayln (format "LIST OF ~a ALIASES/EXTERNAL-IDS FROM HGNC:ID" sym-hgnc-ls))
			 (newline)
			 (pretty-print xrefs-from-hgnc)
			 (newline)
       
			 (displayln (format "LIST OF ~a ALIASES/EXTERNAL-IDS FROM CURIE/STR FUNCTION" sym-hgnc-ls))
			 (newline)
			 (pretty-print xrefs-from-str/curie)
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

			 (define export-drug-dec-gene/edges
			   (outer-loop x-dec-o/edge out-dec/all))
			 (define export-drug-inc-gene/edges
			   (outer-loop x-inc-o/edge out-inc/all))
			 (define export_pure_mixed_drug_downregulators
			   (outer-loop/dec x-dec-o/edge out-dec/mr out-dec/pr))
			 (define export_pure_mixed_drug_upregulators
			   (outer-loop/inc x-inc-o/edge out-inc/mr out-inc/pr))
			 (define export-mol-entity-dec-gene/edges
			   (outer-loop mol_entity-dec-o/edge out-all_molecular_entity_dec))
			 (define export-mol-entity-inc-gene/edges
			   (outer-loop mol_entity-inc-o/edge out-all_molecular_entity_inc))
			 (define export_pure_mixed_gene_downregulators
			   (outer-loop/dec mol_entity-dec-o/edge out-mixed_molecular_entity_dec out-pure_molecular_entity_dec))
			 (define export_pure_mixed_gene_upregulators
			   (outer-loop/inc mol_entity-inc-o/edge out-mixed_molecular_entity_inc out-pure_molecular_entity_inc))
			 (handle-case pmi-ls hgnc-id-ls sym-hgnc-ls)))))))
		)
	 (newline)
	 (displayln (format "BEGINNING QUERIES FOR CASE: ~a" pmi-ls))
	 (newline)
	 
	 )))))

|#





















       #|


	    #|(drug-dec-molecular_entity->inc->gene/path
	    (format "~a~a_drug_dec_molecular_entity_upregulates_~a" export-path pmi-ls sym-hgnc-ls)) ;
	    (drug-inc-molecular_entity->dec->gene/path ;
	    (format "~a~a_drug_inc_molecular_entity_downregulates_~a" export-path pmi-ls sym-hgnc-ls)) ;
	    (drug-dec-molecular_entity->dec->gene/path ;
	    (format "~a~a_drug_dec_molecular_entity_downregulates_~a" export-path pmi-ls sym-hgnc-ls)) ;
	    (drug-inc-molecular_entity->inc->gene/path ;
	    (format "~a~a_drug_inc_molecular_entity_upregulates_~a" export-path pmi-ls sym-hgnc-ls)) ;
 	    (out-drug-dec-molecular_entity->inc->gene ;
	    (open-output-file drug-dec-molecular_entity->inc->gene/path #:exists 'replace)) ;
	    (out-drug-inc-molecular_entity->dec->gene ;
	    (open-output-file drug-inc-molecular_entity->dec->gene/path #:exists 'replace)) ;
	    (out-drug-dec-molecular_entity->dec->gene ;
	    (open-output-file drug-dec-molecular_entity->dec->gene/path #:exists 'replace)) ;
	    (out-drug-inc-molecular_entity->inc->gene ;
	    (open-output-file drug-inc-molecular_entity->inc->gene/path #:exists 'replace))|#
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

       #|
       (define mol_entity-dec-o-xrefs
	 (time
	  (find-concepts/options
	   #f #f 0 #f 
	   (remove-duplicates
	    (prune-xrefs
	     (flatten
	      (get-concept-xrefs-from-edges molecular_entity-dec-gene-list '())) '())))))
       |#
       
       ;; test to see what goes into the query
       (displayln "MOL_ENTITY->inc->gene-xrefs!")
       (pretty-print
	(remove-duplicates
	 (prune-xrefs
	  (flatten
	   (get-concept-xrefs-from-edges molecular_entity-inc-gene-list '())) '())))
      #|
       (define mol_entity-inc-o-xrefs
	 (time
	  (find-concepts/options
	   #f #f 0 #f 
	   (remove-duplicates
	    (prune-xrefs 
	     (flatten
	      (get-concept-xrefs-from-edges molecular_entity-inc-gene-list '())) '())))))
       |#
       |#

   #|
       ;;CODE FOR 2-HOP LOOKUPS		;
	    ;;NEED TO PRUNE OUT META IDENTIFIERS LIKE "GENE" FROM XREF-GATHERED LIST, 8 hr run didnt get past drug inc ;
	    ;; gene inc gene....	;
					;
	    				;
   (newline)				;
   (displayln (format "~a ALIASES/EXTERNAL-IDENTIFIERS FOUND\n~a ACTIVATORS OF ~a" (length mol_entity-inc-o-xrefs) filtered-X-molecular_entity sym-hgnc-ls)) ;
   (newline)				;
	    				;
   (newline)				;
   (displayln (format "~a ALIASES/EXTERNAL-IDENTIFIERS FOUND\n~a INHIBITORS OF ~a" (length mol_entity-dec-o-xrefs) filtered-X-molecular_entity sym-hgnc-ls)) ;
   (newline)				;
	    				;
   (newline)			 	;
   (displayln			 	;
   (format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->INCREASES-->~a-->INCREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls))	;
   (newline)			 	;
					;
   (match-define		 	;
   (list b-inc-gene=>concepts b-inc-gene=>edges) ;
   (time				;
   (run/graph				;
   ((B drugs)				;
   (mol_entity-inc-o-xrefs mol_entity-inc-o-xrefs)) ;
   ((B->inc increases))			;
   (B B->inc mol_entity-inc-o-xrefs))))	;
					;
   (define drug-upregulators-of-molecular-entity-inc-gene-ls (hash-ref b-inc-gene=>edges 'B->inc)) ;
					;
   (newline)				;
   (displayln (format "~a INDIRECT ACTIVATORS EDGES FOUND! " (length drug-upregulators-of-molecular-entity-inc-gene-ls))) ;
   (newline)				;
					;
	    ;; consider pruning down these edges based on whether they contain ;
	    ;; drugs that are not FDA approved at the point of edge collection ;
	    ;; function idea --> edge-pruner, if edge doesnt contain umls status/drug-bank status/rx-norm status ;
	    ;; then discard it.		;
	    ;; if edge concept exists on a drug->inc-gene or drug-dec-gene list already, keep it. ;
	    ;; if drug is a down-regulator of genes that upregulate gene and a downregulate of the target gene ;
	    ;; we can give it "super downregulator" status. ;
					;
   #|(displayln "drug->inc->MOL_ENTITY->inc->gene-xrefs!") ;
   (pretty-print			;
   (remove-duplicates			;
   (prune-xrefs				;
   (flatten				;
   (get-concept-xrefs-from-edges drug-upregulators-of-molecular-entity-inc-gene-ls '())) '())))|# ;
					;
   (newline)			 	;
   (displayln			 	;
   (format "MATCHING:\n~a-->INCREASES-->~a-->INCREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls)) ;
   (newline)			 	;
					;
   (define drug-inc-mol-entity-inc-gene/edge ;
   (time				;
   (remove-duplicates		       	;
   (match-drug-pred-gene-edges	       	;
   drug-upregulators-of-molecular-entity-inc-gene-ls '())))) ;
	    				;
					;
   (newline)			 	;
   (displayln			 	;
   (format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->DECREASES-->~a-->INCREASES-->GENE" filtered-X-drug filtered-X-molecular_entity)) ;
   (newline)			 	;
					;
   (match-define		 	;
   (list j-dec-gene=>concepts j-dec-gene=>edges) ;
   (time				;
   (run/graph				;
   ((J drugs)				;
   (mol_entity-inc-o-xrefs mol_entity-inc-o-xrefs)) ;
   ((J->dec decreases))			;
   (J J->dec mol_entity-inc-o-xrefs))))	;
					;
   (define drug-downregulators-of-molecular-entity-inc-gene-ls (hash-ref j-dec-gene=>edges 'J->dec)) ;
					;
   (displayln "drug->dec->MOL_ENTITY->inc->gene-xrefs!") ;
   (pretty-print			;
   (remove-duplicates			;
   (prune-xrefs				;
   (flatten				;
   (get-concept-xrefs-from-edges drug-downregulators-of-molecular-entity-inc-gene-ls '())) '()))) ;
					;
					;
   (newline)			 	;
   (displayln			 	;
   (format "MATCHING:\n~a-->DECREASES-->~a-->INCREASES-->GENE" filtered-X-drug filtered-X-molecular_entity)) ;
   (newline)			 	;
					;
   (define drug-dec-mol-entity-inc-gene/edge ;
   (time				;
   (remove-duplicates		       	;
   (match-drug-pred-gene-edges	       	;
   drug-downregulators-of-molecular-entity-inc-gene-ls '())))) ;
					;
					;
   (newline)			 	;
   (displayln			 	;
   (format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->INCREASES-->~a-->DECREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls))	;
   (newline)			 	;
					;
   (match-define		 	;
   (list d-inc-gene=>concepts d-inc-gene=>edges) ;
   (time			 	;
   (run/graph			 	;
   ((D drugs)			 	;
   (mol_entity-dec-o-xrefs mol_entity-dec-o-xrefs)) ;
   ((D->inc increases))	 		;
   (D D->inc mol_entity-dec-o-xrefs))))	;
					;
   (define drug-upregulators-of-molecular-entity-dec-gene-ls (hash-ref d-inc-gene=>edges 'D->inc)) ;
					;
					;
   (newline)			 	;
   (displayln (format "MATCHING\n~a-->INCREASES-->~a-->DECREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls)) ;
   (newline)			 	;
					;
   (define drug-inc-mol-entity-dec-gene/edge ;
   (time				;
   (remove-duplicates		       	;
   (match-drug-pred-gene-edges	       	;
   drug-upregulators-of-molecular-entity-dec-gene-ls '())))) ;
					;
   (newline)			 	;
   (displayln			 	;
   (format "BEGINNING RUN/GRAPH 2-HOP:\n~a-->DECREASES-->~a-->DECREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls))	;
   (newline)			 	;
					;
   (match-define		 	;
   (list f-dec-gene=>concepts f-dec-gene=>edges) ;
   (time				;
   (run/graph				;
   ((F drugs)				;
   (mol_entity-dec-o-xrefs mol_entity-dec-o-xrefs)) ;
   ((F->dec decreases))			;
   (F F->dec mol_entity-dec-o-xrefs))))	;
					;
   (define drug-downregulators-of-molecular-entity-dec-gene-ls (hash-ref f-dec-gene=>edges 'F->dec)) ;
					;
   (newline)			 	;
   (displayln (format "MATCHING\n~a-->DECREASES-->~a-->DECREASES-->~a" filtered-X-drug filtered-X-molecular_entity sym-hgnc-ls)) ;
   (newline)			 	;
					;
   (define drug-dec-mol-entity-dec-gene/edge ;
   (time				;
   (remove-duplicates		       	;
   (match-drug-pred-gene-edges	       	;
   drug-downregulators-of-molecular-entity-dec-gene-ls '())))) ;
					;
   (newline)			 	;
   (displayln "MATCHING COMPLETE!\n BEGINNING EDGE EXPORT") ;
   (newline)			 	;
					;
   (define drug-dec-mol-entitiy-dec-gene-pure-indirect-upregulator? ;
   (lambda (ls)		 		;
   (and (member? (list-ref ls 1) (flatten drug-dec-mol-entity-dec-gene/edge)) ;
   (not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-inc-gene/edge))) ;
   (not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-dec-gene/edge)))))) ;
					;
   (define drug-inc-mol-entity-inc-gene-pure-indirect-upregulator? ;
   (lambda (ls)		 		;
   (and (member? (list-ref ls 1) (flatten drug-inc-mol-entity-inc-gene/edge)) ;
   (not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-inc-gene/edge))) ;
   (not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-dec-gene/edge)))))) ;
					;
   (define drug-inc-mol-entity-dec-gene-pure-indirect-downregulator? ;
   (lambda (ls)		 		;
   (and (member? (list-ref ls 1) (flatten drug-inc-mol-entity-dec-gene/edge)) ;
   (not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-inc-gene/edge))) ;
   (not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-dec-gene/edge)))))) ;
					;
   (define drug-dec-mol-entity-inc-gene-pure-indirect-downregulator? ;
   (lambda (ls)		 		;
   (and (member? (list-ref ls 1) (flatten drug-dec-mol-entity-inc-gene/edge)) ;
   (not (member? (list-ref ls 1) (flatten drug-inc-mol-entity-inc-gene/edge))) ;
   (not (member? (list-ref ls 1) (flatten drug-dec-mol-entity-dec-gene/edge)))))) ;
					;
       					;
       ;;; indirect downregulators	;
       ;; port1 = out-drug-inc-molecular_entity->dec->gene ;
       ;; drug-inc-mol-entity-dec-gene-pure-indirect-downregulator? ;
       ;;       = out-drug-dec-molecular_entity->inc->gene ;
       ;; drug-dec-mol-entity-inc-gene-pure-indirect-downregulator? ;
       					;
       ;;; indirect upregulators	;
       ;; port2 = out-drug-inc-molecular_entity->inc->gene ;
       ;; drug-inc-mol-entity-inc-gene-pure-indirect-upregulator? ;
       ;;       = out-drug-dec-molecular_entity->dec->gene ;
       ;; drug-dec-mol-entitiy-dec-gene-pure-indirect-upregulator? ;
					;
   (define outer-loop/indirect-regulators ;
   (lambda (ls port1 port2 port3 port4)	;
   (cond				;
   ((null? ls)				;
   (close-output-port port1)		;
   (close-output-port port2)		;
   (close-output-port port3)		;
   (close-output-port port4))		;
   ((not (pure-drug-upregulator? (car ls))) ;
   (cond				;
   ((drug-inc-mol-entity-dec-gene-pure-indirect-downregulator? (car ls)) ;
   (inner-loop (car ls) port1)	       	;
   (fprintf port1 (format "~c" #\newline)) ;
   (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4)) ;
   ((drug-dec-mol-entity-inc-gene-pure-indirect-downregulator? (car ls)) ;
   (inner-loop (car ls) port2)	       	;
   (fprintf port2 (format "~c" #\newline)) ;
   (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4)) ;
   (else		 		;
   (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4))))	;
   ((not (pure-drug-downregulator? (car ls))) ;
   (cond				;
   ((drug-inc-mol-entity-inc-gene-pure-indirect-upregulator? (car ls)) ;
   (inner-loop (car ls) port3)	       	;
   (fprintf port3 (format "~c" #\newline)) ;
   (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4)) ;
   ((drug-dec-mol-entitiy-dec-gene-pure-indirect-upregulator? (car ls))	;
   (inner-loop (car ls) port4)  	;
   (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4))))	;
   (else			 	;
   (outer-loop/indirect-regulators (cdr ls) port1 port2 port3 port4))))) ;
					;
					;
					;
   (export-column-headers (list pmi-ls) out-drug-dec-molecular_entity->inc->gene) ;
   (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-dec-molecular_entity->inc->gene) ;
					;
   (export-column-headers (list pmi-ls) out-drug-inc-molecular_entity->dec->gene) ;
   (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-inc-molecular_entity->dec->gene) ;
					;
   (export-column-headers (list pmi-ls) out-drug-dec-molecular_entity->dec->gene) ;
   (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-dec-molecular_entity->dec->gene) ;
					;
   (export-column-headers (list pmi-ls) out-drug-inc-molecular_entity->inc->gene) ;
   (export-column-headers COLUMN_HEADERS_INDIRECT_DRUGS out-drug-inc-molecular_entity->inc->gene) ;
					;
					;
   (define export_pure_indirect_upregulators_drug->inc->mol-entity->inc->gene ;
   (outer-loop/indirect-regulators	;
   drug-inc-mol-entity-inc-gene/edge	;
   out-drug-inc-molecular_entity->dec->gene ;
   out-drug-dec-molecular_entity->inc->gene ;
   out-drug-inc-molecular_entity->inc->gene ;
   out-drug-dec-molecular_entity->dec->gene)) ;
					;
   (define export_pure_indirect_upregulators_drug->dec->mol-entity->dec-gene ;
   (outer-loop/indirect-regulators	;
   drug-dec-mol-entity-dec-gene/edge	;
   out-drug-inc-molecular_entity->dec->gene ;
   out-drug-dec-molecular_entity->inc->gene ;
   out-drug-inc-molecular_entity->inc->gene ;
   out-drug-dec-molecular_entity->dec->gene)) ;
					;
   (define export_pure_indirect_downregulators_drug->dec->mol-entity->inc->gene	;
   (outer-loop/indirect-regulators	;
   drug-dec-mol-entity-inc-gene/edge	;
   out-drug-inc-molecular_entity->dec->gene ;
   out-drug-dec-molecular_entity->inc->gene ;
   out-drug-inc-molecular_entity->inc->gene ;
   out-drug-dec-molecular_entity->dec->gene)) ;
					;
   (define export_pure_indirect_downregulators_drug->inc->mol-entity->dec-gene ;
   (outer-loop/indirect-regulators	;
   drug-inc-mol-entity-dec-gene/edge	;
   out-drug-inc-molecular_entity->dec->gene ;
   out-drug-dec-molecular_entity->inc->gene ;
   out-drug-inc-molecular_entity->inc->gene ;
   out-drug-dec-molecular_entity->dec->gene)) ;
					;
	    				;
       |#


























#|--- KNOWLEDGE GRAPH CATEGORIES ---|#
 
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


    #|(drug-dec-molecular_entity->inc->gene/path
    (format "~a~a_drug_dec_molecular_entity_upregulates_~a" export-path pmi-ls sym-hgnc-ls)) ;
    (drug-inc-molecular_entity->dec->gene/path ;
    (format "~a~a_drug_inc_molecular_entity_downregulates_~a" export-path pmi-ls sym-hgnc-ls)) ;
    (drug-dec-molecular_entity->dec->gene/path ;
    (format "~a~a_drug_dec_molecular_entity_downregulates_~a" export-path pmi-ls sym-hgnc-ls)) ;
    (drug-inc-molecular_entity->inc->gene/path ;
    (format "~a~a_drug_inc_molecular_entity_upregulates_~a" export-path pmi-ls sym-hgnc-ls)) ;
    (out-drug-dec-molecular_entity->inc->gene ;
    (open-output-file drug-dec-molecular_entity->inc->gene/path #:exists 'replace)) ;
    (out-drug-inc-molecular_entity->dec->gene ;
    (open-output-file drug-inc-molecular_entity->dec->gene/path #:exists 'replace)) ;
    (out-drug-dec-molecular_entity->dec->gene ;
    (open-output-file drug-dec-molecular_entity->dec->gene/path #:exists 'replace)) ;
    (out-drug-inc-molecular_entity->inc->gene ;
    (open-output-file drug-inc-molecular_entity->inc->gene/path #:exists 'replace))|#	     
    #|(gene-concept-ls
    (time				;
    (query-with-curie/str xrefs-from-hgnc '())))|#
    #|(gene-concept-ls
    (time				;
    (find-concepts/options #f #f 0 #f xrefs-from-hgnc)))|#
    (define drugs
      '((semmed 4 . "chemical_substance")
	(rtx 0 . "chemical_substance")
	(robokop 1 . "(\"named_thing\" \"chemical_substance\")")
	(rtx 3 . "metabolite")
	(orange 12 . "(\"food material\")")))

    (define filtered-X-drug "BIOLOGICAL/CHEMICAL-SUBSTANCE")

    (define molecular_entity
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

    (define filtered-X-molecular_entity "MOLECULAR-ENTITY")

    (define disease
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

    (define filtered-X-disease "SYMPTOM/DISEASE")
 
    (define start-time (current-seconds))


|#

#|
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
  (open-output-file all-downregulator/path #:exists 'append))
(define out-inc/all
  (open-output-file all-upregulator/path #:exists 'append))
(define out-dec/mr
  (open-output-file mixed-downregulator/path #:exists 'append))
(define out-inc/mr
  (open-output-file mixed-upregulator/path #:exists 'append))
(define out-dec/pr
  (open-output-file pure-downregulator/path #:exists 'append))
(define out-inc/pr
  (open-output-file pure-upregulator/path #:exists 'append))
(define all_molecular_entity-dec/path
  (format
   "~a~a_all_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define all_molecular_entity-inc/path
  (format
   "~a~a_all_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define pure_molecular_entity-inc/path
  (format
   "~a~a_pure_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define pure_molecular_entity-dec/path
  (format
   "~a~a_pure_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define mixed_molecular_entity-inc/path
  (format
   "~a~a_mixed_molecular_entity_upregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))
(define mixed_molecular_entity-dec/path
  (format
   "~a~a_mixed_molecular_entity_downregulators_for_~a.tsv" export-path pmi-ls sym-hgnc-ls))

(define out-all_molecular_entity_dec
  (open-output-file all_molecular_entity-dec/path #:exists 'append))
(define out-all_molecular_entity_inc
  (open-output-file all_molecular_entity-inc/path #:exists 'append))
(define out-pure_molecular_entity_dec
  (open-output-file pure_molecular_entity-dec/path #:exists 'append))
(define out-pure_molecular_entity_inc
  (open-output-file pure_molecular_entity-inc/path #:exists 'append))
(define out-mixed_molecular_entity_dec
  (open-output-file mixed_molecular_entity-dec/path #:exists 'append))
(define out-mixed_molecular_entity_inc
  (open-output-file mixed_molecular_entity-inc/path #:exists 'append))
|#
