# Redis & RabbitMQ Use Case Scenarios

## Redis

### 1) Pub-Sub for Real-Time Notifications – Building a Chat Application
Redis'in Pub/Sub (Publish/Subscribe) mekanizması, gerçek zamanlı bildirimler ve anlık iletişim gerektiren uygulamalar için güçlü bir çözüm sunar. Özellikle sohbet uygulamaları gibi anlık mesajlaşma gereksinimi olan sistemlerde, Redis Pub/Sub kullanılarak kullanıcılar arasında hızlı ve etkili bir iletişim altyapısı kurulabilir.

**Pub/Sub Modeli:**  
Redis Pub/Sub, yayıncılar (publishers) ve aboneler (subscribers) arasında mesajların asenkron olarak iletilmesini sağlayan bir mesajlaşma modelidir. Bu modelde, bir kanal (channel) üzerinden mesaj yayınlanır ve bu kanala abone olan tüm alıcılar bu mesajları alır.

**Kanal Üzerinden Mesaj Yayınlama (Publish):**  
`PUBLISH chat_channel "user1: Hello, how are you?"` ——> komutu `chat_channel` adlı kanala bir mesaj yayınlar. Mesaj, `user1` tarafından gönderilen "Hello, how are you?" mesajıdır. Bu mesaj, `chat_channel` kanalına abone olan tüm kullanıcılar tarafından alınır.

**Kanal Aboneliği (Subscribe):**  
`SUBSCRIBE chat_channel` ——> komutu ise `chat_channel` adlı kanala abone olur. Bu komutu çalıştıran kullanıcı, bu kanala yayınlanan tüm mesajları anında alacaktır.

**Gerçek Zamanlı Bildirimler:**  
Redis Pub/Sub modeli, gerçek zamanlı bildirimler ve mesaj iletimi için ideal bir yapı sunar. Aboneler bir kanala abone olduktan sonra, bu kanal üzerinden gönderilen tüm mesajları anında alır ve bu mesajlar üzerinde işlem yapabilir.

**Yüksek Performans ve Düşük Gecikme:**  
Redis, hafıza tabanlı bir veri yapısı olduğu için mesajlar çok hızlı bir şekilde iletilir. Bu da anlık iletişim gerektiren uygulamalar için kritik bir avantaj sağlar. Mesajlar, yayıncıdan alıcıya neredeyse gecikmesiz bir şekilde iletilir.

**Pub/Sub ile Mesaj Yönetimi ve Filtreleme:**  
Pub/Sub modeli, mesajları filtreleme ve yönetme yeteneğine de sahiptir. Örneğin, belirli bir kanal üzerinden sadece belirli türde mesajlar gönderilebilir ve bu mesajlar alıcılar tarafından işlenebilir.

**Güvenlik ve Erişim Kontrolü:**  
Redis, Pub/Sub mekanizması için güvenlik önlemleri ve erişim kontrolleri sunar. ACL (Access Control Lists) ile belirli kullanıcıların belirli kanallara erişimi kontrol edilebilir.

Redis Pub/Sub, gerçek zamanlı iletişim gerektiren sohbet uygulamaları için güçlü bir altyapı sağlar. Anlık mesajlaşmanın güvenilir, hızlı ve etkin bir şekilde gerçekleşmesini mümkün kılar. Pub/Sub modeli, mesajların asenkron olarak iletilmesini sağlayarak kullanıcılar arasında kesintisiz bir iletişim ortamı oluşturur. Redis'in yüksek performansı ve esnekliği, büyük ölçekli uygulamalarda bile gerçek zamanlı bildirimler ve anlık iletişim için ideal bir çözüm sunar.

### 2) Message Queues – Job Queue for Background Processing
Redis'in List veri yapısı, FIFO (First-In, First-Out) prensibiyle çalışır ve bu yapı, iş kuyrukları için idealdir. İşler (jobs) sırayla kuyruklanır ve kuyruktan çekilerek işlenir.

