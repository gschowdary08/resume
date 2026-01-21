param(
    [ValidateSet("devops","sre")]
    [string]$Role = "devops"
)

# -------------------------
# Load Data Files
# -------------------------
$profile  = Get-Content data/profile.json | ConvertFrom-Json
$skills   = (Get-Content data/skills.json | ConvertFrom-Json).$Role
$exp      = Get-Content data/experience.json | ConvertFrom-Json
$projects = Get-Content data/projects.json | ConvertFrom-Json
$education = Get-Content data/education.json | ConvertFrom-Json
$certs    = Get-Content data/certifications.json | ConvertFrom-Json
$awards   = Get-Content data/awards.json | ConvertFrom-Json
$template = Get-Content templates/resume.template.txt -Raw

# -------------------------
# Format Skills
# -------------------------
$skillsText = ($skills | ForEach-Object { "- $_" }) -join "`n"

# -------------------------
# Format Experience
# -------------------------
$expText = ""
foreach ($e in $exp) {
    $expText += "$($e.company) – $($e.role) | $($e.duration)`n"
    $expText += ($e.points | ForEach-Object { "- $_" }) -join "`n"
    $expText += "`n`n"
}

# -------------------------
# Format Projects
# -------------------------
$projText = ""
foreach ($p in $projects) {
    $projText += "$($p.name)`n"
    $projText += ($p.points | ForEach-Object { "- $_" }) -join "`n"
    $projText += "`n`n"
}

# -------------------------
# Format Certifications
# -------------------------
$certText = ($certs | ForEach-Object {
    "- $($_.name) ($($_.issuer), $($_.year))"
}) -join "`n"

# -------------------------
# Format Education
# -------------------------
$eduText = ""
foreach ($e in $education) {
    $eduText += "$($e.degree)`n"
    $eduText += "$($e.institution) | CGPA: $($e.cgpa) | $($e.year)`n`n"
}

# -------------------------
# Format Awards (Optional)
# -------------------------
$awardText = ""
if ($awards -and $awards.Count -gt 0) {
    $awardText = "AWARDS`n"
    $awardText += ($awards | ForEach-Object {
        "- $($_.title), $($_.organization) ($($_.year)) – $($_.description)"
    }) -join "`n"
}

# -------------------------
# Generate Final Resume
# -------------------------
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
    -replace "{{PROJECTS}}",$projText `
    -replace "{{CERTIFICATIONS}}",$certText `
    -replace "{{EDUCATION}}",$eduText `
    -replace "{{AWARDS}}",$awardText

# -------------------------
# Write Output File
# -------------------------
$outputPath = "output/resume-$Role.txt"
$output | Out-File $outputPath -Encoding UTF8

Write-Host "Resume generated successfully: $outputPath"
