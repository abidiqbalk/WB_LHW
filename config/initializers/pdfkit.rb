PDFKit.configure do |config|
  config.wkhtmltopdf = 'C:\Program Files (x86)\wkhtmltopdf\wkhtmltopdf.exe'
  # config.default_options = {
  #   :page_size => 'Legal',
  #   :print_media_type => true
  # }
   config.root_url = "http://localhost:3000" # Use only if your external hostname is unavailable on the server.
end