**LPUSH job_queue "send_email:1001"** ——> komutu ile `job_queue` kuyruğunun başına bir iş ekler. `send_email:1001` iş tanımı, bir e-posta gönderme işlemini temsil eder ve kuyrukta işlenmeyi bekler.

**RPOP job_queue** ——> komutu ile kuyruktaki son işi (en eski iş) çekip getirir ve bu işin işlenmeye başlanmasını sağlar. Kuyruktan çekilen bu iş, artık kuyrukta bulunmaz ve bu iş işlendikten sonra bir sonraki iş işlenmeye hazırdır.

**Blocking Operations (Bloklama İşlemleri):**  
Arka plan işleyicileri (background workers), genellikle kuyruktaki bir işin gelmesini beklerken bloklanır. Redis, `BRPOP` gibi bloklama işlemleri sunarak, bir iş geldiğinde hemen işlenmeye başlanmasını sağlar.

**BRPOP job_queue 0** ——> Bu komut, `job_queue` adlı kuyruktan bir iş çekmeye çalışır. Eğer kuyruk boşsa, iş kuyruğunda yeni bir iş olana kadar işlem bloke olur. `0` parametresi, iş gelene kadar süresiz beklemeyi belirtir.

**Redis ile Öncelikli İşler Yönetimi:**  
Redis ile birden fazla iş kuyruğu oluşturulabilir ve işlerin önem derecesine göre bu kuyruklara eklenmesi sağlanabilir. Çalışan işleyiciler (workers), öncelikli kuyruktaki işleri önce işlemeyi tercih eder.

**LPUSH high_priority_queue "process_payment:1002"** ——> Bu komut, yüksek öncelikli bir işlemi `high_priority_queue` adlı kuyruktan önce işleyecek şekilde ekler. Örneğin, ödeme işlemleri yüksek öncelik taşıyabilir.

**BRPOP high_priority_queue normal_queue 0** ——> komutu ile önce `high_priority_queue` kuyruğunu, ardından `normal_queue` kuyruğunu dinleyerek bir iş bekler. Öncelikli kuyruğun boş olması durumunda normal kuyruktaki işlerle devam edilir.

**Redis ile İş Durumu Yönetimi:**  
İşlerin durumu (başladı, bitti, hata aldı vb.) Redis'te saklanabilir. Ayrıca, işler kalıcı hale getirilebilir, böylece sistem yeniden başlatıldığında işler kaybolmaz.

**HSET job_status:1001 status "processing"** ——> komutu, `job_status:1001` anahtarında, bir işin durumunu `processing` olarak günceller. İşin durumu, gerektiğinde takip edilebilir ve güncellenebilir.

**Kuyruktaki İşleri Diskte Saklamak:**  
Redis'in AOF (Append-Only File) veya RDB snapshot mekanizmaları kullanılarak, kuyruktaki işler kalıcı olarak saklanabilir. AOF, tüm işlemleri diske yazarak veri kaybını en aza indirir.

**CONFIG SET appendonly yes**  
**BGSAVE**

Bu komutlar, Redis'in AOF modunda çalışmasını sağlar ve kuyruktaki tüm işlemler diske yazılır. Ayrıca, `BGSAVE` komutu mevcut veritabanının bir yedeğini alır.

### 3) Session Store (Kullanıcı Oturumlarını Yönetme)
Redis, kullanıcı oturum bilgilerini saklamak için genellikle Hash veri yapısını kullanır. Her bir kullanıcı oturumu, farklı bir `session_id` ile tanımlanır ve bu `session_id`, Redis'te bir key olarak kullanılır.

**HSET session:abc123 user_id 1001 is_logged_in true last_active 1626789876** ——> komutu, `session:abc123` oturum kimliği ile saklanan tüm verileri getirir.

