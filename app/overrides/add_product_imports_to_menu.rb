Deface::Override.new(
  virtual_path: 'spree/layouts/admin',
  name: 'product_imports_sidebar_menu',
  insert_bottom: '#main-sidebar',
  partial: 'spree/admin/shared/product_imports_sidebar_menu',
)