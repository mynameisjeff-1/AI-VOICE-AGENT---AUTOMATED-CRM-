Write-Host "Setting up Python virtual environments and installing dependencies..." -ForegroundColor Cyan

# Service 1: auth-service
Write-Host "`n>>> Setting up auth-service..." -ForegroundColor Green
cd backend/auth-service
python -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
cd ../..

# Service 2: crm_integration_service
Write-Host "`n>>> Setting up crm_integration_service..." -ForegroundColor Green
cd backend/crm_integration_service
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
cd ../..

# Service 3: reporting_service
Write-Host "`n>>> Setting up reporting_service..." -ForegroundColor Green
cd backend/reporting_service
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r app/requirements.txt
cd ../..

# Service 4: sales_agent_service
Write-Host "`n>>> Setting up sales_agent_service..." -ForegroundColor Green
python -m venv sv_sales
.\sv_sales\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r backend/sales_agent_service/src/requirements.txt


# Frontend
Write-Host "`n>>> Setting up frontend..." -ForegroundColor Green
cd frontend
npm install
cd ..

Write-Host "`nSetup complete!" -ForegroundColor Cyan
