#lang racket/base
(provide
  (all-from-out "mk.rkt")
  make-db

  db:edgeo
  db:concepto
  db:categoryo
  db:predicateo
  db:pmid-eido
  db:subject-predicateo
  db:object-predicateo

  db:~cui*-concepto
  db:~cui-concepto
  db:~name-concepto
  db:~predicateo
  db:~categoryo
  db:~name*-concepto/options
  db:synonym-concepto
  db:xref-concepto

  chars:ignore-typical
  chars:split-typical
  )

(require
  "db.rkt"
  "mk.rkt"
  "repr.rkt"
  (except-in racket/match ==)
  racket/stream
  )

(define (vconcept->details db v)
  (define catid (concept-category v))
  (list (concept-cui v)
        (concept-name v)
        (cons catid (vector-ref (db:category* db) catid))
        (concept-props v)))
(define ((i&v->i&d db) i&v) (cons (car i&v) (vconcept->details db (cdr i&v))))

(define (stream-refo i&v* iv)
  (let loop ((i&v* i&v*))
    (if (stream-empty? i&v*) fail
      (let* ((i&v (stream-first i&v*)))
        (conde
          ((== `(,(car i&v) . ,(cdr i&v)) iv))
          ((loop (stream-rest i&v*))))))))

(define (db:~cui*-concepto db ~cui* concept)
  (project (~cui*)
    (stream-refo
      (stream-map (i&v->i&d db) (db:~cui*->cid&concept* db ~cui*)) concept)))
(define (db:~cui-concepto db ~cui concept)
  (project (~cui)
    (stream-refo
      (stream-map (i&v->i&d db) (db:~cui->cid&concept* db ~cui)) concept)))
(define (db:~name-concepto db ~name concept)
  (project (~name)
    (stream-refo
      (stream-map (i&v->i&d db) (db:~name->cid&concept* db ~name)) concept)))
(define (db:~name*-concepto/options
          case-sensitive? chars:ignore chars:split db ~name* concept)
  (project (~name*)
    (stream-refo
      (stream-map (i&v->i&d db)
                  (db:~name*->cid&concept*/options
                    case-sensitive? chars:ignore chars:split db ~name*))
      concept)))
(define (db:~predicateo db ~predicate predicate)
  (project (~predicate)
    (stream-refo (db:~predicate->pid&predicate* db ~predicate) predicate)))
(define (db:~categoryo db ~category category)
  (project (~category)
    (stream-refo (db:~category->catid&category* db ~category) category)))

(define (db:synonym-concepto db synonym concept)
  (project (synonym concept)
    (match concept
      (`(,(and cid (? integer?)) . ,_)
        (fresh ()
          (db:concepto db concept)
          (let loop ((synonym* (concept->synonyms (db:cid->concept db cid))))
            (if (null? synonym*) fail
              (conde ((== (car synonym*) synonym))
                     ((loop (cdr synonym*))))))))
      (_ (cond ((not (var? synonym))
                (let loop ((cid* (db:synonym->cid* db synonym)))
                  (if (null? cid*) fail
                    (let ((c (vconcept->details
                               db (db:cid->concept db (car cid*)))))
                      (conde ((== (cons (car cid*) c) concept))
                             ((loop (cdr cid*))))))))
               (else (fresh ()
                       (db:concepto db concept)
                       (db:synonym-concepto db synonym concept))))))))
(define (db:xref-concepto db xref concept)
  (project (xref concept)
    (match concept
      (`(,(and cid (? integer?)) . ,_)
        (fresh ()
          (db:concepto db concept)
          (let loop ((xref* (concept->xrefs (db:cid->concept db cid))))
            (if (null? xref*) fail
              (conde ((== (car xref*) xref))
                     ((loop (cdr xref*))))))))
      (_ (cond ((not (var? xref))
                (let loop ((cid* (db:xref->cid* db xref)))
                  (if (null? cid*) fail
                    (let ((c (vconcept->details
                               db (db:cid->concept db (car cid*)))))
                      (conde ((== (cons (car cid*) c) concept))
                             ((loop (cdr cid*))))))))
               (else (fresh ()
                       (db:concepto db concept)
                       (db:xref-concepto db xref concept))))))))

(define (vector-refo e->v v* iv)
  (when (not (vector? v*)) (error "vector-refo vector must be ground:" v* iv))
  (project (iv)
    (cond ((and (pair? iv) (integer? (car iv)))
           (== (cons (car iv) (e->v (vector-ref v* (car iv)))) iv))
          (else
            (define len (vector-length v*))
            (let loop ((i 0))
              (if (<= len i) fail
                (conde
                  ((== (cons i (e->v (vector-ref v* i))) iv))
                  ((loop (+ i 1))))))))))

(define (db:predicateo db predicate)
  (vector-refo (lambda (x) x) (db:predicate* db) predicate))

(define (db:categoryo db category)
  (vector-refo (lambda (x) x) (db:category* db) category))

(define (db:concepto db concept)
  (define (v->concept v) (vconcept->details db v))
  (project (concept)
    (match concept
      (`(,(and cid (? integer?)) . ,_)
        (== (cons cid (v->concept (db:cid->concept db cid))) concept))
      (`(,_ ,_ ,_ (,(and catid (? integer?)) . ,_) . ,_)
        (define cid* (db:catid->cid* db catid))
        (define len (vector-length cid*))
        (let loop ((i 0))
          (if (<= len i) fail
            (let ((cid (vector-ref cid* i)))
              (conde
                ((== (cons cid (v->concept (db:cid->concept db cid))) concept))
                ((loop (+ i 1))))))))
      (_ (let loop ((c&c* (db:cid&concept-stream db)))
           (if (stream-empty? c&c*) fail
             (let ((c&c (stream-first c&c*)))
               (conde
                 ((== (cons (car c&c) (v->concept (cdr c&c))) concept))
                 ((loop (stream-rest c&c*)))))))))))

(define (db:concept-predicateo db:concept->pids db concept predicate)
  (fresh (cid cdetails pdetails)
    (== `(,cid . ,cdetails) concept)
    (db:concepto db concept)
    (project (cid)
      (foldr (lambda (pid others) (conde
                                    ((== `(,pid . ,pdetails) predicate)
                                     (db:predicateo db predicate))
                                    (others)))
             fail (db:concept->pids db cid)))))
(define (db:subject-predicateo db concept predicate)
  (db:concept-predicateo db:subject->pids db concept predicate))
(define (db:object-predicateo db concept predicate)
  (db:concept-predicateo db:object->pids db concept predicate))

(define (db:edgeo db edge)
  (define (edge-propso eid scid ocid pid eprops)
    (define e/p (db:eid->edge db eid))
    (fresh ()
      (== (edge/props-subject e/p) scid)
      (== (edge/props-object e/p) ocid)
      (== (edge/props-pid e/p) pid)
      (== (edge/props-props e/p) eprops)))
  (define (edges-by-Xo cid->stream cid pid dcatid dcid eid)
    (project (cid pid dcatid dcid eid)
      (let loop ((e* (cid->stream db cid
                                  (and (not (var? pid)) pid)
                                  (and (not (var? dcatid)) dcatid)
                                  (and (not (var? dcid)) dcid))))
        (if (stream-empty? e*) fail
          (conde
            ((== (edge-eid (stream-first e*)) eid))
            ((loop (stream-rest e*))))))))
  (fresh (scid scui sname scatid scat sprops
               ocid ocui oname ocatid ocat oprops eid pid pred eprops)
    (== `(,eid (,scid ,scui ,sname (,scatid . ,scat) ,sprops)
               (,ocid ,ocui ,oname (,ocatid . ,ocat) ,oprops)
               (,pid . ,pred) ,eprops) edge)
    (project (scid scui sname scatid scat sprops
                   ocid ocui oname ocatid ocat oprops eid pid pred eprops)
      (let* ((edges-by-subject
               (edges-by-Xo db:subject->edge-stream scid pid ocatid ocid eid))
             (edges-by-object
               (edges-by-Xo db:object->edge-stream ocid pid scatid scid eid))
             (subject (db:concepto
                        db `(,scid ,scui ,sname (,scatid . ,scat) ,sprops)))
             (object (db:concepto
                       db `(,ocid ,ocui ,oname (,ocatid . ,ocat) ,oprops)))
             (subject-edges (fresh () subject edges-by-subject))
             (object-edges (fresh () object edges-by-object)))
        (cond ((not (var? eid)) succeed)
              ((not (var? scid)) edges-by-subject)
              ((not (var? ocid)) edges-by-object)
              ((not (var? scatid)) subject-edges)
              ((not (var? ocatid)) object-edges)
              ((not (var? scat))
               (fresh () (db:categoryo db `(,scatid . ,scat)) subject-edges))
              ((not (var? ocat))
               (fresh () (db:categoryo db `(,ocatid . ,ocat)) object-edges))
              ((not (andmap var? (list scui sname scat sprops))) subject-edges)
              ((not (andmap var? (list ocui oname ocat oprops))) object-edges)
              (else subject-edges))))
    (project (eid) (edge-propso eid scid ocid pid eprops))
    (db:predicateo db `(,pid . ,pred))
    (db:concepto db `(,scid ,scui ,sname (,scatid . ,scat) ,sprops))
    (db:concepto db `(,ocid ,ocui ,oname (,ocatid . ,ocat) ,oprops))))

(define (db:pmid-eido db pmid eid)
  (define (eid-loop eid*)
    (if (null? eid*) fail
      (conde
        ((== (car eid*) eid))
        ((eid-loop (cdr eid*))))))
  (project (pmid)
    (if (var? pmid)
      (let loop ((pe* (db:pmid&eid*-stream db)))
        (cond ((stream-empty? pe*) fail)
              (else (define pe (stream-first pe*))
                    (conde
                      ((== (car pe) pmid) (eid-loop (cdr pe)))
                      ((loop (stream-rest pe*)))))))
      (eid-loop (db:pmid->eid* db pmid)))))
