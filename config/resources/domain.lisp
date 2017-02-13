(in-package :mu-cl-resources)

;;;;
;; NOTE
;; docker-compose stop; docker-compose rm; docker-compose up
;; after altering this file.

;; Describe your resources here

;; The general structure could be described like this:
;;
;; (define-resource <name-used-in-this-file> ()
;;   :class <class-of-resource-in-triplestore>
;;   :properties `((<json-property-name-one> <type-one> ,<triplestore-relation-one>)
;;                 (<json-property-name-two> <type-two> ,<triplestore-relation-two>>))
;;   :has-many `((<name-of-an-object> :via ,<triplestore-relation-to-objects>
;;                                    :as "<json-relation-property>")
;;               (<name-of-an-object> :via ,<triplestore-relation-from-objects>
;;                                    :inverse t ; follow relation in other direction
;;                                    :as "<json-relation-property>"))
;;   :has-one `((<name-of-an-object :via ,<triplestore-relation-to-object>
;;                                  :as "<json-relation-property>")
;;              (<name-of-an-object :via ,<triplestore-relation-from-object>
;;                                  :as "<json-relation-property>"))
;;   :resource-base (s-url "<string-to-which-uuid-will-be-appended-for-uri-of-new-items-in-triplestore>")
;;   :on-path "<url-path-on-which-this-resource-is-available>")


;; An example setup with a catalog, dataset, themes would be:
;;
;; (define-resource catalog ()
;;   :class (s-prefix "dcat:Catalog")
;;   :properties `((:title :string ,(s-prefix "dct:title")))
;;   :has-many `((dataset :via ,(s-prefix "dcat:dataset")
;;                        :as "datasets"))
;;   :resource-base (s-url "http://webcat.tmp.semte.ch/catalogs/")
;;   :on-path "catalogs")

;; (define-resource dataset ()
;;   :class (s-prefix "dcat:Dataset")
;;   :properties `((:title :string ,(s-prefix "dct:title"))
;;                 (:description :string ,(s-prefix "dct:description")))
;;   :has-one `((catalog :via ,(s-prefix "dcat:dataset")
;;                       :inverse t
;;                       :as "catalog"))
;;   :has-many `((theme :via ,(s-prefix "dcat:theme")
;;                      :as "themes"))
;;   :resource-base (s-url "http://webcat.tmp.tenforce.com/datasets/")
;;   :on-path "datasets")

;; (define-resource distribution ()
;;   :class (s-prefix "dcat:Distribution")
;;   :properties `((:title :string ,(s-prefix "dct:title"))
;;                 (:access-url :url ,(s-prefix "dcat:accessURL")))
;;   :resource-base (s-url "http://webcat.tmp.tenforce.com/distributions/")
;;   :on-path "distributions")

;; (define-resource theme ()
;;   :class (s-prefix "tfdcat:Theme")
;;   :properties `((:pref-label :string ,(s-prefix "skos:prefLabel")))
;;   :has-many `((dataset :via ,(s-prefix "dcat:theme")
;;                        :inverse t
;;                        :as "datasets"))
;;   :resource-base (s-url "http://webcat.tmp.tenforce.com/themes/")
;;   :on-path "themes")

;;



(define-resource topic ()
  :class (s-prefix "lvoc:Topic")
  :properties `((:title :string ,(s-prefix "dct:title")))
  :has-many `((theme :via ,(s-prefix "lvoc:hasTopic")
                     :inverse t
                     :as "themes"))
  :resource-base (s-url "http://leuven.be/topics/")
  :on-path "topics")

(define-resource region ()
  :class (s-prefix "lvoc:Region")
  :properties `((:title :string ,(s-prefix "dct:title")))
  :has-many `((region-theme :via ,(s-prefix "lvoc:hasRegion")
                     :inverse t
                     :as "region-themes"))
  :resource-base (s-url "http://leuven.be/regions/")
  :on-path "regions")

(define-resource theme ()
  :class (s-prefix "lvoc:Theme")
  :properties `((:title :string ,(s-prefix "dct:title")))
  :has-many `((topic :via ,(s-prefix "lvoc:hasTopic")
                     :as "topics")
              (region-theme :via ,(s-prefix "lvoc:hasTheme")
                     :inverse t
                     :as "region-themes"))
  :resource-base (s-url "http://leuven.be/themes/")
  :on-path "themes")

(define-resource region-theme ()
  :class (s-prefix "lvoc:RegionTheme")
  :properties `((:title :string ,(s-prefix "dct:title")))
  :has-many `((value :via ,(s-prefix "lvoc:hasRegionTheme")
                     :inverse t
                     :as "values"))
  :has-one `((theme :via ,(s-prefix "lvoc:hasTheme")
                    :as "theme")
             (region :via ,(s-prefix "lvoc:hasRegion")
                    :as "region"))
  :resource-base (s-url "http;//leuven.be/region-themes/")
  :on-path "region-themes")

(define-resource value ()
  :class (s-prefix "lvoc:Value")
  :properties `((:value :number ,(s-prefix "lvoc:value"))
                (:year :string ,(s-prefix "lvoc:year")))
  :has-one `((region-theme :via ,(s-prefix "lvoc:hasRegionTheme")
                    :as "region-theme"))
  :resource-base (s-url "http://leuven.be/values/")
  :on-path "values")
