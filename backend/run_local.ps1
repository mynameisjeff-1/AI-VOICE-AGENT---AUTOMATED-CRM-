# Ensure Redis is running in WSL
Write-Host "Ensuring Redis is started in WSL..." -ForegroundColor Cyan
wsl -u root service redis-server start

Write-Host "`nLaunching microservices in separate windows..." -ForegroundColor Cyan

# Get the root project directory (parent of backend/)
$root = Split-Path -Parent $PSScriptRoot

# 1. Start Auth Service
Write-Host "Launching Auth Service on port 2000..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$root\backend\auth-service'; .\venv\Scripts\Activate.ps1; uvicorn app.main:app --reload --port 2000"

# 2. Start CRM Service
Write-Host "Launching CRM Integration Service on port 5000..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$root\backend\crm_integration_service'; .\.venv\Scripts\Activate.ps1; uvicorn app.api.main:app --reload --port 5000"

# 3. Start CRM Celery Worker
Write-Host "Launching CRM Celery Worker..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$root\backend\crm_integration_service'; .\.venv\Scripts\Activate.ps1; celery -A app.worker.celery_app worker --loglevel=info -P solo"

# 4. Start Reporting Service
Write-Host "Launching Reporting Service on port 6000..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$root\backend\reporting_service'; .\.venv\Scripts\Activate.ps1; Set-Location app; uvicorn main:app --reload --port 6000"

# 5. Start Sales Agent Service
Write-Host "Launching Sales Agent Service on port 8000..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$root\backend\sales_agent_service\src'; '$root\backend\sv_sales\Scripts\Activate.ps1'; python -m calling_agent.main"



# 6. Start Next.js Frontend
Write-Host "Launching Frontend on http://localhost:3000..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$root\frontend'; npm run dev"

Write-Host "`nAll services have been launched in separate windows!" -ForegroundColor Cyan
Write-Host "You can close the windows to stop the services when you are finished." -ForegroundColor Yellow
