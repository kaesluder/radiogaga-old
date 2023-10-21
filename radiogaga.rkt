#lang racket
(require vela)
(require net/dns)
(require http-client)


(define server
  (dns-get-name (dns-find-nameserver)
                (dns-get-address (dns-find-nameserver) "all.api.radio-browser.info")))

;; http://de1.api.radio-browser.info/json/stations

(define top-stations-endpoint
  (format "~a~a~a" "http://" server "/json/stations/topclick"))

(define top-stations-conn
  (http-connection top-stations-endpoint
                   (hasheq 'Content-Type "application/json"
                           'User-Agent "RadioGaGa/0.0.1")
                   (hasheq 'limit 250)))

(define search-stations-endpoint
  (format "~a~a~a" "http://" server "/json/stations/search"))


(define search-stations-conn
  (http-connection search-stations-endpoint
                   (hasheq 'Content-Type "application/json"
                           'User-Agent "RadioGaGa/0.0.1")
                   (hasheq 'limit 250)))

(define (get-stations-by-name searchName)
  (http-response-body (http-post search-stations-conn
                                 #:data (hasheq 'name searchName))))


(define (get-top-stations) (http-response-body (http-post top-stations-conn)))
  

(define index
  (lambda (req)
    (jsonify (hash 'msg "hello world!" ))))

(define kexp
  (lambda (req)
    (jsonify (get-stations-by-name "kexp"))))

(define top-stations-route
  (lambda (req)
    (jsonify (get-top-stations))))

(define routers
  (urls
   (url "/" index "index")
   (url "/top" top-stations-route "top stations")
   (url "/kexp" kexp "kexp")))


;; (app-run routers #:port 8000)