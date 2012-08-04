module DocmagoClient
  module PdfRenderer
    def self.init(options={})
      require "action_controller"
      unless Mime::Type.lookup_by_extension("pdf")
        Mime::Type.register "application/pdf", :pdf
      end

      ActionController::Renderers.add :pdf do |filename, options|
        pdf = DocmagoClient.create(:content => render_to_string(options))
        send_data(pdf, :filename => "#{filename}.pdf", :type => "application/pdf", :disposition => "attachment")
      end
    end
  end
end