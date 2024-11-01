local function requiref(module)
    require(module)
end

has_iron = pcall(requiref,'iron')
if has_iron then
    iron = require('iron')
    iron.core.add_repl_definitions {
      clojure = {
        lein_connect = {
          command = {"lein", "repl", ":connect"}
        }
      }
    }

    iron.core.set_config {
      preferred = {
        python = "ptpython",
        clojure = "lein"
      }
    }
end

