;; extends

; dbt builtins: https://docs.getdbt.com/reference/dbt-jinja-functions
(function_call
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "ref" "source" "config" "var" "env_var" "is_incremental" "run_query" "log"
    "return" "statement" "load_result" "adapter" "dispatch" "exceptions"
    "fromjson" "tojson" "fromyaml" "toyaml" "zip" "set" "print" "doc"))

((identifier) @variable.builtin
  (#any-of? @variable.builtin "this" "target" "model" "graph" "execute" "invocation_id" "flags" "builtins" "modules"))
