Automation Testing - SauceDemo
INSTALACIÓN
1. Ruby 3.0.2: https://rubyinstaller.org/downloads/
2. Instalar gems: gem install cucumber capybara selenium-webdriver rspec capybara-screenshot
3. ChromeDriver compatible

COMANDOS BÁSICOS

- Ejecutar TODOS: cucumber features
- Ejecutar UN feature: cucumber features\login.feature
- Ejecutar con TAG: cucumber features\cart.feature -t @smoke
- Reporte HTML: cucumber features -f html -o reports\resultados.html
- Sin diálogo: cucumber features --publish-quiet

TAGS DISPONIBLES
- @smoke - Pruebas críticas
- @login - Autenticación
- @cart - Carrito de compras
- @checkout - Proceso de pago
- @negative - Manejo de errores
- @navigation - Navegación
- @products - Listado productos
- @product_detail - Detalle producto
- @ui - Interfaz de usuario

ESTADÍSTICAS
- Features: 6
- Escenarios: 40
- Steps: 192
- Tiempo: 2m43.876s
- Cobertura: Login, Cart, Checkout, Navigation, Products

CONFIGURACIÓN
- Navegador: Chrome (incógnito, maximizado)
- Tiempo espera: 10 segundos
- Screenshots automáticos en fallos: reports/screenshots/
