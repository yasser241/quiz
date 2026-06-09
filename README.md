# فروشگاه آنلاین - E-Commerce Platform

یک پلتفرم فروشگاهی جامع و ایمن با PHP خام، HTML5، CSS3، JavaScript و MySQL

## ویژگی‌های اصلی

### 🛍️ بخش مشتری
- صفحه اصلی با اسلایدر و استوری‌ها
- کاتالوگ محصولات با فیلترهای پیشرفته
- صفحات محصول تکی با گالری و نظرات
- سبد خرید و فرایند تکمیل سفارش
- پنل کاربری جامع
- سیستم علاقه‌مندی و مقایسه
- بخش وبلاگ
- سیستم تیکت‌های پشتیبانی

### 👨‍💼 پنل مدیریت
- مدیریت محصولات (ساده و متغیر)
- مدیریت سفارشات و وضعیت‌ها
- مدیریت کاربران و نقش‌ها
- مدیریت کوپن‌ها و تخفیف‌ها
- مدیریت روش‌های ارسال
- تحلیل و گزارش‌های فروش
- مدیریت درگاه‌های پرداخت
- مدیریت محتوا (صفحات و وبلاگ)

### 🔒 امنیت
- CSRF Protection
- SQL Injection Prevention (PDO Prepared Statements)
- Password Hashing (bcrypt)
- Input Validation & Sanitization
- HTTPS Support
- HSTS Headers
- Rate Limiting
- Session Security
- Content Security Policy

### 📱 طراحی
- فارسی‌ساز کامل (RTL)
- Responsive (Mobile-First)
- طراحی مدرن با انیمیشن‌ها
- رابط کاربری شهودی

## نیازمندی‌ها

- PHP >= 7.4
- MySQL >= 5.7 یا MariaDB >= 10.3
- Apache با mod_rewrite فعال
- cURL enabled
- GD Library (برای پردازش تصاویر)

## نصب و راه‌اندازی

### 1. کلون کردن پروژه
```bash
git clone https://github.com/yasser241/quiz.git
cd quiz
```

### 2. کپی کردن فایل محیط
```bash
cp .env.example .env
```

### 3. تنظیم اطلاعات پایگاه داده در .env
```bash
DB_HOST=localhost
DB_NAME=quiz_shop
DB_USER=root
DB_PASSWORD=your_password
```

### 4. ایجاد پایگاه داده
```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seeds.sql
```

### 5. تنظیمات Apache
اطمینان حاصل کنید که `mod_rewrite` فعال است:
```bash
a2enmod rewrite
service apache2 restart
```

### 6. دسترسی‌های پوشه‌ها
```bash
chmod -R 755 public/
chmod -R 777 uploads/
chmod -R 777 cache/
chmod -R 777 session/
```

## ساختار پروژه

```
quiz/
├── config/              # تنظیمات پایه
├── src/                 # کد اصلی
│   ├── Core/           # کلاس‌های اساسی
│   ├── Controllers/    # کنترلرها
│   ├── Models/         # مدل‌های داده
│   ├── Views/          # صفحات HTML
│   ├── Middlewares/    # میانی‌افزارها
│   └── Utils/          # ابزار و کمک‌ها
├── public/             # فایل‌های عمومی
│   ├── index.php       # نقطه ورود
│   ├── css/           # فایل‌های CSS
│   ├── js/            # فایل‌های JavaScript
│   └── img/           # تصاویر
├── uploads/            # فایل‌های آپلودی
├── database/           # فایل‌های پایگاه داده
├── tests/              # تست‌ها
└── docs/               # مستندات
```

## شروع سریع

### دسترسی به پنل مدیریت
```
URL: http://localhost/admin
Username: admin@example.com
Password: admin123
```

### دسترسی به سایت
```
URL: http://localhost
```

## مستندات

برای اطلاعات بیشتر به پوشه `docs/` مراجعه کنید:
- [مستندات API](docs/API.md)
- [راهنمای توسعه دهنده](docs/DEVELOPER.md)
- [راهنمای امنیت](docs/SECURITY.md)

## مشارکت

ما استقبال از مشارکت‌ها می‌کنیم! لطفاً یک Pull Request بفرستید.

## مجوز

MIT License - برای جزئیات به [LICENSE](LICENSE) مراجعه کنید.

## تماس

برای سؤالات و پیشنهادات:
- ایمیل: admin@example.com
- Issues: [GitHub Issues](https://github.com/yasser241/quiz/issues)
