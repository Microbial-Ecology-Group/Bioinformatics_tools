;; https://github.com/weizhongli/cdhit/wiki
;; https://guix.gnu.org/blog/2023/from-development-environments-to-continuous-integrationthe-ultimate-guide-to-software-development-with-guix/
;; https://news.ycombinator.com/item?id=36239195
;; https://github.com/weizhongli/cdhit
;; https://guix.gnu.org/manual/en/html_node/Build-Systems.html

(use-modules (guix packages)
             (guix build-system gnu)
             (gnu packages compression))

(package
  (name "cd-hit")
  (version "4.8.1-git")
  (source
   #f)
  (build-system gnu-build-system)
  (inputs (list zlib))
  (synopsis "")
  (description "")
  (home-page "cd-hit.org")
  (license #f))
