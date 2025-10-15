<#
Emits known memory-related diagnostics for asm/preproc.c::do_directive
so they appear in VS Code Problems via the configured task/problem matcher.
#>

function RelPath([string]$p) {
  # Normalize to a relative path with OS-native separators
  return [System.IO.Path]::Combine($p.Split('/'))
}

$fileRel = RelPath 'asm/preproc.c'

$problems = @(
  @{ file = $fileRel; line = 2741; col = 1; severity = 'warning'; message = 'do_directive: leaks origline on non-final pass (issue_error early return). Call free_tlist(origline) before return.' },
  @{ file = $fileRel; line = 2890; col = 1; severity = 'error';   message = 'do_directive: leak and stale global on redefinition path. Free free_mmacro(defining) and set defining = NULL before return; also free origline if not already freed.' },
  @{ file = $fileRel; line = 3700; col = 1; severity = 'error';   message = 'do_directive: leaks origline in default case. Call free_tlist(origline) before return.' }
)

foreach ($p in $problems) {
  Write-Output ("{0}:{1}:{2}: {3}: {4}" -f $p.file, $p.line, $p.col, $p.severity, $p.message)
}

exit 0
