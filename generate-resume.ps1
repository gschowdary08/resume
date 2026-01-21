param(
    [ValidateSet("devops","sre","Azure")]
    [string]$Role = "devops"
)

# Load data
$profile   = Get-Content profile.json | ConvertFrom-Json
$skills    = (Get-Content skills.json | ConvertFrom-Json).$Role
$exp       = Get-Content experience.json | ConvertFrom-Json
$projects  = Get-Content projects.json | ConvertFrom-Json
$education = Get-Content education.json | ConvertFrom-Json
$certs     = Get-Content certification.json | ConvertFrom-Json
$awards    = Get-Content awards.json | ConvertFrom-Json
$template  = Get-Content resume.templet.txt -Raw

# Skills
$skillsText = ($skills | ForEach-Object { "- $_" }) -join "`n"

# Experience
$expText = ""
foreach ($e in $exp) {
    $expText += "$($e.company) - $($e.role) | $($e.duration)`n"
    $expText += ($e.points | ForEach-Object { "- $_" }) -join "`n"
    $expText += "`n`n"
}

# Projects
$projText = ""
foreach ($p in $projects) {
    $projText += "$($p.name)`n"
    $projText += ($p.points | ForEach-Object { "- $_" }) -join "`n"
    $projText += "`n`n"
}

# Certifications
$certText = ($certs | ForEach-Object {
    "- $($_.name) ($($_.issuer), $($_.year))"
}) -join "`n"

# Education
$eduText = ""
foreach ($e in $education) {
    $eduText += "$($e.degree)`n"
    $eduText += "$($e.institution) | CGPA: $($e.cgpa) | $($e.year)`n`n"
}

# Awards (optional)
$awardText = ""
if ($awards -and $awards.Count -gt 0) {
    $awardText = "AWARDS`n"
    $awardText += ($awards | ForEach-Object {
        "- $($_.title), $($_.organization) ($($_.year)) - $($_.description)"
    }) -join "`n"
}

# Generate resume
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

# Write output
$outputPath ="C:\Users\gscho\OneDrive\Documents\resume\resume-$Role.txt"
$output | Out-File $outputPath -Encoding UTF8

Write-Host "Resume generated successfully: $outputPath"
