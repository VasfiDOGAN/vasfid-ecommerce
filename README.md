# vasfid-ecommerce

vasfid-ecommerce is a scalable e-commerce application built using Docker, Nginx, Python (backend), and MySQL.

## Features
- Nginx is used as a web server and load balancer.
- Python backend service (Flask) for handling API requests.
- MySQL database for data storage.
- Docker Compose for easy setup and management of services.

### Accessing the Application
To access the application, navigate to `localhost` in your web browser. 
The Nginx server will automatically route the requests to one of the backend services based on the load balancing configuration.

#### Database Access
For database access, you can use the following credentials:
- **URL:** `localhost:8080`
- **Username:** `root`
- **Password:** `123123123`

##### Clone the repository
git clone https://github.com/VasfiDOGAN/vasfid-ecommerce.git
