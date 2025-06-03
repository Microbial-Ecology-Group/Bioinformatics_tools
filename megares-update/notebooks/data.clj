;; clojure -M -m scicloj.clay.v2.main

(ns megares-test
  (:require [tablecloth.api :as tc]
            [scicloj.kindly.v4.kind :as kind]))

(kind/table
 (tc/dataset "matches.tsv"))
