;; extends

; dbt: text between jinja tags is SQL. Combined so the fragments parse as one
; SQL document (with the jinja holes cut out) instead of many broken snippets.
((content) @injection.content
  (#set! injection.language "googlesql")
  (#set! injection.combined))