**Oturum Süresi Yönetimi:**  
Oturum süresini yönetmek güvenlik ve performans açısından kritik bir rol oynar. Redis, oturum verisine bir TTL (Time to Live) değeri ekleyerek, oturumun belirli bir süre sonunda otomatik olarak sonlandırılmasını sağlar.

**SETEX session:abc123 3600 "user_session_data"** ——> Komut, oturum verisini 1 saatlik TTL ile saklar. Bu süre sonunda oturum verisi otomatik olarak silinir.

**Dağıtık Yapıda Oturum Yönetimi:**  
Redis oturumları yönetirken dağıtık yapıyı kullanır. Birden fazla uygulama sunucusu, Redis'i ortak bir oturum deposu olarak kullanabilir. Bu, oturum durumlarının tüm sunucular arasında tutarlı kalmasını sağlar.

Örnek Senaryo: A kullanıcısı, Sunucu1'de oturum açar ve `session_id` Redis'te saklanır. A Kullanıcısı, daha sonra Sunucu2'den bir istekte bulunur. Sunucu 2, Redis'ten `session_id` ile ilişkili oturum verilerini alır ve kullanıcının oturumunu doğrular.

**Yüksek Erişilebilirlik ve Kalıcılık (Persistence):**  
Redis, oturum verilerini disk üzerinde saklayarak veri kaybını önler. Bu özellik, özellikle oturum verilerinin kalıcı olmasının kritik olduğu durumlarda önemlidir. Redis'in iki temel kalıcılık mekanizması vardır: RDB (Redis Database Backup) ve AOF (Append-Only File).

Sonuç olarak, Redis'in oturum yönetimindeki rolü, yüksek performansı, düşük gecikme süresi ve esnek veri yapıları sayesinde oldukça etkili ve güvenilirdir. Kullanıcı oturumlarının verimli bir şekilde yönetilmesi, web uygulamalarında kullanıcı deneyiminin sorunsuz olmasını sağlar. Redis'in sunduğu kalıcılık, güvenlik ve ölçeklenebilirlik özellikleri, dağıtık sistemlerde oturum yönetimi için ideal bir çözüm oluşturur.

## RabbitMQ

### 1) Mobile Applications – RabbitMQ for Message Delivery to Mobile Devices
RabbitMQ, mesajlaşma sistemlerinde yüksek performans, esneklik ve güvenilirlik sunar. Mobil uygulamalar için, her bir uygulama örneği (instance) için ayrı bir kuyruk oluşturulabilir ve mesajlar bu kuyruklar üzerinden iletilebilir. Özellikle cihazların çevrimdışı olma durumunda bile mesajların güvenle iletilmesi ve bekletilmesi sağlanabilir.

**RabbitMQ Mimarisi: Exchange, Queue ve Binding:**  
RabbitMQ mesajların yönlendirilmesi ve işlenmesi için Exchange (değişim), Queue (kuyruk) ve Binding (bağlantı) yapılarını kullanır. Mobil uygulamalar için her bir uygulama örneği (instance) için ayrı bir kuyruk oluşturulur ve mesajlar bu kuyruklara yönlendirilir.

**Fanout Exchange:**  
Fanout exchange, gelen mesajları tüm bağlı kuyruklara dağıtır. Bu exchange türü, bir mesajı birden fazla mobil cihaza (veya uygulama örneğine) aynı anda göndermek için idealdir.

**Direct Exchange:**  
Direct exchange, mesajları belirli bir routing key (yönlendirme anahtarı) ile eşleşen kuyruklara gönderir. Bu, belirli bir cihaza mesaj göndermek için kullanılabilir.

**Queue Oluşturma:**  
Her mobil uygulama örneği için ayrı bir kuyruk oluşturulur. Bu kuyruklar, uygulama örnekleri çevrimdışı olduğunda bile mesajları saklar.

