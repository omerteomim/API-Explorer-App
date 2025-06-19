# 🌐 API Explorer App

A powerful Flask-based web application that serves as a unified interface for exploring and interacting with multiple external APIs. This dockerized application provides a clean, intuitive dashboard for developers and users to discover, test, and integrate various API services.

## ✨ Features

- **🔍 Multi-API Integration**: Connect and explore multiple external APIs from a single interface
- **🐳 Dockerized Deployment**: Easy setup and deployment using Docker containers
- **📊 Interactive Dashboard**: User-friendly web interface for API exploration
- **🔧 API Testing Tools**: Built-in tools for testing API endpoints and requests
- **📈 Response Visualization**: Clean display of API responses and data formatting
- **🔐 Authentication Support**: Handle various API authentication methods
- **📝 Request History**: Track and review previous API calls
- **⚡ Real-time Results**: Instant API response display and error handling

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Web Browser   │◄──►│   Flask App      │◄──►│  External APIs  │
│   (Frontend)    │    │   (Backend)      │    │   (Various)     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │
                              ▼
                       ┌──────────────────┐
                       │   Docker         │
                       │   Container      │
                       └──────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- [Docker](https://www.docker.com/get-started) installed on your system

### Using Docker (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/omerteomim/API-Explorer-App.git
   cd API-Explorer-App
   ```

2. **Build and run with Docker**
   ```bash
   # Build the Docker image
   docker build -t api-explorer-app .
   
   # Run the container
   docker run -p 5000:5000 api-explorer-app
   ```

3. **Access the application**
   Open your browser and navigate to: [http://localhost:5000](http://localhost:5000)

### Local Development Setup

1. **Clone and setup environment**
   ```bash
   git clone https://github.com/omerteomim/API-Explorer-App.git
   cd API-Explorer-App
   
   # Create virtual environment
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   
   # Install dependencies
   pip install -r requirements.txt
   ```

2. **Environment Configuration**
   ```bash
   # Copy environment template
   cp .env.example .env
   
   # Edit .env file with your API keys and configuration
   nano .env
   ```

3. **Run the application**
   ```bash
   python app.py
   ```

## 📁 Project Structure

```
API-Explorer-App/
├── app.py                  # Main Flask application
├── Dockerfile              # Docker configuration
├── requirements.txt        # Python dependencies
├── .dockerignore           # Docker ignore rules
├── templates/              # Every HTML files for the app
│   ├── dadjokes.html
│   ├── dogs.html              
│   ├── memes.html  
│   ├── evilinsult.html  
│   ├── dadjokes.html  
│   ├── personnotexist.html  
│   ├── index.html  
│   └── pokemon.html 
├── static/
│   ├── styles.css
```
## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 👨‍💻 Author

**Omer Teomim**
- GitHub: [@omerteomim](https://github.com/omerteomim)
- Repository: [API-Explorer-App](https://github.com/omerteomim/API-Explorer-App)

## 🙏 Acknowledgments

- Flask framework and community
- Docker for containerization
- All external API providers
- Open source contributors

## 📚 Additional Resources

- [Flask Documentation](https://flask.palletsprojects.com/)
- [Docker Documentation](https://docs.docker.com/)
- [API Design Best Practices](https://restfulapi.net/)
- [Python Best Practices](https://docs.python-guide.org/)

---

⭐ **Star this repository if you find it helpful!**