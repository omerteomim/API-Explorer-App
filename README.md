# 🌐 API Explorer App

A containerized Flask and PostgreSQL web application, deployed seamlessly to AWS using Terraform with infrastructure components including EC2, ECR, and an Application Load Balancer for scalable and efficient delivery. This is a web application that serves as a unified interface for exploring and interacting with multiple external APIs. This dockerized application provides a clean, intuitive dashboard for developers and users to discover, test, and integrate various API services.

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

### This deployment architecture is designed for a scalable and resilient web application using AWS services:

- **Amazon ECR (Elastic Container Registry)**
Stores Docker images of your containerized Flask application. Acts as a centralized and secure repository from which EC2 instances can pull the latest application version.

- **EC2 Instances (Elastic Compute Cloud)**
Two EC2 instances are provisioned using Terraform.
Each EC2 pulls the application image from ECR and runs the app inside a Docker container.
The app is typically orchestrated via Docker Compose, which also spins up a PostgreSQL container alongside the Flask app. These instances act as the backend servers serving application traffic.

- **Application Load Balancer (ALB)**
Distributes incoming HTTP traffic evenly across the two EC2 instances. Provides health checks to route traffic only to healthy instances. Improves fault tolerance and availability, allowing seamless failover.




## 📁 Project Structure

```
API-Explorer-App/
├───.github
│   └───workflows
│           CI.yml
│   .gitignore
│   docker-compose.yaml
│   README.md
├───flask-app
│   │   .dockerignore
│   │   app.py
│   │   Dockerfile
│   │   models.py
│   │   requirements.txt
│   ├───static
│   │  └────styles.css
│   └───templates
│       |   dadjokes.html
│       |   dogs.html
│       |   evilinsult.html
│       |   index.html
│       |   personnotexist.html
│       |   pokemon.html
│       └───shoppinglist.html
└───infrastructure
    ├───environments
    │   ├───dev
    │   │   │   main.tf
    │   │   └───variables.tf
    │   └───prod
    │       │   main.tf
    │       └───variables.tf
    └───modules
        ├───ALB
        |   │   main.tf
        |    └───variables.tf
        ├───EC2
        |   │   data.tf
        |   │   main.tf
        |   │   outputs.tf
        |   └───variables.tf
        └───ECR
            │   main.tf
            └───variables.tf
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


⭐ **Star this repository if you find it helpful!**