**Binding (Bağlantı):**  
Kuyruklar, exchange ile bağlanarak mesajların doğru kuyruklara yönlendirilmesi sağlanır. Fanout exchange kullanıldığında, mesajlar exchange'e bağlı tüm kuyruklara yönlendirilir.

**Mesajların Gönderimi ve Dağıtımı:**  
RabbitMQ, mesajları exchange aracılığıyla bağlı kuyruklara yönlendirir. Fanout exchange kullanıldığında, bir mesaj tüm bağlı kuyruklara iletilir. Bu, her mobil cihazın bir mesajı aldığından emin olmayı sağlar.

**Çevrimdışı Cihazlar için Mesaj Saklama:**  
Mobil cihazların çevrimdışı olabileceği durumlarda, RabbitMQ kuyrukları bu mesajları saklar ve cihaz çevrimiçi olduğunda mesajlar teslim edilir. RabbitMQ'nun kalıcılık (durability) özelliği, mesajların kuyrukta saklanmasını sağlar.

**Kalıcı Kuyruk ve Mesajlar:**  
Kuyrukların ve mesajların kalıcı olmasını sağlamak için, kuyruk ve mesajların kalıcı (durable) olarak tanımlanması gereklidir.

**Kuyruktan Mesaj Alma (Consume):**  
Mobil cihazlar çevrimiçi olduğunda, ilgili kuyruktan mesajları alır ve işler. Bu süreçte, cihazlar kuyruklara bağlı kalır ve mesajları tükettikçe kuyruk boşalır.

**Ölçeklenebilirlik ve Performans:**  
RabbitMQ, büyük ölçekli sistemlerde verimli çalışmak üzere tasarlanmıştır. Birden fazla kuyruk ve exchange kullanarak mesajların dağıtımını optimize edebilirsiniz. Ayrıca, RabbitMQ'nun clustering ve high availability (yüksek erişilebilirlik) özellikleri, sistemin güvenilirliğini ve ölçeklenebilirliğini artırır.

**Clustering:**  
RabbitMQ, birden fazla düğüm (node) ile çalışabilir ve bu sayede yük dengelemesi yapılabilir.

### 2) Microservices – Using RabbitMQ as a Central Broker
Microservices mimarisinde, çok sayıda hizmet (service) arasında iletişimi koordine etmek karmaşık olabilir. RabbitMQ, merkezi bir mesajlaşma aracısı olarak hizmet vererek, mikro hizmetler arasındaki iletişimi kolaylaştırır. Her mikro hizmet, ihtiyaç duyduğu mesaj türlerine abone olabilir ve bu mesajları işleyebilir.

**RabbitMQ ve Mikro Hizmetler Arası İletişim:**  
RabbitMQ, mikro hizmetler arasında mesaj yönlendirmeyi sağlayan bir merkezi aracı (broker) olarak kullanılır. Her mikro hizmet, belirli mesaj türlerine abone olarak yalnızca ihtiyaç duyduğu mesajları alır. Bu yapı, mikro hizmetler arasındaki bağımlılıkları azaltır ve iletişimi esnek hale getirir.

**Kuyruk ve Binding (Bağlantı):**  
Her mikro hizmet, belirli bir konuya (topic) veya mesaj türüne abone olmak için kendi kuyruğunu oluşturur ve bu kuyruğu exchange ile bağlar.

**Mesaj Gönderimi (Publish) ve Abonelik (Subscribe):**  
Mikro hizmetler, belirli bir konuya mesaj gönderebilir veya bu konudaki mesajları alabilir. RabbitMQ, mesajları ilgili kuyruklara yönlendirir ve abone olan mikro hizmetler bu mesajları işleyebilir.

**Ölçeklenebilirlik ve Bağımsız Gelişim:**  
RabbitMQ'nun kullanımı, mikro hizmetlerin birbirlerinden bağımsız olarak gelişmesini sağlar. Yeni bir hizmet oluşturulduğunda, yalnızca ilgili mesajlara abone olarak mevcut sisteme entegre olabilir.

