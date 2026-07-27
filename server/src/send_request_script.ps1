param (
    [string]$FcmToken = "",
    [string]$UserId = "",
    [string]$IP = ""
)

$uri = "http://$IP/api/trigger-report"

$body = @{
    fcmToken = $FcmToken
    userId   = $UserId
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body $body
    Write-Host "Success:" $response.message -ForegroundColor Green
}
catch {
    Write-Host "Error:" $_.Exception.Message -ForegroundColor Red
}