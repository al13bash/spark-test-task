class Admin::ProductsImportController < Spree::Admin::BaseController
  def new
  end

  def create
    if params[:products_import].blank?
      return redirect_to new_admin_products_import_path, notice: 'You need to select a file'
    end
    ProductsImportWorker.perform_async(params[:products_import][:file].tempfile.path)
    redirect_to new_admin_products_import_path, notice: 'Products are going to be imported'
  end
end