RabbitMQ, mikro hizmetler arasındaki iletişimi basitleştirir ve merkezi bir mesajlaşma sistemi olarak hizmet eder. Hizmetler, ihtiyaç duydukları mesaj türlerine abone olarak bağımsız çalışabilir ve yeni hizmetler kolayca sisteme entegre edilebilir. Bu yapı, mikro hizmetlerin ölçeklenebilirliğini artırır ve esnek bir iletişim altyapısı sağlar.

### 3) Critical APIs – Using RabbitMQ for Handling Long-Running Downstream Services
Bir kritik API'nin hızlı yanıt vermesi gerektiği, ancak arka planda çalışan servislerin yanıt süresinin uzun olabileceği durumlarda, RabbitMQ gibi bir mesaj aracısı (message broker) bu sorunu çözmek için kullanılabilir. Bu senaryoda, API çağrısını aldıktan sonra mesajı RabbitMQ'ya gönderir ve hemen bir yanıt döneriz. Arka plandaki servis ise bu mesajı alarak işleme başlar ve gerek duyduğu süre boyunca çalışabilir. Bu yaklaşım, API'nin hızlı yanıt verme gereksinimini karşılar ve arka plan işlemlerinin tamamlanmasını sağlar.

**API Çağrısı ve Mesaj Yönlendirme:**  
Bir API'ye yapılan çağrılar hızlı yanıt gerektiriyorsa, bu çağrılar RabbitMQ aracılığıyla işleme alınabilir. API, çağrıyı aldıktan sonra işlenmesi gereken bilgiyi RabbitMQ'ya bir mesaj olarak gönderir ve hemen bir başarı yanıtı döner.

**Arka Planda Çalışan Servisin Mesajı Alması:**  
Arka plandaki servis, RabbitMQ'ya gönderilen mesajı alarak bu veriyi işlemeye başlar. Bu işlem, API yanıtı döndükten sonra zaman alabilir ve bu nedenle ana işlemden ayrıdır.

**Asenkron İşleme ve Hızlı Yanıt:**  
Bu yapı, API'nin hızlı yanıt verme gereksinimini karşılarken, uzun sürecek işlemleri arka plana alır. Böylece kullanıcılar hızlı bir şekilde yanıt alır, ancak işlemler gerektiği kadar uzun sürede tamamlanır. RabbitMQ, bu yapıda asenkron işlemeyi sağlar. API çağrısı hemen yanıt dönerken, arka plan işlemi gerektiği kadar uzun sürede tamamlanabilir. Bu yapı, kritik API'lerin performansını artırır.

RabbitMQ, kritik API'lerin hızlı yanıt vermesini sağlamak için kullanılır. API çağrısı, bir mesaj olarak RabbitMQ'ya gönderilir ve hızlı bir yanıt döner. Bu sayede arka plandaki servisler, zaman alıcı işlemleri API'yi yavaşlatmadan gerçekleştirebilir. Bu yaklaşım, API performansını optimize ederken, arka plan işlemlerinin sorunsuz bir şekilde tamamlanmasını sağlar.

---

# vasfid-ecommerce

vasfid-ecommerce is a scalable e-commerce application built using Docker, Nginx, Python (backend), and MySQL.

## Features

- Nginx is used as a web server and load balancer.
- Python backend service (Flask) for handling API requests.
- MySQL database for data storage.
- Docker Compose for easy setup and management of services.

## Accessing the Application

To access the application, navigate to `localhost` in your web browser. The Nginx server will automatically route the requests to one of the backend services based on the load balancing configuration.

## Database Access

For database access, you can use the following credentials:

- **URL:** `localhost:8080`
- **Username:** `root`
- **Password:** `123123123`

## Clone the Repository

```bash
git clone https://github.com/VasfiDOGAN/vasfid-ecommerce.git
