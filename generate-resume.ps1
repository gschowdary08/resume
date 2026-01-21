param(
  [ValidateSet("devops","sre")]
  [string]$Role = "devops"
)

$profile = Get-Content data/profile.json | ConvertFrom-Json
$skills  = (Get-Content data/skills.json | ConvertFrom-Json).$Role
$exp     = Get-Content data/experience.json | ConvertFrom-Json
$proj    = Get-Content data/projects.json | ConvertFrom-Json
$template = Get-Content templates/resume.template.txt -Raw

$skillsText = ($skills | ForEach-Object { "- $_" }) -join "`n"

$expText = ""
foreach ($e in $exp) {
  $expText += "`n$($e.company) – $($e.role) | $($e.duration)`n"
  $expText += ($e.points | ForEach-Object { "- $_" }) -join "`n"
  $expText += "`n"
}

$projText = ""
foreach ($p in $proj) {
  $projText += "`n$($p.name)`n"
  $projText += ($p.points | ForEach-Object { "- $_" }) -join "`n"
  $projText += "`n"
}

$output = $template `
  -replace "{{NAME}}",$profile.name `
  -replace "{{TITLE}}",$profile.title `
  -replace "{{LOCATION}}",$profile.location `
  -replace "{{PHONE}}",$profile.phone `
  -replace "{{EMAIL}}",$profile.email `
  -replace "{{LINKEDIN}}",$profile.linkedin `
  -replace "{{SUMMARY}}",$profile.summary `
  -replace "{{SKILLS}}",$skillsText `
  -replace "{{EXPERIENCE}}",$expText `
  -replace "{{PROJECTS}}",$projText

$output | Out-File "output/resume-$Role.txt" -Encoding UTF8
