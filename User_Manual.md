# User Manual
## AI Automation for Sales and Customer Care
### F24-160 | FAST-NUCES Lahore | Final Year Project

---

> **Version:** 1.0  
> **Authors:** FYP Team — F24-160  
> **Institution:** FAST National University of Computer and Emerging Sciences, Lahore  
> **Date:** July 2026  

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Getting Started](#2-getting-started)
   - [Creating Your Account](#21-creating-your-account)
   - [Logging In](#22-logging-in)
   - [Navigating the Dashboard](#23-navigating-the-dashboard)
3. [CRM Integration](#3-crm-integration)
   - [Uploading a CSV File](#31-uploading-a-csv-file)
   - [Mapping Columns](#32-mapping-columns)
   - [Viewing Imported Data](#33-viewing-imported-data)
4. [Dashboard](#4-dashboard)
   - [Contacts Overview](#41-contacts-overview)
   - [Filtering and Searching](#42-filtering-and-searching)
5. [Sales Agent](#5-sales-agent)
   - [Starting the Automated Campaign](#51-starting-the-automated-campaign)
   - [Monitoring Call Status](#52-monitoring-call-status)
   - [Email Alerts](#53-email-alerts)
6. [Reporting & Analytics](#6-reporting--analytics)
   - [Uploading Data for Analysis](#61-uploading-data-for-analysis)
   - [Viewing Charts and Insights](#62-viewing-charts-and-insights)
   - [AI Chat for Data Queries](#63-ai-chat-for-data-queries)
7. [Voice Demo](#7-voice-demo)
   - [Using the Voice Interface](#71-using-the-voice-interface)
8. [Account Settings](#8-account-settings)
9. [Frequently Asked Questions](#9-frequently-asked-questions)
10. [Support and Contact](#10-support-and-contact)

---

## 1. Introduction

**AI Automation for Sales and Customer Care** is an intelligent platform that automates outbound sales campaigns, customer relationship management, and business reporting using cutting-edge AI technologies.

### What This System Does

| Feature | Description |
|---------|-------------|
| 📊 **CRM Integration** | Import your customer data from CSV files and organize leads |
| 🤖 **AI Sales Agent** | Automatically calls leads using a conversational AI voice agent |
| 📈 **Smart Reporting** | Analyze your data with interactive charts and AI-powered Q&A |
| 🎤 **Voice Demo** | Test the AI voice agent in real-time via your browser microphone |
| 🔐 **Secure Auth** | JWT-based authentication with optional Google OAuth sign-in |

### Who Is This For?

- **Sales Managers** who want to automate outbound calling campaigns
- **Business Analysts** who need instant insights from customer data
- **Development Teams** evaluating AI-powered sales automation

---

## 2. Getting Started

### 2.1 Creating Your Account

1. Open your browser and navigate to:
   - **Production:** `https://your-deployed-app.vercel.app`
   - **Local:** `http://localhost:3000`

2. Click **Sign Up** on the home page.

3. Fill in the registration form:
   - **Full Name** — your display name
   - **Email Address** — must be a valid email
   - **Password** — at least 8 characters

4. Click **Create Account**.

5. Check your email inbox for a **verification email** from Supabase. Click the link to verify your account.

> **Tip:** If you don't see the email, check your Spam/Junk folder.

### 2.2 Logging In

1. Navigate to the **Login** page.

2. Enter your **Email** and **Password**.

3. Click **Sign In**.

4. Alternatively, click **Continue with Google** to sign in using your Google account (if enabled by your admin).

> **Forgot your password?** Click "Forgot Password" on the login page to receive a reset email.

### 2.3 Navigating the Dashboard

After logging in, you will see the main navigation sidebar with the following sections:

| Section | Icon | Description |
|---------|------|-------------|
| **Dashboard** | 🏠 | Overview of contacts and recent activity |
| **CRM Integration** | 📁 | Upload and import customer CSV data |
| **Sales Agent** | 🤖 | Launch and monitor automated voice campaigns |
| **Reporting** | 📊 | Analytics and AI-powered Q&A on your data |
| **Voice Demo** | 🎤 | Test the AI voice agent in real-time |

---

## 3. CRM Integration

The CRM Integration module allows you to import customer data from CSV files and map them to the system's lead fields.

### 3.1 Uploading a CSV File

1. Click **CRM Integration** in the sidebar.

2. Click the **Upload CSV** button or drag and drop your file onto the upload area.

3. **Supported file format:** `.csv` only  
   **Maximum file size:** 50 MB

4. Your CSV should contain customer data such as:
   - Customer names
   - Phone numbers
   - Email addresses
   - Company names
   - Any other lead data

**Example CSV structure:**

```
Name,Phone,Email,Company,Status
John Smith,+1-555-0101,john@acme.com,Acme Corp,New Lead
Jane Doe,+1-555-0202,jane@beta.com,Beta Inc,Contacted
```

5. Once uploaded, a preview of your data will appear.

### 3.2 Mapping Columns

The system will attempt to **auto-detect** your column names. You will see a mapping interface showing:

- **Your CSV Column** (left) → **System Field** (right)

Review each mapping and correct any that were not detected automatically:

| System Field | What It Represents |
|-------------|-------------------|
| `name` | Full name of the lead |
| `phone` | Phone number (E.164 format: `+1XXXXXXXXXX`) |
| `email` | Email address |
| `company` | Company or organization name |
| `status` | Lead status (New, Contacted, Qualified, etc.) |

> **Important:** The `phone` field is required for the AI Sales Agent to make calls.

3. Once mappings are confirmed, click **Import Data**.

4. A background job will process your data. You will see a **progress indicator**. Large files may take up to a few minutes.

### 3.3 Viewing Imported Data

After the import completes:

1. Navigate to **Dashboard** to see your imported contacts.
2. All contacts will appear in the contacts table with their mapped fields.
3. If the import fails, an error message will describe the issue (e.g., invalid phone numbers, missing required fields).

---

## 4. Dashboard

The Dashboard provides an overview of all your contacts and their current status.

### 4.1 Contacts Overview

The contacts table displays:

| Column | Description |
|--------|-------------|
| **Name** | Lead's full name |
| **Phone** | Phone number |
| **Email** | Email address |
| **Company** | Company name |
| **Status** | Current lead status (New, Called, Completed, etc.) |
| **Created At** | Date the record was imported |

### 4.2 Filtering and Searching

- Use the **search bar** at the top of the table to filter by name, email, or company.
- Use the **Status filter** dropdown to view only leads with a specific status.
- Click any **column header** to sort the table by that column.

---

## 5. Sales Agent

The Sales Agent module uses an AI-powered voice agent to automatically call your leads and conduct sales conversations.

### 5.1 Starting the Automated Campaign

1. Navigate to **Sales Agent** in the sidebar.

2. You will see a list of your leads that are eligible for calling (those with valid phone numbers).

3. Review the leads you want to include in the campaign.

4. Click **Start Processing** to begin the automated call campaign.

5. The system will queue all leads and begin placing outbound calls.

> **Prerequisites for voice calls:**
> - Twilio account credentials configured in `backend/.env`
> - ngrok running locally (for local dev): `ngrok http 8000`
> - `PUBLIC_URL` set in `.env` to your ngrok URL

### 5.2 Monitoring Call Status

While the campaign is running:

- Each lead's status updates in real-time as calls are placed.
- Status values:
  - **Pending** — queued, waiting to be called
  - **Calling** — call is currently in progress
  - **Completed** — call finished successfully
  - **Failed** — call could not be connected

- You can view a summary of completed, failed, and pending calls at the top of the page.

### 5.3 Email Alerts

The sales agent will send **email notifications** to your configured email address (`EMAIL_USER` in `.env`) for key events:

- When a lead conversation is completed
- When a lead expresses interest
- When a call fails repeatedly

> Make sure `EMAIL_USER` and `EMAIL_PASS` are correctly set in `backend/.env`.  
> `EMAIL_PASS` should be a **Gmail App Password**, not your regular Gmail password.

---

## 6. Reporting & Analytics

The Reporting module allows you to upload data files and get instant visual analytics plus an AI-powered chat interface to ask questions about your data.

### 6.1 Uploading Data for Analysis

1. Navigate to **Reporting** in the sidebar.

2. Click **Upload File** and select a CSV file containing your business data.

3. The system will process the file and extract:
   - Column names and data types
   - Basic statistics (min, max, mean, unique counts)
   - Distribution patterns

### 6.2 Viewing Charts and Insights

After uploading, the system automatically generates:

| Chart Type | Description |
|------------|-------------|
| **Bar Charts** | Compare categorical data (e.g., sales by region) |
| **Line Charts** | Show trends over time |
| **Pie Charts** | Show proportional breakdowns |
| **Summary Cards** | Key metrics at a glance (total rows, averages, etc.) |

- Charts are interactive — hover over data points for exact values.
- You can download charts as images using the download button on each chart.

### 6.3 AI Chat for Data Queries

Below the charts, there is an **AI Chat** interface powered by Groq + Qdrant RAG:

1. Type your question about the data in the chat input box.
2. Press **Enter** or click **Send**.
3. The AI will analyze your data and respond with insights.

**Example questions you can ask:**

```
"What is the average sales value in Q1?"
"Which region has the highest customer count?"
"Show me leads with status Pending."
"What percentage of customers are from Lahore?"
"Which product category generates the most revenue?"
```

> **Tip:** The more specific your question, the more precise the AI's answer.

---

## 7. Voice Demo

The Voice Demo allows you to interact with the AI sales agent directly through your browser microphone — without making a real phone call.

### 7.1 Using the Voice Interface

1. Navigate to **Voice Demo** in the sidebar.

2. Click **Allow Microphone Access** when your browser requests permission.

3. Click the **Start Recording** button (or the microphone icon).

4. Speak your test query or question — for example:
   - *"Hello, I'm calling about your product."*
   - *"Can you tell me more about your pricing?"*

5. The AI agent will respond with a voice reply in real-time.

6. Click **Stop Recording** when done.

> **Note:** The Voice Demo uses ElevenLabs TTS for high-quality voice synthesis. An internet connection is required.

---

## 8. Account Settings

Access account settings by clicking your **profile avatar** in the top-right corner of the navigation bar.

### Available Settings

| Setting | Description |
|---------|-------------|
| **Profile** | Update your display name and email |
| **Change Password** | Set a new password |
| **Log Out** | End your current session securely |

---

## 9. Frequently Asked Questions

**Q: I uploaded a CSV but no data appeared in the Dashboard. Why?**  
A: Check that your CSV has the correct column structure and that required fields (especially `phone`) are present. Look for an error message in the CRM Integration page after import.

---

**Q: The Sales Agent is not making calls. What's wrong?**  
A: Ensure that:
1. Your Twilio credentials are set correctly in `backend/.env`.
2. The `PUBLIC_URL` in `.env` is set to your active ngrok URL (for local dev).
3. The sales service (port 8000) is running.

---

**Q: The Reporting AI Chat is not responding.**  
A: Check that:
1. `GROQ_API_KEY` is set in `backend/.env`.
2. `QDRANT_CLUSTER_URL` and `QDRANT_API_KEY` are correct.
3. The reporting service (port 6000) is running.

---

**Q: I see "Network Error" on all API calls in the frontend.**  
A: This usually means:
1. The backend services are not running.
2. `NEXT_PUBLIC_API_BASE_URL` in `frontend/.env.local` is incorrect.
3. The hardcoded API URLs in the source need to be updated for local dev (see Setup Guide).

---

**Q: I see user ID `6921` on the dashboard instead of my real user ID.**  
A: You may not be fully authenticated. Try logging out and logging back in via the `/login` page. The `6921` is a hardcoded fallback that appears when the auth token isn't reaching the backend.

---

**Q: Can I import multiple CSV files?**  
A: Yes, you can upload and import multiple CSV files. Each import adds to your existing contacts table. To reset your data, contact your administrator.

---

**Q: Is my data secure?**  
A: All sensitive data is stored in Supabase with encryption at rest. API communications use HTTPS in production. JWT tokens expire after 30 minutes for security. Never share your `backend/.env` file.

---

**Q: How do I add a new user to the system?**  
A: New users can self-register via the Sign Up page. If you need admin-level access control, contact the system administrator.

---

**Q: The voice demo is not responding after I speak.**  
A: Check that:
1. Your browser has microphone access granted.
2. ElevenLabs API key (`eleven_labs_key`) is set in `.env`.
3. The sales service (port 8000) is running.
4. You are using a supported browser (Chrome or Edge recommended).

---

## 10. Support and Contact

For technical issues or questions, contact the FYP team:

| Contact | Details |
|---------|---------|
| **Project** | FYP F24-160 — AI Automation for Sales and Customer Care |
| **Institution** | FAST-NUCES Lahore |
| **Email** | Reach out through your supervisor or department |
| **Technical Docs** | See `backend/LOCAL_SETUP.md` for full technical documentation |
| **Source Code** | Available in the project repository |

---

### Quick Reference — Service URLs

| Service | Local URL | Purpose |
|---------|-----------|---------|
| Frontend | http://localhost:3000 | Main application |
| Auth API | http://localhost:2000/docs | Authentication API docs |
| CRM API | http://localhost:5000/docs | CRM API docs |
| Reporting API | http://localhost:6000/docs | Reporting API docs |
| Sales API | http://localhost:8000 | Sales Agent API |

---

*This document is the official User Manual for FYP F24-160.*  
*FAST National University of Computer and Emerging Sciences, Lahore | 2026*
