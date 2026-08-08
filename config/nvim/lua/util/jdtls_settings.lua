-- Per-project overrides for jdtls' `java.completion.importOrder`, which
-- controls the grouping/order used by "Organize Imports" and import completion.
--
-- None of the checkstyle.xml files on this machine currently define an
-- `ImportOrder`/`CustomImportOrder` module (only AvoidStarImport/RedundantImport/
-- UnusedImports), so there's no concrete project convention to mirror yet.
-- DEFAULT is a reasonable placeholder grouping used until one exists.
--
-- Once a project defines a real checkstyle ImportOrder module, add an entry
-- here keyed by a substring of the project root path, e.g.:
--   overrides["/Users/shane/dev/somejavaproj"] = { "java", "javax", "com.company", "" }
-- (an empty string group is a catch-all for anything not matched above it)

local M = {}

local DEFAULT_IMPORT_ORDER = { "java", "javax", "org", "com" }

local overrides = {
  -- ["/Users/shane/dev/someproject"] = { "java", "javax", "com.company", "" },
}

function M.import_order(root_dir)
  for path_substring, order in pairs(overrides) do
    if root_dir and root_dir:find(path_substring, 1, true) then
      return order
    end
  end
  return DEFAULT_IMPORT_ORDER
end

return M
