Automation Testing - SauceDemo
==============================
Estructura
==============================
Proyecto/
├── features/                    # .feature files
│   ├── login.feature           # @login @smoke @negative
│   ├── cart.feature            # @cart @smoke @ui
│   ├── checkout.feature        # @checkout @smoke @negative
│   ├── navigation.feature      # @navigation @smoke
│   ├── products.feature        # @products @smoke @sorting
│   ├── product_detail.feature  # @product_detail @smoke
│   ├── step_definitions/       # .rb files
│   └── support/                # env.rb, hooks.rb
├── reports/                    # Screenshots y reportes
└── Gemfile
==============================
Instalación
==============================
1. Ruby 3.0.2: https://rubyinstaller.org/downloads/
2. Instalar gems:
   gem install cucumber capybara selenium-webdriver rspec capybara-screenshot
3. ChromeDriver compatible
==============================
Comandos Básicos
==============================
Ejecutar TODOS los tests:
cucumber features

Ejecutar UN feature:
cucumber features\login.feature

Ejecutar CON TAG:
cucumber features\cart.feature -t @smoke
cucumber features\checkout.feature -t @negative

Ejecutar y GENERAR REPORTE HTML:
cucumber features -f html -o reports\resultados.html

Ejecutar SIN DIÁLOGO:
cucumber features --publish-quiet
==============================
Tags Disponibles
==============================
@smoke        - Pruebas críticas
@login        - Autenticación
@cart         - Carrito de compras
@checkout     - Proceso de pago
@negative     - Manejo de errores
@navigation   - Navegación
@products     - Listado productos
@product_detail - Detalle producto
@ui           - Interfaz de usuario
==============================
Estadísticas
==============================
Features: 6
Escenarios: 41
Steps: 192
Tiempo: 2m43.876s
Cobertura: Login, Cart, Checkout, Navigation, Products
==============================
Configuración
==============================
Navegador: Chrome (incógnito, maximizado)
Tiempo espera: 10 segundos
Screenshots automáticos en fallos: reports/screenshots/