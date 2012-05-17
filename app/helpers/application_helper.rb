module ApplicationHelper
	def spinner_tag id
	  #Assuming spinner image is called "spinner.gif"
	  image_tag("spinner.gif", :id => id, :alt => "Loading....", :style => "display:none")
	end
	
	def medium_spinner_tag id
	  #Assuming spinner image is called "spinner.gif"
	  image_tag("medium-spinner.gif", :id => id, :alt => "Loading....", :style => "display:none")
	end

	def request_from_pdfkit?
		# when generating a PDF, PDFKit::Middleware will set this flag
		request.env["Rack-Middleware-PDFKit"] == "true"
	end
	
end
