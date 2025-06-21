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
