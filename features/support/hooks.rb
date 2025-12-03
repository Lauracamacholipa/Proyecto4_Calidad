require 'capybara/cucumber'

# Hook para maximizar ventana 
Before '@maximize' do
  page.driver.browser.manage.window.maximize
end

# Hook para limpiar carrito después de tests @cart
After '@cart' do
  # Solo intentar limpiar si estamos en una página activa
  next unless page.current_path && !page.current_path.empty?
  
  begin
    # Ir al carrito si es posible
    if has_css?('.shopping_cart_link', wait: 1)
      find('.shopping_cart_link').click
      
      # Remover todos los items
      while has_css?('.cart_button', text: 'Remove', wait: 1)
        first('.cart_button').click
      end
      
      # Volver a inventory
      visit('/inventory.html') if has_css?('#continue-shopping', wait: 1)
    end
  rescue => e
    # Silenciar errores de limpieza
    puts "Nota: No se pudo limpiar carrito - #{e.message}" if ENV['DEBUG']
  end
end

# Hook para tomar screenshots en fallos
After do |scenario|
  if scenario.failed?
    begin
      timestamp = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
      scenario_name = scenario.name.gsub(/[^\w\-]/, '_')[0..50]
      screenshot_name = "screenshot-#{scenario_name}-#{timestamp}.png"
      
      page.save_screenshot(screenshot_name) if page.current_path
      puts "Screenshot: #{screenshot_name}" if ENV['DEBUG']
    rescue => e
      puts "Error screenshot: #{e.message}" if ENV['DEBUG']
    end
  end
  
  # Cerrar menú si está abierto (sin sleep)
  begin
    if has_css?('#react-burger-cross-btn', visible: true, wait: 1)
      find('#react-burger-cross-btn').click
    end
  rescue
    # Ignorar errores
  end
end

Before '@auth_required' do
  visit('/inventory.html')
  
  # Si redirige a login, hacer login
  if page.current_url.include?('/')
    fill_in 'user-name', with: 'standard_user'
    fill_in 'password', with: 'secret_sauce'
    find('#login-button').click
  end
end