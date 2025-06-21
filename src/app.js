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
