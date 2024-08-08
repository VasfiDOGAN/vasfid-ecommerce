CREATE DATABASE IF NOT EXISTS vd_ecommerce;
USE vd_ecommerce;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO users (username, password, email) VALUES
('ali_kaya', 'password1', 'ali@example.com'),
('ayse_demir', 'password2', 'ayse@example.com'),
('mehmet_yilmaz', 'password3', 'mehmet@example.com'),
('fatma_turan', 'password4', 'fatma@example.com');

INSERT INTO categories (name) VALUES
('Elektronik'),
('Moda'),
('Ev ve Yaşam'),
('Kitap'),
('Oyuncak');

INSERT INTO products (category_id, name, description, price, stock) VALUES
(1, 'Akıllı Telefon', 'Yüksek kaliteli akıllı telefon', 4999.99, 50),
(1, 'Dizüstü Bilgisayar', 'Güçlü ve hafif dizüstü bilgisayar', 7499.99, 30),
(1, 'Kulaklık', 'Kablosuz bluetooth kulaklık', 299.99, 100),
(1, 'Akıllı Saat', 'Kalp atış hızı sensörlü akıllı saat', 1299.99, 20),
(1, 'Tablet', 'Yüksek çözünürlüklü ekranlı tablet', 1999.99, 40),
(2, 'Kot Pantolon', 'Rahat kesim kot pantolon', 149.99, 70),
(2, 'Tişört', 'Pamuklu tişört', 49.99, 200),
(2, 'Elbise', 'Yazlık elbise', 199.99, 60),
(2, 'Ceket', 'Şık ve rahat ceket', 299.99, 50),
(2, 'Ayakkabı', 'Spor ayakkabı', 199.99, 80),
(3, 'Sürahi', 'Cam sürahi', 29.99, 150),
(3, 'Tabak Takımı', '6 kişilik tabak takımı', 199.99, 100),
(3, 'Çatal Kaşık Seti', '24 parça çatal kaşık seti', 99.99, 120),
(3, 'Tencere Seti', '4 parça tencere seti', 499.99, 30),
(3, 'Yastık', 'Ortopedik yastık', 79.99, 200),
(4, 'Roman', 'En çok satan roman', 24.99, 300),
(4, 'Bilim Kurgu', 'Bilim kurgu kitabı', 29.99, 250),
(4, 'Çocuk Kitabı', 'Çocuklar için eğitici kitap', 19.99, 100),
(4, 'Ders Kitabı', 'Üniversite ders kitabı', 99.99, 50),
(4, 'Klasik Edebiyat', 'Dünya klasiklerinden bir eser', 39.99, 150),
(5, 'Yapboz', '1000 parça yapboz', 49.99, 100),
(5, 'Lego Seti', '500 parça lego seti', 199.99, 70),
(5, 'Oyuncak Araba', 'Metal oyuncak araba', 29.99, 150),
(5, 'Bebek', 'Konuşan bebek', 79.99, 90),
(5, 'Masa Oyunu', 'Aile için masa oyunu', 59.99, 110);

INSERT INTO orders (user_id, total_price) VALUES
(1, 5499.97),
(2, 899.97);

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 4999.99),
(1, 3, 3, 299.99),
(2, 6, 3, 149.99),
(2, 8, 2, 199.99);

INSERT INTO products (category_id, name, description, price, stock) VALUES
(1, 'Televizyon', '4K Ultra HD Televizyon', 2999.99, 25),
(1, 'Hoparlör', 'Bluetooth hoparlör', 149.99, 60),
(2, 'Etek', 'Diz boyu etek', 79.99, 90),
(2, 'Gömlek', 'Pamuklu gömlek', 89.99, 120),
(3, 'Halı', 'Yün halı', 499.99, 40),
(3, 'Perde', 'Keten perde', 199.99, 70),
(4, 'Ansiklopedi', 'Genel kültür ansiklopedisi', 199.99, 30),
(4, 'Resim Kitabı', 'Sanat tarihi kitabı', 99.99, 80),
(5, 'Bisiklet', 'Çocuk bisikleti', 299.99, 40),
(5, 'Drone', 'Kameralı drone', 799.99, 20);

ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123123123';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;