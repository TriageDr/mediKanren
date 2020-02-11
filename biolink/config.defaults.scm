;; DO NOT EDIT THIS FILE!
;; Instead, add overrides to: config.scm
((databases . (
               semmed
               orange
               robokop
               ;; rtx
               rtx2
               ))

 (query-results.write-to-file?  . #t)  ;; #t will write the query and results to file, #f will not
 (query-results.file-name       . "last.sx")
 (query-results.file-name-human . "last.txt") 
 (query-results.file-name-spreadsheet . "last.tsv")
 ;; Uncomment exactly one of these:
 (query-results.file-mode       . replace)  ;; Clobber the save file each time you run a query.
 ;(query-results.file-mode       . append)  ;; Save all the queries.
 (initial-window-size.horizontal . 800)
 (initial-window-size.vertical . 400)


 (decreases-predicate-names
  .
  ("negatively_regulates"
   "prevents"
   "treats"
   "indicated_for"
   "decreases_activity_of"
   "decreases_expression_of"
   "decreases_molecular_interaction"
   "decreases_secretion_of"
   "decreases_synthesis_of"
   "decreases_transport_of"
   "decreases_uptake_of"
   "disrupts"
   "increases_degradation_of"
   ;; "negatively_regulates__entity_to_entity"
   ;; "increases_metabolic_processing_of"
   ;; "decreases_response_to"
   ;; "decreases_localization_of"
   ;; "decreases_molecular_modification_of"
   ))
 (increases-predicate-names
  .
  ("positively_regulates"
   "causes"
   "produces"
   "causes_condition"
   "causally_related_to"
   "contributes_to"
   "causes_adverse_event"
   "gene_associated_with_condition"
   "gene_mutations_contribute_to"
   "disease_to_gene_association"
   "increases_activity_of"
   "increases_expression_of"
   "increases_molecular_interaction"
   "increases_response_to"
   "increases_secretion_of"
   "increases_stability_of"
   "increases_synthesis_of"
   "increases_transport_of"
   "increases_uptake_of"
   "decreases_degradation_of"
   "posetively_regulates" ;;; robokop typo--now fixed, but keep it for compatibility with old data
   ;; "positively_regulates__entity_to_entity"
   ;; "increases_molecular_modification_of"
   ;; "increases_localization_of"
   ;; "increases_splicing_of"
   ;; "decreases_mutation_rate_of"
   ;; "predisposes"
   ;; "decreases_metabolic_processing_of"
   ))
 ("automated_query_export_path" . "/Users/ozborn/code/repo/mediKanrenAutomatedQueries/")
 ("automated_query_input_path" . "/home/mjpatton/PhD/CaseReviews/test_prototype_files/")
 ;; Add configuration options as new association pairs.
 )
