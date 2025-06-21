#!/bin/bash

# Azure App Project Setup Script
# Run this script from your project root directory

set -e  # Exit on any error

echo "🚀 Setting up Azure App project structure..."

# Create directory structure
echo "📁 Creating directories..."
mkdir -p public
mkdir -p src

echo "✅ Directories created successfully!"

# Create package.json
echo "📦 Creating package.json..."
cat > package.json << 'EOF'
{
  "name": "my-azure-app",
  "version": "1.0.0",
  "description": "A simple Node.js web application for Azure App Service",
  "main": "src/app.js",
  "scripts": {
    "start": "node src/app.js",
    "dev": "node src/app.js",
    "build": "echo 'No build step required for this simple app'",
    "test": "echo 'No tests specified'"
  },
  "keywords": ["azure", "nodejs", "express", "webapp"],
  "author": "Your Name",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF

# Create main app.js
echo "🖥️  Creating src/app.js..."
cat > src/app.js << 'EOF'
const express = require('express');
const path = require('path');

const app = express();

// Get port from environment or default to 3000
const port = process.env.PORT || 3000;

// Serve static files from public directory
app.use(express.static(path.join(__dirname, '../public')));

// API Routes
app.get('/api/hello', (req, res) => {
  res.json({ 
    message: 'Hello from Azure App Service!',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

app.get('/api/status', (req, res) => {
  res.json({
    status: 'healthy',
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    version: process.version
  });
});

// Health check endpoint for Azure
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// Catch all handler - serve index.html for SPA routing
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/index.html'));
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
EOF

# Create index.html
echo "🌐 Creating public/index.html..."
cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Azure App</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Welcome to My Azure App</h1>
            <p>This app is deployed using Azure DevOps and Azure App Service</p>
        </header>

        <main>
            <section class="info-section">
                <h2>App Information</h2>
                <div id="app-info">
                    <p>Loading...</p>
                </div>
            </section>

            <section class="status-section">
                <h2>Server Status</h2>
                <div id="server-status">
                    <p>Loading...</p>
                </div>
            </section>

            <section class="actions">
                <button id="refresh-btn" class="btn">Refresh Data</button>
                <button id="test-api-btn" class="btn">Test API</button>
            </section>

            <section class="logs">
                <h3>Activity Log</h3>
                <div id="activity-log"></div>
            </section>
        </main>

        <footer>
            <p>&copy; 2025 My Azure App - Deployed with Azure DevOps</p>
        </footer>
    </div>

    <script src="script.js"></script>
</body>
</html>
EOF

# Create style.css
echo "🎨 Creating public/style.css..."
cat > public/style.css << 'EOF'
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.6;
    color: #333;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    background: white;
    margin-top: 20px;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

header {
    text-align: center;
    padding: 2rem 0;
    border-bottom: 2px solid #eee;
    margin-bottom: 2rem;
}

header h1 {
    color: #2c3e50;
    font-size: 2.5rem;
    margin-bottom: 0.5rem;
}

header p {
    color: #7f8c8d;
    font-size: 1.1rem;
}

main {
    display: grid;
    gap: 2rem;
}

.info-section, .status-section {
    background: #f8f9fa;
    padding: 1.5rem;
    border-radius: 8px;
    border-left: 4px solid #3498db;
}

.info-section h2, .status-section h2 {
    color: #2c3e50;
    margin-bottom: 1rem;
}

.actions {
    text-align: center;
    padding: 1rem 0;
}

.btn {
    background: #3498db;
    color: white;
    border: none;
    padding: 12px 24px;
    margin: 0 10px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.3s ease;
}

.btn:hover {
    background: #2980b9;
}

.btn:active {
    transform: translateY(1px);
}

.logs {
    background: #2c3e50;
    color: white;
    padding: 1.5rem;
    border-radius: 8px;
    max-height: 300px;
    overflow-y: auto;
}

.logs h3 {
    margin-bottom: 1rem;
    color: #ecf0f1;
}

#activity-log {
    font-family: 'Courier New', monospace;
    font-size: 0.9rem;
    line-height: 1.4;
}

.log-entry {
    margin-bottom: 0.5rem;
    padding: 0.25rem 0;
    border-bottom: 1px solid #34495e;
}

.log-timestamp {
    color: #95a5a6;
    margin-right: 0.5rem;
}

.log-message {
    color: #ecf0f1;
}

#app-info, #server-status {
    background: white;
    padding: 1rem;
    border-radius: 5px;
    border: 1px solid #ddd;
}

.data-item {
    display: flex;
    justify-content: space-between;
    margin-bottom: 0.5rem;
    padding: 0.25rem 0;
    border-bottom: 1px solid #eee;
}

.data-label {
    font-weight: 600;
    color: #2c3e50;
}

.data-value {
    color: #7f8c8d;
    font-family: 'Courier New', monospace;
}

footer {
    text-align: center;
    padding: 2rem 0 1rem;
    border-top: 2px solid #eee;
    margin-top: 2rem;
    color: #7f8c8d;
}

@media (max-width: 768px) {
    .container {
        margin: 10px;
        padding: 15px;
    }
    
    header h1 {
        font-size: 2rem;
    }
    
    .actions {
        flex-direction: column;
    }
    
    .btn {
        margin: 5px 0;
        width: 100%;
    }
}
EOF

# Create script.js
echo "⚡ Creating public/script.js..."
cat > public/script.js << 'EOF'
// Client-side JavaScript for Azure App
class AzureApp {
    constructor() {
        this.activityLog = document.getElementById('activity-log');
        this.appInfo = document.getElementById('app-info');
        this.serverStatus = document.getElementById('server-status');
        
        this.init();
    }

    init() {
        this.log('Application initialized');
        this.loadAppInfo();
        this.loadServerStatus();
        this.bindEvents();
    }

    bindEvents() {
        document.getElementById('refresh-btn').addEventListener('click', () => {
            this.refreshData();
        });

        document.getElementById('test-api-btn').addEventListener('click', () => {
            this.testAPI();
        });
    }

    async loadAppInfo() {
        try {
            this.log('Loading app information...');
            const response = await fetch('/api/hello');
            const data = await response.json();
            
            this.displayAppInfo(data);
            this.log('App information loaded successfully');
        } catch (error) {
            this.log(`Error loading app info: ${error.message}`, 'error');
            this.appInfo.innerHTML = '<p class="error">Failed to load app information</p>';
        }
    }

    async loadServerStatus() {
        try {
            this.log('Loading server status...');
            const response = await fetch('/api/status');
            const data = await response.json();
            
            this.displayServerStatus(data);
            this.log('Server status loaded successfully');
        } catch (error) {
            this.log(`Error loading server status: ${error.message}`, 'error');
            this.serverStatus.innerHTML = '<p class="error">Failed to load server status</p>';
        }
    }

    displayAppInfo(data) {
        this.appInfo.innerHTML = `
            <div class="data-item">
                <span class="data-label">Message:</span>
                <span class="data-value">${data.message}</span>
            </div>
            <div class="data-item">
                <span class="data-label">Timestamp:</span>
                <span class="data-value">${new Date(data.timestamp).toLocaleString()}</span>
            </div>
            <div class="data-item">
                <span class="data-label">Environment:</span>
                <span class="data-value">${data.environment}</span>
            </div>
        `;
    }

    displayServerStatus(data) {
        const uptimeHours = Math.floor(data.uptime / 3600);
        const uptimeMinutes = Math.floor((data.uptime % 3600) / 60);
        const memoryMB = Math.round(data.memory.used / 1024 / 1024);
        
        this.serverStatus.innerHTML = `
            <div class="data-item">
                <span class="data-label">Status:</span>
                <span class="data-value">${data.status}</span>
            </div>
            <div class="data-item">
                <span class="data-label">Uptime:</span>
                <span class="data-value">${uptimeHours}h ${uptimeMinutes}m</span>
            </div>
            <div class="data-item">
                <span class="data-label">Memory Usage:</span>
                <span class="data-value">${memoryMB} MB</span>
            </div>
            <div class="data-item">
                <span class="data-label">Node Version:</span>
                <span class="data-value">${data.version}</span>
            </div>
        `;
    }

    refreshData() {
        this.log('Refreshing all data...');
        this.loadAppInfo();
        this.loadServerStatus();
    }

    async testAPI() {
        try {
            this.log('Testing API connection...');
            
            const startTime = Date.now();
            const response = await fetch('/api/hello');
            const endTime = Date.now();
            
            if (response.ok) {
                const data = await response.json();
                this.log(`API test successful (${endTime - startTime}ms)`);
                this.log(`Response: ${data.message}`);
            } else {
                this.log(`API test failed: ${response.status} ${response.statusText}`, 'error');
            }
        } catch (error) {
            this.log(`API test error: ${error.message}`, 'error');
        }
    }

    log(message, type = 'info') {
        const timestamp = new Date().toLocaleTimeString();
        const logEntry = document.createElement('div');
        logEntry.className = 'log-entry';
        
        logEntry.innerHTML = `
            <span class="log-timestamp">[${timestamp}]</span>
            <span class="log-message">${message}</span>
        `;
        
        if (type === 'error') {
            logEntry.style.color = '#e74c3c';
        }
        
        this.activityLog.appendChild(logEntry);
        this.activityLog.scrollTop = this.activityLog.scrollHeight;
    }
}

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new AzureApp();
});
EOF

# Create .gitignore
echo "🚫 Creating .gitignore..."
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# nyc test coverage
.nyc_output

# Grunt intermediate storage
.grunt

# Bower dependency directory
bower_components

# node-waf configuration
.lock-wscript

# Compiled binary addons
build/Release

# Dependency directories
jspm_packages/

# TypeScript cache
*.tsbuildinfo

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.test
.env.local
.env.production

# parcel-bundler cache
.cache
.parcel-cache

# Next.js build output
.next

# Nuxt.js build / generate output
.nuxt
dist

# Gatsby files
.cache/
public

# Storybook build outputs
.out
.storybook-out

# Temporary folders
tmp/
temp/

# Logs
logs
*.log

# Runtime data
pids
*.pid
*.seed

# Directory for instrumented libs generated by jscoverage/JSCover
lib-cov

# Coverage directory used by tools like istanbul
coverage

# Grunt intermediate storage
.grunt

# Compiled binary addons
build/Release

# Users Environment Variables
.lock-wscript

# IDE/Editor files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Azure specific
.azure/
EOF

# Create azure-pipelines.yml
echo "🔧 Creating azure-pipelines.yml..."
cat > azure-pipelines.yml << 'EOF'
# Azure DevOps Pipeline for Node.js App
# This pipeline builds and deploys the Node.js application to Azure App Service

trigger:
- main
- develop

pool:
  vmImage: 'ubuntu-latest'

variables:
  # Node.js version to use
  nodeVersion: '18.x'
  # Build configuration
  buildConfiguration: 'Release'

stages:
- stage: Build
  displayName: 'Build Stage'
  jobs:
  - job: BuildJob
    displayName: 'Build Job'
    steps:
    
    # Install Node.js
    - task: NodeTool@0
      inputs:
        versionSpec: $(nodeVersion)
      displayName: 'Install Node.js $(nodeVersion)'
    
    # Display Node and npm versions
    - script: |
        node --version
        npm --version
      displayName: 'Display Node.js and npm versions'
    
    # Install dependencies
    - script: |
        npm ci
      displayName: 'Install dependencies'
      
    # Run tests (if you have any)
    - script: |
        npm run test
      displayName: 'Run tests'
      continueOnError: true
    
    # Run build
    - script: |
        npm run build
      displayName: 'Build application'
    
    # Copy files to staging directory
    - task: CopyFiles@2
      inputs:
        sourceFolder: '$(System.DefaultWorkingDirectory)'
        contents: |
          **/*
          !node_modules/**/*
          !.git/**/*
          !.gitignore
          !azure-pipelines.yml
          !README.md
        targetFolder: '$(Build.ArtifactStagingDirectory)'
      displayName: 'Copy application files'
    
    # Create package.json in staging for production dependencies
    - task: CopyFiles@2
      inputs:
        sourceFolder: '$(System.DefaultWorkingDirectory)'
        contents: |
          package.json
          package-lock.json
        targetFolder: '$(Build.ArtifactStagingDirectory)'
        overWrite: true
      displayName: 'Copy package files'

    # Archive files
    - task: ArchiveFiles@2
      inputs:
        rootFolderOrFile: '$(Build.ArtifactStagingDirectory)'
        includeRootFolder: false
        archiveType: 'zip'
        archiveFile: '$(Build.ArtifactStagingDirectory)/$(Build.BuildId).zip'
        replaceExistingArchive: true
        verbose: true
      displayName: 'Archive application'

    # Publish build artifacts
    - task: PublishBuildArtifacts@1
      inputs:
        PathtoPublish: '$(Build.ArtifactStagingDirectory)/$(Build.BuildId).zip'
        ArtifactName: 'drop'
        publishLocation: 'Container'
      displayName: 'Publish build artifact'

# Optional: Add deployment stage (uncomment and configure as needed)
# - stage: Deploy
#   displayName: 'Deploy Stage'
#   dependsOn: Build
#   condition: succeeded()
#   jobs:
#   - deployment: DeployJob
#     displayName: 'Deploy to Azure App Service'
#     environment: 'production'
#     strategy:
#       runOnce:
#         deploy:
#           steps:
#           - task: AzureWebApp@1
#             inputs:
#               azureSubscription: 'your-service-connection-name'
#               appType: 'webAppLinux'
#               appName: 'your-app-service-name'
#               package: '$(Pipeline.Workspace)/drop/$(Build.BuildId).zip'
#               runtimeStack: 'NODE|18-lts'
#               startUpCommand: 'npm start'
EOF

# Create README.md
echo "📖 Creating README.md..."
cat > README.md << 'EOF'
# My Azure App

A simple Node.js web application demonstrating deployment to Azure App Service using Azure DevOps CI/CD pipeline.

## Features

- Express.js web server
- Static file serving
- REST API endpoints
- Health check endpoint for Azure
- Responsive frontend with real-time server status
- Activity logging
- Environment-aware configuration

## Prerequisites

- Node.js 18.x or higher
- npm (comes with Node.js)
- Azure subscription
- Azure DevOps account

## Local Development

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd my-azure-app
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start the development server**
   ```bash
   npm run dev
   ```

4. **Open your browser**
   Navigate to `http://localhost:3000`

## API Endpoints

- `GET /` - Serves the main HTML page
- `GET /api/hello` - Returns a greeting message with timestamp
- `GET /api/status` - Returns server health and performance metrics
- `GET /health` - Health check endpoint (returns 200 OK)

## Project Structure

```
my-azure-app/
├── public/                 # Static files (HTML, CSS, JS)
│   ├── index.html         # Main HTML page
│   ├── style.css          # Stylesheet
│   └── script.js          # Client-side JavaScript
├── src/                   # Server-side source code
│   └── app.js            # Main Express application
├── package.json          # Project configuration
├── README.md             # This file
├── .gitignore           # Git ignore rules
└── azure-pipelines.yml  # Azure DevOps pipeline configuration
```

## Deployment to Azure

### Manual Deployment

1. **Create Azure App Service**
   - Login to Azure Portal
   - Create a new App Service
   - Choose Node.js runtime
   - Note the app name and resource group

2. **Deploy using Azure CLI** (optional)
   ```bash
   az webapp up --name <your-app-name> --resource-group <your-resource-group>
   ```

### Automated Deployment with Azure DevOps

1. **Set up Azure DevOps project**
   - Create a new project in Azure DevOps
   - Connect your Git repository

2. **Create Build Pipeline**
   - Use the included `azure-pipelines.yml` file
   - The pipeline will:
     - Install Node.js dependencies
     - Run build scripts
     - Create deployment artifacts

3. **Create Release Pipeline**
   - Add Azure App Service deployment task
   - Configure service connection to Azure
   - Set up continuous deployment triggers

4. **Configure Environment Variables** (optional)
   Set these in Azure App Service Configuration:
   - `NODE_ENV=production`
   - Any custom environment variables your app needs

## Environment Variables

The application supports these environment variables:

- `PORT` - Port number (default: 3000, Azure sets this automatically)
- `NODE_ENV` - Environment (development/production)

## Monitoring and Troubleshooting

### Health Check
The app includes a health endpoint at `/health` that Azure can use for health monitoring.

### Application Insights
Consider enabling Application Insights in Azure for detailed monitoring:
1. Go to your App Service in Azure Portal
2. Navigate to Application Insights
3. Enable and configure monitoring

### Logs
View application logs in Azure Portal:
1. Go to your App Service
2. Navigate to Log stream or Diagnose and solve problems

## Development Commands

```bash
npm start      # Start production server
npm run dev    # Start development server
npm run build  # Run build process (currently just echoes)
npm test       # Run tests (not implemented)
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally
5. Create a pull request

## License

MIT License - see LICENSE file for details

## Support

For issues with:
- **Application code**: Open an issue in this repository
- **Azure services**: Check Azure documentation or contact Azure support
- **Azure DevOps**: Check Azure DevOps documentation

## Next Steps

Consider adding:
- Unit tests with Jest
- Integration with Azure Key Vault for secrets
- Database connectivity (Azure SQL, CosmosDB)
- Authentication (Azure AD)
- Custom domains and SSL certificates
- Application Insights for monitoring
- Docker containerization
- Infrastructure as Code (ARM templates or Terraform)
EOF

# Make the script executable (not needed since we're running it, but good practice)
chmod +x setup-project.sh 2>/dev/null || true

echo ""
echo "🎉 Project setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Install dependencies: npm install"
echo "2. Test locally: npm start"
echo "3. Initialize git: git init && git add . && git commit -m 'Initial commit'"
echo "4. Push to your repository and set up Azure DevOps pipeline"
echo ""
echo "🌐 Your app will be available at http://localhost:3000"
echo ""

# List the created structure
echo "📁 Created project structure:"
find . -type f -name "*.js" -o -name "*.json" -o -name "*.html" -o -name "*.css" -o -name "*.yml" -o -name "*.md" -o -name ".gitignore" | head -20
