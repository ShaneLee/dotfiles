-- Fetches and verifies the pinned vscode-java-test server jars jdtls needs
-- for its JUnit test runner (test_class()/test_nearest_method(), wired in
-- via ../plugins/jdtls.lua and ../../after/ftplugin/java.lua). Called from
-- that plugin's config() the first time a Java buffer is opened on a
-- machine that doesn't have them cached yet; a no-op after that.
--
-- Why this exists instead of letting Mason install "java-test" directly:
-- Mason's own resolution for that package proved unreliable in practice --
-- across several version-pin attempts it silently served jar content that
-- didn't match the version its own receipt claimed (verified by hash), and
-- its "latest" lagged behind what open-vsx.org actually listed as current.
--
-- Why a *pinned* version instead of always fetching "latest": different
-- java-test releases pin different (and sometimes incompatible)
-- org.objectweb.asm version ranges against whatever ASM jdtls itself
-- bundles. 0.46.0 was verified (by hand, inspecting its OSGi manifest) to
-- require ASM [9.10.1,9.11.0) -- an exact match for the ASM the current
-- jdtls snapshot bundles. If jdtls's bundled ASM version ever moves and
-- test running silently stops working again (test_nearest_method() erroring
-- with "No LSP client found that supports resolving possible test cases"),
-- that's the compatibility axis to re-check: find whichever java-test
-- release's com.microsoft.java.test.plugin manifest matches the new ASM
-- version, and repin VERSION + EXPECTED_SHA256 below to match.
--
-- Why checksums instead of trusting the download as-is: open-vsx serves
-- jar content under a version tag that isn't actually guaranteed immutable
-- (the inner plugin jar's own filename stayed "0.43.1" across several
-- outer releases with materially different content), so "the version
-- string matches" isn't good enough evidence that this download is safe to
-- hand to jdtls -- verify the exact bytes instead.
--
-- The runner fat-jar and jacoco agent are intentionally excluded: neither
-- is a real OSGi bundle, and including them breaks OSGi resolution for the
-- rest of the set (see nvim-jdtls's README, "From source" bundle setup).

local M = {}

M.VERSION = "0.46.0"

local URL = "https://open-vsx.org/api/vscjava/vscode-java-test/"
  .. M.VERSION .. "/file/vscjava.vscode-java-test-" .. M.VERSION .. ".vsix"

local EXCLUDE = {
  ["jacocoagent.jar"] = true,
  ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
}

M.EXPECTED_SHA256 = {
  ["com.microsoft.java.test.plugin-0.43.1.jar"] = "e01cc491d866f996499e8ee55d0c3d8ba4f6ec44053975b791e3d0d2c76044e6",
  ["junit-jupiter-api_5.14.4.jar"] = "aa1ae085fd92dfdbf85d867e60e59adc599bac183b46fc7e0698198bf426ad3f",
  ["junit-jupiter-api_6.0.1.jar"] = "a3ca8c7e567436093e4a6703d5d4aac02dbea36106ea32fd1367b56de20d4e02",
  ["junit-jupiter-engine_5.14.4.jar"] = "e1e35cf651ae1635638d431ea4412d5c65938be54150444f07ba659586042b11",
  ["junit-jupiter-engine_6.0.1.jar"] = "7476a56f4aaab57fc2f459847cd6bfb712b3bd04a9ac0b89ed9573f7adc2c550",
  ["junit-jupiter-migrationsupport_5.14.4.jar"] = "814dc0557337208a4bbc2450c49c04cd1d2127f8a642a524aa35d37d279a0496",
  ["junit-jupiter-params_5.14.4.jar"] = "28f2a8dab5b9d259b18fa6b0ba5a6f302cbc70dd875f42032ea9e3afea09a870",
  ["junit-jupiter-params_6.0.1.jar"] = "9566e249b4d4c7d53a6c8908f577885ce2d4c6313c916bdfbf7ffbc526b8a36f",
  ["junit-platform-commons_1.14.4.jar"] = "55c8a0c069ac1bc4e1f8bbb26b5eae95cbd10e4ff1b23248441ab61a607381e1",
  ["junit-platform-commons_6.0.1.jar"] = "f8853f45c10f380ddb157cf42abba9b073474f05cc40335b585055f85538dcad",
  ["junit-platform-engine_1.14.4.jar"] = "3c7f3f84a6747aef0db6bd5fdd2a6c8fe37132e653c939bd67387377af66d91c",
  ["junit-platform-engine_6.0.1.jar"] = "f49577073a7ae184c718d9b43ae0d8edcb8abfc5ac738735ee3339d4652e92bf",
  ["junit-platform-launcher_1.14.4.jar"] = "768d62f1b2a523713b702db53609c230af62bbd645fc2c07a7d794df4da32228",
  ["junit-platform-launcher_6.0.1.jar"] = "ee758ddb06fab1fd1a890c0bae4aacf8dc004c4f367e138dbffcb113cd09ebac",
  ["junit-platform-runner_1.14.4.jar"] = "bd7f09d24666a7c87f10029832652f7b2bf2211d1e6e0e08cfb885de68e2ff8f",
  ["junit-platform-suite-api_1.14.4.jar"] = "7297640fea76410a63b7fad20b349cf0f6c23c3e93ea704c4056a2beb6dfd0a4",
  ["junit-platform-suite-api_6.0.1.jar"] = "d79605e890a0b63c628cd7157451edc0ff94edaa8f527dfe53efb9b0f03002b6",
  ["junit-platform-suite-commons_1.14.4.jar"] = "8790c345a319a9ec5247cd38f36a1f67256d0bcd9c112af8daa235812e1876d8",
  ["junit-platform-suite-engine_1.14.4.jar"] = "be9d3d460d5e88b4d53f1e2e62f1b47354e23106e2a4fa4050a724c5d705b4d3",
  ["junit-platform-suite-engine_6.0.1.jar"] = "80258fc6dbc08a6145daf2db1c2bac9c0f4ec628afeb802d130cc218578acd6c",
  ["junit-vintage-engine_5.14.4.jar"] = "76317ecb621922d4c1430342285e4f7a75f0bf93e2528a8cf5004964fe5f8f8f",
  ["org.apiguardian.api_1.1.2.jar"] = "b509448ac506d607319f182537f0b35d71007582ec741832a1f111e5b5b70b38",
  ["org.eclipse.jdt.junit4.runtime_1.4.0.v20251113-1434.jar"] = "7d4dc5f688dffd5918a92e70e26394cafd3c0c824926a9d3d167a46f930ee9ed",
  ["org.eclipse.jdt.junit5.runtime_1.2.0.v20251113-1434.jar"] = "4ef5247c2db2b5b70ca4377e2eca559647a61f52b084427d6ecc2d6d9aa80c02",
  ["org.eclipse.jdt.junit6.runtime_1.0.0.v20251112-1701.jar"] = "ea5c107999b64395fba3d88b50caa0945ca7ac13b5883bb1f79d289075c9523e",
  ["org.jacoco.core_0.8.15.202606040825.jar"] = "ade1e0fdb4cd80d8537b57c6edb70a1360c47fdc518c20c65314517479bc4d0d",
  ["org.objectweb.asm_9.10.1.jar"] = "ed825d10ab1399c8c0cb669e688cf0c8c82629b4c8399b58352b68e92ca10fcb",
  ["org.objectweb.asm.commons_9.10.1.jar"] = "6d0abefb7cbf972ea16edb37ec14835372505063a45f976ab7ea889ed9497895",
  ["org.objectweb.asm.tree_9.10.1.jar"] = "3dfb0d5b6a106cd40b5b250e39935fbf2f927f4477546a5369a3ac609cf0506b",
  ["org.opentest4j_1.3.0.jar"] = "48e2df636cab6563ced64dcdff8abb2355627cb236ef0bf37598682ddf742f1b",
}

local function sha256(path)
  local out = vim.fn.system({ "shasum", "-a", "256", path })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return out:match("^(%x+)")
end

--- True when `dest` already has every pinned jar.
local function is_complete(dest)
  for name, _ in pairs(M.EXPECTED_SHA256) do
    if vim.fn.filereadable(dest .. "/" .. name) == 0 then
      return false
    end
  end
  return true
end

--- Synchronously ensures the pinned, checksum-verified jars exist at `dest`.
--- No-ops (cheap: just file-existence checks, no network) once already
--- fetched, so safe to call on every jdtls attach.
---@param dest string
---@return boolean success
function M.ensure_installed(dest)
  if is_complete(dest) then
    return true
  end

  vim.notify("Fetching vscode-java-test " .. M.VERSION .. " bundles for jdtls (one-time)...", vim.log.levels.INFO)

  local tmp = vim.fn.tempname()
  vim.fn.mkdir(tmp, "p")
  local vsix = tmp .. "/download.vsix"

  vim.fn.system({ "curl", "-fsSL", URL, "-o", vsix })
  if vim.v.shell_error ~= 0 then
    vim.notify("java_test_bundles: download of " .. URL .. " failed", vim.log.levels.ERROR)
    vim.fn.delete(tmp, "rf")
    return false
  end

  vim.fn.system({ "unzip", "-q", vsix, "extension/server/*.jar", "-d", tmp })
  if vim.v.shell_error ~= 0 then
    vim.notify("java_test_bundles: extracting " .. vsix .. " failed", vim.log.levels.ERROR)
    vim.fn.delete(tmp, "rf")
    return false
  end

  vim.fn.mkdir(dest, "p")
  local installed = 0
  for _, jar in ipairs(vim.fn.glob(tmp .. "/extension/server/*.jar", true, true)) do
    local name = vim.fn.fnamemodify(jar, ":t")
    if not EXCLUDE[name] then
      local expected = M.EXPECTED_SHA256[name]
      if expected then
        local actual = sha256(jar)
        if actual ~= expected then
          vim.notify(string.format(
            "java_test_bundles: checksum mismatch for %s (expected %s, got %s) -- refusing to install a jar"
              .. " that doesn't match what was verified against jdtls's ASM version",
            name, expected, tostring(actual)
          ), vim.log.levels.ERROR)
          vim.fn.delete(tmp, "rf")
          return false
        end
        vim.uv.fs_copyfile(jar, dest .. "/" .. name)
        installed = installed + 1
      end
    end
  end

  vim.fn.delete(tmp, "rf")

  if not is_complete(dest) then
    vim.notify("java_test_bundles: some pinned jars were missing from the downloaded archive", vim.log.levels.ERROR)
    return false
  end

  vim.notify(string.format("java_test_bundles: installed %d jars to %s", installed, dest), vim.log.levels.INFO)
  return true
end

return M
